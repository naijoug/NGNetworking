//
//  NGNetworkManager.m
//  NGNetworking
//
//  Created by guojian on 2017/3/16.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NGNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>

@interface NGNetworkManager ()

/** 请求任务字典
 *  key     : taskIdentifier
 *  value   : NSURLSessionTask
 */
@property (nonatomic,strong) NSCache *taskCache;

/** 网络请求库 */
@property (nonatomic,assign) NGNetwokLib networkLib;

/** HTTP请求方法 */
@property (nonatomic,assign) NGHTTPMethod httpMethod;
/** 请求URL串 */
@property (nonatomic,copy) NSString *urlString;
/** 请求参数 */
@property (nonatomic,strong) id parameters;

/** 请求成功返回类型 */
@property (nonatomic,assign) NGResponseType responseType;
/** 模型的Class */
@property (nonatomic,strong) Class modelClass;

/** 是否打印log */
@property (nonatomic,assign) BOOL isLog;


/** 成功block */
@property (nonatomic,copy) NGSuccessHandler successHandler;
/** 失败block */
@property (nonatomic,copy) NGFailureHandler failureHandler;

@end

@implementation NGNetworkManager

- (NSCache *)taskCache {
    if (!_taskCache) {
        _taskCache = [[NSCache alloc] init];
    }
    return _taskCache;
}

+ (instancetype)shareManager {
    static NGNetworkManager *_manager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        _manager        = [[NGNetworkManager alloc] init];
        _manager.isLog  = YES;
    });
    return _manager;
}


- (NGNetworkManager *(^)(NGNetwokLib))ng_networkLib {
    return ^ NGNetworkManager * (NGNetwokLib networkLib) {
        self.networkLib = networkLib;
        return self;
    };
}

- (NGNetworkManager *(^)(NGHTTPMethod))ng_httpMethod {
    return ^ NGNetworkManager * (NGHTTPMethod method) {
        self.httpMethod = method;
        return self;
    };
}
- (NGNetworkManager *(^)(NSString *))ng_urlString {
    return ^ NGNetworkManager * (NSString *url) {
        self.urlString = url;
        return self;
    };
}
- (NGNetworkManager *(^)(id))ng_parameters {
    return ^ NGNetworkManager * (id parameters) {
        self.parameters = parameters;
        return self;
    };
}

- (NGNetworkManager *(^)(NGResponseType))ng_responseType {
    return ^ NGNetworkManager * (NGResponseType responseType) {
        self.responseType = responseType;
        return self;
    };
}
- (NGNetworkManager *(^)(__unsafe_unretained Class))ng_modelClass {
    return ^ NGNetworkManager * (Class modelClass) {
        self.modelClass = modelClass;
        return self;
    };
}

- (NGNetworkManager *(^)(BOOL))ng_isLog {
    return ^ NGNetworkManager * (BOOL isLog) {
        self.isLog = isLog;
        return self;
    };
}


- (NGNetworkManager *(^)(NGSuccessHandler))ng_successHandler {
    return ^ NGNetworkManager * (NGSuccessHandler successHandler) {
        self.successHandler = successHandler;
        return self;
    };
}
- (NGNetworkManager *(^)(NGFailureHandler))ng_failureHandler {
    return ^ NGNetworkManager * (NGFailureHandler failureHandler) {
        self.failureHandler = failureHandler;
        return self;
    };
}

#pragma mark -

- (NSUInteger)ng_start {
    
    [self _logRequest];
    
    NSURLSessionTask *task = nil;
    switch (self.networkLib) {
        case NGNetworkLibAFNetworking: task = [self _startWithAFNetworking]; break;
        case NSNetworkLibNSURLSession: task = [self _startWithNSURLSession]; break;
    }
    
    // 添加任务到字典
    NSUInteger taskIndentifier = task.taskIdentifier;
    [self.taskCache setObject:task forKey:@(taskIndentifier)];
    
    return taskIndentifier;
}

- (void)ng_cancelWithTaskIdentifier:(NSUInteger)taskIdentifier {
    
    NSURLSessionTask *task = [self.taskCache objectForKey:@(taskIdentifier)];
    if (task) { // 取消任务，并从字典中移除
        [task cancel];
        [self.taskCache removeObjectForKey:@(taskIdentifier)];
    }
}

#pragma mark - Networking

#pragma mark AFNetworking

- (NSURLSessionDataTask *)_startWithAFNetworking {
    
    AFHTTPSessionManager *manager   = [AFHTTPSessionManager manager];
    manager.requestSerializer       = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer      = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *task      = nil;
    switch (self.httpMethod) {
        case NGHTTPMethodGet:
        {
            task = [manager GET:self.urlString parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self _handlerSuccessWithTask:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self _handlerFailureWithTask:task error:error];
            }];
        }
            break;
        case NGHTTPMethodPost:
        {
            task = [manager POST:self.urlString parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self _handlerSuccessWithTask:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self _handlerFailureWithTask:task error:error];
            }];
        }
            break;
    }
    
    return task;
}

#pragma mark NSURLSessionTask

- (NSURLSessionDataTask *)_startWithNSURLSession {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURL *url                      = [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:url];
    switch (self.httpMethod) {
        case NGHTTPMethodGet:   request.HTTPMethod = @"GET"; break;
        case NGHTTPMethodPost:  request.HTTPMethod = @"POST"; break;
    }
    request.HTTPBody                = [[self _httpBodyWithParameters:self.parameters] dataUsingEncoding:NSUTF8StringEncoding];
    
    
    __block NSURLSessionDataTask *task = nil;
    task = [[NSURLSession sessionWithConfiguration:configuration] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { // 失败
            [self _handlerFailureWithTask:task error:error];
        } else { // 成功
            [self _handlerSuccessWithTask:task responseObject:data];
        }
    }];
    [task resume];
    
    return task;
}

#pragma mark Handler
/** 处理成功返回 */
- (void)_handlerSuccessWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
    NSError *error;
    id responseJSON     = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
    [self _logWithTitle:@"JSON解析错误" error:error];
    [self _logResponse:responseObject];
    
    // 成功响应数据
    id response         = nil;
    switch (self.responseType) {
        case NGResponseTypeData:        response = responseObject; break;
        case NGResponseTypeJSON:        response = responseJSON;   break;
        case NGResponseTypeModel:       response = [self.modelClass yy_modelWithJSON:responseJSON]; break;
        case NGResponseTypeModelArray:  response = [NSArray yy_modelArrayWithClass:self.modelClass json:responseJSON]; break;
    }
    
    if (self.successHandler) {
        self.successHandler(urlResponse.statusCode, response);
    }
}
/** 处理失败返回 */
- (void)_handlerFailureWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    [self _logWithTitle:@"HTTP请求错误" error:error];
    if (self.failureHandler) {
        self.failureHandler(error);
    }
}


#pragma mark - Tool

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
- (void)_logRequest {
    NSMutableString *message = [NSMutableString string];
    switch (self.networkLib) {
        case NGNetworkLibAFNetworking: [message appendString:@"AFNetworking"]; break;
        case NSNetworkLibNSURLSession: [message appendString:@"NSURLSession"]; break;
    }
    switch (self.httpMethod) {
        case NGHTTPMethodGet:   [message appendString:@" GET"]; break;
        case NGHTTPMethodPost:  [message appendString:@" POST"]; break;
    }
    [message appendFormat:@"\nRequest : %@", self.urlString];
    if (self.parameters) { // 有参数
        [message appendString:@"?"];
        [message appendString:[self _httpBodyWithParameters:self.parameters]];
    }
    
    [self _logWithTitle:@"发送请求" message:message];
}

/** log响应信息 */
- (void)_logResponse:(id)response {
    NSData *responseData    = nil;
    if ([response isKindOfClass:[NSData class]]) {
        responseData        = response;
    } else {
        NSError *error      = nil;
        responseData        = [NSJSONSerialization dataWithJSONObject:response options:kNilOptions error:&error];
        [self _logWithTitle:@"Response log JSON解析失败" error:error];
    }
    
    NSString *message       = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // 去除首尾空格、回车、制表符
    message                 = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    message                 = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    message                 = [NSString stringWithFormat:@"\nResponse : %@\n\n", message];
    [self _logWithTitle:@"响应数据" message:message];
}

/** log错误信息 */
- (void)_logWithTitle:(NSString *)title error:(NSError *)error {
    if ( error ) { // 有错误信息，打印
        [self _logWithTitle:title message:error.description];
    }
}

/**
 *  打印log日志
 */
- (void)_logWithTitle:(NSString *)title message:(NSString *)message {
    if (self.isLog) {
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
