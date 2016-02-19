//
//  MZBusinessManager.h
//  Mizu
//
//  Created by Apisit Toompakdee on 9/10/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

/**
 *  Business manager
 */
@interface MZBusinessManager : MZUser

/**
 *  Verify whether this user is authorized.
 *
 *  @param block MZUser,NSError
 */
+ (void)verify:(SingleRowResult)block;

/**
 *  Businesses that this user is authorized to manage.
 */
@property (nonatomic, strong) NSArray* businesses;


@end
