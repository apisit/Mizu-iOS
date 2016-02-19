//
//  MZForgotPasswordTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 11/19/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZForgotPasswordTableViewController.h"

@interface MZForgotPasswordTableViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UITextField* txtEmail;
@property (nonatomic,strong)  UIBarButtonItem* btnNext;

@end

@implementation MZForgotPasswordTableViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.txtEmail.delegate = nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [MZColor styleTableView:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

#pragma mark - 
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MZSectionHeaderView *headerView = [[MZSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [MZColor subBackgroundColor];
    headerView.separatorColor = [MZColor tableSeparatorColor];
    headerView.textColor = [MZColor subTitleColor];
    headerView.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
    if (section==0){
        headerView.title = [@"" uppercaseString];
    }
    
    return headerView;
}

@end
