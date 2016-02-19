//
//  MZPhoneNumberViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZPhoneNumberViewController.h"
#import "InternationalCallingCodeService.h"

@interface MZPhoneNumberViewController ()

@property (nonatomic, strong) IBOutlet MZTextFieldWithCaption* txtPhoneNumber;
@property (nonatomic, strong) CallingCode* currentCallingCode;
@end

@implementation MZPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Phone number";
    [self.txtPhoneNumber becomeFirstResponder];
    self.currentCallingCode = [InternationalCallingCodeService getCurrentCallingCode];
    self.txtPhoneNumber.title = [NSString stringWithFormat:@"+%@",self.currentCallingCode.code];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(didTapNext:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapNext:(id)sender{
    if ([self.txtPhoneNumber.text trim].length==0)
        return;
    NSString* phoneNumber = [NSString stringWithFormat:@"%@%@",self.currentCallingCode.code,[self.txtPhoneNumber.text trim]];
    
    NSString* message = [NSString stringWithFormat:@"Your phone number with country code is %@",phoneNumber];
    [UIAlertView alertViewWithTitle:@"Please confirm" message:message cancelButtonTitle:@"Change" otherButtonTitles:@[@"Confirm"] onDismiss:^(int buttonIndex) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.txtPhoneNumber resignFirstResponder];
        });
        
        [[MZUser currentUser] updatePhoneNumber:phoneNumber block:^(BOOL valid, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (valid){
                    [self performSegueWithIdentifier:@"verify" sender:nil];
                }
            });
        }];
    } onCancel:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.txtPhoneNumber becomeFirstResponder];
        });
    }];
}

- (IBAction)didTapChangeCountryCode:(id)sender{
    
}

@end
