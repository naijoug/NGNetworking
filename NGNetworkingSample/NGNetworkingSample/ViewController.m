//
//  ViewController.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/3/16.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "ViewController.h"
#import "NGNetworking.h"


#pragma mark - Model

@interface BookRequest : NGRequest
@property (nonatomic,copy) NSString *q;
@end

@implementation BookRequest
- (NSString *)q { return @"iOS"; }
@end

@interface BookInfo : NSObject

@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,strong) NSArray *author;

@end
@implementation BookInfo

@end
@interface BookList : NSObject<NGModel>

@property (nonatomic,strong) NSNumber *count;
@property (nonatomic,strong) NSNumber *start;
@property (nonatomic,strong) NSNumber *total;
@property (nonatomic,strong) NSArray *books;

@end
@implementation BookList

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"books": [BookInfo class]};
}

@end


#pragma mark -

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NGConfig *config = [NGConfig ng_config].ng_baseUrlString(@"https://api.douban.com")
                                           .ng_isLog(YES)
                                           .ng_httpMethod(NGHTTPMethodPost);
    
    NGRequest *request = [BookRequest ng_request].ng_urlPathString(@"/v2/book/search").ng_requestType(NGRequestTypeModel);
    NGResponse *response = [NGResponse ng_response].ng_responseType(NGResponseTypeModel).ng_responseClass([BookList class]);
    
    [[NGNetworkManager shareManager]
     .ng_config(config)
     .ng_request(request)
     .ng_response(response)
     .ng_successHandler(^(NSInteger stateCode, id response) {
         NSLog(@"response : %@", response);
    }).ng_failureHandler(^(NSError *error){
        NSLog(@"error : %@", error.description);
    }) ng_start];
    
    
}

@end


