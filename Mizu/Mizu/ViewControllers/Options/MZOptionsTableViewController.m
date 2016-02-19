//
//  MZOptionsTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 10/30/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZOptionsTableViewController.h"
#import "MZOptionTableViewCell.h"
#import "MZWebViewViewController.h"
#import "MZAppDelegate.h"
#import "MZConnectedCardTableViewController.h"
#import <MessageUI/MessageUI.h>
@interface MZOptionsTableViewController ()<MFMailComposeViewControllerDelegate>
@property (nonatomic) __block __weak id observerLogout;
@end

@implementation MZOptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Options";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationController.navigationBar.translucent = NO;
    [MZColor styleTableView:self.tableView];
    self.observerLogout = [[NSNotificationCenter defaultCenter] addObserverForName:@"logout" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.observerLogout name:@"logout" object:nil];
        [[FBSDKLoginManager alloc] logOut];
        [[MZUser currentUser] logout];
        UINavigationController *initialViewController = [UIStoryboard registration];
        MZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = initialViewController;
        [appDelegate.window makeKeyAndVisible];
        initialViewController.view.alpha = 0.0;
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            initialViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    //if user checked in without having a card.
    //we then ask them to add one. if they tap "add one"
    //then go to add new card screen.
    [[NSNotificationCenter defaultCenter] addObserverForName:@"addNewCard" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController.tabBarController setSelectedIndex:1];
            [self.navigationController popToRootViewControllerAnimated:NO];
            MZConnectedCardTableViewController* vc = [UIStoryboard connectedCard];
            vc.skipLoading = YES;
            [self.navigationController pushViewController:vc animated:NO];
            vc.skipLoading = NO;
            UIViewController* addNewCardVC = [UIStoryboard addNewCard];
            [self.navigationController pushViewController:addNewCardVC animated:YES];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MZSectionHeaderView *headerView = [[MZSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [MZColor subBackgroundColor];
    headerView.separatorColor = [MZColor tableSeparatorColor];
    headerView.textColor = [MZColor subTitleColor];
    headerView.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
    if (section==0){
        headerView.title = @"ACCOUNT";
    }else if (section==1){
        headerView.title = @"PAYMENT DETAILS";
    }else if (section==2){
        headerView.title = @"";
    }else if (section==3){
        headerView.title = @"STAY CONNECTED WITH US";
    }else if (section==4){
        headerView.title = @"";
    }else if (section==5){
        headerView.title = @"APP SETTINGS";
    }
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
        return 3;
    if (section==1)
        return 1;
    if (section==2)
        return 2;
    if (section==3)
        return 3;
    if (section==4)
        return 2;
    if (section==5)
        return 1;
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [MZColor styleTableViewCell:cell];
    cell.lblTitle.textColor = [MZColor titleColor];
    if (indexPath.section==0){
        if (indexPath.row==0){
            cell.lblTitle.text = @"Edit Profile";
        }else if (indexPath.row==1){
            cell.lblTitle.text = @"Food Preferences";
        }else if (indexPath.row==2){
            cell.lblTitle.text = @"Transaction History";
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0){
            cell.lblTitle.text = @"Connected Card";
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0){
            cell.lblTitle.text = @"Help & Support";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row==1){
            cell.lblTitle.text = @"Share Mizu";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else if (indexPath.section==3){
        if (indexPath.row==0){
            cell.lblTitle.text = @"Facebook";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row==1){
            cell.lblTitle.text = @"Twitter";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row==2){
            cell.lblTitle.text = @"Instagram";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section==4){
        if (indexPath.row==0){
            cell.lblTitle.text = @"Privacy Policy";
        }else if (indexPath.row==1){
            cell.lblTitle.text = @"Terms of Service";
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }else if (indexPath.section==5){
        if (indexPath.row==0){
            cell.lblTitle.text = @"Log out";
            cell.accessoryType = UITableViewCellAccessoryNone;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0){
        if (indexPath.row==0){
            UIViewController* vc = [UIStoryboard editProfile];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==1){
            UINavigationController* nav = [UIStoryboard tastePreferences];
            UIViewController* vc = [nav.viewControllers firstObject];
            [MZAnalytics trackUserAction:@"View Taste Preferences"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==2){
            UIViewController* vc = [UIStoryboard transactionHistories];
            [MZAnalytics trackUserAction:@"View transaction histories"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0){
            UIViewController* vc = [UIStoryboard connectedCard];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 2){
        
        if (indexPath.row==0){
            [self didTapHelp:nil];
        }else if (indexPath.row==1){
            [self didTapShare:nil];
        }
    }else if (indexPath.section == 3){
        MZWebViewViewController* webView = [[MZWebViewViewController alloc]init];
        webView.hideCloseButton = YES;
        if (indexPath.row==0){
            //facebook
            webView.url = @"https://www.facebook.com/getmizu";
            webView.webTitle = @"Mizu on Facebook";
        }else if (indexPath.row==1){
            //twitter
            webView.url = @"https://www.twitter.com/mizu";
            webView.webTitle = @"Mizu on Twitter";
        }else if (indexPath.row==2){
            //instagram
            webView.url = @"https://www.instagram.com/getmizu";
            webView.webTitle = @"Mizu on Instagram";
        }
         [self.navigationController pushViewController:webView animated:YES];
    }else if (indexPath.section==4){
        MZWebViewViewController* webView = [[MZWebViewViewController alloc]init];
        webView.hideCloseButton = YES;
        if (indexPath.row==0){
            webView.url = @"http://getmizu.com/legal/privacy-policy";
            webView.webTitle = @"Privacy Policy";
            [MZAnalytics trackUserAction:@"View Privacy Policy"];
        }else if (indexPath.row==1){
            webView.url = @"http://getmizu.com/legal/terms-of-service";
            webView.webTitle = @"Terms of Service";
            [MZAnalytics trackUserAction:@"View Terms of Service"];
            
        }
        
        [self.navigationController pushViewController:webView animated:YES];
    }else if (indexPath.section == 5){
        if (indexPath.row==0){
            [self didTapLogout:nil];
        }
    }
}

#pragma mark -
-(IBAction)didTapHelp:(id)sender{
    if(![MFMailComposeViewController canSendMail]) {
        return;
    }
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc]init];
    mailController.mailComposeDelegate = self;
    mailController.navigationBar.tintColor = [UIColor whiteColor];
    [mailController setSubject:@"Help & Support"];
    [mailController setToRecipients:@[@"hello@getmizu.com"]];
    [self presentViewController:mailController animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapShare:(id)sender{
    NSString *string = @"Pay like magic, get Mizu. https://getmizu.com";
    NSURL *URL = [NSURL URLWithString:@"https://getmizu.com"];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

- (IBAction)didTapLogout:(id)sender{
    
    [UIAlertView alertViewWithTitle:@"Logout" message:@"Logging out from Mizu?" cancelButtonTitle:@"No" otherButtonTitles:@[@"Log out"] onDismiss:^(int buttonIndex) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MZAnalytics trackUserAction:@"log out"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil userInfo:nil];
        });
    } onCancel:^{
        
    }];
}
@end
