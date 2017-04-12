//
//  NGResponse.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGModel.h"

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
@property (nonatomic,assign) NGResponseType ng_responseType;
/** 响应数据 Model class ( ng_responseType == NGResponseTypeModel , 需要设置 ) */
@property (nonatomic,strong) Class ng_responseClass;

/**
 *  通过 ng_responseType 解析返回数据(NSData)
 */
- (id)ng_responseWithResponseObject:(id)responseObject;

@end

@interface NGResponse (NGChain)

/** 设置 responseType */
@property (nonatomic,copy,readonly) NGResponse *(^c_ng_responseType)(NGResponseType responseType);
/** 设置 responseClass */
@property (nonatomic,copy,readonly) NGResponse *(^c_ng_responseClass)(Class responseClass);

@end
