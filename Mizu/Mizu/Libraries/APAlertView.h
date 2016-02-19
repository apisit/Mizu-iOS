//
//  PSAlertView.h
//  Print Studio 2
//
//  Created by Apisit Toompakdee on 7/10/14.
//  Copyright (c) 2014 All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PSAlertViewCancelBlock) ();
typedef void (^PSAlertViewDismissBlock) (NSInteger buttonIndex);

@interface APAlertView : UIControl
+ (void)alertWithTitle:(NSString*)title message:(NSString*)message fromRect:(CGRect)fromRect cancelButtonTitle:(NSString*)cancelTitle otherButtonTitles:(NSArray*)otherTitles onDismiss:(PSAlertViewDismissBlock)onDismiss onCancel:(PSAlertViewCancelBlock)onCancel;
@end
