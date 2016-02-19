//
//  MZColor.h
//  MizuToolkit
//
//  Created by Apisit Toompakdee on 11/4/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZColor : NSObject

+ (UIColor*)mizuColor;
+ (UIColor*)backgroundColor;
+ (UIColor*)subBackgroundColor;
+ (UIColor*)titleColor;
+ (UIColor*)subTitleColor;
+ (UIColor*)tableBackgroundColor;
+ (UIColor*)tableCellBackgroundColor;
+ (UIColor*)tableSeparatorColor;
+ (UIColor*)tabBarBackgroundColor;
+ (void)styleTableView:(UITableView*)tableView;
+ (void)styleTableViewCell:(UITableViewCell*)tableViewCell;

@end
