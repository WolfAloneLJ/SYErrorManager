//
//  SYNetWorkErrorView.m
//  SYErrorManager
//
//  Created by 吕俊 on 2018/1/5.
//  Copyright © 2018年 sandboy. All rights reserved.
//

#import "SYNetWorkErrorView.h"

@implementation SYNetWorkErrorView

static SYNetWorkErrorView  * v_instance;
+ (SYNetWorkErrorView *)sharedErrorView{
    if(v_instance == nil){
        v_instance = [[[NSBundle mainBundle ] loadNibNamed:@"SYNetWorkErrorView" owner:self options:nil] lastObject];
    }
    return v_instance;
}

+ (SYNetWorkErrorView *)showNetworkErrorViewAnimated:(BOOL )animated
                                          parentView:(UIView *)parentView
                                            delegate:(id)delegate
                                dismissAutomatically:(BOOL)dismissAutomatically{
    if(![SYNetWorkErrorView canShow]){
        return nil;
    }
    SYNetWorkErrorView *networkErrorView = [SYNetWorkErrorView sharedErrorView];
    
    networkErrorView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 36);
    networkErrorView.alpha = 1.0f;
    networkErrorView.actionDelegate = delegate;
    
    
    if ([networkErrorView.superview isEqual:parentView] == NO)
    {
        [networkErrorView removeFromSuperview];
    }
    [parentView addSubview:networkErrorView];
    
    [parentView bringSubviewToFront:networkErrorView];
    
    networkErrorView.alpha = 0.f;
    if(animated ){
        [UIView animateWithDuration:.3f animations:^{
            networkErrorView.alpha = 1.0f;
        }];
        
    }else{
        networkErrorView.alpha = 1.0f;
    }
    
    if(dismissAutomatically)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:networkErrorView selector:@selector(dismissNetworkErrorView) object:nil];
        [networkErrorView performSelector:@selector(dismissNetworkErrorView) withObject:nil afterDelay:3.f];
    }
    return networkErrorView;
}
- (void)dismissNetworkErrorView
{
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (BOOL)canShow
{
    return ![SYNetWorkErrorView sharedErrorView].needHidden;
}
+ (void)blockError:(BOOL)flag
{
    [SYNetWorkErrorView sharedErrorView].needHidden = flag;
}
- (void)setTitle:(NSString *)title
{
    self.errorMessageLabel.text = title;
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = [self.errorMessageLabel sizeThatFits:CGSizeMake(1000, self.errorMessageLabel.frame.size.height)];
    self.errorMessageLabel.frame = CGRectMake(self.frame.size.width/2-size.width/2, self.errorMessageLabel.frame.origin.y, size.width, self.errorMessageLabel.frame.size.height);
    float cx = CGRectGetMinX(self.errorMessageLabel.frame);
    cx -= CGRectGetWidth(self.imgvAlert.frame)/2.f;
    self.imgvAlert.center = CGPointMake(cx, self.imgvAlert.center.y);
}
- (IBAction)doPressDetail:(id)sender
{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(didTapNetworkErrorView:)]) {
        [self.actionDelegate performSelector:@selector(didTapNetworkErrorView:) withObject:nil];
    }
}
@end

