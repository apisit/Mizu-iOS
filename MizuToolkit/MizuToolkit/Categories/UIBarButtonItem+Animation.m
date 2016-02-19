//
//  UIBarButtonItem+Animation.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/30/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "UIBarButtonItem+Animation.h"

@implementation UIBarButtonItem (Animation)

-(void)wiggleView {
    UIView *view = [self valueForKey:@"view"];
    [view popOutsideWithDuration:0.3 callBack:^{
       
    }];
}

@end
