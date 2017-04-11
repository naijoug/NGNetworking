//
//  NGRequest.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//  url request 

#import <Foundation/Foundation.h>
#import "NGModel.h"

/** HTTP请求数据类型 */
typedef NS_ENUM(NSInteger, NGRequestType) {
    NGRequestTypeModel,         // Model, (继承 NGRequest )
    NGRequestTypeJSON,          // JSON字典 (NSDictionary)
};

@interface NGRequest : NSObject<NGModel>

+ (instancetype)ng_request;

/**
 *  请求 urlString Path 后缀 
 * 
 *  ( eg: "/v2/book/search" )
 */
@property (nonatomic,copy,readonly) NSString *urlPathString;
/** 请求数据类型 ( 默认 : NGRequestTypeModel )  */
@property (nonatomic,assign,readonly) NGRequestType requestType;
/** 请求参数 parameters ( requestType == NGRequestTypeJSON , 需要设置 ) */
@property (nonatomic,strong,readonly) id parameters;

- (NGRequest * (^)(NSString *urlPathString))ng_urlPathString;   // 设置 urlPathString
- (NGRequest * (^)(NGRequestType requestType))ng_requestType;   // 设置 requestType
- (NGRequest * (^)(id parameters))ng_parameters;                // 设置 parameters

@end
