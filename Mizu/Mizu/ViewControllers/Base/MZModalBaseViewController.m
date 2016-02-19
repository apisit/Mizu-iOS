//
//  MZModalBaseViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/11/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZModalBaseViewController.h"
#import "MZModalTransition.h"
@interface MZModalBaseViewController ()

@end

@implementation MZModalBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id <UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(UIViewController *)presenting
sourceController:(UIViewController *)source
{
    return [MZModalTransition new];
}

- (id <UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [MZModalTransition new];
}



@end
