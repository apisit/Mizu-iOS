//
//  MZTransaction.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/19/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import "MZBaseObject.h"

/**
 *  Transaction for Check-In
 */
@interface MZTransaction : MZBaseObject

@property (nonatomic, readonly) NSString* objectId;
@property (nonatomic, readonly) NSInteger amount;
@property (nonatomic, readonly) double tipPercent;
@property (nonatomic, assign) BOOL chargeSucceeded;
@property (nonatomic, assign) BOOL refunded;
@property (nonatomic, readonly) NSDate* refundedDate;
@property (nonatomic, readonly) NSString* refundedRemark;
@property (nonatomic, readonly) NSInteger refundedAmount;
@property (nonatomic, readonly) NSString* errorMessage;
@property (nonatomic, readonly) NSInteger tipAmount;
@property (nonatomic, readonly) NSInteger totalAmount;
@property (nonatomic, readonly) NSDate* createdDate;

@property (nonatomic,readonly) NSString* formattedAmount;
@property (nonatomic,readonly) NSString* formattedTipAmount;
@property (nonatomic,readonly) NSString* formattedTotalAmount;
@property (nonatomic,readonly) NSString* formattedRefundedAmount;
@property (nonatomic,readonly) NSString* formattedNewTotalAmount;



@end
