//
//  MZCommentViewController.h
//  Mizu
//
//  Created by Apisit Toompakdee on 2/7/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLKTextViewController.h"
@interface MZCommentViewController : SLKTextViewController

@property (nonatomic, strong) MZBusiness* selectedBusiness;
@property (nonatomic, strong) MZMenuItem* selectedMenuItem;
@property (nonatomic, assign) CGFloat cachedCellHeight;
@property (nonatomic, strong) UIImageView* imageViewForSelectedImage;
@property (nonatomic, strong) UIImage* selectedImage;
@property (nonatomic, assign) BOOL isFromLikes;

- (void)showSelectedImage:(UIImage*)image;

@end
