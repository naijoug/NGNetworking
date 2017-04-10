//
//  ViewController.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/3/16.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "ViewController.h"
#import "NGNetworking.h"


@interface TestRequest : NGBaseRequest

/** cmd */
@property (nonatomic,copy) NSString *cmd;

@end

@implementation TestRequest

@end

@interface PosLine : NSObject

/** pos */
@property (nonatomic,copy) NSString *pos;
/** value */
@property (nonatomic,strong) NSNumber *value;

@end

@implementation PosLine


@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *urlString = @"http://www.gupiaogaoshou.com:8090/v2/ex/ai/ai/apply.jsp";
    
    TestRequest *request = [TestRequest ng_request];
    request.cmd = @"getPosLine";
    
    
    [[NGNetworkManager shareManager].ng_httpMethod(NGHTTPMethodPost).ng_urlString(urlString)
     .ng_requestType(NGRequestTypeModel).ng_request(request)
     .ng_responseType(NGResponseTypeModel).ng_responseClass([PosLine class])
     .ng_successHandler(^(NSInteger stateCode, id response){
        NSLog(@"response : %@", response);
    }).ng_failureHandler(^(NSError *error){
        NSLog(@"error : %@", error.description);
    }) ng_start];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
