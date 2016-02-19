//
//  UIView+Category.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/27/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallBack) ();
@interface UIView (Category)
- (UIImage *)toUIImage;
- (UIView *)blurredView;
- (void)shake;
- (UIViewController *) firstAvailableUIViewController;

- (void)popOutsideWithDuration:(NSTimeInterval)duration callBack:(CallBack)callBack;

- (void)popInsideWithDuration:(NSTimeInterval)duration;
- (void)wiggleView;
@end
