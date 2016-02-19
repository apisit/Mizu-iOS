//
//  MZWaitListViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/4/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZWaitListViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>

@interface MZWaitListViewController ()
@property (strong, nonatomic) IBOutlet UIView *mizuLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

@end

@implementation MZWaitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Waiting list";
    self.lblMessage.alpha = 0;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self reverseGeocodeLocation:self.userLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)reverseGeocodeLocation:(CLLocation *)location
{
    CLGeocoder* reverseGeocoder = [[CLGeocoder alloc] init];
    if (reverseGeocoder) {
        [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark* placemark = [placemarks firstObject];
            if (placemark) {
                NSString* city = [placemark.addressDictionary objectForKey:@"City"];
                NSString* country = [placemark.addressDictionary objectForKey:@"Country"];
                 self.lblMessage.text = [NSString stringWithFormat:self.lblMessage.text,[MZUser currentUser].firstname,city,country];
                [UIView animateWithDuration:0.2 animations:^{
                   self.lblMessage.alpha = 1;
                } completion:^(BOOL finished) {
                   
                }];
            }
        }];
    }
}

#pragma mark - share
- (IBAction)didTapFacebook:(id)sender {
    NSString *link = @"https://www.facebook.com/getmizu";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (IBAction)didTapTwitter:(id)sender {
    NSString *link = @"https://www.twitter.com/getmizu";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
    
}
- (IBAction)didTapInstagram:(id)sender {
    NSString *link = @"https://www.instagram.com/getmizu";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

@end
