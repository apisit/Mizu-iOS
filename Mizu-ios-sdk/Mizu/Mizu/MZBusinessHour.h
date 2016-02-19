//
//  MZBusinessHour.h
//  Mizu
//
//  Created by Apisit Toompakdee on 5/22/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

/**
 *  Business hour
 */
@interface MZBusinessHour : MZBaseObject

@property (nonatomic, assign) NSInteger weekday;
@property (nonatomic, assign) NSInteger weekdayISO8601;
@property (nonatomic, assign) NSInteger workingMinutes;
@property (nonatomic, strong) NSString* day;
@property (nonatomic, strong) NSString* openAt;
@property (nonatomic, strong) NSString* closeAt;
@property (nonatomic, readonly) NSDate* openDateTime;
@property (nonatomic, readonly) NSDate* closeDateTime;
@property (nonatomic, readonly) NSString* formattedOpenTime;
@property (nonatomic, readonly) NSString* formattedCloseTime;
@property (nonatomic, assign) BOOL isClose;

@end
