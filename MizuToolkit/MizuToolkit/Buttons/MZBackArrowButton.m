//
//  PSBackArrowButton.m
//  Print Studio 2
//
//  Created by Apisit Toompakdee on 5/21/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZBackArrowButton.h"



@implementation MZBackArrowButton


- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color = [UIColor whiteColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMidX(rect) , CGRectGetMidY(rect) );
    
     CGContextRotateCTM(context, 90 * M_PI );
    //if ([self.direction isEqualToString:@"up"]) {
      //  CGContextRotateCTM(context, 90 * M_PI / 180);
  //  }else if ([self.direction isEqualToString:@"down"]) {
     //   CGContextRotateCTM(context, 90 * -M_PI / 180);
   // }
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(0.92, -9.42)];
    [bezierPath addLineToPoint: CGPointMake(-8.58, -0.17)];
    [bezierPath addLineToPoint: CGPointMake(0.92, 9.08)];
    
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    
    [color setStroke];
    bezierPath.lineWidth = 2.5;
    [bezierPath stroke];
    CGContextRestoreGState(context);
    
    self.layer.anchorPoint=(CGPoint){0.5, 0.5};
}

@end
