//
//  DetailViewController.m
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import "DetailViewController.h"
#import "SYHTTPSessionManager.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情页";
    self.view.backgroundColor = [UIColor orangeColor];
    NSDictionary *parameter = @{
                                @"key":@"9a0aee0a9adbb615464b9b7bc1e9059b",
                                @"pagesize":[NSNumber numberWithInt:arc4random()%20+1],
                                @"sort":@"asc",
                                @"time":@"1418745237"
                                };
    __weak typeof(self) weakSelf = self;
    [SYHTTPSessionManager requestPostNetWithURL:@"http://japi.juhe.cn/joke/content/list.from?" andParameter:parameter withReturnValueBlock:^(id returnValue) {
        weakSelf.view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    } withErrorCodeBlock:^(id errorCode) {
        
    } withFailureBlock:^(id failCode) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
