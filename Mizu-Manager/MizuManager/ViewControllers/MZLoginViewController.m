//
//  MZLoginViewController.m
//  MizuManager
//
//  Created by Apisit Toompakdee on 9/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZLoginViewController.h"
#import "AppDelegate.h"
@interface MZLoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) UIBarButtonItem* btnNext;
@end

@implementation MZLoginViewController



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.txtEmail.delegate = nil;
    self.txtPassword.delegate = nil;
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Log In";
   
    [self.txtEmail addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtPassword addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    self.btnNext = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTapNext:)];
    self.navigationItem.rightBarButtonItem = self.btnNext;
    self.btnNext.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - enable next button
- (void)shouldEnableNextButton:(UITextField*)sender{
    //[NSRunLoop cancelPreviousPerformRequestsWithTarget:sender];
    //[sender performSelector:@selector(validateToNext:) withObject:nil afterDelay:0.5];
    [sender validateToNext:nil];
    BOOL valid = [self.txtEmail isValid] && [self.txtPassword isValid];
    [self.btnNext setEnabled:valid];
}

#pragma mark - textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtEmail){
        return [self.txtEmail validateToNext:self.txtPassword];
    }
    
    if (textField == self.txtPassword){
        [self.txtPassword validateToNext:nil];
        BOOL isValid =  [self.txtPassword isValid];
        
        if (isValid){
            //[MZAnalytics track:@"Signing in with Return button"];
            [self signin];
            return YES;
        }
    }
    return NO;
}

#pragma mark - Did tap forgot password
- (IBAction)didTapForgotPassword:(id)sender{
    
}

- (IBAction)didTapNext:(id)sender{
    //[MZAnalytics track:@"Signing in with Next button"];
    [self signin];
}

- (void)signin{
    NSString* username =[self.txtEmail.text trim];
    NSString* password = [self.txtPassword.text trim];
    
    if (username.length==0 || password.length==0){
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [MZUser loginWithEmail:username password:password socialAccount:nil block:^(MZUser *currentUser, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil || currentUser==nil){
                //[MZAnalytics track:[NSString stringWithFormat:@"Error sign in: %@",error.localizedDescription]];
                [UIAlertView alertViewWithTitle:@"Invalid Email or Password" message:@"Please try again" cancelButtonTitle:@"Okay"];
                
                return;
            }
            //if login with existing account we don't need to show the taste pref dialog.
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"setTastePreferences"];
            [defaults synchronize];
            
           // [MZAnalytics track:@"Signed in"];
            UINavigationController *initialViewController = [UIStoryboard manager];
            
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController = initialViewController;
            [appDelegate.window makeKeyAndVisible];
            initialViewController.view.alpha = 0.0;
            [UIView animateWithDuration:1.0 animations:^{
                initialViewController.view.alpha = 1.0;
            }];
        });
    }];
}

@end
