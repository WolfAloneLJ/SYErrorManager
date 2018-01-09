//
//  ViewController.m
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import "ViewController.h"
#import "SYHTTPSessionManager.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *jokeBookView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MainVC";
   
    [self refresh];
}
- (IBAction)refreshEvent:(id)sender {
    [self refresh];
}
-(void)refresh{
    NSDictionary *parameter = @{
                                @"key":@"9a0aee0a9adbb615464b9b7bc1e9059b",
                                @"pagesize":[NSNumber numberWithInt:arc4random()%20+1],
                                @"sort":@"asc",
                                @"time":@"1418745237"
                                };
    __weak typeof(self) weakSelf = self;
    [SYHTTPSessionManager requestPostNetWithURL:@"http://japi.juhe.cn/joke/content/list.from?" andParameter:parameter withReturnValueBlock:^(id returnValue) {
        NSLog(@"%@",[[returnValue objectForKey:@"result"] objectForKey:@"data"]);
        NSArray * tempAry =[[returnValue objectForKey:@"result"] objectForKey:@"data"];
        NSString *str = [tempAry[0] objectForKey:@"content"];
        weakSelf.jokeBookView.text = str ;
    } withErrorCodeBlock:^(id errorCode) {
        
    } withFailureBlock:^(id failCode) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
