//
//  NGBaseRequest.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//  请求Model的基类

#import <Foundation/Foundation.h>

@interface NGBaseRequest : NSObject

/**
 *  初始化请求参数
 */
+ (instancetype)ng_request;

/** 请求参数 */
@property (nonatomic,strong,readonly) id ng_parameters;

@end
