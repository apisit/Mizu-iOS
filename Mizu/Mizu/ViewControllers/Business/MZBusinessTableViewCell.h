//
//  MZBusinessTableViewCell.h
//  Mizu
//
//  Created by Apisit Toompakdee on 7/9/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZBusinessTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblTags;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (strong, nonatomic) IBOutlet UIImageView *gradientImageView;
@property (strong, nonatomic) IBOutlet UIButton* btnGetDirections;
@property (strong, nonatomic) IBOutlet UIButton *hourDescription;
@property (nonatomic, strong) IBOutlet UIButton* btnMoreInfo;
@property (nonatomic, strong) MZBusiness* data;
@property (strong, nonatomic) IBOutlet UIImageView *verifiedStatus;

@end
