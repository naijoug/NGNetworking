//
//  NGRequest.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//  url request 基类

#import <Foundation/Foundation.h>
#import "NGModel.h"

/** HTTP请求数据类型 */
typedef NS_ENUM(NSInteger, NGRequestType) {
    NGRequestTypeJSON,          // JSON字典 (NSDictionary)
    NGRequestTypeModel,         // Model, (继承 NGRequest )
};

@interface NGRequest : NSObject<NGModel>

+ (instancetype)ng_request;

/** 请求数据类型 */
@property (nonatomic,assign) NGRequestType requestType;
/** 请求 urlString Path 后缀 */
@property (nonatomic,copy) NSString *urlPathString;
/** 请求参数 parameters ( == NGRequestTypeJSON ) */
@property (nonatomic,strong,readonly) id parameters;

- (NGRequest * (^)(NGRequestType requestType))ng_requestType;
- (NGRequest * (^)(NSString *urlPathString))ng_urlPathString;
- (NGRequest * (^)(id parameters))ng_parameters;

@end
