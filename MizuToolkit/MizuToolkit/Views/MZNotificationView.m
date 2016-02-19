//
//  MZNotificationView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/1/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZNotificationView.h"
#import "MZNotificationViewLabel.h"
@interface MZNotificationView()

@property (nonatomic, strong) UILabel* label;
@property (nonatomic, assign) UIStatusBarStyle currentBarStyle;
@end

@implementation MZNotificationView

-(void)setupView{
    CGRect frame = CGRectMake(0, -64,CGRectGetWidth([UIScreen mainScreen].bounds), 64);
    self.label = [[MZNotificationViewLabel alloc]initWithFrame:frame];
    self.label.backgroundColor = UIColorFromRGB(0x303030);
    self.label.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    self.label.textColor = UIColorFromRGB(0xb3b3b3);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.alpha = 0;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)showNoInternetConnection{
   // self.currentBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication.sharedApplication.delegate.window addSubview:self.label];
        self.label.text = @"No internet connection";
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect rect = self.label.frame;
            rect.origin.y = 0;
            self.label.frame = rect;
            self.label.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    });
}

-(void)hideNoInternetConnection{
  //  [[UIApplication sharedApplication] setStatusBarStyle:self.currentBarStyle animated:YES];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = self.label.frame;
        rect.origin.y = -64;
        self.label.frame = rect;
    } completion:^(BOOL finished) {
        [self.label removeFromSuperview];
    }];
}

@end
