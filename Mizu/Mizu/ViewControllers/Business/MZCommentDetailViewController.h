//
//  MZCommentDetailViewController.h
//  Mizu
//
//  Created by Apisit Toompakdee on 2/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZCommentDetailViewController : MZBaseViewController

@property (nonatomic, strong) MZActivity* data;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
