//
//  NGConfig.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//  HTTP请求配置

#import <Foundation/Foundation.h>

/** 网络请求库 */
typedef NS_ENUM(NSInteger, NGNetwokLib) {
    NGNetworkLibAFNetworking,    // AFNetworking
    NSNetworkLibNSURLSession,    // NSURLSession
};
/** HTTP请求方法 */
typedef NS_ENUM(NSInteger, NGHTTPMethod) {
    NGHTTPMethodPost,           // POST请求
    NGHTTPMethodGet,            // GET请求
};

@interface NGConfig : NSObject

+ (instancetype)ng_config;

/**
 *  请求 base URL String 
 *
 *  ( eg : "https://api.douban.com" )
 */
@property (nonatomic,copy,readonly) NSString *baseUrlString;
/** 网络请求库 ( 默认 : AFNetworking ) */
@property (nonatomic,assign,readonly) NGNetwokLib networkLib;
/** HTTP请求方法 ( 默认 : POST ) */
@property (nonatomic,assign,readonly) NGHTTPMethod httpMethod;
/** 是否打印log ( 默认 : YES ) */
@property (nonatomic,assign,readonly) BOOL isLog;

- (NGConfig * (^)(NSString *baseUrlString))ng_baseUrlString;    // 设置 baseUrlString
- (NGConfig * (^)(NGNetwokLib networkLib))ng_networkLib;        // 设置 networkLib
- (NGConfig * (^)(NGHTTPMethod httpMethod))ng_httpMethod;       // 设置 httpMethod
- (NGConfig * (^)(BOOL isLog))ng_isLog;                         // 设置 isLog

@end
