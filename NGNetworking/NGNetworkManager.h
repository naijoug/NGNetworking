//
//  NGNetworkManager.h
//  NGNetworking
//
//  Created by guojian on 2017/3/16.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 网络请求库 */
typedef NS_ENUM(NSInteger, NGNetwokLib) {
    NGNetworkLibAFNetworking,    // AFNetworking
    NSNetworkLibNSURLSession     // NSURLSession
};

/** HTTP请求方法 */
typedef NS_ENUM(NSInteger, NGHTTPMethod) {
    NGHTTPMethodGet,
    NGHTTPMethodPost
};

/** HTTP成功返回数据类型 */
typedef NS_ENUM(NSInteger, NGResponseType){
    NGResponseTypeData,         // 二进制NSData
    NGResponseTypeJSON,         // JSON字典
    // 以下两种类型，需要指定模型类的Class
    NGResponseTypeModel,        // 模型,
    NGResponseTypeModelArray    // 模型数组
};

typedef void (^NGSuccessHandler)(NSInteger stateCode, id response);
typedef void (^NGFailureHandler)(NSError *error);


@interface NGNetworkManager : NSObject

+ (instancetype)shareManager;

/** 设置网络请求库 */
- (NGNetworkManager * (^)(NGNetwokLib networkLib))ng_networkLib;

/** 设置HTTP请求的Method */
- (NGNetworkManager * (^)(NGHTTPMethod httpMethod))ng_httpMethod;
/** 设置请求url地址串 */
- (NGNetworkManager * (^)(NSString *urlString))ng_urlString;
/** 设置请求参数 */
- (NGNetworkManager * (^)(id parameters))ng_parameters;

/** 设置成功响应数据类型 */
- (NGNetworkManager * (^)(NGResponseType responseType))ng_responseType;
/** 设置Model的Class */
- (NGNetworkManager * (^)(Class modelClass))ng_modelClass;

/** 设置是否打印log */
- (NGNetworkManager * (^)(BOOL isLog))ng_isLog;

/** 请求成功回调block */
- (NGNetworkManager * (^)(NGSuccessHandler successHandler))ng_successHandler;
/** 请求失败回调block */
- (NGNetworkManager * (^)(NGFailureHandler failureHandler))ng_failureHandler;

#pragma mark -

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
