//
//  NGResponse.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import <Foundation/Foundation.h>

/** HTTP成功响应数据类型 */
typedef NS_ENUM(NSInteger, NGResponseType) {
    NGResponseTypeString,       // String
    NGResponseTypeData,         // 二进制 (NSData)
    NGResponseTypeJSON,         // JSON (NSDictionary || NSArray)
    NGResponseTypeModel,        // Model (需要设置Model Class)
};

@interface NGResponse : NSObject

+ (instancetype)ng_response;

/** 响应数据类型 ( 默认 : NGResponseTypeString ) */
@property (nonatomic,assign,readonly) NGResponseType responseType;
/** 响应数据 Model class ( responseType == NGResponseTypeModel , 需要设置 ) */
@property (nonatomic,strong,readonly) Class responseClass;

- (NGResponse * (^)(NGResponseType responseType))ng_responseType;   // 设置 responseType
- (NGResponse * (^)(Class responseClasss))ng_responseClass;         // 设置 responseClass

@end
