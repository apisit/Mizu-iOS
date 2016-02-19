//
//  AppDelegate.m
//  MizuManager
//
//  Created by Apisit Toompakdee on 9/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "AppDelegate.h"
#import "MZReachability.h"
#import <sys/utsname.h>

@interface AppDelegate ()
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) MZNotificationView* notificationView;

@end

@implementation AppDelegate

- (void)setupMizuNavigationBarStyle{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xffffff)];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x000000)];
    CGFloat fontSize = 17.0f;
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:fontSize]}];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:fontSize]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:fontSize]} forState:UIControlStateDisabled];
    
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0f, -2.5f)
                                               forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class],nil] setTitlePositionAdjustment:UIOffsetMake(0.0f, 1.0f)
                                                                                      forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     [Mizu setApplicationId:@"BPxKUIGwk0mEg5QxWwgFqg" apiKey:@"VrGscxgjkktG1ETiG93HDm7xK0j1Fv6oo84OX6epTwaH4x"];
    
    self.notificationView = [[MZNotificationView alloc]init];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    [self setupMizuNavigationBarStyle];
    if ([MZUser currentUser]==nil){
        UINavigationController *initialViewController = [UIStoryboard login];
        self.window.rootViewController = initialViewController;
    }
    
    
    
    return YES;
}


/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.internetReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:{
                [self.notificationView showNoInternetConnection];
                break;
            }
            case ReachableViaWWAN:{
                [self.notificationView hideNoInternetConnection];
                break;
            }
            case ReachableViaWiFi:{
                [self.notificationView hideNoInternetConnection];
                break;
            }
        }
    }
}


#pragma mark - push notification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checked" object:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checked" object:nil];
}

- (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    NSMutableString* deviceInfo = [[NSMutableString alloc]init];
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    [deviceInfo appendFormat:@"Version: %@,",version];
    [deviceInfo appendFormat:@"Device: %@,%@,",[self deviceModel],[[UIDevice currentDevice] systemVersion]];
    [deviceInfo appendFormat:@"App: Mizu Manager %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    if ([MZUser currentUser]!=nil){
        [[MZUser currentUser] saveDeviceToken:token deviceInfo:deviceInfo block:^(BOOL valid, NSError *error) {
        }];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
