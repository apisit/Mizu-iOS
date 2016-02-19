//
//  MZVerifyPhoneNumberViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZVerifyPhoneNumberViewController.h"

@interface MZVerifyPhoneNumberViewController ()

@property (nonatomic, strong) IBOutlet UITextField* txtVerificationCode;

@end

@implementation MZVerifyPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Phone Verification";
    [self.txtVerificationCode becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(didTapVerify:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (IBAction)didTapVerify:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MZUser currentUser] verifyPhoneNumberWithCode:[self.txtVerificationCode.text trim] block:^(BOOL valid, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (valid==NO && error!=nil){
                [UIAlertView alertViewWithTitle:@"Invalid verification code" message:@"" cancelButtonTitle:@"Try again"];
            }
            if (valid){
                //add card
                [self performSegueWithIdentifier:@"card" sender:nil];
            }
        });
        
    }];
}
- (IBAction)didTapResend:(id)sender{
    
}
@end
