//
//  NGResponse.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import <Foundation/Foundation.h>

/** HTTP成功返回数据类型 */
typedef NS_ENUM(NSInteger, NGResponseType) {
    NGResponseTypeData,         // 二进制 (NSData)
    NGResponseTypeJSON,         // JSON字典 (NSDictionary)
    NGResponseTypeModel,        // Model (需要设置Model Class)
};

@interface NGResponse : NSObject

+ (instancetype)ng_response;

/** 响应数据类型 */
@property (nonatomic,assign,readonly) NGResponseType responseType;
/** response Model class ( == NGResponseTypeModel ) */
@property (nonatomic,strong,readonly) Class responseClass;

- (NGResponse * (^)(NGResponseType responseType))ng_responseType;
- (NGResponse * (^)(Class responseClasss))ng_responseClass;

@end
