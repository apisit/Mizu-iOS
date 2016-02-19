//
//  MZTextFieldWithCaption.h
//  Mizu
//
//  Created by Apisit Toompakdee on 1/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MZTextFieldWithCaption : UITextField
@property (nonatomic, assign) IBInspectable BOOL showTopSeparator;
@property (nonatomic, assign) IBInspectable BOOL showSeparator;
@property (nonatomic, assign) IBInspectable BOOL showTopCornerRadius;
@property (nonatomic, assign) IBInspectable BOOL showBottomCornerRadius;
@property (nonatomic, strong) IBInspectable NSString* title;
@property (nonatomic, strong) IBInspectable IBOutlet UILabel* lblTitle;
@property (nonatomic, assign) IBInspectable BOOL hideCaption;
@end
