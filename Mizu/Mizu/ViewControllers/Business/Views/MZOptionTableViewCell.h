//
//  MZOptionTableViewCell.h
//  Mizu
//
//  Created by Apisit Toompakdee on 10/30/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZOptionTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) IBOutlet UILabel* lblTitle;

@end
