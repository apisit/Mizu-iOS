//
//  MZBusinessHour.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/22/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import "MZBusinessHour.h"


@implementation MZBusinessHour

-(NSDate*)parseTimeFromServer:(NSString*)time{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"hh:mma"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    });
    return [dateFormatter dateFromString:time];
}

-(NSString*)formatTimeForDisplay:(NSDate*)time{
    static NSDateFormatter *displayDateFormatter = nil;
    static dispatch_once_t onceToken;
    BOOL is24hourFormat = [MZHelper is24HourFormat];
    dispatch_once(&onceToken, ^{
        displayDateFormatter=[[NSDateFormatter alloc]init];
        [displayDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        
        if (is24hourFormat){
            [displayDateFormatter setDateFormat:@"HH:mm"];
        }else{
            [displayDateFormatter setDateFormat:@"h:mma"];
        }
    });

    NSString* formatted = [displayDateFormatter stringFromDate:time];;
    if (is24hourFormat){
        if ([formatted isEqualToString:@"12:00"]){
            return @"NOON";
        }
        
        if ([formatted isEqualToString:@"00:00"]){
            return  @"MIDNIGHT";
        }
    }else{
        if ([formatted isEqualToString:@"12:00PM"]){
            return  @"NOON";
        }
        
        if ([formatted isEqualToString:@"12:00AM"]){
            return  @"MIDNIGHT";
        }
    }
    
    return formatted;
}





-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        self.weekday = [[json objectForKey:@"week_day"] integerValue];
        if (self.weekday==0){
            self.weekdayISO8601 = 7;
        }else{
            self.weekdayISO8601 = self.weekday;
        }
        
        self.day = [json objectForKey:@"day"];
        self.openAt = [json objectForKey:@"open_at"];
        self.closeAt = [json objectForKey:@"close_at"];
        self.workingMinutes = [[json objectForKey:@"working_minutes"] integerValue];
        
        self.isClose = [[json objectForKey:@"is_close"] boolValue];
        
        if (self.openAt && self.closeAt){
            NSDate* openDateTime = [self parseTimeFromServer:self.openAt];
            NSDate* closeDateTime = [openDateTime dateByAddingTimeInterval:self.workingMinutes * 60];
            _openDateTime = openDateTime;
            _closeDateTime = closeDateTime;
            _formattedCloseTime = [self formatTimeForDisplay:_closeDateTime];
            _formattedOpenTime = [self formatTimeForDisplay:_openDateTime];
            
        }
    }
    return self;
}

@end
