//
//  MZCustomHighlightedColorButton.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/3/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZCustomHighlightedColorButton.h"

@implementation MZCustomHighlightedColorButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    int errorMargin = 60;
    CGRect largerFrame = CGRectMake(0 - errorMargin, 0 - errorMargin, self.frame.size.width + errorMargin, self.frame.size.height + errorMargin);
    return (CGRectContainsPoint(largerFrame, point) == 1) ? self : nil;
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.8];
    }else {
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1.0];
    }
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
