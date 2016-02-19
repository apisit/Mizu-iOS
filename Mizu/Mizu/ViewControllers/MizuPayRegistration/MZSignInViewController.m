//
//  MZSignInViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 7/1/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZSignInViewController.h"
#import "MZAppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface MZSignInViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) UIBarButtonItem* btnNext;
@end

@implementation MZSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"Log In";
    [self.btnForgotPassword setTitle:NSLocalizedString(@"Forgot password?", nil) forState:UIControlStateNormal];
    [MZColor styleTableView:self.tableView];
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

- (IBAction)didTapLoginWithFacebook:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
          
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                if ([FBSDKAccessToken currentAccessToken]){
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, first_name,last_name,email,gender"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        if (!error) {
                            [self loginWithFacebook:result];
                        }
                    }];
                }
            }
        }
    }];
}
- (void)loginWithFacebook:(NSDictionary*)user{
    [MZAnalytics track:@"Signing in with facebook"];
    NSString *fbEmail = [user objectForKey:@"email"] ? [user objectForKey:@"email"] : [NSString stringWithFormat:@"%@@facebook.com", [user objectForKey:@"username"]];
    NSString* userId = [user objectForKey:@"id"];
    NSString* accessToken = [FBSDKAccessToken currentAccessToken].tokenString;

    MZSocialAccount* facebookAccount = [[MZSocialAccount alloc]init];
    facebookAccount.accessToken = accessToken;
    facebookAccount.serviceName = @"facebook";
    facebookAccount.serviceUserId = userId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MZUser loginWithEmail:fbEmail password:nil socialAccount:facebookAccount block:^(MZUser *currentUser, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil || currentUser==nil){
                //destroy all session if signup failed
                [MZAnalytics track:[NSString stringWithFormat:@"Error sign in with facebook: %@",error.localizedDescription]];
                 [[FBSDKLoginManager alloc] logOut];
                [UIAlertView alertViewWithTitle:@"Facebook account not found" message:error.localizedDescription cancelButtonTitle:@"Okay"];
                
                return;
            }
            //if login with existing account we don't need to show the taste pref dialog.
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"setTastePreferences"];
            [defaults synchronize];

            [MZAnalytics track:@"Signed in with facebook"];
            
            [UIStoryboard showBusiness];
        });
    }];
    
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
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView setContentOffset:CGPointMake(0, 59) animated:YES];
    });
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtEmail){
        return [self.txtEmail validateToNext:self.txtPassword];
    }
    
    if (textField == self.txtPassword){
        [self.txtPassword validateToNext:nil];
        BOOL isValid =  [self.txtPassword isValid];
        
        if (isValid){
            [MZAnalytics track:@"Signing in with Return button"];
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
    [MZAnalytics track:@"Signing in with Next button"];
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
                [MZAnalytics track:[NSString stringWithFormat:@"Error sign in: %@",error.localizedDescription]];
                [UIAlertView alertViewWithTitle:@"Invalid Email or Password" message:@"Please try again" cancelButtonTitle:@"Okay"];
                
                return;
            }
            //if login with existing account we don't need to show the taste pref dialog.
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"setTastePreferences"];
            [defaults synchronize];

            [MZAnalytics track:@"Signed in"];
            UINavigationController *initialViewController = [UIStoryboard business];
            
            MZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
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
