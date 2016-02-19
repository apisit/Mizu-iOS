//
//  MZMapViewViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/21/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZMapViewViewController.h"
#import <MapKit/MapKit.h>
@interface MZMapViewViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation MZMapViewViewController


- (void)getDirections:(MZBusiness*)business{


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
         if (error) {
             // Handle Error
         } else {
             [self showRoute:response];
         }
     }];
}
-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapView
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
         [self.mapView setVisibleMapRect:[route.polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(50.0, 50.0, 80.0, 50.0) animated:YES];
    }
   
    MKPointAnnotation* point = [[MKPointAnnotation alloc]init];
    point.title = self.selectedBusiness.name;
    point.subtitle = self.selectedBusiness.address;
    point.coordinate = self.selectedBusiness.coordinate;
    [self.mapView addAnnotation:point];
    [self.mapView selectAnnotation:point animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){

        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.locationManager.distanceFilter = kCLHeadingFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
    }
    
    
    self.mapView.delegate = self;
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(didTapClose:)];
    self.title = self.selectedBusiness.name;
    self.screenName = @"Restaurant Direction";
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 1, 1);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    [self getDirections:self.selectedBusiness];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)didTapClose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - location delegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status==kCLAuthorizationStatusDenied){
        //if user denied location we load without it.
        
    }else if (status==kCLAuthorizationStatusNotDetermined){
    }else if (status==kCLAuthorizationStatusAuthorizedAlways || status==kCLAuthorizationStatusAuthorizedWhenInUse){
 
    }
}

#pragma mark - mapview delegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
    renderer.lineWidth = 5.0;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    return renderer;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

#pragma mark - 
-(IBAction)didTapOpenInMaps:(id)sender{
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
}

-(IBAction)didTapGoogleMap:(id)sender{
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f&dirflg=w", self.selectedBusiness.coordinate.latitude, self.selectedBusiness.coordinate.longitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

@end
