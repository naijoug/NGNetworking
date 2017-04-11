//
//  NGRequest.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NGRequest.h"

@interface NGRequest ()

@end

@implementation NGRequest

+ (instancetype)ng_request {
    return [[self alloc] init];
}

- (NGRequest *(^)(NGRequestType))ng_requestType {
    return ^(NGRequestType requestType) {
        _requestType = requestType;
        return self;
    };
}
- (NGRequest *(^)(NSString *))ng_urlPathString {
    return ^(NSString *urlPathString) {
        _urlPathString = urlPathString;
        return self;
    };
}
- (NGRequest *(^)(id))ng_parameters {
    return ^(id parameters) {
        _parameters = parameters;
        return self;
    };
}

#pragma mark - NGModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return nil;
}
+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"requestType",
             @"urlPathString",
             @"parameters"];
}


@end
