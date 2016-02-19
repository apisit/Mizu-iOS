//
//  MZSmallRoundedCornerButton.m
//  Mizu
//
//  Created by Apisit Toompakdee on 1/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZSmallRoundedCornerButton.h"

@implementation MZSmallRoundedCornerButton


- (void)setupView{
    self.layer.cornerRadius = 6.0;
}

-(void)setWithBorder:(BOOL)withBorder{
    _withBorder = withBorder;
    if (_withBorder==YES){
        self.layer.borderColor = UIColorFromRGB(0x252525).CGColor;
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
    }
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
