//
//  MZBusinessHourButton.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/25/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZBusinessHourButton.h"


@implementation MZBusinessHourButton
- (void)setupView{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
   [self setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    [self setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    self.backgroundColor = UIColorFromRGB(0xcc3333);
    self.layer.cornerRadius = 3;
    self.adjustsImageWhenHighlighted = NO;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
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

-(void)prepareForInterfaceBuilder{
    [self setupView];
}

@end
