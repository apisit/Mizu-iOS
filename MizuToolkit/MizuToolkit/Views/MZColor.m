//
//  MZColor.m
//  MizuToolkit
//
//  Created by Apisit Toompakdee on 11/4/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZColor.h"

@implementation MZColor


+(void)styleTableView:(UITableView*)tableView{
    tableView.backgroundColor = [self tableBackgroundColor];
    tableView.separatorColor = [self tableSeparatorColor];
}

+(void)styleTableViewCell:(UITableViewCell *)tableViewCell{
    tableViewCell.backgroundColor = [self tableCellBackgroundColor];
}

+ (UIColor*)mizuColor{
    return UIColorFromRGB(0xffba44);
}
+ (UIColor*)backgroundColor{
    return UIColorFromRGB(0x191919);
}
+ (UIColor*)subBackgroundColor{
    return UIColorFromRGB(0x131313);
}

+ (UIColor*)titleColor{
    return UIColorFromRGB(0xffffff);
}
+ (UIColor*)subTitleColor{
    return UIColorFromRGB(0x868686);
}

+(UIColor *)tableBackgroundColor{
    return UIColorFromRGB(0x131313);
}
+ (UIColor*)tableCellBackgroundColor{
    return UIColorFromRGB(0x1c1c1c);
}
+ (UIColor*)tableSeparatorColor{
    return UIColorFromRGB(0x303030);
}

+ (UIColor*)tabBarBackgroundColor{
    return UIColorFromRGB(0x191919);
}
@end
