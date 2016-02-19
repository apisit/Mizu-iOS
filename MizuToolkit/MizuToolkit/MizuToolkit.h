//
//  MizuToolkit.h
//  MizuToolkit
//
//  Created by Apisit Toompakdee on 9/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import <UIKit/UIKit.h>

#import "MZBackArrowButton.h"
#import "MZBiggerTapAreaButton.h"
#import "MZBusinessHourButton.h"
#import "MZCustomHighlightedColorButton.h"
#import "MZDeleteButton.h"
#import "MZLikeButton.h"
#import "MZMoreInfoButton.h"
#import "MZRequestRestaurantButton.h"
#import "MZRoundedCornerButton.h"
#import "MZSmallRoundedCornerButton.h"
#import "MZTagBadgeViewButton.h"
#import "MZBusinessNameLabel.h"
#import "MZCommentTextView.h"
#import "MZLabelPaddingTop.h"
#import "MZLabelZeroPadding.h"
#import "MZNotificationViewLabel.h"
#import "MZRaterView.h"
#import "MZSectionDetailLabel.h"
#import "MZSelectedForYouLabel.h"
#import "MZStyleLabel.h"
#import "MZTextField.h"
#import "MZTextFieldWithCaption.h"
#import "MZTextView.h"
#import "MZDarkBackgroundView.h"
#import "MZHeartAnimation.h"
#import "MZLineView.h"
#import "MZLogo.h"
#import "MZNotificationView.h"
#import "MZParticleView.h"
#import "MZPassThroughImageView.h"
#import "MZSuccessCheckmark.h"
#import "MZTagBadgeView.h"
#import "MZTagCircleView.h"
#import "MZTempAvatarImageView.h"
#import "MZVerticalLineView.h"
#import "NSAttributedString+Category.h"
#import "NSDate+Categories.h"
#import "NSString+Utilities.h"
#import "UIBarButtonItem+Animation.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Utilities.h"
#import "UITextField+Category.h"
#import "UIView+Category.h"
#import "MZSectionHeaderView.h"
#import "MZColor.h"
#import "MZBaseTextField.h"
#import "MZCustomKerningLabel.h"


//! Project version number for MizuToolkit.
FOUNDATION_EXPORT double MizuToolkitVersionNumber;

//! Project version string for MizuToolkit.
FOUNDATION_EXPORT const unsigned char MizuToolkitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MizuToolkit/PublicHeader.h>


