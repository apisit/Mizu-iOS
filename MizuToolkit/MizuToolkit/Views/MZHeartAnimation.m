//
//  MZHeartAnimation.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/17/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZHeartAnimation.h"

@implementation MZHeartAnimation


-(void)setupView{
    self.animationDuration = 0.5;
    self.animationRepeatCount = 1;
    self.animationImages = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"1.png"],
                             [UIImage imageNamed:@"2.png"],
                             [UIImage imageNamed:@"3.png"],
                             [UIImage imageNamed:@"4.png"],
                             [UIImage imageNamed:@"5.png"],
                             [UIImage imageNamed:@"6.png"],
                             [UIImage imageNamed:@"7.png"],
                             [UIImage imageNamed:@"8.png"],
                             [UIImage imageNamed:@"9.png"],nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)awakeFromNib{
    [self setupView];
}

@end
