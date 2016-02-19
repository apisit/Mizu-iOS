//
//  MZBaseObject.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Base object
 */
@interface MZBaseObject : NSObject
/**
 *  Resource name for this object
 *
 *  @return uri resource name
 */
+(NSString*)resourceName;

/**
 *  Initial object with json
 *
 *  @param json NSDictionary returned from http request
 *
 *  @return Object
 */
-(id)initWithJson:(NSDictionary *)json;

/**
 *  To NSDictionry
 *
 *  @return NSDictionary
 */
- (NSDictionary*)toJson;
@end
