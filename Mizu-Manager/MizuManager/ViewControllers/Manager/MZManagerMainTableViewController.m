//
//  MZManagerMainTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 9/10/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZManagerMainTableViewController.h"
#import "MZManagerCurrentCheckInTableViewController.h"
#import "MZManagerPaymentHistoryTableViewController.h"
#import <MessageUI/MessageUI.h>

@import CoreBluetooth;
@import SafariServices;
@interface MZManagerMainTableViewController ()<CBPeripheralManagerDelegate,MFMailComposeViewControllerDelegate,SFSafariViewControllerDelegate>

@property (nonatomic, strong) CBPeripheralManager* peripheralManager;
@property (nonatomic, strong) CLBeaconRegion* region;

@end

@implementation MZManagerMainTableViewController
- (void)startAdvertising{
    NSUUID *proximityUUID = [[NSUUID alloc]initWithUUIDString:kProximity_UUID];
    NSInteger major = [self.selectedBusiness.objectId integerValue];
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID major:major identifier:@"com.getmizu.pay"];
    NSDictionary *beaconPeripheralData = [self.region peripheralDataWithMeasuredPower:nil];
    // Start advertising your beacon's data.
    [self.peripheralManager startAdvertising:beaconPeripheralData];
}
- (void)setupBeaconEmitter{
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}
#pragma mark - CBPeripheralManagerDelegate
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    if(self.peripheralManager.state < CBPeripheralManagerStatePoweredOn)
    {
        //        NSString *title = NSLocalizedString(@"Bluetooth must be enabled", @"");
        //        NSString *message = NSLocalizedString(@"To configure your device as a beacon", @"");
        //        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel button title in configuration Save Changes");
        //        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        //        [errorAlert show];
        
        return;
    }
    
    [self.peripheralManager stopAdvertising];
    
    [self startAdvertising];
}

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    //  [UIAlertView alertViewWithTitle:@"Start advertising" message:@""];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBeaconEmitter];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
        if  ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]){
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    });
    
    self.title = self.selectedBusiness.name;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self checkMizuPayEnabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 
- (void)checkMizuPayEnabled{
    if (self.selectedBusiness.mizuPayEnabled == NO){
        [UIAlertView alertViewWithTitle:@"Mizu Pay" message:@"Start accepting Mizu Pay by linking your bank account to your business." cancelButtonTitle:@"Later" otherButtonTitles:@[@"Enter account info"] onDismiss:^(int buttonIndex) {
            [self openStripeConnect];
        } onCancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
        [self.tableView reloadData];
        return;
    }else{
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
    }
}


#pragma mark -
- (void)openStripeConnect{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.selectedBusiness connectWithStripe:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil || object==nil){
                return;
            }
            NSString* urlString = [NSString stringWithFormat:@"%@",object];
            urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* url = [NSURL URLWithString:urlString];
            NSLog(@"%@",urlString);
            if (url==nil){
                return;
            }
            SFSafariViewController* vc = [[SFSafariViewController alloc]initWithURL:url];
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        });
    }];
    
}


#pragma mark - table view delgate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==1 && indexPath.row==0){
        //open email dialog.
        [self openEmailDialog];
    }
}

#pragma mark -

-(void)openEmailDialog{
    if(![MFMailComposeViewController canSendMail]) {
        return;
    }
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc]init];
    mailController.mailComposeDelegate = self;
    NSString* subject = [NSString stringWithFormat:@"Help & Support from %@",self.selectedBusiness.name];
    [mailController setSubject:subject];
    [mailController setToRecipients:@[@"support@getmizu.com"]];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString* body = [NSString stringWithFormat:@""];
    [mailController setMessageBody:body isHTML:NO];
    [self presentViewController:mailController animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark-
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"current"]){
        MZManagerCurrentCheckInTableViewController* vc = segue.destinationViewController;
        vc.selectedBusiness = self.selectedBusiness;
    }
    
    if ([segue.identifier isEqualToString:@"histories"]){
        MZManagerPaymentHistoryTableViewController* vc = segue.destinationViewController;
        vc.selectedBusiness = self.selectedBusiness;
    }
}
#pragma mark -
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MZBusiness businessDetail:self.selectedBusiness.objectId block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                return;
            }
           self.selectedBusiness =  object;
            [self checkMizuPayEnabled];
        });
    }];
}

@end
