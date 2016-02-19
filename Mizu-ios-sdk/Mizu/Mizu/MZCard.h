//
//  MZCard.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

/**
 *  Card detail with only last 4 digits
 */
@interface MZCard : MZBaseObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* last4;
@property (nonatomic, strong) NSString* expMonth;
@property (nonatomic, strong) NSString* expYear;
@property (nonatomic, strong) NSString* brand;

@property (nonatomic, readonly) NSString* cardBrandWithLast4;

@end
