//
//  MZSectionHeaderView.h
//  MizuToolkit
//
//  Created by Apisit Toompakdee on 10/27/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface MZSectionHeaderView : UIView

@property (nonatomic, strong) IBInspectable UIColor* separatorColor;

@property (nonatomic, strong) IBInspectable NSString* title;
@property (nonatomic, strong) IBInspectable UIFont* font;
@property (nonatomic, strong) IBInspectable UIColor* textColor;
@property (nonatomic, assign) IBInspectable NSTextAlignment textAlignment;
@property (nonatomic, assign) IBInspectable BOOL hideBottomSeparator;
@property (nonatomic, assign) IBInspectable BOOL hideTopSeparator;

@end
