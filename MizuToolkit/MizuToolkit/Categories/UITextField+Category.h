//
//  UITextField+Category.h
//  Mizu
//
//  Created by Apisit Toompakdee on 1/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Category)


- (BOOL)validateToNext:(UITextField*)nextTextField;
- (void)invalid;
- (void)valid;
- (BOOL)isValid;
@end
