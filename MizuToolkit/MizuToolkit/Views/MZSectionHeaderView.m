//
//  MZSectionHeaderView.m
//  MizuToolkit
//
//  Created by Apisit Toompakdee on 10/27/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZSectionHeaderView.h"
#import "MZCustomKerningLabel.h"
@implementation MZSectionHeaderView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setupView:rect];
}
- (void)setupView:(CGRect)frame{
    struct CGColor* strokeColor = self.separatorColor.CGColor;
    if (!self.hideTopSeparator){
        CALayer *topLayer  = [CALayer layer];
        topLayer.frame = (CGRectMake(0, 0, frame.size.width, 0.5));
        topLayer.backgroundColor = strokeColor;
        [self.layer addSublayer:topLayer];
    }

    
    if (!self.hideBottomSeparator){
        CALayer *bottomLayer  = [CALayer layer];
        bottomLayer.frame = (CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5));
        bottomLayer.backgroundColor = strokeColor;
        [self.layer addSublayer:bottomLayer];
    }
    
    MZCustomKerningLabel* lbl = [[MZCustomKerningLabel alloc]initWithFrame:CGRectMake(15, 0, frame.size.width-30, frame.size.height)];
    lbl.font = self.font;
    if (self.title){
        lbl.text = self.title;
    }
    lbl.textAlignment = self.textAlignment;
    lbl.textColor = self.textColor;
    [self addSubview:lbl];
}

@end
