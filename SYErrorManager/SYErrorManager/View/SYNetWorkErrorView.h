//
//  SYNetWorkErrorView.h
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/5.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYNetWorkErrorView;
@protocol SYNetworkErrorViewDelegate <NSObject>

@optional
- (void)didTapNetworkErrorView:(SYNetWorkErrorView *)errorView;

@end

@interface SYNetWorkErrorView : UIView
@property (nonatomic ,weak)IBOutlet UIImageView  *imgvAlert;
@property (nonatomic ,weak)IBOutlet UILabel *errorMessageLabel;
@property (nonatomic, assign) BOOL needHidden;

@property (nonatomic, assign) id <SYNetworkErrorViewDelegate> actionDelegate;
+ (SYNetWorkErrorView *)sharedErrorView;
+ (SYNetWorkErrorView *)showNetworkErrorViewAnimated:(BOOL )animated
                                          parentView:(UIView *)parentView
                                            delegate:(id)delegate
                                dismissAutomatically:(BOOL)dismissAutomatically;
- (void)dismissNetworkErrorView;
+ (BOOL)canShow;
+ (void)blockError:(BOOL)flag;

- (IBAction)doPressDetail:(id)sender;

- (void)setTitle:(NSString *)title;
@end
