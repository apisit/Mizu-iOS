//
//  MZCommentTableViewCell.h
//  Mizu
//
//  Created by Apisit Toompakdee on 2/8/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MZCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) MZActivity* data;
@property (nonatomic, strong) IBOutlet UILabel* lblMessage;
@property (nonatomic, strong) IBOutlet MZTempAvatarImageView* profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *commentImageView;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTimeConstraint;

@end
