//
//  MZListBusinessViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 7/9/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZListBusinessViewController.h"
#import "MZBusinessTableViewCell.h"
#import "MZMenuViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MZMenuListTableViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MZAppDelegate.h"
#import "MZMapViewViewController.h"
#import "MZSectionTableViewController.h"
#import "MZMenuViewController.h"
#import "MZBusinessDetailTableViewController.h"
#import "MZBusinessWithMizuPayTableViewController.h"
#import "MZCurrentCheckInTableViewController.h"
#import "MZRecieptTableViewController.h"

@interface MZListBusinessViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* data;
@property (nonatomic, assign) BOOL locationEnabled;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (strong, nonatomic) IBOutlet UILabel *lblMissingRestaurant;
@property (strong, nonatomic) IBOutlet UIButton *btnMissingRestaurant;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (strong, nonatomic) NSMutableArray* searchResult;
@property (nonatomic, strong) CLLocation* userLocation;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) IBOutlet UISearchBar* searchBar;
@property (nonatomic, assign) BOOL isAlreadyAlertUnsupportedCountry;

@property (nonatomic) __block __weak id observerDirection;
@property (nonatomic) __block __weak id observerBusinessInfo;

@end

@implementation MZListBusinessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
}

- (void)askForLocationPermission{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self performSegueWithIdentifier:@"locationPermission" sender:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"locationPermissionNotification" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if (note.userInfo==nil){
            [defaults setBool:YES forKey:@"askLocationPermission"];
            [defaults synchronize];
        }
        BOOL allow = [note.object boolValue];
        if (allow){
            [self updateLocation:nil];
        }else{
            [self loadBusiness:nil];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Discover", nil);
    self.isSearching = false;
    self.screenName = @"Restaurants";
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UIMutableUserNotificationAction* checkIn = [[UIMutableUserNotificationAction alloc]init];
        checkIn.title = @"Check In";
        checkIn.activationMode = UIUserNotificationActivationModeBackground;
        checkIn.identifier = @"checkin";
        checkIn.authenticationRequired = NO;
        checkIn.destructive = NO;
        
        UIMutableUserNotificationAction* later = [[UIMutableUserNotificationAction alloc]init];
        later.title = @"Not today";
        later.activationMode = UIUserNotificationActivationModeBackground;
        later.identifier = @"later";
        later.authenticationRequired = NO;
        later.destructive = YES;
        
        UIMutableUserNotificationCategory* category = [[UIMutableUserNotificationCategory alloc]init];
        category.identifier = @"CHECK_IN";
        [category setActions:@[later,checkIn] forContext:UIUserNotificationActionContextDefault];
        NSSet *categories = [NSSet setWithObject:category];
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:categories];
        if  ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]){
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    });
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem* btnHamburger = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"hamburger_menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapHamburger:)];
    btnHamburger.tintColor = UIColorFromRGB(0xa3a3a3);
    self.navigationItem.leftBarButtonItem = btnHamburger;
    
    BOOL isInSupportedCountry = [Mizu userIsInSupportedCountry];
    
    self.refreshControl  = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"Avenir-Medium" size:15]];
    
    if (isInSupportedCountry){
        [self.refreshControl addTarget:self action:@selector(updateLocation:) forControlEvents:UIControlEventValueChanged];
    }else{
        [self.refreshControl addTarget:self action:@selector(loadBusinessWithoutLocation:) forControlEvents:UIControlEventValueChanged];
    }
    
    
    [self.btnMissingRestaurant setTitle:NSLocalizedString(@"Request Restaurant", nil) forState:UIControlStateNormal];
    self.lblMissingRestaurant.text = NSLocalizedString(@"Missing your favorite restaurant?\nTell us about it!", nil);
    
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.delegate = self;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = backgroundView;
    
    [self.tableView setContentOffset:CGPointMake(0.0, self.tableView.tableHeaderView.frame.size.height) animated:YES];
    
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusNotDetermined){
        [defaults setBool:YES forKey:@"askLocationPermission"];
        [defaults synchronize];
    }
    
    BOOL setTastePreferences = [defaults boolForKey:@"setTastePreferences"];
    BOOL askedLocationPermission = [defaults boolForKey:@"askLocationPermission"];
    
    if (setTastePreferences==NO){
        UIViewController* vc = [UIStoryboard tastePreferences];
        [self presentViewController:vc animated:YES completion:nil];
        //when finish set taste preference for the first time
        //we then ask for location permission
        [[NSNotificationCenter defaultCenter] addObserverForName:@"finishSetTastePreferences" object:nil queue:nil usingBlock:^(NSNotification *note) {
            if (askedLocationPermission==NO){
                [self askForLocationPermission];
            }else{
                [self updateLocation:nil];
            }
        }];
    }
    
    if (isInSupportedCountry==NO){
        [self loadBusiness:nil];
        return;
    }
    
    //if never ask for location permission before.
    //we then subscribe to location permission notification.
    if (askedLocationPermission==NO && setTastePreferences==YES){
        [self askForLocationPermission];
        return;
    }
    
    if (setTastePreferences == YES && askedLocationPermission==YES){
        self.locationEnabled = [CLLocationManager locationServicesEnabled];
        
        if (self.locationEnabled==false){
            [self loadBusiness:nil];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.distanceFilter = kCLHeadingFilterNone;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.pausesLocationUpdatesAutomatically = NO;
            [self.locationManager startUpdatingLocation];
        });
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.observerDirection = [[NSNotificationCenter defaultCenter] addObserverForName:@"direction" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self performSegueWithIdentifier:@"direction" sender:note.object];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self.observerDirection name:@"direction" object:nil];
    }];
    
    self.observerBusinessInfo = [[NSNotificationCenter defaultCenter] addObserverForName:@"businessMoreInfo" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self performSegueWithIdentifier:@"businessMoreInfo" sender:note.object];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self.observerBusinessInfo name:@"businessMoreInfo" object:nil];
    }];
    
    [[MZUser currentUser] recentCheckInWithBlock:^(id object, NSError *error) {
        if (error!=nil){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MZCheckIn* checkIn = (MZCheckIn*)object;
            if (checkIn.objectId==nil){
                return;
            }
            if (checkIn.checked==YES){
                UINavigationController* nav = [UIStoryboard receipt];
                MZRecieptTableViewController* vc = [nav.viewControllers firstObject];
                vc.checkIn = checkIn;
                [self presentViewController:nav animated:YES completion:nil];
                return;
            }
            UINavigationController* nav = [UIStoryboard mizuPay];
            MZCurrentCheckInTableViewController* vc = [nav.viewControllers firstObject];
            vc.checkIn = checkIn;
            [self presentViewController:nav animated:YES completion:nil];
        });
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self.observerDirection name:@"direction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.observerBusinessInfo name:@"businessMoreInfo" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - actions
- (IBAction)didTapRequestRestaurant:(id)sender{
    if(![MFMailComposeViewController canSendMail]) {
        return;
    }
    UIColor* bgColor = UIColorFromRGB(0xffffff);
    [[UINavigationBar appearance] setBarTintColor:bgColor];
    [[UINavigationBar appearance] setBackgroundColor:bgColor];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc]init];
    mailController.mailComposeDelegate = self;
    [mailController setSubject:@"Restaurant Request"];
    [mailController setToRecipients:@[@"hello@getmizu.com"]];
    mailController.navigationBar.barTintColor = bgColor;
    mailController.navigationBar.tintColor = [UIColor blackColor];
    [self presentViewController:mailController animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* userLocation = [locations lastObject];
    if (userLocation == nil)
        return;
    self.userLocation = userLocation;
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    NSNotification* locationInfo = [[NSNotification alloc]initWithName:@"location" object:userLocation userInfo:nil];
    [self loadBusiness:locationInfo];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status==kCLAuthorizationStatusDenied){
        //if user denied location we load without it.
        [self loadBusiness:nil];
    }else if (status==kCLAuthorizationStatusNotDetermined){
    }else if (status==kCLAuthorizationStatusAuthorizedAlways || status==kCLAuthorizationStatusAuthorizedWhenInUse){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        });
    }
}

#pragma mark - update location
- (void)updateLocation:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    });
}

#pragma mark - Load bussiness
- (void)loadBusinessWithoutLocation:(id)sender{
    [self loadBusiness:nil];
}

- (void)loadBusiness:(NSNotification*)info{
    CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    CLLocation* location;
    if (info!=nil){
        location = info.object;
        userCoordinate = location.coordinate;
    }else{
        if (self.userLocation){
            location = self.userLocation;
            userCoordinate = location.coordinate;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Mizu isInSupportedCountry:^(BOOL valid, NSError *error) {
        if (self.isAlreadyAlertUnsupportedCountry)
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!valid && error==nil){
                self.isAlreadyAlertUnsupportedCountry = YES;
                [UIAlertView alertViewWithTitle:@"" message:@"Mizu is only available in Dublin at present, but you will be the first to know when we launch in your city." cancelButtonTitle:@"Okay"];
                return;
            }
        });
    }];
    
#if DEBUG
    userCoordinate = CLLocationCoordinate2DMake(53.3000566, -6.2954957);
#endif
    
    [MZAnalytics trackUserAction:@"View restaurants"];
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    NSString* trimmed = [self.searchDisplayController.searchBar.text trim];
    [MZBusiness businessesNearby:userCoordinate search:trimmed block:^(NSArray *list, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            app.networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error){
                if ([MZHelper isInvalidTokenError:error]){
                    [self.refreshControl endRefreshing];
                    [[FBSDKLoginManager alloc] logOut];
                    [[MZUser currentUser] logout];
                    UINavigationController *initialViewController = [UIStoryboard registration];
                    MZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                    appDelegate.window.rootViewController = initialViewController;
                    [appDelegate.window makeKeyAndVisible];
                    initialViewController.view.alpha = 0.0;
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        initialViewController.view.alpha = 1.0;
                    }];
                    
                    return;
                }
                return;
            }
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            if (list==nil){
                return;
            }
            
            
            if (self.isSearching){
                self.searchResult = [[NSMutableArray alloc]initWithArray:list];
                [self.searchDisplayController.searchResultsTableView reloadData];
                return;
            }
            self.data = [[NSMutableArray alloc]initWithArray:list];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return self.searchResult.count;
    }
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 225.0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    MZBusinessTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if  ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
        cell.preservesSuperviewLayoutMargins = NO;
    if(cell == nil) {
        cell = [[MZBusinessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    MZBusiness* business;
    
    if (self.isSearching){
        business = [self.searchResult objectAtIndex:indexPath.row];
    }else{
        business = [self.data objectAtIndex:indexPath.row];
    }
    cell.data = business;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MZBusiness* business;
    if (self.isSearching){
        business = [self.searchResult objectAtIndex:indexPath.row];
    }else{
        business = [self.data objectAtIndex:indexPath.row];
    }
    [self loadData:business];
}


#pragma mark - did tap hamburger
- (void)didTapHamburger:(id)sender{
    [self performSegueWithIdentifier:@"setting" sender:sender];
}


#pragma mark - UISearchDisplayController Delegate Methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    // [self loadBusiness:nil];
}
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    self.isSearching = YES;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    tableView.backgroundColor = UIColorFromRGB(0x303030);
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    self.searchResult = nil;
    self.isSearching = NO;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (UIView* v in self.searchDisplayController.searchResultsTableView.subviews) {
            if ([v isKindOfClass: [UILabel class]] &&
                [[(UILabel*)v text] isEqualToString:@"No Results"]) {
                UILabel* label = (UILabel*)v;
                label.font = [UIFont fontWithName:@"Avenir-Black" size:20];
                break;
            }
        }
    });
    
    NSString* s = [searchString trim];
    //filter locally first
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ || address CONTAINS[cd] %@ || city CONTAINS[cd] %@ || ANY tags CONTAINS[cd] %@",s,s,s,s];
    NSArray* filtered = [self.data filteredArrayUsingPredicate:predicate];
    self.searchResult = [[NSMutableArray alloc]initWithArray:filtered];
    return YES;
}


#pragma mark - prepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    
    if ([segue.identifier isEqualToString:@"mizupay"]){
        UINavigationController* vc = (UINavigationController*)segue.destinationViewController;
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"mizuPayEnabled==%@",@YES];
        
        MZBusinessWithMizuPayTableViewController* viewController =  [vc.viewControllers firstObject];
        viewController.businesses = [self.data filteredArrayUsingPredicate:predicate];
    }
    
    if ([segue.identifier isEqualToString:@"onemenu-onesection"]){
        MZMenuViewController* vc = (MZMenuViewController*)segue.destinationViewController;
        NSDictionary* dic = sender;
        MZBusiness* selectedBusiness = [dic objectForKey:@"selectedBusiness"];
        MZMenu* menu = [dic objectForKey:@"menu"];
        MZMenuSection* section = [menu.sections firstObject];
        vc.selectedBusiness = selectedBusiness;
        vc.selectedSection = section;
    }else if ([segue.identifier isEqualToString:@"onemenu"]){
        
        MZSectionTableViewController* vc = (MZSectionTableViewController*)segue.destinationViewController;
        NSDictionary* dic = sender;
        
        vc.selectedBusiness = [dic objectForKey:@"selectedBusiness"];
        vc.selectedMenu = [dic objectForKey:@"menu"];
    }else if ([segue.identifier isEqualToString:@"menu"]){
        
        MZMenuListTableViewController* vc = (MZMenuListTableViewController*)segue.destinationViewController;
        
        NSDictionary* dic = sender;
        NSArray* menus = [dic objectForKey:@"menus"];
        MZBusiness* selectedBusiness = [dic objectForKey:@"selectedBusiness"];
        vc.selectedBusiness = selectedBusiness;
        vc.data = menus;
        
    }else if ([segue.identifier isEqualToString:@"setting"]){
        UIViewController* controller = (UIViewController*)segue.destinationViewController;
        controller.transitioningDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationCustom;        controller.modalPresentationCapturesStatusBarAppearance = YES;
    }else if ([segue.identifier isEqualToString:@"direction"]){
        UINavigationController* vc = segue.destinationViewController;
        MZMapViewViewController* mapViewController = [vc.viewControllers firstObject];
        MZBusiness* selectedBusiness = sender;
        mapViewController.selectedBusiness = selectedBusiness;
        NSString* action = [NSString stringWithFormat:@"Get directions"];
        [MZAnalytics trackBusiness:selectedBusiness.name action:action];
    }else if ([segue.identifier isEqualToString:@"businessMoreInfo"]){
        MZBusinessDetailTableViewController* vc = segue.destinationViewController;
        MZBusiness* selectedBusiness = sender;
        vc.selectedBusiness = selectedBusiness;
        NSString* action = [NSString stringWithFormat:@"View more info"];
        [MZAnalytics trackBusiness:selectedBusiness.name action:action];
        
    }
    
    
}

#pragma mark - load data
- (void)loadData:(MZBusiness*)selectedBusiness{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [selectedBusiness menusWithBlock:^(NSArray *list, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MZAnalytics trackBusiness:selectedBusiness.name action:@"View Menus"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error){
                if ([MZHelper isInvalidTokenError:error]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[FBSDKLoginManager alloc] logOut];
                        [[MZUser currentUser] logout];
                        UINavigationController *initialViewController = [UIStoryboard registration];
                        MZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                        appDelegate.window.rootViewController = initialViewController;
                        [appDelegate.window makeKeyAndVisible];
                        initialViewController.view.alpha = 0.0;
                        
                        [UIView animateWithDuration:1.0 animations:^{
                            initialViewController.view.alpha = 1.0;
                        }];
                    });
                    return;
                }
                return;
            }
            
            NSArray* data = [NSArray arrayWithArray:list];
            if (data.count==1){
                MZMenu* menu = [data firstObject];
                
                if (menu.sections.count==1){
                    NSDictionary* dic = @{@"selectedBusiness":selectedBusiness,@"menu":menu};
                    [self performSegueWithIdentifier:@"onemenu-onesection" sender:dic];
                }else{
                    NSDictionary* dic = @{@"selectedBusiness":selectedBusiness,@"menu":menu};
                    [self performSegueWithIdentifier:@"onemenu" sender:dic];
                }
                
            }else{
                NSDictionary* dic = @{@"selectedBusiness":selectedBusiness,@"menus":data};
                [self performSegueWithIdentifier:@"menu" sender:dic];
            }
        });
    }];
}

@end
