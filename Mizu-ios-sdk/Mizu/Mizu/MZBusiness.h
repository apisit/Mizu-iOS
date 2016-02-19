//
//  MZBusiness.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Mizu.h"
#import "MZBusinessHour.h"
#import "MZBusinessSocial.h"
@class MZBusinessHour;
/**
 *  Meta data for MZBusiness contains country name, currency symbol and etc.
 */
@interface MZMeta : MZBaseObject

@property (nonatomic,strong) NSString* countryCode;
@property (nonatomic,strong) NSString* countryName;
@property (nonatomic,strong) NSString* currency;
@property (nonatomic,strong) NSString* currencySymbol;
@property (nonatomic,strong) NSNumber* currencyFactor;

@end

/**
 *  MZBusiness business detail
 */
@interface MZBusiness : MZBaseObject

@property (nonatomic,strong) NSString* objectId;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* address;
@property (nonatomic,strong) NSString* city;
@property (nonatomic,strong) NSString* state;
@property (nonatomic,strong) NSString* postalCode;
@property (nonatomic,strong) NSString* phone;
@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) MZMeta* meta;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,assign) double tax;
@property (nonatomic,strong) NSArray* imageUrls;
@property (nonatomic,strong) NSArray* tags;
@property (nonatomic,assign) BOOL isOpen24hours;
@property (nonatomic,assign) BOOL verified;

@property (nonatomic, strong) NSArray* socials;
@property (nonatomic,strong) NSArray* businessHours;
@property (nonatomic,readonly) NSArray* businessHoursISO8601;
@property (nonatomic,readonly) MZBusinessHour* todayHours;
@property (nonatomic, readonly) BOOL isOpenToday;
@property (nonatomic, readonly) MZBusinessHour* nextOpenBusinessHour;
@property (nonatomic, strong) NSString* hourDescription;
@property (nonatomic, readonly) NSString* hourDescriptionColorHex;
@property (nonatomic, strong) NSString* dayListISO8601;
@property (nonatomic, strong) NSString* hourListISO8601;

@property (nonatomic, strong) NSString* dayListISO8601WithStyle;
@property (nonatomic, strong) NSString* hourListISO8601WithStyle;

//v.2.0
@property (nonatomic,assign) BOOL mizuPayEnabled;
/**
 *  This menus is NSArray of MZMenu. will be assigned when call menusWithBlock.
 */
@property (nonatomic,readonly) NSArray* menus;
/**
 *  Distance from current location in meter
 */
@property (nonatomic,assign) double distanceFromCurrentLocation;

/**
 *  Url with pre-filled data to stripe connect
 *
 *  @param block  url string to open in webview
 */
- (void)connectWithStripe:(SingleRowResult)block;

/**
 *  Get businesses near by user's location
 *
 *  @param coordinate user's location
 *  @param searchQuery search query
 *  @param block      return list of object otherwise NSError
 */
+ (void)businessesNearby:(CLLocationCoordinate2D)coordinate search:(NSString*)searchQuery block:(ListResult)block;

/**
 *  Get businesses with Mizu Pay near by user's location
 *
 *  @param coordinate user's location
 *  @param block      return list of object otherwise NSError
 */
+(void)businessesWithMizuPayNearby:(CLLocationCoordinate2D)coordinate block:(ListResult)block;

/**
 *  Get business detail inclusing tags and business hours
 *
 *  @param businessId business Id
 *  @param block      return MZBusiness
 */
+ (void)businessDetail:(NSString*)businessId block:(SingleRowResult)block;

/**
 *  Get Menus of business
 *
 *  @param block return list of object otherwise NSError
 */
- (void)menusWithBlock:(ListResult)block;


/**
 *  Current check-ins (Authorized business manager only)
 *
 *  @param block MZCheckIn,NSError
 */
- (void)currentCheckIns:(ListResult)block;

/**
 *  Check in histories (Authorized business manager only)
 *
 *  @param block MZCheckIn,NSError
 */
- (void)checkInHistories:(ListResult)block;


@end
