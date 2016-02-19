//
//  MZMenu.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZMenu.h"
#import "Mizu.h"

@implementation MZMenuItem
+(NSString *)resourceName{
    return @"menu_item";
}
-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self==nil)
        return nil;
    self.objectId = [json valueForKey:@"id"];
    self.name = [json valueForKey:@"name"];
    self.detail = [json valueForKey:@"detail"];
    self.price = [[json valueForKey:@"price"] doubleValue];
    self.rank = [[json valueForKey:@"rank"] floatValue];
    id likeCount = [json valueForKey:@"like_count"];
    if (likeCount){
        self.likeCount = [[json valueForKey:@"like_count"] integerValue];
    }else{
        self.likeCount = 0;
    }
    
    id commentCount = [json valueForKey:@"comment_count"];
    if (commentCount){
        self.commentCount = [[json valueForKey:@"comment_count"] integerValue];
    }else{
        self.commentCount = 0;
    }
    
    self.userLiked = [[json valueForKey:@"user_liked"] boolValue];
    
    NSArray* tags = [json valueForKey:@"tags"];
    if (tags){
        self.tags = [NSArray arrayWithArray:tags];
    }
    
    NSArray* images = [json valueForKey:@"images"];
    if (images!=nil){
        self.imageUrls = [NSArray arrayWithArray:images];
    }
    
    self.url = [json valueForKey:@"url"];
    return self;
}

- (void)refreshWithBlock:(SingleRowResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/items/%@",kBase_API_Endpoint,self.objectId];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        block([[MZMenuItem alloc]initWithJson:obj],nil);
    }];
    [task resume];
}


@end

@implementation MZMenuSection

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self==nil)
        return nil;
    
    self.objectId = [json valueForKey:@"id"];
    self.name = [json valueForKey:@"name"];
    self.detail = [json valueForKey:@"detail"];
    NSMutableArray* listItems = [[NSMutableArray alloc]init];
    NSArray* items = [json valueForKey:@"items"];
    NSMutableArray* list = [[NSMutableArray alloc]init];
    for(NSDictionary* i in items){
        MZMenuItem * item =  [[MZMenuItem alloc]initWithJson:i];
        [listItems addObject:item];
        [list addObject:item.name];
    }
    NSArray* images = [json valueForKey:@"images"];
    if (images!=nil){
        self.imageUrls = [NSArray arrayWithArray:images];
    }
    _listItemString = [list componentsJoinedByString:@", "];
    self.items = [NSArray arrayWithArray:listItems];
    return self;
}

-(NSArray *)imageUrls{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"imageUrls!=nil"];
    NSArray* filtered = [self.items filteredArrayUsingPredicate:predicate];
    if (filtered.count>0){
        MZMenuItem* item = [filtered firstObject];
        return item.imageUrls;
    }
    return nil;
}


+(NSString *)resourceName{
    return @"menu_section";
}

@end

@implementation MZMenu

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self==nil)
        return nil;
    
    self.objectId = [json valueForKey:@"id"];
    self.name = [json valueForKey:@"name"];
    
    NSArray* sections = [json valueForKey:@"sections"];
    NSMutableArray* listSections = [[NSMutableArray alloc]init];
    NSMutableArray* list = [[NSMutableArray alloc]init];
    for(NSDictionary* s in sections){
        MZMenuSection* section = [[MZMenuSection alloc]initWithJson:s];
        [listSections addObject:section];
        [list addObject:section.name];
    }
    _listSectionString = [list componentsJoinedByString:@", "];
    
    self.sections = [NSArray arrayWithArray:listSections];
    return self;
}

-(NSArray *)imageUrls{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ANY imageUrls!=nil"];
    NSArray* filtered = [self.sections filteredArrayUsingPredicate:predicate];
    if (filtered.count>0){
        MZMenuItem* item = [filtered firstObject];
        return item.imageUrls;
    }
    return nil;

}


+(NSString *)resourceName{
    return  @"menus";
}

@end
