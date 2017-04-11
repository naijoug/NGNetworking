//
//  NGConfig.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NGConfig.h"

@implementation NGConfig

- (instancetype)init {
    if (self = [super init]) {
        _isLog = YES;   // 默认开启log
    }
    return self;
}

+ (instancetype)ng_config {
    return [[self alloc] init];
}

- (NGConfig * (^)(NSString *))ng_baseUrlString {
    return ^(NSString *baseUrlString) {
        _baseUrlString = baseUrlString;
        return self;
    };
}
- (NGConfig * (^)(NGNetwokLib))ng_networkLib {
    return ^(NGNetwokLib networkLib) {
        _networkLib = networkLib;
        return self;
    };
}
- (NGConfig * (^)(NGHTTPMethod))ng_httpMethod {
    return ^(NGHTTPMethod httpMethod) {
        _httpMethod = httpMethod;
        return self;
    };
}
- (NGConfig * (^)(BOOL))ng_isLog {
    return ^(BOOL isLog) {
        _isLog = isLog;
        return self;
    };
}

@end
