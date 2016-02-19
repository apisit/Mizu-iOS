//
//  MZTasteOptionTableViewCell.h
//  Mizu
//
//  Created by Apisit Toompakdee on 4/11/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZTasteOptionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton* btnYes;
@property (strong, nonatomic) IBOutlet UIButton* btnNo;
@property (strong, nonatomic) MZQuestion* data;
@property (strong, nonatomic) IBOutlet UIImageView *tasteImageView;

@end
