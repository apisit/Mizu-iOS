//
//  MizuBlock.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/23/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

@class MZUser;
/**
 *  Authentication result
 *
 *  @param currentUser MZUser
 *  @param error       NSError contains error detail.
 */
typedef void (^AuthenticationResult) (MZUser* currentUser, NSError* error);

/**
 *  Valid result block return YES / NO
 */
typedef void (^ValidResult) (BOOL valid, NSError* error);

/**
 *  Return list of objects 
 */
typedef void (^ListResult) (NSArray* list, NSError* error);

/**
 *  Return single object
 */
typedef void (^SingleRowResult) (id object, NSError* error);