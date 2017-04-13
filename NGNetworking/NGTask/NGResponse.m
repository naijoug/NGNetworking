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

+ (instancetype)ng_response {
    return [[self alloc] init];
}

- (id)ng_responseWithResponseObject:(id)responseObject {
    
    // data -> String
    NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    // data -> JSON
    NSError *error;
    id responseJSON     = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
    [[NGNetworkManager ng_shareManager] logWithTitle:@"JSON解析错误" error:error];
    
    // 成功响应数据
    id response         = responseString;
    switch (self.ng_responseType) {
            case NGResponseTypeString:      response = responseString; break;
            case NGResponseTypeData:        response = responseObject; break;
            case NGResponseTypeJSON:        response = responseJSON;   break;
            case NGResponseTypeModel: { // response 解析成 Model
                if (!self.ng_responseClass) {
                    [[NGNetworkManager ng_shareManager] logWithTitle:@"Model解析错误" message:@"未设置 responseClass 类型"];
                }
                if ([responseJSON isKindOfClass:[NSArray class]]) { // 是JSON数组
                    response = [NSArray ng_modelArrayWithClass:self.ng_responseClass json:responseJSON];
                } else if ([responseJSON isKindOfClass:[NSDictionary class]]) { // 是JSON字典
                    response = [self.ng_responseClass ng_modelWithJSON:responseJSON];
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
