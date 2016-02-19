//
//  MZBaseNavigationBar.m
//  Mizu
//
//  Created by Apisit Toompakdee on 1/15/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZBaseNavigationBar.h"

@interface MZBaseNavigationBar()

@property (nonatomic,strong)  UIImageView *navBarHairlineImageView;
@end

@implementation MZBaseNavigationBar

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
   // self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.view];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.navBarHairlineImageView.hidden = YES;
}

@end
