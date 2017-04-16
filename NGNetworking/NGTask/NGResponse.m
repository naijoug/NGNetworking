//
//  NGResponse.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/4/10.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "NGResponse.h"
#import "NGNetworkManager.h"

@implementation NGResponse

+ (instancetype)ng_response { return [[self alloc] init]; }

- (id)ng_paraseResponse:(id)response {
    
    NSString *responseString    = nil;
    NSData *responseData        = nil;
    id responseJSON             = nil;
    
    if ([response isKindOfClass:[NSString class]]) { // String类型
        responseString  = response;
        // String -> Data
        responseData    = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        // Data -> JSON
        NSError *error;
        responseJSON    = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        [[NGNetworkManager ng_shareManager] logWithTitle:@"JSON解析错误" error:error];
    } else if ([response isKindOfClass:[NSData class]]) { // Data类型
        responseData    = response;
        // Data -> String
        responseString  = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        // Data -> JSON
        NSError *error;
        responseJSON    = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        [[NGNetworkManager ng_shareManager] logWithTitle:@"JSON解析错误" error:error];
    } else if ( [response isKindOfClass:[NSDictionary class]]
             || [response isKindOfClass:[NSArray class]] ) { // NSDictionary || NSArray
        responseJSON    = response;
        // JSON -> Data
        NSError *error;
        responseData    = [NSJSONSerialization dataWithJSONObject:responseJSON options:kNilOptions error:&error];
        [[NGNetworkManager ng_shareManager] logWithTitle:@"JSON解析错误" error:error];
        // Data -> String
        responseString  = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    }
    
    // 根据类型解析response
    switch (self.ng_responseType) {
            case NGResponseTypeString:  return responseString;  break;
            case NGResponseTypeData:    return responseData;    break;
            case NGResponseTypeJSON:    return responseJSON;    break;
            case NGResponseTypeModel: { // response 解析成 Model
                if (!self.ng_responseClass) {
                    [[NGNetworkManager ng_shareManager] logWithTitle:@"Model解析错误" message:@"未设置 responseClass 类型"];
                }
                if ([responseJSON isKindOfClass:[NSArray class]]) { // 是JSON数组
                    return [NSArray ng_modelArrayWithClass:self.ng_responseClass json:responseJSON];
                } else if ([responseJSON isKindOfClass:[NSDictionary class]]) { // 是JSON字典
                    return [self.ng_responseClass ng_modelWithJSON:responseJSON];
                }
            }
            break;
    }
    return response;
}

@end

@implementation NGResponse (NGChain)

- (NGResponse * (^)(NGResponseType))c_ng_responseType {
    return ^ NGResponse * (NGResponseType responseType) {
        _ng_responseType = responseType;
        return self;
    };
}
- (NGResponse * (^)(__unsafe_unretained Class))c_ng_responseClass {
    return ^(Class responseClass) {
        _ng_responseClass = responseClass;
        return self;
    };
}

@end
