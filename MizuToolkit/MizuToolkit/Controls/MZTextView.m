//
//  MZTextView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 11/8/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZTextView.h"

@implementation MZTextView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = UIEdgeInsetsZero;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 0);
}

@end
