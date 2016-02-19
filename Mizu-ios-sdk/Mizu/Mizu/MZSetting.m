//
//  MZSetting.m
//  Mizu
//
//  Created by Apisit Toompakdee on 2/5/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import "MZSetting.h"

@implementation MZSetting

+(void)tastePreferenceQuestions:(ListResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/settings/tastequestions",kBase_API_Endpoint];

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
        NSDictionary* questions = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        NSArray* list = [questions objectForKey:@"questions"];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [listResult addObject:[[MZQuestion alloc]initWithJson:obj]];
        }];
        block(listResult,nil);
    }];
    [task resume];
}
@end
