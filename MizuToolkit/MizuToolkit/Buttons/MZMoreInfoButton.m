//
//  MZMoreInfoButton.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/24/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZMoreInfoButton.h"

@implementation MZMoreInfoButton

- (void)setupView{
    self.clipsToBounds = YES;
    NSString* text = @"MORE INFO";
    [self setTitle:text forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = UIColorFromRGB(0xffffff);
    self.titleLabel.shadowColor = [UIColor clearColor];
    self.layer.backgroundColor =  [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.8].CGColor;
    self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.8];
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColorFromRGB(0xffffff) colorWithAlphaComponent:0.5].CGColor;
    self.adjustsImageWhenHighlighted = NO;
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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    int errorMargin = 10;
    CGRect largerFrame = CGRectMake(0 - errorMargin, 0 - errorMargin, self.frame.size.width + errorMargin, self.frame.size.height + errorMargin);
    return (CGRectContainsPoint(largerFrame, point) == 1) ? self : nil;
}


@end
