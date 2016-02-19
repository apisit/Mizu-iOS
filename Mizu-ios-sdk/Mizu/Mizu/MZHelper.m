//
//  MZHelper.m
//  Mizu
//
//  Created by Apisit Toompakdee on 9/27/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZHelper.h"
@implementation MZHelper
#pragma mark - NSDictionary


+ (BOOL)is24HourFormat{
   static BOOL is24hourFormat = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
        NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
        is24hourFormat = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    });
    return is24hourFormat;
}
+(void)saveJsonToFilename:(NSString*)filename dictionary:(NSDictionary*)dictionary{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:filename];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
        NSFileManager* fm = [NSFileManager defaultManager];
        BOOL written =  [fm createFileAtPath:filePath contents:data attributes:[NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey]];
        if (written){
            NSLog(@"file written");
        }
    });
}

+(NSDictionary*)getJsonByFilename:(NSString*)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *json = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return json;
    }
    return nil;
}

#pragma mark - NSError
+(NSError *)errorRequireParameters{
    return [NSError errorWithDomain:kError_Domain code:kCFNetServiceErrorBadArgument userInfo:@{NSLocalizedDescriptionKey:@"All parameters are required"}];
}

#pragma mark - NSMutableURLRequest
+ (NSMutableURLRequest*)requestProtectedResource:(NSURL*)url method:(NSString*)method{
    NSMutableURLRequest* r = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [r addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [r addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [r addValue:[Mizu getAPIKey] forHTTPHeaderField:@"X-Mizu-Rest-API-Key"];
    [r addValue:[Mizu getApplicationId] forHTTPHeaderField:@"X-Mizu-Application-Id"];
    [r addValue:@"2.0" forHTTPHeaderField:@"X-Mizu-Version"];
    [r setHTTPMethod:method];
    return r;
}

+ (NSMutableURLRequest*)requestUserProtectedResource:(NSURL*)url user:(MZUser*)user method:(NSString*)method{
    NSMutableURLRequest* r = [self requestProtectedResource:url method:method];
    NSString* token = [NSString stringWithFormat:@"Mizu %@",user.sessionToken];
    [r addValue:token forHTTPHeaderField:@"Authorization"];
    return r;
}

#pragma mark - NSURLResponse
+ (NSError*)response:(NSURLResponse*)response toNSError:(NSData*)data{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode==200){
        return nil;
    }
    if (data==nil){
        NSError *errorDataIsNull = [NSError errorWithDomain:kError_Domain code:responseStatusCode userInfo:@{NSLocalizedDescriptionKey:@"Error data is null"}];
        return  errorDataIsNull;
    }
    NSLog(@"%@",[data class]);
    
    NSDictionary* errorDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    if (errorDic!=nil){
        NSString* errorMessage = [[errorDic valueForKey:@"meta"] valueForKey:@"error_message"];
        NSError *error = [NSError errorWithDomain:kError_Domain code:responseStatusCode userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@",errorMessage]}];
        return error;
    }
    NSString* errorMessage = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    NSError *error = [NSError errorWithDomain:kError_Domain code:responseStatusCode userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@",errorMessage]}];
    return error;
}

+ (BOOL)isInvalidTokenError:(NSError*)error{
    return error.code == 401;
}

+ (BOOL)isInUnsupportedCountry:(NSError*)error{
    return error.code == 418;
}
@end
