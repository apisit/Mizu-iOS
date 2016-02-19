//
//  MZManagerPaymentHistoryTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 9/10/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZManagerPaymentHistoryTableViewController.h"
#import "MZManagerCheckInTableViewCell.h"
#import "MZManagerPaymentHistoryDetailTableViewController.h"
@interface MZManagerPaymentHistoryTableViewController ()

@property (nonatomic, strong) NSArray* data;

@end

@implementation MZManagerPaymentHistoryTableViewController

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.selectedBusiness checkInHistories:^(NSArray *list, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                return;
            }
            self.data = [NSArray arrayWithArray:list];
            [self.tableView reloadData];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    self.title = @"Payment History";
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    self.tableView.tableFooterView = footerView;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
- (IBAction)didRefresh:(id)sender{
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MZCheckIn* data = [self.data objectAtIndex:indexPath.row];
    if (data.feedback.comment.length>0){
        return [data.feedback.comment textHeightWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 30 font:[UIFont fontWithName:@"Avenir-Medium" size:15]] + 90;
    }
    return 88;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MZCheckIn* checkIn = [self.data objectAtIndex:indexPath.row];
    MZManagerCheckInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.data = checkIn;
    
    //SHOW FAILED TRANSACTION PROPERLY
    if (checkIn.transaction.chargeSucceeded == NO){
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MZCheckIn* checkIn = [self.data objectAtIndex:indexPath.row];
    if (checkIn.isCanceled)
        return;
    [self performSegueWithIdentifier:@"historyDetail" sender:checkIn];
}

#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"historyDetail"]){
        MZManagerPaymentHistoryDetailTableViewController* vc = segue.destinationViewController;
        vc.selectedCheckIn = (MZCheckIn*)sender;
    }
}
@end
