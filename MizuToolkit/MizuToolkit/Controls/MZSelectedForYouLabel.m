//
//  MZSelectedForYouLabel.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZSelectedForYouLabel.h"

@implementation MZSelectedForYouLabel

- (void)setupView{
    self.clipsToBounds = YES;
    NSString* text = @"SELECTED BY MIZU";
    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSKernAttributeName value:@0.8 range:NSMakeRange(0,text.length)];
    [self setAttributedText:attributedString];
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 4;
    self.highlightedTextColor = UIColorFromRGB(0x444444);
    self.textColor = UIColorFromRGB(0x444444);
    self.layer.backgroundColor =  UIColorFromRGB(0xFEB945).CGColor ;
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
