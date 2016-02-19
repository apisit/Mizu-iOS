//
//  MZMenuViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/3/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZMenuViewController.h"
#import "MZItemTableViewCell.h"
#import "MZMenuSectionView.h"
#import "MZCommentViewController.h"
#import "MZBusinessDetailTableViewController.h"
@interface MZMenuViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary* selectedItem;
@property (nonatomic,strong) NSMutableDictionary* cachedCellHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reviewConstraint;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *lblSectionDetail;

@end

@implementation MZMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* screenName = [NSString stringWithFormat:@"Menu Items"];
    self.screenName = screenName;
    //track section name.
    NSString* action = [NSString stringWithFormat:@"Viewed items in section : %@",self.selectedSection.name];
    [MZAnalytics trackBusiness:self.selectedBusiness.name action:action];
    self.navigationItem.hidesBackButton = NO;
    self.title = self.selectedSection.name;
    
    if (self.selectedSection.detail!=nil){
        self.lblSectionDetail.text = self.selectedSection.detail;
        self.lblSectionDetail.layer.cornerRadius = 4;
        self.lblSectionDetail.clipsToBounds = YES;
        CGRect textSize = [self.selectedSection.detail boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lblSectionDetail.font} context:nil];
        CGFloat height = textSize.size.height;
        CGRect rect = self.headerView.frame;
        rect.size.height = height + 24;
        self.headerView.frame = rect;
    }else{
        self.tableView.tableHeaderView = nil;
        [self.headerView setHidden:YES];
    }
    
    self.cachedCellHeight = [[NSMutableDictionary alloc]init];
    self.summaryContainer.layer.cornerRadius = 5;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = NO;
    self.tableView.editing = NO;
    self.tableView.allowsSelection = YES;
    self.selectedItem = [[NSMutableDictionary alloc]init];
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.reviewOrderContainer.frame.size.height)];
    self.tableView.tableFooterView = footerView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"info"] style:UIBarButtonItemStyleDone target:self action:@selector(didTapInfo:)];
}

- (void)didTapInfo:(id)sender{
    MZBusinessDetailTableViewController* vc = [UIStoryboard businessDetail];
    vc.selectedBusiness = self.selectedBusiness;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - calculate total
- (void)calculateTotal{
    NSInteger count = self.tableView.indexPathsForSelectedRows.count;
    [self.reviewOrderContainer layoutIfNeeded];
    [self.reviewOrderContainer setNeedsUpdateConstraints];
    [self.reviewOrderContainer updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.reviewConstraint.constant = count==0?0:-80;
        [self.reviewOrderContainer setNeedsUpdateConstraints];
        [self.reviewOrderContainer layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    
    CGFloat total = 0;
    
    for(NSMutableArray* list in self.selectedItem.allValues){
        for(MZOrderItem* item in list){
            total +=item.price;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.lblSubtotal.alpha=0;
        self.lblSubtotal.text = [NSString stringWithFormat:@"%@%.2f",self.selectedBusiness.meta.currencySymbol,(CGFloat)(total/[self.selectedBusiness.meta.currencyFactor floatValue])];
        self.lblSubtotal.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage* image = info[UIImagePickerControllerOriginalImage];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:picker.view.tag inSection:0];
        [self performSegueWithIdentifier:@"addPicture" sender:@[image,indexPath]];
    });
}


#pragma mark - action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==2){//cancel
        [MZAnalytics trackUserAction:@"Cancel Add Item picture"];
        return;
    }
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.view.tag = actionSheet.tag;
    if (buttonIndex==0){
        [MZAnalytics trackUserAction:@"Taking Item picture"];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        [MZAnalytics trackUserAction:@"Select Item picture from library"];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:pickerController animated:YES completion:NULL];
}
#pragma mark - actions
- (IBAction)didTapAddPicture:(UIButton*)sender{
    [MZAnalytics trackUserAction:@"Add Item picture"];
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose existing Photo", nil];
    //passing indexPath.row through tag
    actionSheet.tag = sender.tag;
    [actionSheet showInView:self.view];
}
/*
 #pragma mark - check current order
 -(void)didTapCurrentOrder:(id)sender{
 
 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 [[MZUser currentUser] recentCheckIn:^(id object, NSError *error) {
 if (object!=nil){
 MZCheckIn* checkIn = object;
 [MZCurrentCheckIn sharedInstance].checkIn = checkIn;
 dispatch_async(dispatch_get_main_queue(), ^{
 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
 [self performSegueWithIdentifier:@"summary" sender:[MZCurrentCheckIn sharedInstance].checkIn.orderSummary];
 });
 
 }else if (error==nil && object==nil){
 dispatch_async(dispatch_get_main_queue(), ^{
 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
 [self.navigationController popToRootViewControllerAnimated:YES];
 });
 }
 }];
 
 }*/

#pragma mark - UITableView Datasource
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MZMenuSection* s = self.selectedSection;
    return s.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MZMenuSection* s = self.selectedSection;
    MZMenuSectionView* sectionView = [[MZMenuSectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-10, 44)];
    sectionView.title = s.name;
    sectionView.currencySymbol = self.selectedBusiness.meta.currencySymbol;
    return sectionView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MZMenuSection* s = self.selectedSection;
    MZMenuItem* item = [s.items objectAtIndex:indexPath.row];
    
    if (indexPath.row==0 && item.rank>0){
        cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
        
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
        }
    }
    
   
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    MZMenuSection* s = self.selectedSection;
    MZMenuItem* item = [s.items objectAtIndex:indexPath.row];
    
    NSNumber* cellHeight = [self.cachedCellHeight objectForKey:indexPath];
    if (cellHeight){
        return [cellHeight floatValue];
    }
    CGFloat nameHeight = 0;
    CGFloat detailHeight = 0;
    CGFloat tagHeight = 0;
    
    if (item.name){
        NSDictionary *attribs = @{};
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:item.name attributes:attribs];
        NSRange boldTextRange = [item.name rangeOfString:item.name];
        NSString* fontName = @"Avenir-Black";
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:15]} range:boldTextRange];
        /*  NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
         [paragrahStyle setLineSpacing:0.8];
         [paragrahStyle setMaximumLineHeight:18];
         NSDictionary *paragraphAttribute = @{NSParagraphStyleAttributeName : paragrahStyle,};
         [attributedText addAttributes:paragraphAttribute range:NSMakeRange(0,attributedText.length)];*/
        CGFloat width =  [UIScreen mainScreen].bounds.size.width - 128;
        CGRect textSize = [attributedText boundsForWidth:width];
        nameHeight = textSize.size.height;
    }
    
    if (item.detail && (indexPath.row!=0 || item.rank<=0)){
        NSString* itemText = item.detail;
        NSDictionary *attribs = @{};
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:itemText attributes:attribs];
        NSRange regularTextRange = [itemText rangeOfString:item.detail];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:15]} range:regularTextRange];
        /* NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
         [paragrahStyle setLineSpacing:0.8];
         [paragrahStyle setMaximumLineHeight:19];
         NSDictionary *paragraphAttribute = @{NSParagraphStyleAttributeName : paragrahStyle,};
         [attributedText addAttributes:paragraphAttribute range:NSMakeRange(0,attributedText.length)];*/
        CGFloat width =  [UIScreen mainScreen].bounds.size.width - 80;
        CGRect textSize = [attributedText boundsForWidth:width];
        detailHeight = textSize.size.height;
    }
    
    if (item.tags!=nil && item.tags.count>0){
        tagHeight = [MZTagBadgeView heightByTags:item.tags width:[UIScreen mainScreen].bounds.size.width - 80] + 5;
        NSLog(@"%f",tagHeight);
    }
    
    
    CGFloat height = nameHeight + detailHeight + tagHeight;
    height = height + 42;
    height = MAX(73, height);
    if (indexPath.row==0 && item.rank>0){
        height = height+60;
        height = MAX(230,height);
    }
    
    [self.cachedCellHeight setObject:[NSNumber numberWithFloat:height] forKey:indexPath];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MZMenuSection* s = self.selectedSection;
    MZMenuItem* item = [s.items objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier = indexPath.row==0?@"CellSuggested":@"Cell";
    
    if (item.rank<=0 && indexPath.row==0){
        cellIdentifier = @"Cell";
    }
    
    
    
    MZItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[MZItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
        cell.preservesSuperviewLayoutMargins = NO;
    
    
    
    BOOL isSuggestItem = item.rank>0.0f && indexPath.row==0;
    cell.suggestedItem = isSuggestItem;
    
    
    cell.isFullView = isSuggestItem;
    cell.inMenuScreen = YES;
    cell.btnAddPicture.tag = indexPath.row;
    cell.selectedBusiness = self.selectedBusiness;
    cell.data = item;
    if (item.imageUrls==nil){
        [cell.btnAddPicture addTarget:self action:@selector(didTapAddPicture:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}


#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"viewComment" sender:indexPath];
}

- (IBAction)didTapReviewOrder:(id)sender {
    [self performSegueWithIdentifier:@"confirm" sender:nil];
}

#pragma mark - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"viewComment"]){
        NSIndexPath* indexPath = sender;
        MZMenuSection* s = self.selectedSection;
        MZMenuItem* item = [s.items objectAtIndex:indexPath.row];
        MZCommentViewController* vc = segue.destinationViewController;
        vc.selectedMenuItem = item;
        CGFloat height = 200;
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 80;
        UIFont* font = [UIFont fontWithName:@"Avenir-Medium" size:15];
        CGFloat textHeight = [item.detail textHeightWithMaxWidth:width font:font];
        height +=textHeight;
        height = MAX(230,height);
        vc.cachedCellHeight = height;
        vc.selectedBusiness = self.selectedBusiness;
        
        [MZAnalytics trackUserAction:@"View Item comments"];
        NSString* action = [NSString stringWithFormat:@"View Item %@ Comments",item.name];
        [MZAnalytics trackBusiness:self.selectedBusiness.name action:action];
        
    }else if ([segue.identifier isEqualToString:@"addPicture"]){
        NSArray* data = sender;
        NSIndexPath* indexPath = [data objectAtIndex:1];
        UIImage* image = [data objectAtIndex:0];
        MZMenuSection* s = self.selectedSection;
        MZMenuItem* item = [s.items objectAtIndex:indexPath.row];
        MZCommentViewController* vc = segue.destinationViewController;
        vc.selectedMenuItem = item;
        CGFloat height = [[self.cachedCellHeight objectForKey:indexPath] floatValue];
        if (indexPath.row>0){
            height = height+60;
        }
        height = MAX(230,height);
        vc.cachedCellHeight = height;
        vc.selectedBusiness = self.selectedBusiness;
        [vc showSelectedImage:image];
        
        [MZAnalytics trackUserAction:@"Adding Item Picture from Menu Screen"];
        NSString* action = [NSString stringWithFormat:@"Adding Picture to item %@",item.name];
        [MZAnalytics trackBusiness:self.selectedBusiness.name action:action];
    }
}

@end
