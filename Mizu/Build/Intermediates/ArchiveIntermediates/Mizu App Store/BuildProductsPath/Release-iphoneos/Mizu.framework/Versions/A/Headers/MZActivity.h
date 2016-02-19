//
//  MZActivity.h
//  Mizu
//
//  Created by Apisit Toompakdee on 2/6/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

typedef enum{
    kLike,
    kComment
} MizuActivityType;

/**
 *  Comment contains text and NSArray of image urls
 */
@interface MZActivityComment :MZBaseObject

@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSArray* imageUrls;

@end

/**
 *  User activity. (e.g. comment,like)
 */
@interface MZActivity : MZBaseObject

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, assign) MizuActivityType activityType;
@property (nonatomic, strong) MZActivityComment* comment;
@property (nonatomic, strong) NSDate* createdDate;
@property (nonatomic, strong) NSDate* updatedDate;
@property (nonatomic, strong) MZUser* byUser;


/**
 *  Get likes of menu item
 *
 *  @param business selected MZBusiness
 *  @param item     selected MZMenuItem
 *  @param lastId   lastId of activity for pagination
 *  @param block    NSArray of MZActivity
 */
+ (void)likesByBusiness:(MZBusiness*)business item:(MZMenuItem*)item lastId:(NSString*)lastId block:(ListResult)block;

/**
 *  Get comments of menu item
 *
 *  @param business selected MZBusiness
 *  @param item     selected MZMenuItem
 *  @param lastId   lastId of activity for pagination
 *  @param block    NSArray of MZActivity
 */
+ (void)commentsByBusiness:(MZBusiness*)business item:(MZMenuItem*)item lastId:(NSString*)lastId block:(ListResult)block;

/**
 *  Helper method to translate MizuActivityType to NSString
 *
 *  @param activityType MizuActivityType
 *
 *  @return MizuActivityType in string
 */
+ (NSString*)activityNameByType:(MizuActivityType)activityType;
@end
