//
//  MZOnlyInDublinViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/1/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZOnlyInDublinViewController.h"
@interface MZOnlyInDublinViewController()

@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet MZLineView *lineView;

@end

@implementation MZOnlyInDublinViewController


- (IBAction)didTapJoin:(UIButton*)sender {
    [UIView animateWithDuration:1.0 delay:00 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.lblMessage.alpha = 0;
        self.lineView.alpha = 0;
        sender.alpha = 0;
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
         [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
