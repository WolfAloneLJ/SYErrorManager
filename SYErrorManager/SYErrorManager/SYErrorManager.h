//
//  SYErrorManager.h
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

/*
 //网络错误的时候提示用户当前网络异常状态
 //网络从异常转为正常的时候:
 //1、自动刷新当前页面数据
 //2、去掉网络提示框
 //3、视频网络提示框
 //启动时，网络连接异常提示
 */

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "SYNetworkErrorConfig.h"

@interface SYErrorManager : NSObject

@property ( nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;
+ (SYErrorManager *)manager;
- (void)handleRequestError:(NSError *)error;

@end

