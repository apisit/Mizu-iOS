//
//  MZLabelZeroPadding.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/22/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZLabelZeroPadding.h"

@implementation MZLabelZeroPadding

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {-(self.font
        .pointSize/2), 0, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
