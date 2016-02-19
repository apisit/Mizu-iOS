//
//  InternationalCallingCodeService.h
//  Macro
//
//  Created by Apisit Toompakdee on 6/27/12.
//  Copyright (c) 2012 All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CallingCode : NSObject

@property (nonatomic,strong) NSString* country;
@property (nonatomic,strong) NSString* code;
@property (nonatomic,strong) NSString* isoCode;

@end


@interface InternationalCallingCodeService : NSObject

+(CallingCode*)getCurrentCallingCode;

+(NSArray*)getAvailableCodes;

@end
