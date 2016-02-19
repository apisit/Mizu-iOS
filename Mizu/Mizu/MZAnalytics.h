//
//  MZAnalytics.h
//  Mizu
//
//  Created by Apisit Toompakdee on 4/1/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZAnalytics : NSObject
+ (void)track:(NSString*)label;
+ (void)trackUserAction:(NSString*)action;
+ (void)trackBusiness:(NSString*)businessName action:(NSString*)action;
@end
