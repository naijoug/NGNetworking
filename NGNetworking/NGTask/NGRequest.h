//
//  NGRequest.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//  url request 

#import <Foundation/Foundation.h>
#import <NGModel/NGModel.h>

/** HTTP请求数据类型 */
typedef NS_ENUM(NSInteger, NGRequestType) {
    NGRequestTypeModel,         // Model, (继承 NGRequest )
    NGRequestTypeJSON,          // JSON字典 (NSDictionary)
};

@interface NGRequest : NSObject

+ (instancetype)ng_request;

/**
 *  请求 urlString Path 后缀 
 * 
 *  ( eg: "/v2/book/search" )
 */
@property (nonatomic,copy) NSString *ng_urlPathString;
/** 请求数据类型 ( 默认 : NGRequestTypeModel )  */
@property (nonatomic,assign) NGRequestType ng_requestType;
/** 请求参数 parameters ( requestType == NGRequestTypeJSON , 需要设置 ) */
@property (nonatomic,strong) id ng_parameters;

@end

@interface NGRequest (NGChain)

/** 设置 urlPathString */
@property (nonatomic,copy,readonly) NGRequest *(^c_ng_urlPathString)(NSString *urlPathString);
/** 设置 requestType */
@property (nonatomic,copy,readonly) NGRequest *(^c_ng_requestType)(NGRequestType requestType);
/** 设置 parameters */
@property (nonatomic,copy,readonly) NGRequest *(^c_ng_parameters)(id parameters);

@end
