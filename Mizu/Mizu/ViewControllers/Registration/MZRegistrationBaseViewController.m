//
//  MZRegistrationBaseViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 7/6/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZRegistrationBaseViewController.h"
#import "MZMovingLeftTransition.h"
@interface MZRegistrationBaseViewController ()

@end

@implementation MZRegistrationBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.navigationController.delegate=self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.delegate=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    return [MZMovingLeftTransition withOperation:operation];
}

- (void)didTapNext:(id)sender{

}


@end
