//
//  MZBusinessSocial.h
//  Mizu
//
//  Created by Apisit Toompakdee on 6/18/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

/**
 *  Business social media account
 */
@interface MZBusinessSocial : MZBaseObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* titlePrefix;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* iconUrl;


@end
