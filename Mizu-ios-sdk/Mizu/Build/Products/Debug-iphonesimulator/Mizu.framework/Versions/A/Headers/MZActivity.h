//
//  MZActivity.h
//  Mizu
//
//  Created by Apisit Toompakdee on 2/6/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

typedef enum : NSUInteger{
    kLike,
    kComment
} MizuActivityType;

@interface MZActivityComment :MZBaseObject

@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSArray* imageUrls;

@end

@interface MZActivity : MZBaseObject

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, assign) MizuActivityType activityType;
@property (nonatomic, strong) MZActivityComment* comment;
@property (nonatomic, strong) NSDate* createdDate;
@property (nonatomic, strong) NSDate* updatedDate;
@property (nonatomic, strong) MZUser* byUser;

+ (void)likesByBusiness:(MZBusiness*)business item:(MZMenuItem*)item lastId:(NSString*)lastId block:(ListResult)block;

+ (void)commentsByBusiness:(MZBusiness*)business item:(MZMenuItem*)item lastId:(NSString*)lastId block:(ListResult)block;

+ (NSString*)activityNameByType:(MizuActivityType)activityType;
@end
