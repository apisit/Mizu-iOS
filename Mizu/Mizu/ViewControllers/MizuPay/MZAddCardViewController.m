//
//  MZAddCardViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZAddCardViewController.h"
#import <Stripe/Stripe.h>


@interface MZAddCardViewController ()<STPPaymentCardTextFieldDelegate>

@property (nonatomic) IBOutlet STPPaymentCardTextField* paymentTextField;

@end

@implementation MZAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Mizu Pay";
    self.navigationItem.hidesBackButton = YES;
    self.paymentTextField.delegate = self;
    self.paymentTextField.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(didTapNext:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.paymentTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
-(IBAction)didTapNext:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MZUser currentUser] addDefaultCreditCard:self.paymentTextField.cardNumber expMonth:self.paymentTextField.expirationMonth expYear:self.paymentTextField.expirationYear cvc:self.paymentTextField.cvc block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                [UIAlertView alertViewWithTitle:@"Error" message:@"Error while trying to save your card. Please try again." cancelButtonTitle:@"Retry"];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

#pragma mark -
- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = textField.valid;
}
@end
