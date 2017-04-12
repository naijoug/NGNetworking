//
//  NGNetworkManager.h
//  NGNetworking
//
//  Created by guojian on 2017/3/16.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGTask.h"

@class NGConfig;
@interface NGNetworkManager : NSObject

+ (instancetype)ng_shareManager;

/**  全局配置 config */
@property (nonatomic,strong,readonly) NGConfig *ng_config;

#pragma mark Method

/**
 *  启动一个请求任务 ( 设置回调 )
 */
- (void)ng_startNGTask:(NGTask *)ng_task success:(NGSuccessHandler)success failure:(NGFailureHandler)failure;
/**
 *  启动一个请求任务
 */
- (void)ng_startNGTask:(NGTask *)ng_task;

/**
 *  取消一个请求任务
 */
- (void)ng_cancelNGTask:(NGTask *)ng_task;

@end

@interface NGNetworkManager (NGChain)

/** 设置全局配置 */
@property (nonatomic,strong,readonly) NGNetworkManager * (^c_ng_config)(NGConfig *config);

@end

@interface NGNetworkManager (NGLog)

/**
 *  打印 error 信息
 */
- (void)logWithTitle:(NSString *)title error:(NSError *)error;
/**
 *  打印log日志
 */
- (void)logWithTitle:(NSString *)title message:(NSString *)message;

@end
