//
//  MZManagerListBusinessTableViewController.m
//  MizuManager
//
//  Created by Apisit Toompakdee on 9/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZManagerListBusinessTableViewController.h"
#import "MZBusinessTableViewCell.h"
#import "MZManagerMainTableViewController.h"
#import "AppDelegate.h"

@interface MZManagerListBusinessTableViewController ()
@property (nonatomic, strong) NSArray* data;
@end

@implementation MZManagerListBusinessTableViewController

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //load businesses that this user is manager at
    [[MZUser currentUser] myBusinesses:^(NSArray *list, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                return;
            }
            self.data = [[NSArray alloc]initWithArray:list];
            [self.tableView reloadData];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Businesses";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self loadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(didTapLogout:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 
- (IBAction)didTapLogout:(id)sender{
    [[MZUser currentUser] logout];
    UINavigationController *initialViewController = [UIStoryboard login];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = initialViewController;
    [appDelegate.window makeKeyAndVisible];
    initialViewController.view.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        initialViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 225.0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    MZBusinessTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if  ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
        cell.preservesSuperviewLayoutMargins = NO;
    if(cell == nil) {
        cell = [[MZBusinessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    MZBusiness* business=  [self.data objectAtIndex:indexPath.row];
    cell.data = business;
    return cell;
}
#pragma mark - tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MZBusiness* business=  [self.data objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"business" sender:business];
}

#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"business"]){
        MZManagerMainTableViewController* vc = segue.destinationViewController;
        vc.selectedBusiness = (MZBusiness*)sender;
    }
}

@end
