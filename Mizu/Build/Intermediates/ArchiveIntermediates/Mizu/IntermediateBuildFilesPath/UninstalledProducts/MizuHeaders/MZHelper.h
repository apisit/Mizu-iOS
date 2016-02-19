//
//  MZHelper.h
//  Mizu
//
//  Created by Apisit Toompakdee on 9/27/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mizu.h"
/// This class was created to avoid using category classes in Framework
@interface MZHelper : NSObject

#pragma mark - NSDictionary
+(void)saveJsonToFilename:(NSString*)filename dictionary:(NSDictionary*)dictionary;
+(NSDictionary*)getJsonByFilename:(NSString*)filename;


#pragma mark - NSError
+(NSError*)errorRequireParameters;

#pragma mark - NSMutableURLRequest
+ (NSMutableURLRequest*)requestProtectedResource:(NSURL*)url method:(NSString*)method;

+ (NSMutableURLRequest*)requestUserProtectedResource:(NSURL*)url user:(MZUser*)user method:(NSString*)method;

#pragma mark - NSURLResponse
+ (NSError*)response:(NSURLResponse*)response toNSError:(NSData*)data;


@end
