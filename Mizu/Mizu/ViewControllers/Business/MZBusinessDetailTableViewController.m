//
//  MZBusinessDetailTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/25/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZBusinessDetailTableViewController.h"
#import "MZBusinessTableViewCell.h"
@interface MZBusinessDetailTableViewController()

@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UIImageView* headerGradientImageView;



@end

@implementation MZBusinessDetailTableViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    self.title = self.selectedBusiness.name;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    self.tableView.tableFooterView = footerView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)didTapBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedBusiness.socials!=nil){
        return 3 + self.selectedBusiness.socials.count;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0){
        return 225.0;
    }
    
    if (self.selectedBusiness.phone==nil || self.selectedBusiness.phone.length==0){
        
    }
    
    if (indexPath.row==1){
        if (self.selectedBusiness.phone==nil || self.selectedBusiness.phone.length==0)
            return 0;
        return 50;
    }
    
    if (indexPath.row==2){
        NSInteger rowCount =  self.selectedBusiness.businessHours.count;
        if (self.selectedBusiness.isOpen24hours){
            return 50;
        }
        return rowCount * 25;
    }
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    if (indexPath.row==0){
        MZBusinessTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if  ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
            cell.preservesSuperviewLayoutMargins = NO;
        if(cell == nil) {
            cell = [[MZBusinessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.data = self.selectedBusiness;
        cell.btnMoreInfo.hidden= YES;
        cell.hourDescription.hidden = YES;
        cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        self.headerImageView = cell.restaurantImageView;
        self.headerGradientImageView = cell.gradientImageView;
        return cell;
    }
    
    //phone number
    if (indexPath.row==1){
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"Phone"];
        UILabel* lblPhoneNumber = (UILabel*)[cell viewWithTag:1];
        if (self.selectedBusiness.phone.length>0)
            lblPhoneNumber.text = self.selectedBusiness.phone;
        else{
            lblPhoneNumber.text = @"-";
            cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        }
        return cell;
    }
    if (indexPath.row==2){
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"businessHours"];
        UILabel* lblDay = (UILabel*)[cell viewWithTag:1];
        UILabel* lblHour = (UILabel*)[cell viewWithTag:2];
        
        if (self.selectedBusiness.isOpen24hours){
            lblDay.text = self.selectedBusiness.hourDescription;
        }else{
            lblDay.text = self.selectedBusiness.dayListISO8601WithStyle;
            lblHour.text = self.selectedBusiness.hourListISO8601WithStyle;
        }
        
        if (self.selectedBusiness.socials==nil || self.selectedBusiness.socials.count==0){
            cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        }
        return cell;
    }
    
    if (indexPath.row>2){
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"social"];
        UILabel* lblSocial = (UILabel*)[cell viewWithTag:1];
        UIImageView* socialImageView = (UIImageView*)[cell viewWithTag:2];
        NSInteger index = indexPath.row-3;
        MZBusinessSocial* social = [self.selectedBusiness.socials objectAtIndex:index];
        
        lblSocial.text = social.title;
        
        NSString* imageName = [NSString stringWithFormat:@"profile_%@.png",[social.name lowercaseString]];
        socialImageView.image = [UIImage imageNamed:imageName];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableView Delegate methods
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    if (indexPath.row>2){
        return YES;
    }
    
    return indexPath.row==1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==1){
        if (self.selectedBusiness.phone.length>0){
            
            if (self.selectedBusiness.isOpenToday){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.selectedBusiness.phone]]];
            }else{
                NSString* message = [NSString stringWithFormat:@"Looks like %@ is currently closed.",self.selectedBusiness.name];
                [UIAlertView alertViewWithTitle:message message:@"Do you still want to call?" cancelButtonTitle:@"Later" otherButtonTitles:@[@"Call now"] onDismiss:^(int buttonIndex) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.selectedBusiness.phone]]];
                } onCancel:^{
                    
                }];
            }
            
        }
    }
    
    if (indexPath.row>2){
        NSInteger index = indexPath.row-3;
        MZBusinessSocial* social = [self.selectedBusiness.socials objectAtIndex:index];
        NSString* url = [NSString stringWithFormat:@"%@",social.url];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //Hold the initial the scrollView y value
    float offsetY = scrollView.contentOffset.y;
    CGRect frame = self.headerImageView.frame;
    
    //Perform the Stretching action here
    if (offsetY < 0) {
        frame.origin.y =  offsetY;
        frame.size.height = 225 + (offsetY*-1);
    }
    //Reset it to the Original Position
    else {
        frame.origin.y = offsetY;
        frame.size.height = 225 - (offsetY);
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
@end
