//
//  SYErrorManager.m
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import "SYErrorManager.h"
#import "UIViewController+SYErrorManager.h"
#import "SYNetWorkErrorView.h"
#import "SYNetworkErrorViewController.h"

@implementation SYErrorManager
static SYErrorManager * instance = nil;



+ (SYErrorManager *)manager{
    
    @synchronized(self){
        if(instance == nil){
            instance = [[SYErrorManager alloc] init];
        }
        return instance;
    }
}
- (instancetype)init {
    self = [super init];
    
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        //网络切换通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityDidChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        //活跃状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        //网络错误提示
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HTTPSessionManagerTaskDidFailed:) name:SYHTTPSessionManagerTaskDidFailedNotification object:nil];
        self.networkReachabilityStatus = AFNetworkReachabilityStatusUnknown;
    }
    return self;
}
- (void)dealloc {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)notReachableErrorDescription {
    return @"当前网络不可用,请检查网络设置!";
}
- (NSString *)descriptionWithError:(NSError *)error {
    NSString *errorMessage = nil;
    
    if (self.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        errorMessage = [self notReachableErrorDescription];
    }
    else {
        switch ([error code]) {
            case NSURLErrorCancelled:
            case 0:
                errorMessage = nil;
                break;
                
            case NSURLErrorNotConnectedToInternet:
                errorMessage = @"网络异常,请检查网络设置是否正确!";
                break;
                
            case NSURLErrorCannotConnectToHost:
                errorMessage = @"亲！网络不给力阿！";
                break;
                
            default:
                break;
        }
    }
    return errorMessage;
}

- (void)showErrorAlertView:(NSString *)errorString {
    if (errorString && errorString.length) {
        UIViewController *controller = [self currentController];
        
        if (controller && [controller willShowErrorTipView]) {
            // 网络错误弹框
            SYNetWorkErrorView *errorView = [SYNetWorkErrorView showNetworkErrorViewAnimated:YES
                                                                                  parentView:controller.view
                                                                                    delegate:controller
                                                                        dismissAutomatically:YES];
            [errorView setTitle:errorString];
        }
    }
}

- (void)handleRequestError:(NSError *)error {
    NSString *errorString = [self descriptionWithError:error];
    
    [self showErrorAlertView:errorString];
}

- (void)networkingReachabilityDidChange {
    AFNetworkReachabilityStatus currentReachabilityStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    if (self.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        self.networkReachabilityStatus = currentReachabilityStatus;
    }
    else {
        BOOL isReachable = [AFNetworkReachabilityManager sharedManager].isReachable;
        
        if (isReachable && self.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            //未登录状态转到登录 根据登陆状态自定义是否刷新
            BOOL accountIsLogin = NO;
            if(accountIsLogin){
                //未登陆的操作
            }
            else {
                //                UIViewController *currentController = [self currentController];
                //统一的刷新方法
                //                if ([currentController respondsToSelector:@selector(doRefresh)]) {
                //                    [currentController performSelector:@selector(doRefresh) withObject:nil];
                //                }
            }
        } //从断网状态切换到联网状态，刷新当前页面数据
        
        self.networkReachabilityStatus = currentReachabilityStatus;
        
        if (self.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            [self showErrorAlertView];
        }
    }
}

- (void)applicationDidBecomeActive {
    self.networkReachabilityStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    if (self.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showErrorAlertView];
    }
}

- (void)showErrorAlertView {
    NSString *errorString = [self notReachableErrorDescription];
    
    [self showErrorAlertView:errorString];
}

#pragma mark -
#pragma mark HTTPSessionManagerTaskDidFailed

- (void)HTTPSessionManagerTaskDidFailed:(NSNotification *)notification {
    NSURLSessionTask *task = notification.object;
    
    [self handleRequestError:task.error];
}

#pragma mark -
#pragma mark get current controller

/*
 1.我们在非视图类中想要随时展示一个view时，需要将被展示的view加到当前view的子视图，或用当前view presentViewController，或pushViewContrller，这些操作都需要获取当前正在显示的ViewController。
 */
// tabbar (3)->navBar->MainVC ->pushVC1->presentVC2
//-(UIViewController *)currentController{
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *currentVC = (UIViewController *)[self getCurrentVCFrom:rootViewController];
//    NSLog(@"cuurent :%@",currentVC);
//    return currentVC;
//}

+(UIViewController *)currentController{
  return  [instance currentController];
}
-(UIViewController *)currentController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    NSLog(@"....%@",currVC.title);
    return currVC;
}
-(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC{
    UIViewController *currentVC;
//    if([rootVC presentationController]){
//        //视图是被presented出来的
//        rootVC = (UIViewController *)[rootVC presentationController];
//    }
    if([rootVC isKindOfClass:[UITabBarController class]]){
        //根视图为UITableBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }else if ([rootVC isKindOfClass:[UINavigationController class]]){
        //就是当前显示的控制器
        currentVC = [(UINavigationController *)rootVC visibleViewController];
    }else{
        //根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}
@end

@interface UIViewController (SYNetworkErrorView)

@end

@implementation UIViewController (SYNetworkErrorView)

- (void)didTapNetworkErrorView:(SYNetWorkErrorView *)errorView {
    //跳转设置页
    SYNetworkErrorViewController *controller = [[SYNetworkErrorViewController alloc] initWithNibName:@"SYNetworkErrorViewController" bundle:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end

