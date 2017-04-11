//
//  NGNetworkManager.h
//  NGNetworking
//
//  Created by guojian on 2017/3/16.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NGSuccessHandler)(NSInteger stateCode, id response);
typedef void (^NGFailureHandler)(NSError *error);

@class NGConfig;
@class NGRequest;
@class NGResponse;
@interface NGNetworkManager : NSObject

+ (instancetype)shareManager;

/** 设置HTTP配置 */
- (NGNetworkManager * (^)(NGConfig *config))ng_config;
/** 设置请求类型 */
- (NGNetworkManager * (^)(NGRequest *request))ng_request;
/** 设置响应类型 */
- (NGNetworkManager * (^)(NGResponse *response))ng_response;

/** 请求成功回调block */
- (NGNetworkManager * (^)(NGSuccessHandler successHandler))ng_successHandler;
/** 请求失败回调block */
- (NGNetworkManager * (^)(NGFailureHandler failureHandler))ng_failureHandler;

#pragma mark Method
/**
 *  启动请求任务
 */
- (NSUInteger)ng_start;

/**
 *  取消请求
 *  
 *  @param taskIdentifier 任务ID
 */
- (void)ng_cancelWithTaskIdentifier:(NSUInteger)taskIdentifier;

@end
