//
//  MZBusinessNameLabel.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/30/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZBusinessNameLabel.h"

@implementation MZBusinessNameLabel

- (void)setupView{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.highlightedTextColor = UIColorFromRGB(0xffffff);
    self.textColor = UIColorFromRGB(0xffffff);
    self.layer.backgroundColor =  [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.5].CGColor;
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

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(1.5, 0, 0, 0);
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
