//
//  MZMenuListTableViewController.h
//  Mizu
//
//  Created by Apisit Toompakdee on 4/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZMenuListTableViewController : UITableViewController
@property (nonatomic, strong) MZBusiness* selectedBusiness;
@property (nonatomic, strong) NSArray* data;
@end
