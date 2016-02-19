//
//  MZSignupTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 11/12/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZSignupTableViewController.h"
#import "InternationalCallingCodeService.h"
#import "MZAppDelegate.h"
#import "MZWebViewViewController.h"

@interface MZSignupTableViewController ()<UITextFieldDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtFirstname;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet MZTextFieldWithCaption *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtGender;
@property (strong, nonatomic) IBOutlet UITextField *txtDateOfBirth;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtCountryCode;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUpWithFacebook;
@property (nonatomic, strong) UIDatePicker* dobPicker;
@property UITapGestureRecognizer* tapToResign;
@property (nonatomic, assign) BOOL selectedCustomGender;
@property (nonatomic, strong) UITextField* focusedTextField;
@property (nonatomic, readonly) NSArray* genderOptions;
@end

@implementation MZSignupTableViewController

-(NSArray *)genderOptions{
    return @[@"Female",@"Male",@"Custom"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.txtFirstname.delegate = nil;
    self.txtLastName.delegate = nil;
    self.txtEmail.delegate = nil;
    self.txtPassword.delegate = nil;
    self.txtGender.delegate = nil;
    self.txtDateOfBirth.delegate = nil;
    self.txtPhone.delegate = nil;
    self.txtConfirmPassword.delegate = nil;
    
    [self.txtFirstname resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtGender resignFirstResponder];
    [self.txtPhone resignFirstResponder];
    [self.txtDateOfBirth resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.txtFirstname.delegate = self;
    self.txtLastName.delegate = self;
    self.txtEmail.delegate = self;
    self.txtPassword.delegate = self;
    self.txtDateOfBirth.delegate = self;
    self.txtGender.delegate = self;
    self.txtPhone.delegate = self;
    self.txtConfirmPassword.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.screenName = @"Register";
    self.title = @"Create Account";
    
    [self.txtEmail addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtPassword addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtFirstname addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtLastName addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtPhone addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtGender addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtDateOfBirth addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    [self.txtConfirmPassword addTarget:self action:@selector(shouldEnableNextButton:) forControlEvents:UIControlEventEditingChanged];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(didTapNext:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    CallingCode* code = [InternationalCallingCodeService getCurrentCallingCode];
    self.txtPhone.title = [NSString stringWithFormat:@"+%@",code.code];
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

- (IBAction)didTapToResign:(id)sender{
    [self.txtDateOfBirth resignFirstResponder];
    [self.dobPicker resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapToResign];
}

- (IBAction)didChangeDOB:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    self.txtDateOfBirth.text = [dateFormatter stringFromDate:[self.dobPicker date]];
    [self.txtDateOfBirth valid];
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0){
        self.txtGender.text = [self.genderOptions objectAtIndex:0];
        [self.txtGender valid];
    }else if (buttonIndex==1){
        self.txtGender.text = [self.genderOptions objectAtIndex:1];
        [self.txtGender valid];
    }else if (buttonIndex==2){
        self.txtGender.text = @"";
        self.selectedCustomGender = YES;
        [self.txtGender becomeFirstResponder];
    }
}

#pragma mark - text field delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.focusedTextField = textField;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView setContentOffset:CGPointMake(0, 59) animated:YES];
    });
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.txtDateOfBirth.isFirstResponder && [self.txtDateOfBirth.text trim].length==0){
        return NO;
    }
    
    if (self.txtDateOfBirth.isFirstResponder && [self.txtDateOfBirth.text trim].length>0){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dobPicker = nil;
            self.txtDateOfBirth.inputView = nil;
            [self.txtDateOfBirth resignFirstResponder];
            [self.dobPicker resignFirstResponder];
        });
    }
    
    if (textField == self.txtGender && self.selectedCustomGender==NO){
        BOOL valid = self.focusedTextField==nil || [self.focusedTextField isValid];
        if (valid==NO)
            return YES;
        [self.focusedTextField resignFirstResponder];
        UIActionSheet* actionShet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Female",@"Male",@"Custom", nil];
        [actionShet showInView:self.view];
        return NO;
    }
    
    if (textField != self.txtDateOfBirth)
        return YES;
    
    //init uidatepicker
    if (self.dobPicker==nil){
        self.dobPicker = [[UIDatePicker alloc]init];
        self.dobPicker.datePickerMode = UIDatePickerModeDate;
        if ([MZUser currentUser].dateOfBirth){
            [self.dobPicker setDate:[MZUser currentUser].dateOfBirth];
        }
        self.dobPicker.maximumDate = [NSDate date];
        [self.dobPicker addTarget:self action:@selector(didChangeDOB:) forControlEvents:UIControlEventValueChanged];
        self.txtDateOfBirth.inputView = self.dobPicker;
    }
    self.tapToResign = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapToResign:)];
    [self.view addGestureRecognizer:self.tapToResign];
    return YES;
}

//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    if (self.txtDateOfBirth.isFirstResponder && [self.txtDateOfBirth.text trim].length==0){
//        return NO;
//    }
//
//    if (textField==self.txtPassword || textField ==self.txtConfirmPassword)
//        return YES;
//
//    self.selectedCustomGender = NO;
//    return [textField validateToNext:nil];
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtFirstname){
        return [self.txtFirstname validateToNext:self.txtLastName];
    }
    
    if (textField == self.txtLastName){
        return [self.txtLastName validateToNext:self.txtEmail];
    }
    
    if (textField == self.txtEmail){
        return [self.txtEmail validateToNext:self.txtPhone];
    }
    if (textField == self.txtPhone){
        return [self.txtPhone validateToNext:self.txtDateOfBirth];
    }
    if (textField == self.txtDateOfBirth){
        return [self.txtDateOfBirth validateToNext:self.txtPassword];
    }
    if (textField == self.txtGender){
        return [self.txtGender validateToNext:self.txtDateOfBirth];
    }
    
    if (textField == self.txtPassword){
        return [self.txtPassword validateToNext:self.txtConfirmPassword];
    }
    
    
    if ((textField == self.txtPassword || textField == self.txtConfirmPassword) && self.navigationItem.rightBarButtonItem.enabled){
        [self.txtPassword valid];
        [self.txtConfirmPassword valid];
        [MZAnalytics track:@"Registering account with Return button"];
        [self signup];
        return YES;
    }else{
        [self.txtPassword invalid];
        [self.txtConfirmPassword invalid];
        return NO;
    }
    
    return NO;
}


- (void)shouldEnableNextButton:(UITextField*)sender{
    [sender validateToNext:nil];
    BOOL valid = [self.txtEmail isValid] && [self.txtFirstname isValid] && [self.txtLastName isValid] && [self.txtPhone isValid] && [self.txtGender isValid] && [self.txtDateOfBirth isValid] && ([[self.txtPassword.text trim] isEqualToString:[self.txtConfirmPassword.text trim]]);
    
    if (sender==self.txtConfirmPassword || sender==self.txtPassword){
        if (![[self.txtPassword.text trim] isEqualToString:[self.txtConfirmPassword.text trim]]){
            [self.txtPassword invalid];
            [self.txtConfirmPassword invalid];
        }else{
            if ([self.txtPassword.text trim].length>=6){
                [self.txtPassword valid];
                [self.txtConfirmPassword valid];
            }
        }
    }
    
    [self.navigationItem.rightBarButtonItem setEnabled:valid];
}

- (void)signup{
    NSString* firstname = [self.txtFirstname.text trim];
    NSString* lastname = [self.txtLastName.text trim];
    NSString* email = [self.txtEmail.text trim];
    NSString* password = [self.txtPassword.text trim];
    NSString* phoneNumber = [self.txtPhone.text trim];
    NSString* dateOfBirth = [self.txtDateOfBirth.text trim];
    NSString* gender = [self.txtGender.text trim];
    
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
    
    NSString* title = @"Is this correct?";
    NSString* message = [NSString stringWithFormat:@"Your email: %@",email];
    
    [UIAlertView alertViewWithTitle:title message:message cancelButtonTitle:@"No" otherButtonTitles:@[@"Yes"] onDismiss:^(int buttonIndex) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        [MZUser registerWithFirstname:firstname lastname:lastname email:email password:password phoneNumber:phoneNumber dateOfBirth:dateOfBirth gender:gender socialAccount:nil block:^(MZUser *currentUser, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (currentUser==nil || error!=nil){
                    [MZAnalytics track:[NSString stringWithFormat:@"Error register account: %@",error.localizedDescription]];
                    [UIAlertView alertViewWithTitle:@"Error while trying to signup" message:error.localizedDescription cancelButtonTitle:@"Okay"];
                    return;
                }
                
                //go to next screen
                //adding credit card screen.
                [self performSegueWithIdentifier:@"picture" sender:nil];
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
