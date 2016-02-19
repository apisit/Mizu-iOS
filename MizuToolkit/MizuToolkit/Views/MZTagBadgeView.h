//
//  MZTagBadgeView.h
//  Mizu
//
//  Created by Apisit Toompakdee on 6/21/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZTagBadgeView : UIView
@property (nonatomic, strong) NSArray* tags;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL onDarkBakcground;
+ (CGFloat)heightByTags:(NSArray*)tags width:(CGFloat)width;
@end
