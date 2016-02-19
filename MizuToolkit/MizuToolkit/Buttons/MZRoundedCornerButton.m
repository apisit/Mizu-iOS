//
//  MZRoundedCornerButton.m
//  Mizu
//
//  Created by Apisit Toompakdee on 7/1/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZRoundedCornerButton.h"

@implementation MZRoundedCornerButton


- (void)setupView{
    self.layer.cornerRadius=self.bounds.size.height/2.0;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
