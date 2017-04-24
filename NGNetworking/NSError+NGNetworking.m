//
//  NSError+NGNetworking.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/11.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NSError+NGNetworking.h"
#import <objc/runtime.h>

@implementation NSError (NGNetworking)

- (NSInteger)ng_code {
    return [objc_getAssociatedObject(self, @selector(setNg_code:)) integerValue];
}
- (void)setNg_code:(NSInteger)ng_code {
    objc_setAssociatedObject(self, _cmd, @(ng_code), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)ng_message {
    return objc_getAssociatedObject(self, @selector(setNg_message:));
}
- (void)setNg_message:(NSString *)ng_message {
    objc_setAssociatedObject(self, _cmd, ng_message, OBJC_ASSOCIATION_COPY);
}

+ (instancetype)ng_errorWithCode:(NSInteger)code message:(NSString *)message {
    NSError *error      = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
    error.ng_code       = code;
    error.ng_message    = message;
    return error;
}

@end
