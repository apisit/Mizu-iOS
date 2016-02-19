//
//  MZBusiness.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZBusiness.h"

@implementation MZMeta

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        
        self.countryName = [json objectForKey:@"name"];
        self.countryCode = [json objectForKey:@"code"];
        self.currency = [json objectForKey:@"currency_code"];
        self.currencySymbol = [json objectForKey:@"currency_symbol"];
        self.currencyFactor = [NSNumber numberWithFloat:[[json objectForKey:@"currency_factor"] floatValue]];
    }
    return self;
}

@end

@interface MZBusiness()

#define GREEN @"26bf59"
#define ORANGE @"e68217"
#define RED @"cc3333"

@property (nonatomic, assign) NSInteger todayIndex;
@property (nonatomic, strong) NSArray* days;
@end

@implementation MZBusiness

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        self.objectId = [json objectForKey:@"id"];
        self.name = [json objectForKey:@"name"];
        self.address = [json objectForKey:@"address"];
        self.city = [json objectForKey:@"city"];
        self.state = [json objectForKey:@"state"];
        self.country = [json objectForKey:@"country"];
        self.postalCode = [json objectForKey:@"postal_code"];
        self.phone = [json objectForKey:@"phone"];
        self.tax = [[json objectForKey:@"tax"] doubleValue];
        self.isOpen24hours = [[json objectForKey:@"open_24_hours"] boolValue];
        double lat = [[json objectForKey:@"lat"] doubleValue];
        double lng = [[json objectForKey:@"lng"] doubleValue];
        self.coordinate = CLLocationCoordinate2DMake(lat, lng);
        self.distanceFromCurrentLocation = [[json objectForKey:@"distance_from_current_location"] doubleValue];
        self.verified = [[json objectForKey:@"verified"] boolValue];
        self.mizuPayEnabled = [[json objectForKey:@"mizu_pay_enabled"] boolValue];

        NSDictionary* meta = [json objectForKey:@"meta"];
        self.meta = [[MZMeta alloc]initWithJson:meta];
        
        NSArray* socials = [json objectForKey:@"socials"];
        NSMutableArray* socialList = [[NSMutableArray alloc]init];
        for(NSDictionary* json in socials){
            MZBusinessSocial* social = [[MZBusinessSocial alloc]initWithJson:json];
            if (social!=nil && social.url.length>0){
                [socialList addObject:social];
            }
        }
        
        self.socials = [NSArray arrayWithArray:socialList];
        
        NSArray* tags = [json objectForKey:@"tags"];
        if (tags){
            self.tags= [NSArray arrayWithArray:tags];
        }
        
        NSArray* images = [json objectForKey:@"image_urls"];
        if (images){
            self.imageUrls = [NSArray arrayWithArray:images];
        }
        
        NSArray* businessHours = [json objectForKey:@"business_hours"];
        NSMutableArray* hourList = [[NSMutableArray alloc]init];
        if (businessHours){
            NSDate* nowTime = [self nowTime];
            self.days = @[@"sunday",@"monday",@"tuesday",@"wednesday",@"thursday",@"friday",@"saturday"];
            //get current week day
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dateFormatter setLocale:usLocale];
            [dateFormatter setDateFormat:@"EEEE"];
            
            NSString* today = [[dateFormatter stringFromDate:[NSDate date]] lowercaseString];
            self.todayIndex = [self.days indexOfObject:today];
            
            
            for(NSDictionary* hourJson in businessHours){
                MZBusinessHour* hour = [[MZBusinessHour alloc]initWithJson:hourJson];
                if (hour){
                    [hourList addObject:hour];
                    CGFloat nowInterval = [nowTime timeIntervalSince1970];
                    CGFloat openInterval = [hour.openDateTime timeIntervalSince1970];
                    CGFloat closeInterval = [hour.closeDateTime timeIntervalSince1970];
                    if (hour.weekday == self.todayIndex && (openInterval<= nowInterval && closeInterval>=nowInterval) && hour.isClose==NO){
                        _todayHours = hour;
                    }
                }
            }
            
            
            //making sure to sort by weekday Sunday = 0,Monday = 1...Saturday = 6;
            NSSortDescriptor* sortByWeekday = [NSSortDescriptor sortDescriptorWithKey:@"weekday" ascending:YES];
            
            self.businessHours = [NSArray arrayWithArray:[hourList sortedArrayUsingDescriptors:@[sortByWeekday]]];
            _nextOpenBusinessHour = [self openingBusinessHour];
            
            NSSortDescriptor* sortByISOWeekday = [NSSortDescriptor sortDescriptorWithKey:@"weekdayISO8601" ascending:YES];
            _businessHoursISO8601 = [hourList sortedArrayUsingDescriptors:@[sortByISOWeekday]];
            NSMutableString* dayList = [[NSMutableString alloc]init];
            NSMutableString* hourList = [[NSMutableString alloc]init];
            NSMutableString* dayListWithStyle = [[NSMutableString alloc]init];
            NSMutableString* hourListWithStyle = [[NSMutableString alloc]init];
            
            NSString* previousDay = @"";
            for(MZBusinessHour* hour in _businessHoursISO8601){
                
                if ([[hour.day lowercaseString] isEqualToString:today]){
                    BOOL sameday = [hour.day isEqualToString:previousDay];
                    [dayListWithStyle appendFormat:@"<b>%@</b>\n",sameday?@"":hour.day];
                }else{
                    BOOL sameday = [hour.day isEqualToString:previousDay];
                    [dayListWithStyle appendFormat:@"%@\n",sameday?@"":hour.day];
                }
                
                [dayList appendFormat:@"%@\n",hour.day];
                
                
                if (hour.isClose){
                    if ([[hour.day lowercaseString] isEqualToString:today]){
                        [hourListWithStyle appendString:@"<b>Closed</b>\n"];
                    }else{
                        [hourListWithStyle appendString:@"Closed\n"];
                    }
                    
                    [hourList appendString:@"Closed\n"];
                }else{
                    [hourList appendFormat:@"%@ – %@\n",hour.formattedOpenTime,hour.formattedCloseTime];
                    
                    if ([[hour.day lowercaseString] isEqualToString:today]){
                        [hourListWithStyle appendFormat:@"<b>%@ – %@</b>\n",hour.formattedOpenTime,hour.formattedCloseTime];
                    }else{
                        [hourListWithStyle appendFormat:@"%@ – %@\n",hour.formattedOpenTime,hour.formattedCloseTime];
                    }
                }
                previousDay = hour.day;
            }
            _dayListISO8601 = dayList;
            _dayListISO8601WithStyle = dayListWithStyle;
            _hourListISO8601 = hourList;
            _hourListISO8601WithStyle = hourListWithStyle;
            
        }
    }
    return self;
}

-(MZBusinessHour*)openingBusinessHour{
    
    if (self.businessHours==nil || self.businessHours.count==0){
        return nil;
    }
    
    if (self.businessHours.count==1){
        return [self.businessHours firstObject];
    }
    
    NSDate* nowTime = [self nowTime];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"weekday==%d && ((openDateTime<=%@) AND (closeDateTime>=%@))",self.todayIndex,nowTime,nowTime];
    NSArray* todayShifts = [self.businessHours filteredArrayUsingPredicate:predicate];
    if (todayShifts!=nil && todayShifts.count>0){
        return [todayShifts firstObject];
    }
    
    //if we couldn't find any opening hour for today.
    //also the case where it's already close today then we exclude today hour and
    //iterate through the list to find the next one.
    NSPredicate* findTodayHourButAlreadyClose = [NSPredicate predicateWithFormat:@"(weekday==%d && ((openDateTime<=%@) AND (closeDateTime<=%@))) || isClose==YES",self.todayIndex,nowTime,nowTime];
    NSArray* todayHoursButAlreadyClose = [self.businessHours filteredArrayUsingPredicate:findTodayHourButAlreadyClose];
    
    NSMutableArray* otherDays = [[NSMutableArray alloc]initWithArray:self.businessHours];
    
    if (todayHoursButAlreadyClose.count>0){
        for(MZBusinessHour* hour in todayHoursButAlreadyClose){
            [otherDays removeObject:hour];
        }
    }
    if (otherDays==nil || otherDays.count==0)
        return nil;
    
    if (otherDays.count==1)
        return [otherDays firstObject];
    
    NSInteger nextIndex = self.todayIndex;
    if (nextIndex>=6){
        nextIndex = 0;
    }
    
    MZBusinessHour* nextOpeningHour = nil;
    NSInteger totalLoop = self.days.count;
    NSInteger index = 0;
    while (nextOpeningHour == nil && index<totalLoop) {
        for(MZBusinessHour* hour in otherDays){
            if (hour.weekday==nextIndex){
                nextOpeningHour = hour;
                break;
            }
        }
        nextIndex++;
        if (nextIndex==6)
            nextIndex=0;
        
        index++;
    }
    return nextOpeningHour;
}

-(BOOL)isOpenToday{
    return self.todayHours!=nil;
}

-(NSDate*)nowTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mma"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //here is a trick to get the actual time with day light saving.
    //get the time string from current [NSDate date]
    NSString* time = [dateFormatter stringFromDate:[NSDate date]];
    //convert it back to NSDate with only time
    return [dateFormatter dateFromString:time];
}


-(NSString *)hourDescription{
    
    if (_hourDescription!=nil)
        return _hourDescription;
    
    if (self.isOpen24hours){
        _hourDescription = [@"  OPEN 24 HOURS  " uppercaseString];
        _hourDescriptionColorHex = GREEN;
        return _hourDescription;
    }
    
    if (self.businessHours==nil || self.businessHours.count==0){
        _hourDescription = @"";
        return _hourDescription;
    }
    
    MZBusinessHour* targetHour = self.todayHours;
    if (targetHour==nil){
        targetHour = self.nextOpenBusinessHour;
    }
    
    if (targetHour!=nil && targetHour.weekday == self.todayIndex && targetHour.isClose==NO){
        NSDate* nowTime = [self nowTime];
        NSDate* closeTime = targetHour.closeDateTime;
        NSDate* openTime = targetHour.openDateTime;
        
        CGFloat nowTimeInterval = [nowTime timeIntervalSince1970];
        CGFloat closetimeInterval = [closeTime timeIntervalSince1970];
        CGFloat opentimeInterval = [openTime timeIntervalSince1970];
        
        //compare two time
        NSComparisonResult closeTimeResult = [nowTime compare:closeTime];
        NSComparisonResult openTimeResult = [nowTime compare:openTime];
        //not open yet then show when it will open.
        if (openTimeResult == NSOrderedAscending){
            NSInteger minuteToOpen = abs((int)(nowTimeInterval - opentimeInterval)) / 60;
            _hourDescriptionColorHex = RED;
            if (minuteToOpen<60)
                return [[NSString stringWithFormat:@"  OPENS IN %ld MINS  ",(long)minuteToOpen] uppercaseString];
            
            _hourDescription = [[NSString stringWithFormat:@"  OPENS AT %@  ",targetHour.formattedOpenTime] uppercaseString];
            return _hourDescription;
        }
        
        //still open then show close time
        if(closeTimeResult == NSOrderedAscending){
            //check whether it will be close in less then an hour
            NSInteger minuteToClose = abs((int)(nowTimeInterval - closetimeInterval)) / 60;
            
            if (minuteToClose<60){
                _hourDescriptionColorHex = ORANGE;
                return [[NSString stringWithFormat:@"  CLOSES IN %ld MINS  ",(long)minuteToClose] uppercaseString];
            }
            _hourDescriptionColorHex = GREEN;
            _hourDescription = [NSString stringWithFormat:@"  OPEN UNTIL %@  ",targetHour.formattedCloseTime];
            return _hourDescription;
        }else if(closeTimeResult == NSOrderedDescending){
            //close already show next opening time.
            MZBusinessHour* nextBusinessHour = self.nextOpenBusinessHour;
            //found next business hour
            if (nextBusinessHour!=nil){
                if (self.todayIndex == nextBusinessHour.weekday){
                    _hourDescriptionColorHex = RED;
                    _hourDescription = [[NSString stringWithFormat:@"  OPENS AT %@  ",nextBusinessHour.formattedOpenTime] uppercaseString];
                    return _hourDescription;
                }
                _hourDescriptionColorHex = RED;
                NSInteger nextIndex =  self.todayIndex+1;
                if (nextIndex>=6){
                    nextIndex = 0;
                }
                if (nextBusinessHour.weekday == nextIndex){
                    _hourDescription = [[NSString stringWithFormat:@"  OPENS AT %@ TOMORROW  ",nextBusinessHour.formattedOpenTime] uppercaseString];
                }else{
                    _hourDescription = [[NSString stringWithFormat:@"  OPENS AT %@ ON %@  ",nextBusinessHour.formattedOpenTime,nextBusinessHour.day] uppercaseString];
                }
                
                return _hourDescription;
            }
        }
    }
    
    //not open today we then show open at

    if (targetHour.weekday!=self.todayIndex){
        _hourDescriptionColorHex = RED;
        
        NSInteger nextIndex =  self.todayIndex+1;
        if (nextIndex>=6){
            nextIndex = 0;
        }
        
        if (targetHour.weekday == nextIndex){
            _hourDescription = [[NSString stringWithFormat:@"  OPENS AT %@ TOMORROW  ",targetHour.formattedOpenTime] uppercaseString];
        }else{
            _hourDescription = [[NSString stringWithFormat:@"  OPENS AT %@ ON %@  ",targetHour.formattedOpenTime,targetHour.day] uppercaseString];
        }
        
        return  _hourDescription;
    }
    
    _hourDescription = @"";
    return _hourDescription;
}

+(NSString*)resourceName{
    return @"businesses";
}

+(void)businessDetail:(NSString *)businessId block:(SingleRowResult)block{
    
    if (businessId==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/%@",kBase_API_Endpoint,[self resourceName],businessId];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }
        block([[MZBusiness alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

+(void)businessesWithMizuPayNearby:(CLLocationCoordinate2D)coordinate block:(ListResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@?mizupay=true",kBase_API_Endpoint,[self resourceName]];
    
    if (coordinate.latitude!=0 || coordinate.longitude!=0){
        endpoint = [endpoint stringByAppendingFormat:@"%@lat=%f&lng=%f",@"&",coordinate.latitude,coordinate.longitude];
    }
    endpoint = [endpoint stringByAddingPercentEscapesUsingEncoding:
                NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:endpoint];
    
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSArray* list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MZBusiness* business = [[MZBusiness alloc]initWithJson:obj];
            if (business.mizuPayEnabled==YES){
                [listResult addObject:business];
            }
        }];
        block(listResult,nil);
    }];
    [task resume];
}


+(void)businessesNearby:(CLLocationCoordinate2D)coordinate search:(NSString*)searchQuery block:(ListResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@",kBase_API_Endpoint,[self resourceName]];
    
    BOOL withSearch = searchQuery!=nil && searchQuery.length>0;
    if (withSearch){
        endpoint = [endpoint stringByAppendingFormat:@"?s=%@",searchQuery];
    }
    
    if (coordinate.latitude!=0 || coordinate.longitude!=0){
        endpoint = [endpoint stringByAppendingFormat:@"%@lat=%f&lng=%f",withSearch?@"&":@"?",coordinate.latitude,coordinate.longitude];
    }
    endpoint = [endpoint stringByAddingPercentEscapesUsingEncoding:
                NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:endpoint];
    
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSArray* list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [listResult addObject:[[MZBusiness alloc]initWithJson:obj]];
        }];
        block(listResult,nil);
    }];
    [task resume];
}

- (void)menusWithBlock:(ListResult)block{
    if (self.objectId==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/%@/%@",kBase_API_Endpoint,[MZBusiness resourceName],self.objectId,[MZMenu resourceName]];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSArray* list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [listResult addObject:[[MZMenu alloc]initWithJson:obj]];
        }];
        //assign to read only property .menus
        _menus = [NSArray arrayWithArray:listResult];
        block(listResult,nil);
    }];
    [task resume];
}

-(void)currentCheckIns:(ListResult)block{
    if (self.objectId==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/%@/checkins",kBase_API_Endpoint,[MZBusiness resourceName],self.objectId];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray* list = [obj valueForKey:@"data"];
        NSDictionary* business = [obj valueForKey:@"business"];
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MZCheckIn* checkIn =[[MZCheckIn alloc]initWithJson:obj];
            checkIn.business = [[MZBusiness alloc]initWithJson:business];
            [listResult addObject:checkIn];
        }];
        block(listResult,nil);
    }];
    [task resume];
}

-(void)checkInHistories:(ListResult)block{
    if (self.objectId==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/%@/checkins/histories",kBase_API_Endpoint,[MZBusiness resourceName],self.objectId];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
       NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        NSArray* list = [obj valueForKey:@"data"];
        NSDictionary* business = [obj valueForKey:@"business"];
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MZCheckIn* checkIn =[[MZCheckIn alloc]initWithJson:obj];
            checkIn.business = [[MZBusiness alloc]initWithJson:business];
            [listResult addObject:checkIn];
        }];
        block(listResult,nil);
    }];
    [task resume];
}

- (void)connectWithStripe:(SingleRowResult)block{
    if (self.objectId==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/%@/stripe/connect",kBase_API_Endpoint,[MZBusiness resourceName],self.objectId];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        block([obj valueForKey:@"url"],nil);
    }];
    [task resume];
}

@end
