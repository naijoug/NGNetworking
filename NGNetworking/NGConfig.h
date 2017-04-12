//
//  NGConfig.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//  HTTP请求全局配置

#import <Foundation/Foundation.h>

/** 网络请求库 */
typedef NS_ENUM(NSInteger, NGNetwokLib) {
    NGNetworkLibAFNetworking,    // AFNetworking
    NSNetworkLibNSURLSession,    // NSURLSession
};

@interface NGConfig : NSObject

+ (instancetype)ng_config;

/**
 *  请求 base URL String 
 *
 *  ( eg : "https://api.douban.com" )
 */
@property (nonatomic,copy) NSString *ng_baseUrlString;
/** 网络请求库 ( 默认 : AFNetworking ) */
@property (nonatomic,assign) NGNetwokLib ng_networkLib;
/** 是否打印log ( 默认 : YES ) */
@property (nonatomic,assign) BOOL ng_isLog;

@end

@interface NGConfig (NGChain)

/** 设置 baseUrlString */
@property (nonatomic,copy,readonly) NGConfig *(^c_ng_baseUrlString)(NSString *baseUrlString);
/** 设置 networkLib */
@property (nonatomic,copy,readonly) NGConfig *(^c_ng_networkLib)(NGNetwokLib networkLib);
/** 设置 isLog */
@property (nonatomic,copy,readonly) NGConfig *(^c_ng_isLog)(BOOL isLog);

@end
