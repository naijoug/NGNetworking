//
//  ViewController.m
//  NGNetworkingSample
//
//  Created by guojian on 2017/3/16.
//  Copyright © 2017年 naijoug. All rights reserved.
//

#import "ViewController.h"
#import "NGNetworking.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[NGNetworkManager shareManager].ng_httpMethod(NGHTTPMethodPost).ng_urlString(@"").ng_parameters(nil).ng_successHandler(^(NSInteger stateCode, id response){
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
