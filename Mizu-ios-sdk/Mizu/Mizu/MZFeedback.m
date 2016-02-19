//
//  MZFeedback.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/20/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import "MZFeedback.h"

@implementation MZFeedback
-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if (self==nil)
        return nil;
    _objectId = [json valueForKey:@"id"];
    _rating = [[json valueForKey:@"rating"] integerValue];
    _comment = [json valueForKey:@"comment"];
    return self;
}

+(NSString *)resourceName{
    return @"feedbacks";
}

- (void)submitFeedback:(NSInteger)rating comment:(NSString*)comment block:(SingleRowResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/%@",kBase_API_Endpoint,[MZFeedback resourceName],self.objectId];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"PUT"];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:[NSNumber numberWithInteger:rating] forKey:@"rating"];
    
    if (comment!=nil) {
        [params setValue:comment forKey:@"comment"];
    }
    
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    [request setHTTPBody:postData];
    
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
        if (obj==nil){
            block(nil,nil);
            return;
        }
        block([[MZFeedback alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

@end
