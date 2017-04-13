//
//  NGTask.m
//  NGNetworking
//
//  Created by guojian on 2017/4/12.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NGTask.h"
#import <NGModel/NGModel.h>

@implementation NGTask

+ (instancetype)ng_task {
    return [[self alloc] init];
}

- (NSUInteger)hash {
    NSMutableString *mString = [NSMutableString string];
    [mString appendFormat:@"%ld ", (long)self.ng_httpMethod];
    [mString appendFormat:@"%@ ", self.ng_request.ng_urlPathString];
    [mString appendFormat:@"%@", [self.ng_request.ng_parameters ng_modelToJSONString]];
    
    return [mString hash];
}

@end

@implementation NGTask (NGChain)

- (NGTask * (^)(NGHTTPMethod))c_ng_httpMethod {
    return ^(NGHTTPMethod httpMethod) {
        _ng_httpMethod = httpMethod;
        return self;
    };
}
- (NGTask *(^)(NGRequest *))c_ng_request {
    return ^(NGRequest *request) {
        _ng_request = request;
        return self;
    };
}
- (NGTask * (^)(NGResponse *))c_ng_response {
    return ^(NGResponse *response) {
        _ng_response = response;
        return self;
    };
}
- (NGTask *(^)(NGSuccessHandler))c_ng_success {
    return ^(NGSuccessHandler success) {
        _ng_success = success;
        return self;
    };
}
- (NGTask *(^)(NGFailureHandler))c_ng_failure {
    return ^(NGFailureHandler failure) {
        _ng_failure = failure;
        return self;
    };
}

@end
