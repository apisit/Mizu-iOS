//
//  MZMenuViewController.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/3/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZMenuViewController : MZBaseViewController
@property (strong, nonatomic) IBOutlet UIView *reviewOrderContainer;
@property (strong, nonatomic) IBOutlet UIView *summaryContainer;
@property (strong, nonatomic) IBOutlet UIButton *btnReviewOrder;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtotal;
@property (nonatomic, strong) MZBusiness* selectedBusiness;
@property (nonatomic, strong) MZMenuSection* selectedSection;
@end
