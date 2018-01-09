//
//  UIViewController+ErrorManager.h
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/8.
//  Copyright © 2018年 sandboy. Alv                                                                                                   l rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SYErrorManager)
/**
 *  在当前显示的controller弹出网络错误提示条
 *   默认所有controller都弹出，如果不需要的controller 重写这个方法返回NO
 *  @return yes
 */
- (BOOL)willShowErrorTipView;

@end
