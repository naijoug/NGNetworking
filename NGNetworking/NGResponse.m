//
//  NGResponse.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NGResponse.h"

@implementation NGResponse

+ (instancetype)ng_response {
    return [[self alloc] init];
}

- (NGResponse * (^)(NGResponseType))ng_responseType {
    return ^ NGResponse * (NGResponseType responseType) {
        _responseType = responseType;
        return self;
    };
}
- (NGResponse * (^)(__unsafe_unretained Class))ng_responseClass {
    return ^(Class responseClass) {
        _responseClass = responseClass;
        return self;
    };
}

@end
