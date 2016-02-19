//
//  MZTabBar.m
//  Mizu
//
//  Created by Apisit Toompakdee on 11/16/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZTabBar.h"

@implementation MZTabBar

-(void)drawRect:(CGRect)rect{
    self.layer.borderWidth = 0.50;
    self.layer.borderColor = [MZColor backgroundColor].CGColor;
}

@end
