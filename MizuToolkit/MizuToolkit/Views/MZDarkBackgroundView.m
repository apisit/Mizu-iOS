//
//  MZDarkBackgroundView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/24/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZDarkBackgroundView.h"

@implementation MZDarkBackgroundView

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    self.layer.backgroundColor = [UIColorFromRGB(0x000000)colorWithAlphaComponent:0.5].CGColor;
    self.alpha = 1.0;
    self.layer.opacity = 1.0;
}

-(void)setHighlighted:(BOOL)highlighted{
    self.layer.backgroundColor = [UIColorFromRGB(0x000000)colorWithAlphaComponent:highlighted?0.8:0.5].CGColor;
    [super setHighlighted:highlighted];
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}
@end
