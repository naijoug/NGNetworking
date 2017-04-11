//
//  NSError+NGNetworking.h
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/11.
//  Copyright © 2017年 naijoug. All rights reserved.
//  用于存放接口自定义错误

#import <Foundation/Foundation.h>

@interface NSError (NGNetworking)

/** error code */
@property (nonatomic,assign) NSInteger ng_code;
/** error message */
@property (nonatomic,copy) NSString *ng_message;

+ (instancetype)ng_errorWithCode:(NSInteger)code message:(NSString *)message;

@end
