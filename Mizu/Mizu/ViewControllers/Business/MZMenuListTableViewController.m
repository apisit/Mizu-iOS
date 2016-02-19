//
//  MZMenuListTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZMenuListTableViewController.h"
#import "MZAppDelegate.h"
#import "MZSectionTableViewController.h"
#import "MZMenuListTableViewCell.h"
#import "MZMenuViewController.h"
#import "MZBusinessDetailTableViewController.h"
@interface MZMenuListTableViewController ()

@end

@implementation MZMenuListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* screenName = [NSString stringWithFormat:@"Menu List"];
    self.title = self.selectedBusiness.name;
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    self.title = self.selectedBusiness.name;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"info"] style:UIBarButtonItemStyleDone target:self action:@selector(didTapInfo:)];
}

- (void)didTapInfo:(id)sender{
   MZBusinessDetailTableViewController* vc = [UIStoryboard businessDetail];
    vc.selectedBusiness = self.selectedBusiness;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZMenuListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MZMenu* menu = [self.data objectAtIndex:indexPath.row];
    cell.data = menu;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 150.0;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MZMenu* menu = [self.data objectAtIndex:indexPath.row];
    if (menu.sections.count==1){
        [self performSegueWithIdentifier:@"onesection" sender:indexPath];
        return;
    }
    [self performSegueWithIdentifier:@"section" sender:indexPath];
}

#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"section"]){
        MZSectionTableViewController* vc = (MZSectionTableViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        MZMenu* menu = [self.data objectAtIndex:indexPath.row];
        vc.selectedMenu = menu;
        vc.selectedBusiness = self.selectedBusiness;
        //track menu view
        NSString* viewMenu = [NSString stringWithFormat:@"View sections in %@",menu.name];
        [MZAnalytics trackBusiness:self.selectedBusiness.name action:viewMenu];
    }else if ([segue.identifier isEqualToString:@"onemenu"]){
        MZSectionTableViewController* vc = (MZSectionTableViewController*)segue.destinationViewController;
        MZMenu* menu = sender;
        vc.selectedMenu = menu;
        vc.selectedBusiness = self.selectedBusiness;
        NSString* viewMenu = [NSString stringWithFormat:@"View sections in %@",menu.name];
        [MZAnalytics trackBusiness:self.selectedBusiness.name action:viewMenu];
    } else if ([segue.identifier isEqualToString:@"onesection"]){
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        MZMenu* menu = [self.data objectAtIndex:indexPath.row];
        MZMenuSection* section = [menu.sections firstObject];
        MZMenuViewController* vc = (MZMenuViewController*)segue.destinationViewController;
        vc.selectedBusiness = self.selectedBusiness;
        vc.selectedSection = section;
        NSString* action = [NSString stringWithFormat:@"View items in %@",section.name];
        [MZAnalytics trackBusiness:self.selectedBusiness.name action:action];
    }
}
@end
