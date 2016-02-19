//
//  MZCurrentCheckInTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZCurrentCheckInTableViewController.h"
#import "MZBusinessWithMizuPayTableViewCell.h"
#import "MZRecieptTableViewController.h"
@interface MZCurrentCheckInTableViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) MZBusiness* selectedBusiness;
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UIVisualEffectView* headerGradientImageView;

@property (nonatomic, assign) CGFloat businessInfoCellHeight;
@property (nonatomic) __block __weak id observerChecked;
@property (nonatomic, strong) UIRefreshControl* refreshCheckIn;

@property (nonatomic, strong) NSMutableArray* tipSettings;

@end

@implementation MZCurrentCheckInTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MZColor styleTableView:self.tableView];
    self.tipSettings = [[NSMutableArray alloc]initWithObjects:@0,@5,@10,@15,@20, nil];
    self.observerChecked = [[NSNotificationCenter defaultCenter] addObserverForName:@"checked" object:nil queue:nil usingBlock:^(NSNotification *note) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] removeObserver:self.observerChecked name:@"checked" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    self.refreshCheckIn  = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshCheckIn];
    
    [self.refreshCheckIn addTarget:self action:@selector(didRefreshCheckIn:) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.hidesBackButton = YES;
    self.selectedBusiness = self.checkIn.business;
    self.businessInfoCellHeight = 130;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"You are checked-in";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRefreshCheckIn:) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.refreshCheckIn.superview sendSubviewToBack:self.refreshCheckIn];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Datasource


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MZSectionHeaderView *headerView = [[MZSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [MZColor subBackgroundColor];
    headerView.separatorColor = [MZColor tableSeparatorColor];
    headerView.textColor = [MZColor subTitleColor];
    if (section==1){
        headerView.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
        headerView.title = @"PAYMENT DETAILS";
    }
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0)
        return 0;
    if (section==1)
        return 44;
    if (section==2){
        return [UIScreen mainScreen].bounds.size.height - ((44* 5) + self.businessInfoCellHeight + 64 + 44);
    }
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
        return 1;
    if (section==1)
        return 3;
    if (section==2)
        return 1;
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        return self.businessInfoCellHeight;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Business";
    
    if (indexPath.section==0 && indexPath.row==0){
        MZBusinessWithMizuPayTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if  ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
            cell.preservesSuperviewLayoutMargins = NO;
        if(cell == nil) {
            cell = [[MZBusinessWithMizuPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [MZColor styleTableViewCell:cell];
        
        cell.data = self.selectedBusiness;
        cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        UILabel* lblDetail = (UILabel*)[cell viewWithTag:2];
        lblDetail.textColor = [MZColor subTitleColor];
        return cell;
    }
    //Name
    if (indexPath.section==1 && indexPath.row==0){
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"Name"];
        [MZColor styleTableViewCell:cell];
        UILabel* lbl = (UILabel*)[cell viewWithTag:1];
        lbl.text = self.checkIn.card.name;
        lbl.textColor = [MZColor subTitleColor];
        return cell;
    }
    //Card
    if (indexPath.section==1 && indexPath.row==1){
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"Card"];
        
        UILabel* lbl = (UILabel*)[cell viewWithTag:1];
        lbl.text = self.checkIn.card.cardBrandWithLast4;
        lbl.textColor = [MZColor subTitleColor];
        [MZColor styleTableViewCell:cell];
        return cell;
    }
    //Tip
    if (indexPath.section==1 && indexPath.row==2){
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"Tip"];
        [MZColor styleTableViewCell:cell];
        UILabel* lbl = (UILabel*)[cell viewWithTag:1];
        if (self.checkIn.user.defaultTipPercent>0){
            lbl.text = [NSString stringWithFormat:@"%.1f%@",(double)self.checkIn.user.defaultTipPercent,@"%"];
        }else{
            lbl.text = @"No tip";
        }
        lbl.textColor = [MZColor subTitleColor];
        return cell;
    }
    //Cancel button
    if (indexPath.section==2 && indexPath.row==0){
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"cancel"];
        [MZColor styleTableViewCell:cell];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

        return cell;
    }
    
    return nil;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1 && indexPath.row==2){
        return YES;
    }
    
    if (indexPath.section==2 || indexPath.section==3){
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section==1 && indexPath.row==2){
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"Tip amount" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: nil];
        
        for(NSNumber* tip in self.tipSettings){
            if ([tip doubleValue]==0){
                [actionSheet addButtonWithTitle:@"No tip"];
            }else{
                [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%.1f%@",[tip doubleValue],@"%"]];
            }
        }
        
        [actionSheet showInView:self.view];
//    }else if (indexPath.section==2 && indexPath.row==0){
//        [self didTapBrowseMenu:nil];
//    }
    }else if (indexPath.section==2 && indexPath.row==0){
        [self didTapCancel:nil];
    }
}
#pragma mark - action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0){
        return;
    }
    double defaultTipPercent = [[self.tipSettings objectAtIndex:buttonIndex-1] doubleValue];
    
    [[MZUser currentUser] updateDefaultTipPercentForRecentCheckIn:defaultTipPercent block:^(id object, NSError *error) {
        if (error!=nil){
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.checkIn.user = object;
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - scroll
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //Hold the initial the scrollView y value
    float offsetY = scrollView.contentOffset.y;
    CGRect frame = self.headerImageView.frame;
    
    //Perform the Stretching action here
    if (offsetY < 0) {
        frame.origin.y =  offsetY;
        frame.size.height = self.businessInfoCellHeight + (offsetY*-1);
    }
    //Reset it to the Original Position
    else {
        frame.origin.y = offsetY;
        frame.size.height = self.businessInfoCellHeight - (offsetY);
    }
    
    //Set the frame of UIImageView
    self.headerImageView.frame = frame;
    self.headerGradientImageView.frame = frame;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]) {
        
        return NO;
        
    } else {
        
        return YES;
        
    }
}

#pragma mark -
- (IBAction)didRefreshCheckIn:(id)sender{
    
    [[MZUser currentUser] recentCheckInWithBlock:^(id object, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshCheckIn endRefreshing];
        });
        
        if (error!=nil){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MZCheckIn* checkIn = (MZCheckIn*)object;
            if (checkIn.objectId==nil){
                return;
            }
            if (checkIn.checked==YES){
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
                UINavigationController* nav = [UIStoryboard receipt];
                MZRecieptTableViewController* vc = [nav.viewControllers firstObject];
                vc.checkIn = checkIn;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        });
    }];
    
}


#pragma mark -
-(IBAction)didTapCancel:(id)sender{
    NSString* message = [NSString stringWithFormat:@"Please confirm that you would like to cancel your check-in at %@?",self.selectedBusiness.name];
    
    [UIAlertView alertViewWithTitle:@"Cancel Check-In" message:message cancelButtonTitle:@"No" otherButtonTitles:@[@"Cancel Now"] onDismiss:^(int buttonIndex) {
        [[MZUser currentUser] cancelRecentCheckInWithBlock:^(id object, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    } onCancel:^{
        
    }];
}

- (IBAction)didTapBrowseMenu:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.selectedBusiness menusWithBlock:^(NSArray *list, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MZAnalytics trackBusiness:self.selectedBusiness.name action:@"View Menus"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error){
                return;
            }
            
            NSArray* data = [NSArray arrayWithArray:list];
            UIViewController* vc = [UIStoryboard menuScreen:data business:self.selectedBusiness];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
    
}

@end
