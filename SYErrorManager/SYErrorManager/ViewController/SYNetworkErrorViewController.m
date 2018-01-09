//
//  SYNetworkErrorViewController.m
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import "SYNetworkErrorViewController.h"
#import "UIViewController+SYErrorManager.h"

@interface SYNetworkErrorViewController ()

@end

@implementation SYNetworkErrorViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"网络连接问题";

}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (IBAction)doSetting:(id)sender {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
#endif
}

- (BOOL)willShowErrorTipView {
	return NO;
}

@end
