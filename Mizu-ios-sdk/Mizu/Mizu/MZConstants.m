//
//  MZConstants.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZConstants.h"

//production https://www.getmizu.com/api/v1


#ifdef DEBUG
#define BASE_URL @"http://localhost"
#else
#define BASE_URL @"https://www.getmizu.com/api/v1"
#endif

NSString* const kBase_API_Endpoint = BASE_URL;
NSString* const kError_Domain = @"com.getmizu";
NSString* const kProximity_UUID = @"39ED98FF-2900-441A-802F-9C398FC199D2";
