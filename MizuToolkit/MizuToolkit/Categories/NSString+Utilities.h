//
//  NSString+Utilities.h
//  
//
//  Created by Apisit Toompakdee on 7/7/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Utilities)
- (NSString*)trim;
- (BOOL)isValidEmail;

- (CGFloat)textHeightWithMaxWidth:(CGFloat)width font:(UIFont*)font;
- (CGFloat)textWidthWithFont:(UIFont *)font;
@end
