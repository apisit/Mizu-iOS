//
//  MZRequestRestaurantButton.m
//  Mizu
//
//  Created by Apisit Toompakdee on 3/3/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZRequestRestaurantButton.h"

@implementation MZRequestRestaurantButton


- (void)setupView{
    self.layer.cornerRadius = 6.0;
    self.layer.borderColor = RGB(102, 102, 102).CGColor;
    self.layer.borderWidth = 1.0f;
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

-(void)prepareForInterfaceBuilder{
    [self setupView];
}


@end
