//
//  NGTask.h
//  NGNetworking
//
//  Created by guojian on 2017/4/12.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGRequest.h"
#import "NGResponse.h"

/** 请求成功回调 */
typedef void (^NGSuccessHandler)(NSInteger statusCode, id response);
/** 请求失败回调 */
typedef void (^NGFailureHandler)(NSError *error);

/** HTTP请求方法 */
typedef NS_ENUM(NSInteger, NGHTTPMethod) {
    NGHTTPMethodPost,           // POST请求
    NGHTTPMethodGet,            // GET请求
};

@interface NGTask : NSObject

+ (instancetype)ng_task;

/** HTTP请求方法 ( 默认 : POST ) */
@property (nonatomic,assign) NGHTTPMethod ng_httpMethod;
/** request */
@property (nonatomic,strong) NGRequest *ng_request;
/** response */
@property (nonatomic,strong) NGResponse *ng_response;

/** 请求成功回调block */
@property (nonatomic,copy) NGSuccessHandler ng_success;
/** 请求失败回调block */
@property (nonatomic,copy) NGFailureHandler ng_failure;

/** 保存发送请求的 NSURLSessionTask */
@property (nonatomic,weak) NSURLSessionTask *ng_sessionTask;

@end

@interface NGTask (NGChain)

/** 设置 HTTP请求方法 */
@property (nonatomic,copy,readonly) NGTask *(^c_ng_httpMethod)(NGHTTPMethod httpMethod);
/** 设置 request */
@property (nonatomic,copy,readonly) NGTask *(^c_ng_request)(NGRequest *request);
/** 设置 response */
@property (nonatomic,copy,readonly) NGTask *(^c_ng_response)(NGResponse *response);
/** 设置 成功回调block */
@property (nonatomic,copy,readonly) NGTask *(^c_ng_success)(NGSuccessHandler success);
/** 设置 失败回调block */
@property (nonatomic,copy,readonly) NGTask *(^c_ng_failure)(NGFailureHandler failure);

@end
