//
//  MZSplahViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/18/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZSplahViewController.h"
#import "MZAppDelegate.h"
#import "MZSplashScene.h"
#import <SpriteKit/SpriteKit.h>
@interface MZSplahViewController ()
@property (strong, nonatomic) MZSplashScene* scene;
@property (nonatomic, strong) IBOutlet SKView* skView;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UIButton* btnLogo;
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation MZSplahViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    //#if !DEBUG
    [Mizu isInSupportedCountry:^(BOOL valid, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL isInSupportCountry = valid;
            if (!isInSupportCountry && error==nil){
                [self performSegueWithIdentifier:@"guestlist" sender:nil];
            }
        });
    }];
    //#endif
    self.scene = [MZSplashScene sceneWithSize:self.skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.skView presentScene:self.scene];
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPress:)];
    [self.btnLogo addGestureRecognizer:longPress];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [self.scene pause];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    BOOL hiddenByModal = nil != [self presentedViewController];
    if (hiddenByModal)
        return;
    
    CGFloat time = 3.0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(didTapLogo:) userInfo:nil repeats:YES];
    [self.timer performSelector:@selector(fire) withObject:nil afterDelay:3];
    [self.scene start];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}


-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(event.type == UIEventSubtypeMotionShake)
    {
        [self.scene shake];
    }
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(event.type == UIEventSubtypeMotionShake)
    {
        [self.scene endShake];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (IBAction)didLongPress:(id)sender{
    [self.scene clearAllNode];
}

- (IBAction)didTapLogo:(id)sender{
    [self.logo popInsideWithDuration:0.35];
    [self.scene popout:self.logo.frame.origin];
    
}

- (IBAction)didTapRegisterWithFacebook:(id)sender{
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
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
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
    NSString* username = [user objectForKey:@"username"];
    NSString *fbEmail = [user objectForKey:@"email"] ? [user objectForKey:@"email"] : [NSString stringWithFormat:@"%@@facebook.com", username?username:userId];
    
    NSString* firstname = [user objectForKey:@"first_name"];
    NSString* lastname = [user objectForKey:@"last_name"];
    NSString* email = fbEmail;
    NSString* password = [FBSDKAccessToken currentAccessToken].tokenString;
    MZSocialAccount* facebookAccount = [[MZSocialAccount alloc]init];
    facebookAccount.accessToken = password;
    facebookAccount.serviceName = @"facebook";
    facebookAccount.serviceUserId = userId;
    //construct json for social_account here
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MZUser registerWithFirstname:firstname lastname:lastname email:email password:password phoneNumber:@"" dateOfBirth:@"" gender:@"" socialAccount:facebookAccount block:^(MZUser *currentUser, NSError *error) {
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
