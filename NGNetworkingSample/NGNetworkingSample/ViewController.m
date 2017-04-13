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

- (NSString *)ng_urlPathString {
    return @"/v2/book/search";
}

@end

@interface BookInfo : NSObject

@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,strong) NSArray *author;

@end
@implementation BookInfo

@end
@interface BookList : NSObject

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
    
    NGConfig *config     = [NGConfig ng_config].c_ng_baseUrlString(@"https://api.douban.com");//.c_ng_isLog(NO);
    
    BookRequest *request = [BookRequest ng_request];
    request.q       = @"iOS";
    request.start   = @1;
    request.count   = @3;
    NGResponse *response = [NGResponse ng_response].c_ng_responseType(NGResponseTypeModel).c_ng_responseClass([BookList class]);
    
    // test1
    NGTask *task = [NGTask ng_task].c_ng_request(request).c_ng_response(response)
    .c_ng_success(^(NSInteger statusCode, id response) {
        NSLog(@"response : %@", response);
    }).c_ng_failure(^(NSError *error) {
        NSLog(@"error : %@", error);
    });
    [[NGNetworkManager ng_shareManager].c_ng_config(config) ng_startNGTask:task];
    
    // test2
    request.count = @5;
    [[NGNetworkManager ng_shareManager].c_ng_config(config) ng_startNGTask:[NGTask ng_task].c_ng_request(request).c_ng_response(response) success:^(NSInteger statusCode, id response) {
        NSLog(@"response : %@", response);
    } failure:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
    
    
}

@end


