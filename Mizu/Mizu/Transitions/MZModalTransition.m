//
//  MZModalTransition.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/11/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZModalTransition.h"

@implementation MZModalTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animatePresentation:(id<UIViewControllerContextTransitioning>)transitionContext{
      NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    UIViewController* source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* container = transitionContext.containerView;
    
    UIView* destinationSS = [destination.view snapshotViewAfterScreenUpdates:YES];
    [container addSubview:destinationSS];

    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = 1.0 / -1000.0;
    perspectiveTransform = CATransform3DTranslate(perspectiveTransform, 0, 0, -100);
    
    CGRect destinationRect = destinationSS.frame;
    destinationRect.origin.x = -CGRectGetWidth([[UIScreen mainScreen] bounds]);
    destinationSS.frame = destinationRect;
    
    [source beginAppearanceTransition:NO animated:YES];
    
    [UIView animateWithDuration:transitionDuration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        source.view.layer.transform = perspectiveTransform;
        CGRect newDestinationRect = destinationSS.frame;
        newDestinationRect.origin.x = 0;
        destinationSS.frame = newDestinationRect;
    } completion:^(BOOL finished) {
        [destinationSS removeFromSuperview];
        [container addSubview:destination.view];
        [transitionContext completeTransition:finished];
        [source endAppearanceTransition];

    }];
}

- (void)animateDismissal:(id<UIViewControllerContextTransitioning>)transitionContext{
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    UIViewController* source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* container = transitionContext.containerView;
    destination.view.frame = container.bounds;
    source.view.frame = container.bounds;
    [destination beginAppearanceTransition:YES animated:YES];
    
    [UIView animateWithDuration:transitionDuration delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        destination.view.frame = container.bounds;
        destination.view.layer.transform = CATransform3DIdentity;
        CGRect sourceRect = source.view.frame;
        sourceRect.origin.x = -CGRectGetWidth([[UIScreen mainScreen] bounds]);
        source.view.frame = sourceRect;
    } completion:^(BOOL finished) {
        [destination endAppearanceTransition];
        [transitionContext completeTransition:YES];
    }];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if([destination isBeingPresented]) {
        [self animatePresentation:transitionContext];
    } else {
        [self animateDismissal:transitionContext];
    }
}
@end
