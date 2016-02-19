//
//  MZDeleteButton.m
//  Mizu
//
//  Created by Apisit Toompakdee on 2/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZDeleteButton.h"

@implementation MZDeleteButton


- (void)drawRect:(CGRect)rect {
    
    
    //// Subframes
    CGRect group3 = CGRectMake(CGRectGetMinX(rect) + floor(CGRectGetWidth(rect) * 0.07143 + 0.5), CGRectGetMinY(rect) + floor(CGRectGetHeight(rect) * 0.07143 + 0.5), floor(CGRectGetWidth(rect) * 0.92857 + 0.5) - floor(CGRectGetWidth(rect) * 0.07143 + 0.5), floor(CGRectGetHeight(rect) * 0.92857 + 0.5) - floor(CGRectGetHeight(rect) * 0.07143 + 0.5));
    
    
    //// Group 3
    {
        //// Oval 2 Drawing
        UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(group3) + floor(CGRectGetWidth(group3) * 0.00000 + 0.5), CGRectGetMinY(group3) + floor(CGRectGetHeight(group3) * 0.00000 + 0.5), floor(CGRectGetWidth(group3) * 1.00000 + 0.5) - floor(CGRectGetWidth(group3) * 0.00000 + 0.5), floor(CGRectGetHeight(group3) * 1.00000 + 0.5) - floor(CGRectGetHeight(group3) * 0.00000 + 0.5))];
        [UIColor.darkGrayColor setFill];
        [oval2Path fill];
        [UIColor.whiteColor setStroke];
        oval2Path.lineWidth = 1;
        [oval2Path stroke];
        
        
        //// Bezier 4 Drawing
        UIBezierPath* bezier4Path = UIBezierPath.bezierPath;
        [bezier4Path moveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.65233 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.65367 * CGRectGetHeight(group3))];
        [bezier4Path addCurveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.59033 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.65154 * CGRectGetHeight(group3)) controlPoint1: CGPointMake(CGRectGetMinX(group3) + 0.63583 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.67017 * CGRectGetHeight(group3)) controlPoint2: CGPointMake(CGRectGetMinX(group3) + 0.60808 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.66929 * CGRectGetHeight(group3))];
        [bezier4Path addLineToPoint: CGPointMake(CGRectGetMinX(group3) + 0.34717 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.40833 * CGRectGetHeight(group3))];
        [bezier4Path addCurveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.34504 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.34638 * CGRectGetHeight(group3)) controlPoint1: CGPointMake(CGRectGetMinX(group3) + 0.32942 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.39058 * CGRectGetHeight(group3)) controlPoint2: CGPointMake(CGRectGetMinX(group3) + 0.32854 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.36283 * CGRectGetHeight(group3))];
        [bezier4Path addLineToPoint: CGPointMake(CGRectGetMinX(group3) + 0.34504 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.34638 * CGRectGetHeight(group3))];
        [bezier4Path addCurveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.40704 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.34842 * CGRectGetHeight(group3)) controlPoint1: CGPointMake(CGRectGetMinX(group3) + 0.36154 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.32988 * CGRectGetHeight(group3)) controlPoint2: CGPointMake(CGRectGetMinX(group3) + 0.38929 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.33075 * CGRectGetHeight(group3))];
        [bezier4Path addLineToPoint: CGPointMake(CGRectGetMinX(group3) + 0.65021 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.59167 * CGRectGetHeight(group3))];
        [bezier4Path addCurveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.65233 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.65367 * CGRectGetHeight(group3)) controlPoint1: CGPointMake(CGRectGetMinX(group3) + 0.66796 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.60938 * CGRectGetHeight(group3)) controlPoint2: CGPointMake(CGRectGetMinX(group3) + 0.66887 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.63713 * CGRectGetHeight(group3))];
        [bezier4Path addLineToPoint: CGPointMake(CGRectGetMinX(group3) + 0.65233 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.65367 * CGRectGetHeight(group3))];
        [bezier4Path closePath];
        bezier4Path.miterLimit = 4;
        
        [UIColor.whiteColor setFill];
        [bezier4Path fill];
        
        
        //// Bezier 8 Drawing
        UIBezierPath* bezier8Path = UIBezierPath.bezierPath;
        [bezier8Path moveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.34504 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.65367 * CGRectGetHeight(group3))];
        [bezier8Path addCurveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.34713 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.59167 * CGRectGetHeight(group3)) controlPoint1: CGPointMake(CGRectGetMinX(group3) + 0.32850 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.63713 * CGRectGetHeight(group3)) controlPoint2: CGPointMake(CGRectGetMinX(group3) + 0.32942 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.60942 * CGRectGetHeight(group3))];
        [bezier8Path addLineToPoint: CGPointMake(CGRectGetMinX(group3) + 0.59033 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.34842 * CGRectGetHeight(group3))];
        [bezier8Path addCurveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.65233 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.34638 * CGRectGetHeight(group3)) controlPoint1: CGPointMake(CGRectGetMinX(group3) + 0.60808 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.33075 * CGRectGetHeight(group3)) controlPoint2: CGPointMake(CGRectGetMinX(group3) + 0.63579 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.32988 * CGRectGetHeight(group3))];
        [bezier8Path addLineToPoint: CGPointMake(CGRectGetMinX(group3) + 0.65233 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.34638 * CGRectGetHeight(group3))];
        [bezier8Path addCurveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.65021 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.40833 * CGRectGetHeight(group3)) controlPoint1: CGPointMake(CGRectGetMinX(group3) + 0.66883 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.36288 * CGRectGetHeight(group3)) controlPoint2: CGPointMake(CGRectGetMinX(group3) + 0.66796 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.39063 * CGRectGetHeight(group3))];
        [bezier8Path addLineToPoint: CGPointMake(CGRectGetMinX(group3) + 0.40704 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.65154 * CGRectGetHeight(group3))];
        [bezier8Path addCurveToPoint: CGPointMake(CGRectGetMinX(group3) + 0.34504 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.65367 * CGRectGetHeight(group3)) controlPoint1: CGPointMake(CGRectGetMinX(group3) + 0.38933 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.66929 * CGRectGetHeight(group3)) controlPoint2: CGPointMake(CGRectGetMinX(group3) + 0.36158 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.67013 * CGRectGetHeight(group3))];
        [bezier8Path addLineToPoint: CGPointMake(CGRectGetMinX(group3) + 0.34504 * CGRectGetWidth(group3), CGRectGetMinY(group3) + 0.65367 * CGRectGetHeight(group3))];
        [bezier8Path closePath];
        bezier8Path.miterLimit = 4;
        
        [UIColor.whiteColor setFill];
        [bezier8Path fill];
    }

}


@end
