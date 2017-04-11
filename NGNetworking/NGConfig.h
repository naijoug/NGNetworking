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
    NSNetworkLibNSURLSession     // NSURLSession
};
/** HTTP请求方法 */
typedef NS_ENUM(NSInteger, NGHTTPMethod) {
    NGHTTPMethodGet,            // GET请求
    NGHTTPMethodPost            // POST请求
};

@interface NGConfig : NSObject

+ (instancetype)ng_config;

/** 网络请求库 */
@property (nonatomic,assign,readonly) NGNetwokLib networkLib;
/** HTTP请求方法 */
@property (nonatomic,assign,readonly) NGHTTPMethod httpMethod;
/** 请求 base URL String */
@property (nonatomic,copy,readonly) NSString *baseUrlString;
/** 是否打印log */
@property (nonatomic,assign,readonly) BOOL isLog;

- (NGConfig * (^)(NGNetwokLib networkLib))ng_networkLib;
- (NGConfig * (^)(NGHTTPMethod httpMethod))ng_httpMethod;
- (NGConfig * (^)(NSString *baseUrlString))ng_baseUrlString;
- (NGConfig * (^)(BOOL isLog))ng_isLog;

@end
