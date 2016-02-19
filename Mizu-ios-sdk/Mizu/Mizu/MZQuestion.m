//
//  MZQuestion.m
//  Mizu
//
//  Created by Apisit Toompakdee on 2/5/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import "MZQuestion.h"

@implementation MZQuestion

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        self.title = [json objectForKey:@"title"];
        self.tagForYes = [json objectForKey:@"yes_tag"];
        self.tagForNo = [json objectForKey:@"no_tag"];
        self.index = [[json objectForKey:@"index"] integerValue];
        self.detail = [json objectForKey:@"detail"];
        self.imageUrl = [json objectForKey:@"image_url"];
    }
    return self;
}
@end
