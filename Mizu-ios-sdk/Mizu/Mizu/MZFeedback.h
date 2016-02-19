//
//  MZFeedback.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/20/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

/**
 *  Feedback for transaction
 */
@interface MZFeedback : MZBaseObject

@property (nonatomic, readonly) NSString* objectId;
@property (nonatomic, assign) NSInteger rating;
@property (nonatomic, strong) NSString* comment;

/**
 *  Submit feedback for recent transaction
 *
 *  @param rating  Rating 1-5
 *  @param comment Comment text (optional)
 *  @param block   MZFeedback otherwise NSError
 */
- (void)submitFeedback:(NSInteger)rating comment:(NSString*)comment block:(SingleRowResult)block;

@end
