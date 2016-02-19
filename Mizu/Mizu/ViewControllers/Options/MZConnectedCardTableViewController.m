//
//  MZConnectedCardTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 10/30/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZConnectedCardTableViewController.h"

@interface MZConnectedCardTableViewController ()

@property (nonatomic, strong) IBOutlet UILabel* lblName;
@property (nonatomic, strong) IBOutlet UILabel* lblCardnumber;
@property (nonatomic, strong) IBOutlet UILabel* lblExp;
@property (nonatomic, strong) MZCard* defaultCard;
@end

@implementation MZConnectedCardTableViewController

- (void)loadData{
    if (self.skipLoading==YES){
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MZUser currentUser] getDefaultCard:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                self.tableView.delegate = nil;
                self.tableView.dataSource = nil;
                return;
            }
            
            self.defaultCard = object;
            if ( self.defaultCard.last4==nil){
//                [UIAlertView alertViewWithTitle:@"Add new card" message:@"Please add a credit or debit card to your Mizu account." cancelButtonTitle:@"Later" otherButtonTitles:@[@"Add one"] onDismiss:^(int buttonIndex) {
//                    [self didTapAdd:nil];
//                } onCancel:^{
//                    
//                }];
                return;
            }
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.lblName.text = self.defaultCard.name;
            self.lblName.textColor = [MZColor subTitleColor];
            self.lblCardnumber.text = self.defaultCard.cardBrandWithLast4;
            self.lblCardnumber.textColor = [MZColor subTitleColor];
            self.lblExp.text = [NSString stringWithFormat:@"%@/%@",self.defaultCard.expMonth,self.defaultCard.expYear];
            self.lblExp.textColor = [MZColor subTitleColor];
            
            
        });
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Payment";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView.allowsSelection = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAdd:)];
    [MZColor styleTableView:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (IBAction)didTapAdd:(id)sender{
    [self performSegueWithIdentifier:@"new" sender:nil];
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MZSectionHeaderView *headerView = [[MZSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [MZColor subBackgroundColor];
    headerView.separatorColor = [MZColor tableSeparatorColor];
    headerView.textColor = [MZColor subTitleColor];
    headerView.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
    if (section==0){
        headerView.title = @"CONNECTED CARD";
    }
    
    return headerView;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2){
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==2){
        NSString* message = [NSString stringWithFormat:@"Remove %@?",self.defaultCard.cardBrandWithLast4];
        [UIAlertView alertViewWithTitle:@"Remove card" message:message cancelButtonTitle:@"Later" otherButtonTitles:@[@"Remove"] onDismiss:^(int buttonIndex) {
            [self removeCard];
        } onCancel:^{
            
        }];
    }
}

#pragma mark -
-(void)removeCard{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MZUser currentUser] removeCard:self.defaultCard block:^(BOOL valid, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                return;
            }
            self.defaultCard = nil;
            self.tableView.delegate = nil;
            self.tableView.dataSource = nil;
            [self.tableView reloadData];
            [self loadData];
        });
    }];
}

@end
