//
//  Mizu.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/23/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mizu/MZBaseObject.h>
#import <Mizu/MZUser.h>
#import <Mizu/MZBusiness.h>
#import <Mizu/MZCard.h>
#import <Mizu/MZCheckIn.h>
#import <Mizu/MZMenu.h>
#import <Mizu/MZOrder.h>
#import <Mizu/MZUser.h>
#import <Mizu/MizuBlock.h>
#import <Mizu/MZConstants.h>
#import <Mizu/MZHelper.h>
#import <Mizu/MZQuestion.h>
#import <Mizu/MZSetting.h>
#import <Mizu/MZActivity.h>
#import <Mizu/MZSocialAccount.h>
/**
 *  Mizu
 */
@interface Mizu : NSObject

/**
 *  Set application Id and API key
 *
 *  @param applicationId Application Identifier
 *  @param apiKey        API Key
 */
+ (void)setApplicationId:(NSString*)applicationId apiKey:(NSString*)apiKey;
+(NSString*)getApplicationId;
+(NSString*)getAPIKey;


@end
