//
//  UITextField+Category.m
//  Mizu
//
//  Created by Apisit Toompakdee on 1/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "UITextField+Category.h"
#import "UIView+Category.h"
#import "MZTextFieldWithCaption.h"
#import <objc/runtime.h>

@implementation UITextField (Category)

- (BOOL)validateToNext:(UITextField*)nextTextField{
    if ([self.text trim].length>0){
        
        if (self.keyboardType == UIKeyboardTypeEmailAddress){
            BOOL validEmail = [[self.text trim] isValidEmail];
            if (!validEmail){
                [self invalid];
                return NO;
            }
        }
        
        if (self.isSecureTextEntry == YES){

            if (self.text.length<6){
                [self invalid];
                return NO;
            }
        }
        [self valid];
        if (nextTextField)
            [nextTextField becomeFirstResponder];
        
        return YES;
    }else{
        [self invalid];
    }
    return NO;
}
- (void)invalid{
    self.tag = -1;
    if (![self isKindOfClass:[MZTextFieldWithCaption class]]){
        //[self shake];
        return;
    }else{
        MZTextFieldWithCaption* txt = (MZTextFieldWithCaption*)self;
        [txt.lblTitle setTextColor:UIColorFromRGB(0xff3333)];
    }
}

- (void)valid{
    self.tag = 1;
    if (![self isKindOfClass:[MZTextFieldWithCaption class]]){
        return;
    }
    MZTextFieldWithCaption* txt = (MZTextFieldWithCaption*)self;
    [txt.lblTitle setTextColor:UIColorFromRGB(0x4da169)];
}

-(BOOL)isValid{
    return self.tag==1;
}

@end
