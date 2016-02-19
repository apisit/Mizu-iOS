//
//  MZOrder.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZBaseObject.h"
#import "MZOrder.h"
#import "MZMenu.h"

/**
 *  MZOrderItem contains order item detail
 */
@interface MZOrderItem : MZBaseObject

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* item;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, strong) NSString* note;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double tax;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger subTotalExcludeTax;


+ (MZOrderItem*)fromMZMenuItem:(MZMenuItem*)item quantity:(NSInteger)quantity tax:(double)tax note:(NSString*)note;

- (NSDictionary*)toDictionary;
@end

/**
 *  MZOrder contains order information once user placed an order.
 */
@interface MZOrder : MZBaseObject

@property (nonatomic, strong) NSArray* items;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) float tax;
@property (nonatomic, assign) float totalIncludeTax;
@property (nonatomic, assign) BOOL confirmed;


@end
