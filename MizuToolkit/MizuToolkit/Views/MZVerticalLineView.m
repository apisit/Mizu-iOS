//
//  MZVerticalLineView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/24/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZVerticalLineView.h"

@interface MZVerticalLineView()

@property (nonatomic, strong) CALayer *lineLayer;

@end

@implementation MZVerticalLineView

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lineLayer.frame = (CGRectMake(0, 0,0.5, self.frame.size.height));
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    struct CGColor* strokeColor = [UIColorFromRGB(0xffffff) colorWithAlphaComponent:0.4].CGColor;
    self.lineLayer  = [CALayer layer];
    self.lineLayer.frame = (CGRectMake(0, 0,0.5, rect.size.height));
    self.lineLayer.backgroundColor = strokeColor;
    [self.layer addSublayer:self.lineLayer];
}


@end
