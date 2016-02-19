//
//  MZLocationPermissionViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/1/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZLocationPermissionViewController.h"

@interface MZLocationPermissionViewController()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) IBOutlet UIButton* btnLocation;
@end

@implementation MZLocationPermissionViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.btnLocation.layer.cornerRadius = 5.0f;
    self.btnLocation.layer.borderWidth = 0.0;
    self.btnLocation.layer.borderColor = UIColorFromRGB(0xFEB945).CGColor;
}
- (IBAction)didTapAllowLocation:(id)sender{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8 && [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
        
    }else{
        [self.locationManager startUpdatingLocation];
    }
    
    self.locationManager.distanceFilter = kCLHeadingFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
}

- (IBAction)didTapCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationPermissionNotification" object:@NO userInfo:@{@"later":@YES}];
    }];
}

#pragma mark - location delegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status==kCLAuthorizationStatusDenied){
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"locationPermissionNotification" object:@NO userInfo:nil];
        }];
    }else if (status==kCLAuthorizationStatusNotDetermined){
        
        
    }else if (status==kCLAuthorizationStatusAuthorizedAlways || status==kCLAuthorizationStatusAuthorizedWhenInUse){
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"locationPermissionNotification" object:@YES userInfo:nil];
        }];
    }
}


@end
