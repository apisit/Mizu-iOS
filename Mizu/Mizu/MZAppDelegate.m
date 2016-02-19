//
//  MZAppDelegate.m
//  Mizu
//
//  Created by Apisit Toompakdee on 6/29/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZAppDelegate.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MZReachability.h"
#import <sys/utsname.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

NSString *const BFTaskMultipleExceptionsException = @"BFMultipleExceptionsException";

@interface MZAppDelegate()<CLLocationManagerDelegate>

@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) MZNotificationView* notificationView;
@property (nonatomic, assign) BOOL requesting;
@property CLLocationManager* locationManager;

@end

@implementation MZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    self.notificationView = [[MZNotificationView alloc]init];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [application setStatusBarHidden:NO];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeDefault error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x191919)];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0xffffff)];
    CGFloat fontSize = 17.0f;
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:fontSize]}];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:fontSize]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:fontSize]} forState:UIControlStateDisabled];
    
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0f, -2.5f)
                                               forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class],nil] setTitlePositionAdjustment:UIOffsetMake(0.0f, 1.0f)
                                                                                      forBarMetrics:UIBarMetricsDefault];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[MZColor subTitleColor],NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:13]} forState:UIControlStateNormal];
    [[UITabBar appearance] setBackgroundColor:[MZColor tabBarBackgroundColor]];
    [[UITabBar appearance] setTranslucent:NO];
    // [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    //[[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if (application.applicationState != UIApplicationStateBackground) {
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
#if !DEBUG
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-61430983-3"];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    tracker.allowIDFACollection = YES;
#endif
    
    if ([MZUser currentUser]==nil){
        UINavigationController *initialViewController = [UIStoryboard registration];
        self.window.rootViewController = initialViewController;
    }else{
        /*   self.locationManager = [[CLLocationManager alloc]init];
         self.locationManager.delegate = self;
         for (CLRegion* region in self.locationManager.monitoredRegions){
         [self.locationManager stopMonitoringForRegion:region];
         }
         
         NSString* identifier = @"com.getmizu.pay";
         NSUUID *proximityUUID = [[NSUUID alloc]initWithUUIDString:kProximity_UUID];
         CLBeaconRegion* beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:proximityUUID identifier:identifier];
         beaconRegion.notifyOnEntry = YES;
         beaconRegion.notifyOnExit = YES;
         beaconRegion.notifyEntryStateOnDisplay = YES;
         [self.locationManager startMonitoringForRegion:beaconRegion];*/
        
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checked" object:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) { [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checked" object:nil];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Title for cancel button in local notification");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alert show];
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
    
    if ([MZUser currentUser]!=nil){
        [[MZUser currentUser] saveDeviceToken:token deviceInfo:deviceInfo block:^(BOOL valid, NSError *error) {
        }];
    }
    
    // Store the deviceToken in the current Installation and save it to Parse
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber=1;
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:@"checkin"]) {
        
        NSLog(@"checking user in");
        [UIAlertView alertViewWithTitle:@"You are checked-in" message:nil];
    }
    else  if ([identifier isEqualToString:@"later"]) {
        NSLog(@"delete notification");
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    if (completionHandler) {
        
        completionHandler();
    }
}

#pragma mark - location delegate
-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"start %@",region);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status==kCLAuthorizationStatusAuthorizedAlways){
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion - error: %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    if ([region isKindOfClass:[CLBeaconRegion class]]){
        CLBeaconRegion* beaconRegion = (CLBeaconRegion*)region;
        if (state == CLRegionStateInside) {
            [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        }else if (state==CLRegionStateOutside){
            [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    if ([beacons count]==0){
        return;
    }
    CLBeacon *nearestBusiness = [beacons firstObject];
    if (nearestBusiness.proximity==CLProximityFar){
        return;
    }
    [self.locationManager stopRangingBeaconsInRegion:region];
    NSString* businessID = [NSString stringWithFormat:@"%ld",[nearestBusiness.major integerValue]];
    
    [MZBusiness businessDetail:businessID block:^(id object, NSError *error) {
        if (error!=nil) {
            NSLog(@"%@",error);
            return;
        }
        MZBusiness* business = object;
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.category = @"CHECK_IN";
        notification.alertBody = [NSString stringWithFormat:@"Would you like to check in to %@?",business.name];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        notification.alertAction = @"check in";
        notification.alertTitle = @"Looks like you are close by";
        
    }];
}

@end
