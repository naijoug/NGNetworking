//
//  NGBaseRequest.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NGBaseRequest.h"
#import <YYModel/YYModel.h>

@implementation NGBaseRequest

+ (instancetype)ng_request {
    return [[self alloc] init];
}

- (id)ng_parameters {
    return [self yy_modelToJSONObject];
}

@end
