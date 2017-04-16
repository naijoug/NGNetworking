//
//  NGNetworkManager.m
//  NGNetworking
//
//  Created by guojian on 2017/3/16.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NGNetworking.h"
#import <AFNetworking/AFNetworking.h>

@interface NGNetworkManager ()

/** 请求任务字典
 *  key     : hash
 *  value   : NSTask
 */
@property (nonatomic,strong) NSCache *taskCache;

@end

@implementation NGNetworkManager

- (NSCache *)taskCache {
    if (!_taskCache) {
        _taskCache = [[NSCache alloc] init];
    }
    return _taskCache;
}

+ (instancetype)ng_shareManager {
    static NGNetworkManager *_manager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        _manager = [[NGNetworkManager alloc] init];
        _manager.c_ng_config([NGConfig ng_config]);
    });
    return _manager;
}

#pragma mark - 

#pragma mark Method

- (void)ng_startNGTask:(NGTask *)ng_task success:(NGSuccessHandler)success failure:(NGFailureHandler)failure {
    ng_task.ng_success = success;
    ng_task.ng_failure = failure;
    
    [self ng_startNGTask:ng_task];
}

- (void)ng_startNGTask:(NGTask *)ng_task {
    
    [self _logRequestWithNGTask:ng_task];
    
    NSURLSessionTask *task = nil;
    switch (self.ng_config.ng_networkLib) {
            case NGNetworkLibAFNetworking: task = [self _startAFNetworkingWithNGTask:ng_task]; break;
            case NSNetworkLibNSURLSession: task = [self _startNSURLSessionWithNGTask:ng_task]; break;
    }
    ng_task.ng_sessionTask = task;
    // 添加任务缓存中
    [self.taskCache setObject:ng_task forKey:@(ng_task.hash)];
}

- (void)ng_cancelNGTask:(NGTask *)ng_task {
    NSURLSessionTask *task = [self.taskCache objectForKey:@(ng_task.hash)];
    if (task) { // 取消任务，并从缓存中移除
        [self.taskCache removeObjectForKey:@(ng_task.hash)];
        [task cancel];
    }
}

#pragma mark - Networking

#pragma mark AFNetworking

- (NSURLSessionDataTask *)_startAFNetworkingWithNGTask:(NGTask *)ng_task {
    
    AFHTTPSessionManager *manager   = [AFHTTPSessionManager manager];
    manager.requestSerializer       = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer      = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *task      = nil;
    switch (ng_task.ng_httpMethod) {
        case NGHTTPMethodGet: {
            task = [manager GET:[self _baseUrlStringWithNGTask:ng_task]
                     parameters:ng_task.ng_request.ng_parameters
                       progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self _handlerSuccessWithNGTask:ng_task task:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self _handlerFailureWithNGTask:ng_task task:task error:error];
            }];
        }
            break;
        case NGHTTPMethodPost: {
            task = [manager POST:[self _baseUrlStringWithNGTask:ng_task]
                      parameters:ng_task.ng_request.ng_parameters
                        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self _handlerSuccessWithNGTask:ng_task task:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self _handlerFailureWithNGTask:ng_task task:task error:error];
            }];
        }
            break;
    }
    return task;
}

#pragma mark NSURLSessionTask

- (NSURLSessionDataTask *)_startNSURLSessionWithNGTask:(NGTask *)ng_task {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURL *url                      = [NSURL URLWithString:[self _baseUrlStringWithNGTask:ng_task]];
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:url];
    switch (ng_task.ng_httpMethod) {
        case NGHTTPMethodGet:   request.HTTPMethod = @"GET"; break;
        case NGHTTPMethodPost:  request.HTTPMethod = @"POST"; break;
    }
    request.HTTPBody                = [[self _httpBodyWithParameters:ng_task.ng_request.ng_parameters] dataUsingEncoding:NSUTF8StringEncoding];
    
    __block NSURLSessionDataTask *task = nil;
    task = [[NSURLSession sessionWithConfiguration:configuration] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { // 失败
            [self _handlerFailureWithNGTask:ng_task task:task error:error];
        } else { // 成功
            [self _handlerSuccessWithNGTask:ng_task task:task responseObject:data];
        }
    }];
    [task resume];
    
    return task;
}

#pragma mark Handler
/** 处理成功返回 */
- (void)_handlerSuccessWithNGTask:(NGTask *)ng_task
                             task:(NSURLSessionDataTask *)task
                   responseObject:(id)responseObject {
    [self _logResponse:responseObject];
    
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
    if (ng_task.ng_success) {
        ng_task.ng_success(urlResponse.statusCode, [ng_task.ng_response ng_paraseResponse:responseObject]);
    }
}
/** 处理失败返回 */
- (void)_handlerFailureWithNGTask:(NGTask *)ng_task
                             task:(NSURLSessionDataTask *)task
                            error:(NSError *)error {
    [self logWithTitle:@"HTTP请求错误" error:error];
    /* error code:
     *
     * 3840  : 服务器返回(500),请求错误，导致服务器异常
     * -1001 : 请求超时
     * -1003 : 未能找到使用指定主机名的服务器
     * -1004 : 未能连接到服务器
     * -1005 : 网络连接已中断
     * -1009 : 似乎已断开与互联网的连接
     */
    if (ng_task.ng_failure) {
       ng_task.ng_failure(error);
    }
}


#pragma mark - Tool

/**
 *  拼接HTTP请求baseUrlString
 */
- (NSString *)_baseUrlStringWithNGTask:(NGTask *)ng_task {
    return [NSString stringWithFormat:@"%@%@", self.ng_config.ng_baseUrlString ?: @"", ng_task.ng_request.ng_urlPathString ?: @""];
}

/**
 *  请求参数转化为HTTP请求的body串
 */
- (NSString *)_httpBodyWithParameters:(NSDictionary *)parameters {
    __block NSMutableString *body = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (body.length != 0) { // 不是串头，用&符号连接
            [body appendString:@"&"];
        }
        if ([obj isKindOfClass:[NSArray class]]) { // 数组
            NSArray *arr = (NSArray *)obj;
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [body appendFormat:@"%@[]=%@", key, obj];
            }];
        }  else {
            [body appendFormat:@"%@=%@", key, obj];
        }
    }];
    
    return [body copy];
}

#pragma mark - Log

/** log请求信息 */
- (void)_logRequestWithNGTask:(NGTask *)ng_task {
    NSMutableString *message = [NSMutableString string];
    switch (self.ng_config.ng_networkLib) {
        case NGNetworkLibAFNetworking: [message appendString:@"AFNetworking"]; break;
        case NSNetworkLibNSURLSession: [message appendString:@"NSURLSession"]; break;
    }
    switch (ng_task.ng_httpMethod) {
        case NGHTTPMethodGet:   [message appendString:@" GET"]; break;
        case NGHTTPMethodPost:  [message appendString:@" POST"]; break;
    }
    [message appendFormat:@"\nRequest : %@", [self _baseUrlStringWithNGTask:ng_task]];
    if (ng_task.ng_request.ng_parameters) { // 有参数
        [message appendString:@"?"];
        [message appendString:[self _httpBodyWithParameters:ng_task.ng_request.ng_parameters]];
    }
    
    [self logWithTitle:@"发送请求" message:message];
}

/** log响应信息 */
- (void)_logResponse:(id)response {
    NSData *responseData    = nil;
    if ([response isKindOfClass:[NSData class]]) {
        responseData        = response;
    } else {
        NSError *error      = nil;
        responseData        = [NSJSONSerialization dataWithJSONObject:response options:kNilOptions error:&error];
        [self logWithTitle:@"Response log JSON解析失败" error:error];
    }
    
    NSString *message       = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // 去除首尾空格、回车、制表符
    message                 = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    message                 = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    message                 = [NSString stringWithFormat:@"\nResponse : %@\n\n", message];
    [self logWithTitle:@"响应数据" message:message];
}

@end

@implementation NGNetworkManager (NGChain)

- (NGNetworkManager *(^)(NGConfig *))c_ng_config {
    return ^(NGConfig *config) {
        _ng_config = config;
        return self;
    };
}

@end

@implementation NGNetworkManager (NGLog)

- (void)logWithTitle:(NSString *)title error:(NSError *)error {
    if ( error ) { // 有错误信息，打印
        [self logWithTitle:title message:error.description];
    }
}

- (void)logWithTitle:(NSString *)title message:(NSString *)message {
    if (self.ng_config.ng_isLog) {
        NSMutableString *log = [NSMutableString string];
        if (title && (title.length != 0)) {
            [log appendFormat:@"%@ : ", title];
        }
        if (message) {
            [log appendString:message];
        }
        
        NSLog(@"%@", log);
    }
}

@end
