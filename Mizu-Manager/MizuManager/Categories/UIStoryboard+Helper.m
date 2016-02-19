//
//  UIStoryboard+Helper.m
//  MizuManager
//
//  Created by Apisit Toompakdee on 9/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "UIStoryboard+Helper.h"

@implementation UIStoryboard (Helper)

+ (id)manager{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Manager" bundle:nil];
    return [storyboard instantiateInitialViewController];
    
}
+ (id)login{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    return [storyboard instantiateInitialViewController];
    
}
@end
