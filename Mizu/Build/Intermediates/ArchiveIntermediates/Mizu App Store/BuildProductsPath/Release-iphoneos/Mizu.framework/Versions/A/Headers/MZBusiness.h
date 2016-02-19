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
@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* currency;
@property (nonatomic,strong) NSString* currencySymbol;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,assign) double tax;
@property (nonatomic,strong) NSArray* imageUrls;
@property (nonatomic,strong) NSArray* tags;
/**
 *  Distance from current location in meter
 */
@property (nonatomic,assign) double distanceFromCurrentLocation;
/**
 *  Get businesses near by user's location
 *
 *  @param coordinate user's location
 *  @param block      return list of object otherwise NSError
 */
+ (void)businessesNearby:(CLLocationCoordinate2D)coordinate block:(ListResult)block;

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

@end
