//
//  MZTempAvatarImageView.h
//  Mizu
//
//  Created by Apisit Toompakdee on 3/15/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MZTempAvatarImageView : UIImageView
@property (nonatomic, strong) IBInspectable NSString* name;

@property (nonatomic, assign) IBInspectable BOOL rounded;

@end
