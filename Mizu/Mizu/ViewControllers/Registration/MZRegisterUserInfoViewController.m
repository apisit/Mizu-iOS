//
//  MZRegisterUserInfoViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 7/1/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZRegisterUserInfoViewController.h"
#import "MZMovingLeftTransition.h"
#import "InternationalCallingCodeService.h"
#import "MZAppDelegate.h"
#import "MZWebViewViewController.h"
@interface MZRegisterUserInfoViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtFirstname;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtCountryCode;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation MZRegisterUserInfoViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.txtFirstname.delegate = nil;
    self.txtLastName.delegate = nil;
    self.txtEmail.delegate = nil;
    self.txtPassword.delegate = nil;
    [self.txtFirstname resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        self.topConstraint.constant = 0;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.txtFirstname.delegate = self;
    self.txtLastName.delegate = self;
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        self.topConstraint.constant = 44;
    }
    
    self.screenName = @"Register";
    self.title = @"Create Account";
    
    [self.txtEmail addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtPassword addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtFirstname addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtLastName addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    self.btnNext = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didTapNext:)];
    self.navigationItem.rightBarButtonItem = self.btnNext;
    self.btnNext.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapTOS:(id)sender {
    [MZAnalytics track:@"Viewed TOS in register screen"];
    MZWebViewViewController* webView = [[MZWebViewViewController alloc]init];
    webView.url = @"https://www.getmizu.com/legal/terms-of-service";
    webView.webTitle = @"Terms of Service";
    UINavigationController* nv = [[UINavigationController alloc]initWithRootViewController:webView];
    [self presentViewController:nv animated:YES completion:nil];
}

- (IBAction)didTapPrivacyPolicy:(id)sender {
    [MZAnalytics track:@"Viewed Privacy Policy in register screen"];
    MZWebViewViewController* webView = [[MZWebViewViewController alloc]init];
    webView.url = @"https://www.getmizu.com/legal/privacy-policy";
    webView.webTitle = @"Privacy Policy";
    UINavigationController* nv = [[UINavigationController alloc]initWithRootViewController:webView];
    [self presentViewController:nv animated:YES completion:nil];
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return [textField validateToNext:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtFirstname){
        return [self.txtFirstname validateToNext:self.txtLastName];
    }
    
    if (textField == self.txtLastName){
        return [self.txtLastName validateToNext:self.txtEmail];
    }
    
    if (textField == self.txtEmail){
        return [self.txtEmail validateToNext:self.txtPassword];
    }
    if (textField == self.txtPassword && [self.txtPassword.text trim].length>=6){
        [self.txtPassword valid];
        [MZAnalytics track:@"Registering account with Return button"];
        [self signup];
        return YES;
    }else{
        [self.txtPassword invalid];
        return NO;
    }
    
    return NO;
}


- (void)shouldEnableNextButton:(UITextField*)sender{
    [sender validateToNext:nil];
    BOOL valid = [self.txtEmail isValid] && [self.txtFirstname isValid] && [self.txtLastName isValid] && [self.txtPassword isValid];
    [self.btnNext setEnabled:valid];
}

- (void)signup{
    NSString* firstname = [self.txtFirstname.text trim];
    NSString* lastname = [self.txtLastName.text trim];
    NSString* email = [self.txtEmail.text trim];
    NSString* password = [self.txtPassword.text trim];
    
    if (firstname.length==0){
        [self.txtFirstname invalid];
        return;
    }
    if (lastname.length==0){
        [self.txtLastName invalid];
        return;
    }
    if (email.length==0){
        [self.txtEmail invalid];
        return;
    }
    
    if (password.length==0){
        [self.txtPassword invalid];
        return;
    }
    
    NSString* title = @"Is this correct";
    NSString* message = [NSString stringWithFormat:@"Your email: %@",email];
    
    [UIAlertView alertViewWithTitle:title message:message cancelButtonTitle:@"No" otherButtonTitles:@[@"Yes"] onDismiss:^(int buttonIndex) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        [MZUser registerWithFirstname:firstname lastname:lastname email:email password:password phoneNumber:@"" dateOfBirth:@"" gender:@"" socialAccount:nil block:^(MZUser *currentUser, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (currentUser==nil || error!=nil){
                    [MZAnalytics track:[NSString stringWithFormat:@"Error register account: %@",error.localizedDescription]];
                    [UIAlertView alertViewWithTitle:@"Error while trying to signup" message:error.localizedDescription cancelButtonTitle:@"Okay"];
                    return;
                }
                //reset the set taste preference flag
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:NO forKey:@"setTastePreferences"];
                [defaults synchronize];
                
                [MZAnalytics track:@"Successfully register account"];
                
                UINavigationController *initialViewController = [UIStoryboard business];
                
                MZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                appDelegate.window.rootViewController = initialViewController;
                [appDelegate.window makeKeyAndVisible];
                initialViewController.view.alpha = 0.0;
                
                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    initialViewController.view.alpha = 1.0;
                } completion:^(BOOL finished) {
                    
                }];
                
            });
        }];
    } onCancel:^{
        [self.txtEmail becomeFirstResponder];
    }];
}

- (IBAction)didTapNext:(id)sender {
    [MZAnalytics track:@"Registering account with Next button"];
    [self signup];
}

- (IBAction)didTapRegisterWithFacebook:(id)sender{
    //,@"user_birthday"
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
            
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                if ([FBSDKAccessToken currentAccessToken]){
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, first_name,last_name,email,gender"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        if (!error) {
                            [self signupWithFacebook:result];
                        }
                    }];
                }
            }
        }
    }];
}

- (void)signupWithFacebook:(NSDictionary*)user{
    [MZAnalytics track:@"Registering account with facebook"];
    NSString* userId = [user objectForKey:@"id"];
    NSString *fbEmail = [user objectForKey:@"email"] ? [user objectForKey:@"email"] : [NSString stringWithFormat:@"%@@facebook.com",userId];
    NSString* firstname = [user objectForKey:@"first_name"];
    NSString* lastname = [user objectForKey:@"last_name"];
   // NSString* dob = [user objectForKey:@"last_name"];
    NSString* gender = [user objectForKey:@"gender"];
    NSString* email = fbEmail;
    NSString* password = [FBSDKAccessToken currentAccessToken].tokenString;
    MZSocialAccount* facebookAccount = [[MZSocialAccount alloc]init];
    facebookAccount.accessToken = password;
    facebookAccount.serviceName = @"facebook";
    facebookAccount.serviceUserId = userId;
    //construct json for social_account here
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MZUser registerWithFirstname:firstname lastname:lastname email:email password:password phoneNumber:@"" dateOfBirth:@"" gender:gender socialAccount:facebookAccount block:^(MZUser *currentUser, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (currentUser==nil || error!=nil){
                [MZAnalytics track:[NSString stringWithFormat:@"Error register account with facebook: %@",error.localizedDescription]];
                //destroy all session if signup failed
                
                [[FBSDKLoginManager alloc] logOut];
                
                [UIAlertView alertViewWithTitle:@"Error while trying to signup" message:error.localizedDescription cancelButtonTitle:@"Okay"];
                return;
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:NO forKey:@"setTastePreferences"];
            [defaults synchronize];
            [MZAnalytics track:@"Successfully register account with facebook"];
            UINavigationController *initialViewController = [UIStoryboard business];
            
            MZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController = initialViewController;
            [appDelegate.window makeKeyAndVisible];
            initialViewController.view.alpha = 0.0;
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                initialViewController.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
}


@end
