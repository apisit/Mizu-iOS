//
//  MZMenu.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//
#import "MZBaseObject.h"
#import "MizuBlock.h"
/**
 *  Menu section contains multiple items. 
 *  e.g. Appetizers, Salads.
 */
@interface MZMenuSection : MZBaseObject
@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, readonly) NSString* listItemString;
@property (nonatomic,strong) NSArray* items;
@property (nonatomic, strong) NSArray* imageUrls;
@end

/**
 *  Menu item contain item detail and price
 */
@interface MZMenuItem : MZBaseObject
@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSArray* options;
@property (nonatomic, strong) NSArray* tags;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) BOOL userLiked;
@property (nonatomic, strong) NSArray* imageUrls;


- (void)refreshWithBlock:(SingleRowResult)block;

@end

/**
 *  Menu of business contains multiple sections.
 */
@interface MZMenu : MZBaseObject

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray* sections;

@end
