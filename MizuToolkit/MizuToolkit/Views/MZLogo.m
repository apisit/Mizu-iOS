//
//  MZLogo.m
//  Mizu
//
//  Created by Apisit Toompakdee on 7/1/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZLogo.h"

@implementation MZLogo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)prepareForInterfaceBuilder{
    [self drawRect:self.bounds];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
  
    if (self.mColor==nil){
        self.mColor = [UIColor whiteColor];
    }
    
    if (self.lineColor==nil){
        self.lineColor = [UIColor colorWithRed: 0.78 green: 0 blue: 0 alpha: 1];
    }
    //// Subframes
    CGRect group = CGRectMake(CGRectGetMinX(rect) + floor(CGRectGetWidth(rect) * 0.15417) + 0.5, CGRectGetMinY(rect) + floor((CGRectGetHeight(rect) - 6) * 0.05263 + 0.5), floor(CGRectGetWidth(rect) * 0.84708 - 0.15) - floor(CGRectGetWidth(rect) * 0.15417) + 0.15, CGRectGetHeight(rect) - 6 - floor((CGRectGetHeight(rect) - 6) * 0.05263 + 0.5));
    
    
    //// Group
    {
        //// Text Drawing
        UIBezierPath* textPath = UIBezierPath.bezierPath;
        [textPath moveToPoint: CGPointMake(CGRectGetMinX(group) + 0.00000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.00000 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.00000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.71429 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.19115 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.71429 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.19115 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.21309 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.19375 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.21309 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.42131 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.71429 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.57866 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.71429 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.80622 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.20808 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.80882 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.20808 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.80882 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.71429 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.99997 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.71429 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.99997 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.00000 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.71259 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.00000 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.50714 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.49120 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.50454 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.49120 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.28738 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.00000 * CGRectGetHeight(group))];
        [textPath addLineToPoint: CGPointMake(CGRectGetMinX(group) + 0.00000 * CGRectGetWidth(group), CGRectGetMinY(group) + 0.00000 * CGRectGetHeight(group))];
        [textPath closePath];
        [self.mColor setFill];
        [textPath fill];
        
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(group) + floor(CGRectGetWidth(group) * 0.00000 + 0.5), CGRectGetMinY(group) + floor(CGRectGetHeight(group) * 0.81481 + 0.5), floor(CGRectGetWidth(group) * 1.00000 + 0.35) - floor(CGRectGetWidth(group) * 0.00000 + 0.5) + 0.15, rect.size.height * 0.12)];
        [self.lineColor setFill];
        [rectanglePath fill];
    }}


@end
