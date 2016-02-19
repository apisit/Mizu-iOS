//
//  MZWebViewViewController.h
//  Mizu
//
//  Created by Apisit Toompakdee on 3/14/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZWebViewViewController : MZBaseViewController

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* webTitle;
@property (nonatomic, assign) BOOL hideCloseButton;
@end
