//
//  MZSectionDetailLabel.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZSectionDetailLabel.h"

@implementation MZSectionDetailLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 10, 0, 10))];
}



@end
