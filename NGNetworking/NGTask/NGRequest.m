//
//  NGRequest.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NGRequest.h"

@implementation NGRequest

+ (instancetype)ng_request {
    return [[self alloc] init];
}

- (id)ng_parameters {
    switch (self.ng_requestType) {
            case NGRequestTypeJSON:     return _ng_parameters; break;
            case NGRequestTypeModel:    return [self ng_modelToJSONObject]; break;
    }
}

#pragma mark - NGModel

+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"ng_requestType",
             @"ng_urlPathString",
             @"ng_parameters"];
}

@end

@implementation NGRequest (NGChain)

- (NGRequest * (^)(NSString *))c_ng_urlPathString {
    return ^(NSString *urlPathString) {
        _ng_urlPathString = urlPathString;
        return self;
    };
}
- (NGRequest * (^)(NGRequestType))c_ng_requestType {
    return ^(NGRequestType requestType) {
        _ng_requestType = requestType;
        return self;
    };
}
- (NGRequest * (^)(id))c_ng_parameters {
    return ^(id parameters) {
        _ng_parameters = parameters;
        return self;
    };
}

@end
