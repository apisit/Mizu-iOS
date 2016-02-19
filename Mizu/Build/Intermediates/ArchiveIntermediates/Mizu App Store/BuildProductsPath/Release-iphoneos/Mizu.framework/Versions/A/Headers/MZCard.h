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
@property (nonatomic, strong) NSString* Name;
@property (nonatomic, strong) NSString* Last4;
@property (nonatomic, strong) NSString* ExpMonth;
@property (nonatomic, strong) NSString* ExpYear;
@property (nonatomic, strong) NSString* Brand;


@end
