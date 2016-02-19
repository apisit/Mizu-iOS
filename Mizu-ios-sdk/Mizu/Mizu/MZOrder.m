//
//  MZOrder.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZOrder.h"

@implementation MZOrderItem

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if (self==nil)
        return nil;
    self.objectId = [json valueForKey:@"id"];
    self.item = [json valueForKey:@"item"];
    self.detail = [json valueForKey:@"detail"];
    self.note = [json valueForKey:@"note"];
    self.price = [[json valueForKey:@"price"] integerValue];
    self.tax = [[json valueForKey:@"tax"] doubleValue];
    self.quantity = [[json valueForKey:@"quantity"] integerValue];
    self.subTotalExcludeTax = [[json valueForKey:@"sub_total_excl_tax"] integerValue];
    return self;
}
+(NSString *)resourceName{
    return @"items";
}

+ (MZOrderItem*)fromMZMenuItem:(MZMenuItem*)item quantity:(NSInteger)quantity tax:(double)tax note:(NSString*)note{
    MZOrderItem* orderItem =  [[MZOrderItem alloc]init];
    orderItem.item = item.name;
    orderItem.detail = item.detail;
    orderItem.price = item.price;
    orderItem.tax = tax;
    orderItem.objectId = item.objectId;
    orderItem.quantity = quantity;
    return orderItem;
}

- (NSDictionary*)toDictionary{
    return @{@"id":self.objectId,@"quantity":[NSString stringWithFormat:@"%ld",(long)self.quantity],@"note":self.note==nil?@"":self.note};
}

@end

@implementation MZOrder

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if (self==nil)
        return nil;
    
    NSArray* items = [json valueForKey:@"items"];
    NSMutableArray* list = [[NSMutableArray alloc]init];
    for(NSDictionary* i in items){
        [list addObject:[[MZOrderItem alloc]initWithJson:i]];
    }
    self.items = [NSArray arrayWithArray:list];
    self.total = [[json valueForKey:@"total"] integerValue];
    self.tax = [[json valueForKey:@"tax"] floatValue];
    self.totalIncludeTax = [[json valueForKey:@"total_incl_tax"] floatValue];
    return self;
}

+(NSString *)resourceName{
    return @"orders";
}

@end
