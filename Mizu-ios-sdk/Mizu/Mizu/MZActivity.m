//
//  MZActivity.m
//  Mizu
//
//  Created by Apisit Toompakdee on 2/6/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import "MZActivity.h"

@implementation MZActivityComment

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        if ([json objectForKey:@"text"]!=nil)
            self.text = [json objectForKey:@"text"];
        NSArray* images = [json objectForKey:@"image_urls"];
        if (images!=nil){
            self.imageUrls = [NSArray arrayWithArray:images];
        }
    }
    return self;
}

@end

@implementation MZActivity

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        self.objectId = [json objectForKey:@"id"];
        NSDictionary* dic = [json objectForKey:@"comment"];
        if (dic)
            self.comment = [[MZActivityComment alloc]initWithJson:dic];
        //It's .SSS
        //2015-02-07T19:12:43.572547Z
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [dateFormatter setLocale:[NSLocale systemLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
        self.createdDate = [dateFormatter dateFromString:[json valueForKey:@"created"]];
        self.updatedDate = [dateFormatter dateFromString:[json valueForKey:@"updated"]];
        NSDictionary* user = [json objectForKey:@"user"];
        self.byUser = [[MZUser alloc]initWithJson:user];
        NSString* activityTypeString =[json objectForKey:@"activity_type"];
        self.activityType = [MZActivity activityTypeByName:activityTypeString];
        
        NSDictionary* item =  [json objectForKey:@"item"];
        if (item){
            self.ofItem = [[MZMenuItem alloc]initWithJson:item];
        }
        NSDictionary* business =  [json objectForKey:@"business"];
        if (business){
            self.ofBusiness= [[MZBusiness alloc]initWithJson:business];
        }
    }
    return self;
}

+ (NSString*)activityNameByType:(MizuActivityType)activityType{
    switch (activityType) {
        case kLike:
            return @"likes";
            break;
        case kComment:
            return @"comments";
        default:
            break;
    }
}
+ (MizuActivityType)activityTypeByName:(NSString*)activityName{
    if ([activityName isEqualToString:@"like"]){
        return kLike;
    }
    if ([activityName isEqualToString:@"comment"]){
        return kComment;
    }
    return 0;
}

+ (void)getActivitiesByBusiness:(MZBusiness*)business item:(MZMenuItem*)item lastId:(NSString*)lastId block:(ListResult)block activityType:(MizuActivityType)activityType{
    if (business==nil || item==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* lastIdQueryString =lastId!=nil?[NSString stringWithFormat:@"?last=%@",lastId]:@"";
    NSString* endpoint =[NSString stringWithFormat:@"%@/businesses/%@/items/%@/%@%@",kBase_API_Endpoint,business.objectId,item.objectId,[MZActivity activityNameByType:activityType],lastIdQueryString];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestProtectedResource:url method:@"GET"];
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
        NSArray* list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MZActivity* activity = [[MZActivity alloc]initWithJson:obj];
            activity.activityType = activityType;
            [listResult addObject:activity];
        }];
        block(listResult,nil);
    }];
    [task resume];
}

+ (void)likesByBusiness:(MZBusiness*)business item:(MZMenuItem*)item lastId:(NSString*)lastId block:(ListResult)block{
    [MZActivity getActivitiesByBusiness:business item:item lastId:lastId block:block activityType:kLike];
}

+ (void)commentsByBusiness:(MZBusiness*)business item:(MZMenuItem*)item lastId:(NSString*)lastId block:(ListResult)block{
    [MZActivity getActivitiesByBusiness:business item:item lastId:lastId block:block activityType:kComment];
}

@end
