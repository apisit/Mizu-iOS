//
//  MZBusinessSocial.m
//  Mizu
//
//  Created by Apisit Toompakdee on 6/18/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import "MZBusinessSocial.h"

@implementation MZBusinessSocial

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        self.name = [json valueForKey:@"name"];
        self.title = [json valueForKey:@"title"];
        self.titlePrefix = [json valueForKey:@"title_prefix"];
        self.url = [json valueForKey:@"url"];
        self.iconUrl = [json valueForKey:@"icon_url"];
    }
    return self;
}

@end
