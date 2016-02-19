//
//  MZSetting.h
//  Mizu
//
//  Created by Apisit Toompakdee on 2/5/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>
/**
 *  Settings 
 */
@interface MZSetting : MZBaseObject

/**
 *  Get taste preference questions
 *
 *  @param block Array of MZQuestion
 */
+ (void)tastePreferenceQuestions:(ListResult)block;

@end
