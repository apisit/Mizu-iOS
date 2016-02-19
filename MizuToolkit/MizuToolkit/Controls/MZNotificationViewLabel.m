//
//  MZNotificationViewLabel.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/1/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZNotificationViewLabel.h"

@implementation MZNotificationViewLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {20, 0, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
