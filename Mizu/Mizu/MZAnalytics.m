//
//  MZAnalytics.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/1/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZAnalytics.h"

@implementation MZAnalytics
+(void)track:(NSString *)label{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX" action:@"tap" label:label value:nil] build]];
}

+ (void)trackUserAction:(NSString*)action{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"&uid"
           value:[MZUser currentUser].userId];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX" action:action label:nil value:nil] build]];
}

+ (void)trackBusiness:(NSString*)businessName action:(NSString*)action{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"&uid"
           value:[MZUser currentUser].userId];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Business" action:action label:businessName value:nil] build]];
}

@end
