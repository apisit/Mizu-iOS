//
//  MZCard.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZCard.h"

@implementation MZCard
-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self==nil)
        return nil;
    self.name = [json valueForKey:@"name"];
    self.last4 = [json valueForKey:@"last_4"];
    self.expMonth = [json valueForKey:@"exp_month"];
    self.expYear = [json valueForKey:@"exp_year"];
    self.brand = [json valueForKey:@"brand"];
   
    _cardBrandWithLast4 = [NSString stringWithFormat:@"%@ ending in %@", [self.brand uppercaseString],self.last4];
    return self;
}

+(NSString *)resourceName{
    return @"cards";
}
@end
