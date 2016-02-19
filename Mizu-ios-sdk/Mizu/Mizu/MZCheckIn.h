//
//  MZCheckIn.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

@class MZFeedback;
/**
 *  Check in detail
 */
@interface MZCheckIn : MZBaseObject

@property (nonatomic, readonly) NSString* objectId;
@property (nonatomic, readonly) NSString* note;
@property (nonatomic, readonly) NSDate* createdDate;
@property (nonatomic, readonly) NSDate* updatedDate;
@property (nonatomic, strong) MZUser* user;
@property (nonatomic, strong) MZBusiness* business;
@property (nonatomic, readonly) MZCard* card;

@property (nonatomic, readonly) BOOL waitingForFeedback;
@property (nonatomic, readonly) BOOL checked;
@property (nonatomic, readonly) BOOL isCanceled;

@property (nonatomic, readonly) MZTransaction* transaction;
@property (nonatomic, readonly) MZFeedback* feedback;


/**
 *  Take payment for this check-in (Authorized business manager only)
 *
 *  @param amount Amount in cent
 *  @param block  MZTransaction,NSError
 */
- (void)takePayment:(NSUInteger)amount block:(SingleRowResult)block;

/**
 *  Refund payment
 *
 *  @param transaction Proceeded transaction
 *  @param amount      Amount. Cannot be greater than the transaction
 *  @param fullRefund  Refund full amount.
 *  @param remark      Remark (optional)
 *  @param block  MZTransaction,NSError
 */
- (void)refundPayment:(MZTransaction*)transaction fullRefund:(BOOL)fullRefund amount:(NSUInteger)amount remark:(NSString*)remark block:(SingleRowResult)block;

@end
