//
//  MZForgotPasswordViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 1/17/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZForgotPasswordViewController.h"


@interface MZForgotPasswordViewController()<UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UITextField* txtEmail;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic,strong)  UIBarButtonItem* btnNext;

@end

@implementation MZForgotPasswordViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.txtEmail.delegate = nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        self.topConstraint.constant = 44;
    }
    self.title = @"Forgot password";
    //self.screenName = @"Forgot password";
    self.txtEmail.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(didTapNext:)];
    [self.txtEmail addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - text field delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField validateToNext:nil])
        return NO;
    
    [self forgotPassword];
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return [textField validateToNext:nil];
}

- (void)shouldEnableNextButton:(UITextField*)sender{
    [sender validateToNext:nil];
    BOOL valid = [self.txtEmail isValid];
    [self.btnNext setEnabled:valid];
}

- (void)forgotPassword{
    
    if (![self.txtEmail validateToNext:nil])
        return;
    
    NSString* email =[self.txtEmail.text trim];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MZUser forgotPasword:email block:^(BOOL valid, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (!valid){
                [UIAlertView alertViewWithTitle:@"Error" message:error.localizedDescription cancelButtonTitle:@"Okay"];
                return;
            }
            [self.txtEmail resignFirstResponder];
            [UIAlertView alertViewWithTitle:@"Forgot password" message:@"Reset password link will be sent to given email address." cancelButtonTitle:@"Okay" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
                
            } onCancel:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        });
    }];
    
}

-(void)didTapNext:(id)sender{
    [self forgotPassword];
}


@end
