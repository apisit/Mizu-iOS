//
//  MZRecieptTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZRecieptTableViewController.h"
#import "MZBusinessTableViewCell.h"
@interface MZRecieptTableViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) MZBusiness* selectedBusiness;
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UIImageView* headerGradientImageView;

@property (nonatomic, strong) UITextField* txtComment;
@property (nonatomic, strong) MZRaterView* raterView;
@property (nonatomic, strong) UIButton* btnDone;

@property (nonatomic, assign) CGFloat businessInfoCellHeight;

@end

@implementation MZRecieptTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    self.title = @"Your receipt";
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.translucent = NO;
    [MZColor styleTableView:self.tableView];
    self.businessInfoCellHeight = 130.0;
    
    //    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    //    [df setDateStyle:NSDateFormatterFullStyle];
    //    [df setTimeStyle:NSDateFormatterShortStyle];
    //    NSString* checkedDate = [df stringFromDate:self.checkIn.transaction.createdDate];
    //    self.navigationItem.prompt = checkedDate;
    
    self.selectedBusiness = self.checkIn.business;
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Datasource
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MZSectionHeaderView *headerView = [[MZSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [MZColor subBackgroundColor];
    headerView.separatorColor = [MZColor tableSeparatorColor];
    headerView.textColor = [MZColor subTitleColor];
    if (section==1 || section==2){
        headerView.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
        NSString* title = section==1?@"RECEIPT DETAILS":@"RATE YOUR VISIT";
        headerView.title = title;
    }
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0)
        return 0;
    if (section==1)
        return 44;
    if (section==2)
        return 44;
    if (section==3){
        return [UIScreen mainScreen].bounds.size.height - ((44* 7) + self.businessInfoCellHeight + 64 + 64 + 44);
    }
    
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
        return 1;
    if (section==1)
        return 3;
    if (section==2)
        return 2;
    if (section==3)
        return 1;
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        return self.businessInfoCellHeight;
    }
    if (indexPath.section==2 && indexPath.row==0){
        return 64;
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Header";
    
    if (indexPath.section==0 && indexPath.row==0){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [MZColor styleTableViewCell:cell];
        if  ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
            cell.preservesSuperviewLayoutMargins = NO;
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        UILabel* lblTitle = (UILabel*)[cell viewWithTag:1];
        lblTitle.text = self.checkIn.transaction.formattedTotalAmount;
        UILabel* lblDetail = (UILabel*)[cell viewWithTag:2];
        lblDetail.text = [NSString stringWithFormat:@"Thank you for visiting\n%@.",self.selectedBusiness.name];
        lblDetail.textColor = [MZColor subTitleColor];
        UIImageView* restaurantImageView = (UIImageView*)[cell viewWithTag:3];
        if (self.selectedBusiness.imageUrls!=nil){
            NSString* imageUrl = [self.selectedBusiness.imageUrls firstObject];
            __block NSString* cachedName = [NSString stringWithFormat:@"business-%@-%@.jpg",self.selectedBusiness.objectId,[imageUrl lastPathComponent]];
            UIImage* image = [UIImage imageFromCacheDirectory:cachedName];
            if (image!=nil){
                dispatch_async(dispatch_get_main_queue(), ^ {
                    restaurantImageView.image = image;
                });
            }else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
                    NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                        UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                        if (downloadedImage!=nil){
                            dispatch_async(dispatch_get_main_queue(), ^ {
                                [downloadedImage saveToCacheDirectory:cachedName];
                                restaurantImageView.image = downloadedImage;
                            });
                        }
                    }];
                    [getImageTask resume];
                });
            }
        }
        return cell;
    }
    
    //SubTotal
    if (indexPath.section==1 && indexPath.row==0){
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"SubTotal"];
        [MZColor styleTableViewCell:cell];
        UILabel* lbl = (UILabel*)[cell viewWithTag:1];
        lbl.text = self.checkIn.transaction.formattedAmount;
        
        return cell;
    }
    //Tip
    if (indexPath.section==1 && indexPath.row==1){
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"Tip"];
        [MZColor styleTableViewCell:cell];
        UILabel* lbl = (UILabel*)[cell viewWithTag:1];
        lbl.text = self.checkIn.transaction.formattedTipAmount;
        
        UILabel* lblTipTitle = (UILabel*)[cell viewWithTag:2];
        lblTipTitle.text = [NSString stringWithFormat:@"Tip @ %.1f%@",(double)self.checkIn.transaction.tipPercent,@"%"];
        return cell;
    }
    //Total
    if (indexPath.section==1 && indexPath.row==2){
        
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"Total"];
        [MZColor styleTableViewCell:cell];
        UILabel* lbl = (UILabel*)[cell viewWithTag:1];
        lbl.text = self.checkIn.transaction.formattedTotalAmount;
        
        return cell;
    }
    //rating
    if (indexPath.section==2 && indexPath.row==0){
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"Rating"];
        UIButton* btn = (UIButton*)[cell viewWithTag:3];
        [btn removeTarget:self action:@selector(didTapDone:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(didTapDone:) forControlEvents:UIControlEventTouchUpInside];
        self.raterView = (MZRaterView*)[cell viewWithTag:1];
        [self.raterView didRate:^(double rate) {
            
        }];
        [MZColor styleTableViewCell:cell];
        return cell;
    }
    
    //Comment
    if (indexPath.section==2 && indexPath.row==1){
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"Comment"];
        cell.separatorInset = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0);
        self.txtComment = (UITextField*)[cell viewWithTag:1];
        self.txtComment.delegate = self;
        [MZColor styleTableViewCell:cell];
        return cell;
    }
    
    //submit button
    if (indexPath.section==3 && indexPath.row==0){
        UITableViewCell* cell =[self.tableView dequeueReusableCellWithIdentifier:@"Submit"];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        [MZColor styleTableViewCell:cell];
        return cell;
    }
    return nil;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3){
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==3 && indexPath.row==0){
        [self didTapDone:nil];
    }
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
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]) {
        
        return NO;
        
    } else {
        
        return YES;
        
    }
}

#pragma mark -
- (void)submitFeedback:(NSInteger)rating comment:(NSString*)comment{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.checkIn.feedback submitFeedback:rating comment:comment block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                [UIAlertView alertViewWithTitle:@"Error while trying to give feedback" message:error.localizedDescription];
                return;
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        });
    }];
}

-(IBAction)didTapDone:(id)sender{
    NSInteger rating = self.raterView.rate;
    if (rating==0){
        return;
    }
    NSString* comment = [self.txtComment.text trim];
    if ([comment isEqualToString:@"Add comment (optional)"]){
        comment = @"";
    }
    [self.txtComment resignFirstResponder];
    if (rating<=3 && comment.length==0){
        NSString* cancelTitle = [NSString stringWithFormat:@"Just star%@",rating>1?@"s":@"" ];
        NSString* message = [NSString stringWithFormat:@"Would you mind telling %@ how they can improve their service?",self.selectedBusiness.name];
        [UIAlertView alertViewWithTitle:@"Your feedback matters" message:message cancelButtonTitle:cancelTitle otherButtonTitles:@[@"Write feedback"] onDismiss:^(int buttonIndex) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.txtComment becomeFirstResponder];
            });
        } onCancel:^{
            [self submitFeedback:rating comment:comment];
        }];
        return;
    }
    [self submitFeedback:rating comment:comment];
}

#pragma mark - text field delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtComment resignFirstResponder];
    return YES;
}
@end
