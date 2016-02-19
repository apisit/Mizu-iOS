//
//  MZLineView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/21/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZLineView.h"

@implementation MZLineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    struct CGColor* strokeColor = UIColorFromRGB(0xcccccc).CGColor;
    CALayer *layer  = [CALayer layer];
    layer.frame = (CGRectMake(0, 0, self.frame.size.width, 0.5));
    layer.backgroundColor = strokeColor;
    [self.layer addSublayer:layer];
}


@end
