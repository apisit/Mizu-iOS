//
//  MZSocialAccount.m
//  Mizu
//
//  Created by Apisit Toompakdee on 2/10/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import "MZSocialAccount.h"

@implementation MZSocialAccount

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        self.serviceUserId = [json objectForKey:@"service_user_id"];
        self.serviceName = [json objectForKey:@"service_name"];
        self.accessToken = [json objectForKey:@"access_token"];
    }
    return self;
}


-(NSDictionary *)toJson{
    return @{@"service_user_id":self.serviceUserId,
             @"service_name":self.serviceName,
             @"access_token":self.accessToken};
}


@end
