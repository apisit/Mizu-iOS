//
//  MZSocialAccount.h
//  Mizu
//
//  Created by Apisit Toompakdee on 2/10/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

/**
 *  Social account. (only facebook is supported)
 */
@interface MZSocialAccount : MZBaseObject

@property (nonatomic, strong) NSString* serviceName;
@property (nonatomic, strong) NSString* serviceUserId;
@property (nonatomic, strong) NSString* accessToken;


@end
