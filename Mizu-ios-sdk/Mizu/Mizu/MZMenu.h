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
/**
 *  Object Id
 */
@property (nonatomic, strong) NSString* objectId;
/**
 *  Menu section name
 */
@property (nonatomic, strong) NSString* name;
/**
 *  Menu section detail/description
 */
@property (nonatomic, strong) NSString* detail;
/**
 *  List of MZMenuItem name with ,(comma) (e.g. coffee, tea)
 */
@property (nonatomic, readonly) NSString* listItemString;
/**
 *  List of MZMenuItem
 */
@property (nonatomic,strong) NSArray* items;
/**
 *  List of menu item image urls from latest comment.
 */
@property (nonatomic, strong) NSArray* imageUrls;
@end

/**
 *  Menu item contain item detail and price
 */
@interface MZMenuItem : MZBaseObject
/**
 *  Object Id.
 */
@property (nonatomic, strong) NSString* objectId;
/**
 *  Item name.
 */
@property (nonatomic, strong) NSString* name;
/**
 *  Item detail/description.
 */
@property (nonatomic, strong) NSString* detail;
/**
 *  Price
 */
@property (nonatomic, assign) double price;
/**
 *  Options
 */
@property (nonatomic, strong) NSArray* options;
/**
 *  Tags (e.g. vegetable, spicy)
 */
@property (nonatomic, strong) NSArray* tags;
/**
 *  Like count
 */
@property (nonatomic, assign) NSInteger likeCount;
/**
 *  Comment count
 */
@property (nonatomic, assign) NSInteger commentCount;
/**
 *  If user token is provided. return whether user has liked this item.
 */
@property (nonatomic, assign) BOOL userLiked;
/**
 *  List of item image urls from comments.
 */
@property (nonatomic, strong) NSArray* imageUrls;

/**
 *  Menu item ranking based on user
 */
@property (nonatomic, assign) Float64 rank;

/**
 *  unqiue url
 */
@property (nonatomic, strong) NSString* url;

/**
 *  Refresh data. like and comment count are included.
 *
 *  @param block MZMenuItem
 */
- (void)refreshWithBlock:(SingleRowResult)block;

@end

/**
 *  Menu of business contains multiple sections.
 */
@interface MZMenu : MZBaseObject
/**
 *  Object Id
 */
@property (nonatomic, strong) NSString* objectId;
/**
 *  Menu name
 */
@property (nonatomic, strong) NSString* name;
/**
 *  List of MZMenuSection
 */
@property (nonatomic, strong) NSArray* sections;

/**
 *  List of item image urls from comments.
 */
@property (nonatomic, strong) NSArray* imageUrls;

/**
 *  List of MZMenuSection name with ,(comma) (e.g. Appetizer, Drink)
 */
@property (nonatomic, readonly) NSString* listSectionString;

@end
