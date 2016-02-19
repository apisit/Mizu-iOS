//
//  UIView+Category.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/27/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "UIView+Category.h"
#import "UIImage+ImageEffects.h"
@implementation UIView (Category)
- (UIImage *)toUIImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0f);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

- (UIView *)blurredView {
    UIImage *blurImage = [self toUIImage];
    blurImage = [blurImage applyBlurWithRadius:3.0 tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    imgView.image = blurImage;
    return imgView;
}

- (void)shake{
    dispatch_async(dispatch_get_main_queue(), ^{
        const int reset = 5;
        const int maxShakes = 6;
        static int shakes = 0;
        static int translate = reset;
        [UIView animateWithDuration:0.09-(shakes*.01) delay:0.01f options:(enum UIViewAnimationOptions) UIViewAnimationCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeTranslation(translate, 0);
        }completion:^(BOOL finished){
            if(shakes < maxShakes){
                shakes++;
                if (translate>0)
                    translate--;
                translate*=-1;
                [self shake];
            } else {
                self.transform = CGAffineTransformIdentity;
                shakes = 0;
                translate = reset;
                return;
            }
        }];
    });
}
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}



- (void)popOutsideWithDuration:(NSTimeInterval)duration callBack:(CallBack)callBack{
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
             callBack();
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
           
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (void)popInsideWithDuration:(NSTimeInterval)duration {
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

-(void)wiggleView {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @8, @-8, @4, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.4;
    animation.additive = YES;
    [self.layer addAnimation:animation forKey:@"wiggle"];
}

@end
