//
//  MZMenuListTableViewCell.h
//  Mizu
//
//  Created by Apisit Toompakdee on 4/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZMenuListTableViewCell : UITableViewCell

@property (nonatomic, strong) MZMenu* data;
@property (nonatomic, strong) IBOutlet UILabel* lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceImage;


@end
