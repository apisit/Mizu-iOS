//
//  MZCheckIn.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

/**
 *  Check in detail
 */
@class MZBusiness;
@class MZOrder;
@interface MZCheckIn : MZBaseObject

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* tableNumber;
@property (nonatomic, assign) BOOL billed;
@property (nonatomic, assign) BOOL confirmed;
@property (nonatomic, strong) NSDate* createdDate;
@property (nonatomic, strong) NSDate* updatedDate;
@property (nonatomic, strong) MZBusiness* business;
@property (nonatomic, strong) MZOrder* orderSummary;

@end
