//
//  MZPassThroughImageView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/25/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZPassThroughImageView.h"

@implementation MZPassThroughImageView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView == self ? nil : hitView;
}


@end
