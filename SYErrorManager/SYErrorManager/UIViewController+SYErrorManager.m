//
//  UIViewController+SYErrorManager.m
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import "UIViewController+SYErrorManager.h"

@implementation UIViewController (SYErrorManager)
- (BOOL)willShowErrorTipView{
    UINavigationController *nav = self.navigationController;
    if(nav && nav.navigationBarHidden == NO){
        return YES;
    }
    return NO;
    
}
@end
