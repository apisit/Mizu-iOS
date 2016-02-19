//
//  Mizu.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/23/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "Mizu.h"

@implementation Mizu

+ (void)isInSupportedCountry:(ValidResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/isinlaunchingarea",kBase_API_Endpoint];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestProtectedResource:url method:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(NO,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        BOOL inUnsupportedCountry = [MZHelper isInUnsupportedCountry:responseError];
        if (inUnsupportedCountry){
             [Mizu setUserIsInSupportedCountry:NO];
            block(NO,nil);
            return;
        }
        if (responseError!=nil){
            block(NO,responseError);
            return;
        }
        [Mizu setUserIsInSupportedCountry:YES];
        block(YES,nil);
    }];
    [task resume];
}

+ (void)setUserIsInSupportedCountry:(BOOL)value{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"mizu-user-is-in-supported-country"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)userIsInSupportedCountry{
      return [[NSUserDefaults standardUserDefaults] boolForKey:@"mizu-user-is-in-supported-country"];
}

+(void)setApplicationId:(NSString*)applicationId apiKey:(NSString*)apiKey{
    
    if (applicationId==nil || apiKey==nil){
        NSLog(@"application id and api key must not be null ");
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:applicationId forKey:@"mizu-applicationId"];
    [[NSUserDefaults standardUserDefaults] setObject:apiKey forKey:@"mizu-apiKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getAPIKey{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"mizu-applicationId"];
}

+(NSString *)getApplicationId{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"mizu-apiKey"];
}

@end
