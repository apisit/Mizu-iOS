//
//  MZManagerCurrentCheckInTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 9/4/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZManagerCurrentCheckInTableViewController.h"
#import "MZManagerCheckInDetailTableViewController.h"
#import "MZManagerCheckInTableViewCell.h"
@interface MZManagerCurrentCheckInTableViewController ()

@property (nonatomic, strong) NSArray* data;
@property (nonatomic, strong) NSTimer* timer;


@end

@implementation MZManagerCurrentCheckInTableViewController

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.selectedBusiness currentCheckIns:^(NSArray *list, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.refreshControl endRefreshing];
            if (error!=nil){
                return;
            }
            self.data = [NSArray arrayWithArray:list];
            [self.tableView reloadData];
        });
        
    }];
}

- (void)timeToRefresh:(id)sender{
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    self.title = @"Current Check-ins";
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    self.tableView.tableFooterView = footerView;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
   
   // [self.timer fire];
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
     self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timeToRefresh:) userInfo:nil repeats:YES];
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
 MZCheckIn* checkIn = [self.data objectAtIndex:indexPath.row];
    if (checkIn.note !=nil ){
        return [checkIn.note textHeightWithMaxWidth: [UIScreen mainScreen].bounds.size.width - 48-15 font:[UIFont fontWithName:@"Avenir-Medium" size:15]] + 68;
    }
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MZCheckIn* checkIn = [self.data objectAtIndex:indexPath.row];
    
    MZManagerCheckInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkin" forIndexPath:indexPath];
    cell.data = checkIn;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MZCheckIn* checkIn = [self.data objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"checkInDetail" sender:checkIn];
}

#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"checkInDetail"]){
        MZManagerCheckInDetailTableViewController* vc = segue.destinationViewController;
        vc.selectedCheckIn = (MZCheckIn*)sender;
    }
}
@end
