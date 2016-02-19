//
//  MZBusinessWithMizuPayTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/17/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZBusinessWithMizuPayTableViewController.h"
#import "MZBusinessTableViewCell.h"
#import "MZBusinessDetailTableViewController.h"
#import "MZMapViewViewController.h"
#import "MZCurrentCheckInTableViewController.h"
#import "MZBusinessWithMizuPayTableViewCell.h"
#import "MZRecieptTableViewController.h"

@import MapKit;
@import CoreLocation;
@import MessageUI;

@interface MZBusinessWithMizuPayTableViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UIView* mapViewContainer;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* mapViewContainerHeight;
@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) IBOutlet UILabel* lblHeader;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* loading;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* userLocation;
@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic) __block __weak id observerGetDirection;
@property (nonatomic, strong) IBOutlet UIButton* btnOpenInMaps;

@property (nonatomic, weak) MZBusiness* selectedBusiness;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@end

@implementation MZBusinessWithMizuPayTableViewController

#pragma mark -
- (void)directionTo:(MZBusiness*)business{
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    CLLocationCoordinate2D coordinate = business.coordinate;
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    
    MKMapItem* destination = [[MKMapItem alloc]initWithPlacemark:placeMark];
    destination.name = business.name;
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destination;
    request.requestsAlternateRoutes = NO;
    [request setTransportType:MKDirectionsTransportTypeWalking];
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.mapViewContainer animated:YES];
         if (error) {
             // Handle Error
         } else {
             [self showRoute:response business:business];
         }
     }];
}
-(void)showRoute:(MKDirectionsResponse *)response business:(MZBusiness*)business
{
    self.lblHeader.text = [[NSString stringWithFormat:@"Directions to %@",self.selectedBusiness.name] uppercaseString];
    [self.loading stopAnimating];
    
    for (MKRoute *route in response.routes)
    {
        [self.mapView
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        [self.mapView setVisibleMapRect:[route.polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0) animated:YES];
    }
    
    MKPointAnnotation* point = [[MKPointAnnotation alloc]init];
    point.title = business.name;
    point.subtitle = business.address;
    point.coordinate = business.coordinate;
    [self.mapView addAnnotation:point];
    [self.mapView selectAnnotation:point animated:YES];
}

#pragma mark - map view delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
    renderer.lineWidth = 5.0;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *idenfier = @"annotation";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:idenfier];
    if (!pinView)
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:idenfier];
        UIImage *flagImage = [UIImage imageNamed:@"mizu_pin"];
        
        annotationView.image = flagImage;
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status==kCLAuthorizationStatusDenied){
        //if user denied location we load without it.
        [self loadData:nil];
    }else if (status==kCLAuthorizationStatusNotDetermined){
        NSLog(@"kCLAuthorizationStatusNotDetermined");
    }else if (status==kCLAuthorizationStatusAuthorizedWhenInUse || status==kCLAuthorizationStatusAuthorizedAlways){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        });
    }
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
    [self loadData:locationInfo];
}




#pragma mark -
- (void)updateLocation{
    self.title = @"Pay";
    [MBProgressHUD hideAllHUDsForView:self.mapViewContainer animated:YES];
    
    self.selectedBusiness = nil;
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self askForLocationPermission];
        return;
    }
    //deselect annotation
    for (id anno in self.mapView.selectedAnnotations){
        [self.mapView deselectAnnotation:anno animated:YES];
    }
    //remove overlay
    [self.mapView removeOverlays:self.mapView.overlays];
    self.tableView.scrollEnabled = YES;
    self.mapViewContainerHeight.constant = 210;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        self.btnOpenInMaps.alpha = 0;
    } completion:^(BOOL finished) {
        
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
    
    self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"nearme-found"];
    self.navigationItem.rightBarButtonItem.tintColor = [MZColor mizuColor];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.lblHeader.text = @"FINDING NEARBY BUSINESSES...";
    [self.loading startAnimating];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
}

#pragma mark -
-(void)pinOnMap:(NSArray*)list{
    if (list.count==0 || list ==nil){
        if (self.userLocation){
            MKCoordinateRegion mapRegion;
            mapRegion.center = self.userLocation.coordinate;
            mapRegion.span.latitudeDelta = 0.01;
            mapRegion.span.longitudeDelta = 0.01;
            [self.mapView setRegion:mapRegion animated: YES];
            [self.mapView regionThatFits:mapRegion];
        }
        return;
    }
    
   
       CLLocationCoordinate2D user = self.userLocation.coordinate;
  
    MKMapPoint userPoint = MKMapPointForCoordinate(user);
   
    MKMapRect userRect = MKMapRectMake(userPoint.x, userPoint.y, 0, 0);
   
    MKMapRect unionRect;
    for(MZBusiness* business in list){
        //if (business.distanceFromCurrentLocation<200){
            CLLocationCoordinate2D annotation = business.coordinate;
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation);
            MKMapRect annotationRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            unionRect = MKMapRectUnion(userRect, annotationRect);
       // }
    }
    MKMapRect unionRectThatFits = [self.mapView mapRectThatFits:unionRect];
    [self.mapView setVisibleMapRect:unionRectThatFits edgePadding:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0) animated:YES];

    [self.mapView removeAnnotations:self.mapView.annotations];
    for(MZBusiness* business in list){
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:business.coordinate];
        [annotation setTitle:business.name];
        [self.mapView addAnnotation:annotation];
    }
    //[self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
}
- (void)loadData:(NSNotification*)info{
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
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
#if DEBUG
    //DUBLIN
    userCoordinate = CLLocationCoordinate2DMake(53.3381768, -6.2613077);
    //JAPAN
    //userCoordinate = CLLocationCoordinate2DMake(35.702069, 139.775327);
    
#endif
    [MZBusiness businessesWithMizuPayNearby:userCoordinate block:^(NSArray *list, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            app.networkActivityIndicatorVisible = NO;
            if (error!=nil) {
                return;
            }
            [self.refreshControl endRefreshing];
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"nearme"];
           [self.loading stopAnimating];
            [self pinOnMap:list];
            if (list.count==0){
                  self.lblHeader.text = @"LOOKS LIKE WE CAN'T FIND ANY :(";
                //show let us know button.
                return;
            }
            self.lblHeader.text = @"SELECT THE BUSINESS YOU WISH TO PAY AT";
        
            self.businesses = list;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
        });
    }];
}

- (void)askForLocationPermission{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UIViewController* vc = [UIStoryboard prePermissionLocation];
    [self presentViewController:vc animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"locationPermissionNotification" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if (note.userInfo==nil){
            [defaults setBool:YES forKey:@"askLocationPermission"];
            [defaults synchronize];
        }
        BOOL allow = [note.object boolValue];
        if (allow){
            [self updateLocation];
        }else{
            [self updateLocation];
        }
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observerGetDirection name:@"didTapRoute" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pay";
    
    self.btnOpenInMaps.alpha = 0;
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
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nearme"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapRefresh:)];
    
   // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [MZColor styleTableView:self.tableView];
    
    self.observerGetDirection =  [[NSNotificationCenter defaultCenter] addObserverForName:@"didTapRoute" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        MZBusiness* selectedBusiness = [note.userInfo valueForKey:@"data"];
        self.title = [NSString stringWithFormat:@"Directions"];
        self.lblHeader.text = @"GETTING DIRECTIONS...";
        [self.loading startAnimating];
        self.selectedBusiness = selectedBusiness;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.mapViewContainer animated:YES];
          __block NSInteger index = [self.businesses indexOfObject:selectedBusiness];
            [self.view layoutIfNeeded];
            CGFloat height = [UIScreen mainScreen].bounds.size.height - 64 - 50 - 80 + 1; // navbar - tab bar - cell
            self.mapViewContainerHeight.constant = height;
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view layoutIfNeeded];
                self.btnOpenInMaps.alpha = 1;
                self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"x"];
               
            } completion:^(BOOL finished) {
                 [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [self directionTo:selectedBusiness];
                self.tableView.scrollEnabled = NO;
            }];
        });
    }];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(didTapRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = NO;
    //refresh every time.
    [[MZUser currentUser] refreshWithBlock:^(MZUser *currentUser, NSError *error) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateLocation];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.locationManager stopUpdatingLocation];
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil;
    self.locationManager = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (IBAction)didTapRefresh:(id)sender{
    [self updateLocation];
}

- (IBAction)didTapOpenInMaps:(id)sender{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Apple Maps",@"Google Maps", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - actions
- (IBAction)didTapRequestRestaurant:(id)sender{
    if(![MFMailComposeViewController canSendMail]) {
        return;
    }
//    UIColor* bgColor = UIColorFromRGB(0xffffff);
//    [[UINavigationBar appearance] setBarTintColor:bgColor];
//    [[UINavigationBar appearance] setBackgroundColor:bgColor];
//    [[UINavigationBar appearance] setTranslucent:NO];
//    
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc]init];
    mailController.mailComposeDelegate = self;
    [mailController setSubject:@"Restaurant Request"];
    [mailController setToRecipients:@[@"hello@getmizu.com"]];
    mailController.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:mailController animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0){
        //Apple Maps
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            CLLocationCoordinate2D coordinate = self.selectedBusiness.coordinate;
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:self.selectedBusiness.name];
            
            [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
        }
    }else if (buttonIndex==1){
        //Google Maps
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f&dirflg=w", self.selectedBusiness.coordinate.latitude, self.selectedBusiness.coordinate.longitude];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }else if (buttonIndex==2){
        return;
    }
}

#pragma mark - Table view data source

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableView.scrollEnabled;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    MZBusinessWithMizuPayTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if  ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
        cell.preservesSuperviewLayoutMargins = NO;
    if(cell == nil) {
        cell = [[MZBusinessWithMizuPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    MZBusiness* business = [self.businesses objectAtIndex:indexPath.row];
    
    cell.data = business;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    __block MZBusiness* business = [self.businesses objectAtIndex:indexPath.row];
    
    if ([MZUser currentUser].mizuPayEnabled==NO){
        [UIAlertView alertViewWithTitle:nil message:@"Please add a debit or credit card to your Mizu account first" cancelButtonTitle:@"Later" otherButtonTitles:@[@"Add one"] onDismiss:^(int buttonIndex) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController.tabBarController setSelectedIndex:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCard" object:nil userInfo:nil];
            });
            
        } onCancel:^{
            
        }];
        return;
    }
    
    NSString* message = [NSString stringWithFormat:@"Please confirm that you would like to pay with Mizu at %@",business.name];
    [UIAlertView alertViewWithTitle:@"Confirm Check-In" message:message cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Confirm"] onDismiss:^(int buttonIndex) {
        //check in
        [self checkin:business];
    } onCancel:^{
        
    }];
}

#pragma mark - checkin
- (void)checkin:(MZBusiness*)business{
    [[MZUser currentUser] checkInToBusiness:business note:@"" block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error!=nil){
                if ([error.localizedDescription containsString:@"payment"]){
                    [UIAlertView alertViewWithTitle:nil message:error.localizedDescription cancelButtonTitle:@"Later" otherButtonTitles:@[@"Add one"] onDismiss:^(int buttonIndex) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController.tabBarController setSelectedIndex:1];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCard" object:nil userInfo:nil];
                        });
                        
                    } onCancel:^{
                        
                    }];
                    return;
                }
                [UIAlertView alertViewWithTitle:nil message:error.localizedDescription];
                return;
            }
            
            UINavigationController* nav = [UIStoryboard mizuPay];
            MZCurrentCheckInTableViewController* vc = [nav.viewControllers firstObject];
            vc.checkIn = object;
            [self presentViewController:nav animated:YES completion:nil];
        });
    }];
}

#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"direction"]){
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


@end
