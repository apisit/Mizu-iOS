//
//  MZRegistrationBaseViewController.h
//  Mizu
//
//  Created by Apisit Toompakdee on 7/6/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZBaseViewController.h"

@interface MZRegistrationBaseViewController : MZBaseViewController<UINavigationControllerDelegate>
@property (nonatomic, strong) IBOutlet UIBarButtonItem* btnNext;
@property (nonatomic, strong) IBOutlet UIButton* btnBack;
@property (nonatomic, strong) IBOutlet UILabel* lblTitle;
- (IBAction)didTapNext:(id)sender;
@end
