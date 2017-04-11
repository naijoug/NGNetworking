//
//  NGModel.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//  YYModel 中的 Protocol

#import <Foundation/Foundation.h>

@protocol NGModel <NSObject>

@optional // YYModel 中几个常用的协议
/** 
 * model <-> JSON 自定义字段映射
 *
 * @{@"nid" :@"id"};
 */
+ (nullable NSDictionary<NSString *,id> *)modelCustomPropertyMapper;
/** 
 * model <-> JSON Array中Model Class映射
 *  
 * @{@"books": [BookInfo class]};
 */
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;
/** 
 * model <-> JSON 中忽略的字段 
 *
 * @[@"book"];
 */
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist;

@end
