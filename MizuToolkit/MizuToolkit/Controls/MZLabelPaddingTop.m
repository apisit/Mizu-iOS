//
//  MZLabelPaddingTop.m
//  Mizu
//
//  Created by Apisit Toompakdee on 6/18/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZLabelPaddingTop.h"

@implementation MZLabelPaddingTop

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {-10, 0, -10, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

-(void)setBounds:(CGRect)bounds{
    CGRect newBounds = bounds;
    newBounds.size.height =  newBounds.size.height + 10;
    [super setBounds:newBounds];
    
}

@end
