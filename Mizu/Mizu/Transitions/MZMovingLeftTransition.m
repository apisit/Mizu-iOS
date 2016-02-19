//
//  PSCheckoutTransition.m
//  Print Studio 2
//
//  Created by Apisit Toompakdee on 5/21/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZMovingLeftTransition.h"
@interface MZMovingLeftTransition(){
    
}
@property (nonatomic)  UINavigationControllerOperation operation;
@end

@implementation MZMovingLeftTransition

+(id)withOperation:(UINavigationControllerOperation)viewOperation{
    MZMovingLeftTransition* checkout=[[MZMovingLeftTransition alloc]initWithOperation:viewOperation];
    return  checkout;
}
-(id)initWithOperation:(UINavigationControllerOperation)viewOperation{
    self =[super init];
    if (self){
        self.operation = viewOperation;
    }
    return self;
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
   // CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // UIView *fromSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    //   UIView *fromSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    if (self.operation==UINavigationControllerOperationPop) {
        toViewController.view.userInteractionEnabled=YES;
        
        for(UIView* v in toViewController.view.subviews){
            
            if ([v isKindOfClass:[UIImageView class]]){
                continue;
            }
            CGRect newRect = v.frame;
            newRect.origin.x -= width;
            v.frame = newRect;
        }
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    else {

        for(UIView* v in toViewController.view.subviews){
            if ([v isKindOfClass:[UIImageView class]]){
                continue;
            }
            CGRect newRect = v.frame;
            newRect.origin.x += width;
            v.frame=newRect;
        }
        
        [containerView addSubview:toViewController.view];
        toViewController.view.alpha=0;
        
        for(UIView* v in fromViewController.view.subviews){
            if ([v isKindOfClass:[UIImageView class]]){
                continue;
            }

            CGRect newRect= v.frame;
            newRect.origin.x-=width;
            CGFloat randomDuration=duration;//
            CGFloat randomDelay=[self randomFloatBetween:0.1 and:duration];
            [UIView animateWithDuration:randomDuration delay:randomDelay usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                v.frame=newRect;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
    [UIView animateWithDuration:duration delay:0.35 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.operation==UINavigationControllerOperationPop) {
            fromViewController.view.alpha=0;
            toViewController.view.frame=[UIScreen mainScreen].bounds;
        }else{
            toViewController.view.alpha = 1.0;
            toViewController.view.frame=[UIScreen mainScreen].bounds;
        }
        
        NSArray* subViews=self.operation==UINavigationControllerOperationPop?fromViewController.view.subviews:toViewController.view.subviews;
        for(UIView* v in subViews){
            if ([v isKindOfClass:[UIImageView class]]){
                continue;
            }
            CGRect newRect= v.frame;
            if (self.operation==UINavigationControllerOperationPop){
                newRect.origin.x+=width;
            }
            else{
                newRect.origin.x-=width;
            }CGFloat randomDuration=duration;
            CGFloat randomDelay=[self randomFloatBetween:0.1 and:duration];
            [UIView animateWithDuration:randomDuration delay:randomDelay usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                v.frame=newRect;
            } completion:^(BOOL finished) {
                
            }];
        }
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.35;
}
@end
