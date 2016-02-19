//
//  MZMenuTableViewCell.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/3/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblSuggestedItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet MZTagBadgeView *tagView;
@property (nonatomic, strong) MZMenuItem* data;
@property (nonatomic, strong) MZBusiness* selectedBusiness;
@property (strong, nonatomic) IBOutlet UIButton *btnCommentCount;
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UIButton *btnAddPicture;
@property (strong, nonatomic) IBOutlet UILabel *lblSuggestedForYou;

@property (strong, nonatomic) IBOutlet MZLikeButton *btnLike;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spacingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, assign) BOOL suggestedItem;
@property (nonatomic, assign) BOOL isFullView;
@property (nonatomic, assign) BOOL inMenuScreen;
@property (nonatomic, assign) BOOL showBusinessName;
@property (nonatomic, strong) IBOutlet UILabel* lblBusinessName;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagViewTopConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentScreenNameAndDetailVerticalSpacing;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentScreenDetailAndLikeVerticalSpacing;

@property (nonatomic,strong) IBOutlet UIImageView* addPhotoImageView;
- (void)didPostComment:(id)sender;
- (void)updateLikeCount;
- (void)updateCommentCount;
@end
