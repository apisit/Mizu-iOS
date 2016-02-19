//
//  NSDate+Categories.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/23/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "NSDate+Categories.h"

@implementation NSDate (Categories)

-(NSInteger)toHour{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale:[NSLocale currentLocale]];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    return [components hour];
}

-(NSInteger)toMinute{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale:[NSLocale currentLocale]];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self];
    return [components minute];
}
@end
