//
//  MZSectionTableViewController.h
//  Mizu
//
//  Created by Apisit Toompakdee on 3/1/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZSectionTableViewController : UITableViewController

@property (nonatomic, strong) MZBusiness* selectedBusiness;
@property (nonatomic, strong) MZMenu* selectedMenu;

@end
