//
//  MZSectionTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 3/1/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZSectionTableViewController.h"
#import "MZSectionTableViewCell.h"
#import "MZMenuViewController.h"
#import "MZAppDelegate.h"
#import "MZBusinessDetailTableViewController.h"

@interface MZSectionTableViewController ()


@end

@implementation MZSectionTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* screenName = [NSString stringWithFormat:@"Menu Sections"];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    self.title = self.selectedMenu.name;
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
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MZMenu* menu = self.selectedMenu;
    return menu.sections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MZMenu* menu = self.selectedMenu;
    MZMenuSection* section = [menu.sections objectAtIndex:indexPath.row];
    cell.data = section;
    
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
    [self performSegueWithIdentifier:@"item" sender:indexPath];
}

#pragma mark -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"item"]){
        MZMenuViewController* vc = (MZMenuViewController*)segue.destinationViewController;
        MZMenu* menu = self.selectedMenu;
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        MZMenuSection* section = [menu.sections objectAtIndex:indexPath.row];
        vc.selectedSection = section; 
        vc.selectedBusiness = self.selectedBusiness;
        //track section view
        NSString* viewSection = [NSString stringWithFormat:@"View items in %@",section.name];
        [MZAnalytics trackBusiness:self.selectedBusiness.name action:viewSection];
    }
}


@end
