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
@property (nonatomic,strong) NSNumber *count;
@property (nonatomic,strong) NSNumber *start;

@end

@implementation BookRequest

- (NSString *)urlPathString {
    return @"/v2/book/search";
}

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


#pragma mark - Test

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NGConfig *config     = [NGConfig ng_config].ng_baseUrlString(@"https://api.douban.com");//.ng_isLog(NO);
    
    BookRequest *request = [BookRequest ng_request];
    request.q       = @"iOS";
    request.start   = @1;
    request.count   = @3;
    NGResponse *response = [NGResponse ng_response].ng_responseType(NGResponseTypeModel).ng_responseClass([BookList class]);
    
    [[NGNetworkManager ng_shareManager]
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


