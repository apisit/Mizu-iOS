//
//  MZTransactionHistoryTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 11/4/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZTransactionHistoryTableViewController.h"
#import "MZCheckInHistoryTableViewCell.h"
@interface MZTransactionHistoryTableViewController ()

//@property (nonatomic, strong) NSArray* data;
@property (nonatomic, strong) NSMutableDictionary* groupMonth;
@end

@implementation MZTransactionHistoryTableViewController
- (void)didRefresh:(id)sender{
    [self loadData];
}
- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MZUser currentUser] checkInHistories:^(NSArray *list, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil) {
                return;
            }
            self.groupMonth = [[NSMutableDictionary alloc]init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMMM YYYY"];
            for(MZCheckIn* checkIn in list){
              NSString* key = [dateFormatter stringFromDate:checkIn.createdDate];
                NSMutableArray* list = [self.groupMonth objectForKey:key];
                if (list==nil){
                    list = [[NSMutableArray alloc]init];
                }
               
                [list addObject:checkIn];
                [self.groupMonth setObject:list forKey:key];
            }
            [self.tableView reloadData];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.title = @"Transaction History";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [MZColor styleTableView:self.tableView];

    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self loadData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MZSectionHeaderView *headerView = [[MZSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [MZColor subBackgroundColor];
    headerView.separatorColor = [MZColor tableSeparatorColor];
    headerView.textColor = [MZColor subTitleColor];
    headerView.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
    NSString* key = [[self.groupMonth allKeys] objectAtIndex:section];
    headerView.title = [key uppercaseString];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupMonth.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   NSString* key = [[self.groupMonth allKeys] objectAtIndex:section];
    NSMutableArray* list = [self.groupMonth objectForKey:key];
    return list.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* key = [[self.groupMonth allKeys] objectAtIndex:indexPath.section];
    NSMutableArray* list = [self.groupMonth objectForKey:key];
    
    MZCheckIn* data = [list objectAtIndex:indexPath.row];
    if (data.feedback.comment.length>0){
        return [data.feedback.comment textHeightWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 30 font:[UIFont fontWithName:@"Avenir-Medium" size:15]] + 90;
    }
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZCheckInHistoryTableViewCell *cell = (MZCheckInHistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString* key = [[self.groupMonth allKeys] objectAtIndex:indexPath.section];
    NSMutableArray* list = [self.groupMonth objectForKey:key];
    
    MZCheckIn* checkIn = [list objectAtIndex:indexPath.row];
    cell.data = checkIn;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
