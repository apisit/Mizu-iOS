//
//  MZCommentViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 2/7/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZCommentViewController.h"
#import "MZItemTableViewCell.h"
#import "MZCommentTableViewCell.h"
#import "MZCommentDetailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MZCommentViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) NSMutableArray* comments;
@property (nonatomic, strong) UIButton* btnLoadMoreComments;
@property (nonatomic, strong) MZDeleteButton* btnDeleteImage;
@property (nonatomic,strong) NSMutableDictionary* cachedCommentCellHeight;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
//@property (nonatomic, strong) NSArray* searchResult;
//@property (nonatomic, strong) NSMutableArray* itemList;
@end

@implementation MZCommentViewController

-(UIButton *)btnLoadMoreComments{
    if (_btnLoadMoreComments!=nil){
        return _btnLoadMoreComments;
    }
    _btnLoadMoreComments = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    [_btnLoadMoreComments setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnLoadMoreComments setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    _btnLoadMoreComments.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:14.0];
    [_btnLoadMoreComments setTitle:@"Load more comments" forState:UIControlStateNormal];
    [_btnLoadMoreComments addTarget:self action:@selector(loadMoreComment:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLoadMoreComments setTintColor:[UIColor darkGrayColor]];
    return _btnLoadMoreComments;
}

-(UIImageView *)imageViewForSelectedImage{
    if (_imageViewForSelectedImage){
        return _imageViewForSelectedImage;
    }
    
    CGRect rect = CGRectMake(7, 8, 50, 50);
    _imageViewForSelectedImage = [[UIImageView alloc]initWithFrame:rect];
    _imageViewForSelectedImage.layer.cornerRadius = 4;
    _imageViewForSelectedImage.clipsToBounds = YES;
    _imageViewForSelectedImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.textView addSubview:self.imageViewForSelectedImage];
    self.btnDeleteImage = [[MZDeleteButton alloc]initWithFrame:CGRectMake(39, 2, 25, 25)];
    [self.textView addSubview:self.btnDeleteImage];
    [self.btnDeleteImage setHidden:YES];
    [self.btnDeleteImage addTarget:self action:@selector(didTapDeleteImage:) forControlEvents:UIControlEventTouchUpInside];
    return _imageViewForSelectedImage;
}



+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSString* screenName = [NSString stringWithFormat:@"Comments"];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //auto completion part
    /*  self.itemList = [[NSMutableArray alloc]init];
     for(MZMenu* menu in self.selectedBusiness.menus){
     for(MZMenuSection* section in menu.sections){
     for(MZMenuItem* item in section.items){
     [self.itemList addObject:item];
     }
     }
     }
     [self registerPrefixesForAutoCompletion:@[@"@"]];
     [self.autoCompletionView registerClass:[MZItemTableViewCell class] forCellReuseIdentifier:@"Cell"];*/
    
    self.title = NSLocalizedString(@"Comments", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Share" style:UIBarButtonItemStyleDone target:self action:@selector(didTapShare:)];
    
    self.refreshControl  = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.cachedCommentCellHeight = [[NSMutableDictionary alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"MZItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MZCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"Comment"];
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    
    [self.leftButton setImage:[UIImage imageNamed:@"cameraIcon"] forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor lightGrayColor]];
    
    
    self.inverted = NO;
    self.textInputbar.autoHideRightButton = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.allowsSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.textView.placeholder = @"Write a comment...";
    self.textView.textColor = [UIColor darkGrayColor];
    self.rightButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:16];
    self.textView.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    
    [self loadData:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //post notifiation to liked item page to remove from the list
    if (self.selectedMenuItem.userLiked==NO){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unlikeItemFromItemDetailPage" object:self.selectedMenuItem];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - refresh data
- (void)loadMoreComment:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    MZActivity* lastComment = [self.comments lastObject];
    [MZActivity commentsByBusiness:self.selectedBusiness item:self.selectedMenuItem lastId:lastComment.objectId block:^(NSArray *list, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error){
                return;
            }
            [self.comments addObjectsFromArray:list];
            [self.tableView reloadData];
            if (self.comments.count<self.selectedMenuItem.commentCount){
                self.tableView.tableFooterView = self.btnLoadMoreComments;
            }else{
                self.tableView.tableFooterView = nil;
            }
        });
    }];
}

- (void)loadData:(id)sender{
    [self.selectedMenuItem refreshWithBlock:^(MZMenuItem* object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MZItemTableViewCell* cell = (MZItemTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell updateLikeCount];
            
            if (error!=nil){
                return;
            }
            self.selectedMenuItem.likeCount = object.likeCount;
            self.selectedMenuItem.commentCount = object.commentCount;
            self.selectedMenuItem.userLiked = object.userLiked;
            self.selectedMenuItem.imageUrls = object.imageUrls;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            if (self.selectedMenuItem.commentCount==0){
                self.textView.placeholder = @"Be the first to comment...";
            }
        });
    }];
    
    [MZActivity commentsByBusiness:self.selectedBusiness item:self.selectedMenuItem lastId:nil block:^(NSArray *list, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error){
                return;
            }
            self.comments = [[NSMutableArray alloc]initWithArray:list];
            [self.tableView reloadData];
            if (self.comments.count<self.selectedMenuItem.commentCount){
                self.tableView.tableFooterView = self.btnLoadMoreComments;
            }
        });
    }];
}

#pragma mark - show selected image
-(void)showSelectedImage:(UIImage *)image{
    CGRect bound = CGRectMake(0, 0, 400, 400);
    CGRect resizeRect =  AVMakeRectWithAspectRatioInsideRect(image.size, bound);
    image = [image scaleImageToSize:resizeRect.size];
    self.selectedImage = image;
    UIImage* thumbnail = self.selectedImage;
    self.imageViewForSelectedImage.image = thumbnail;
    UIEdgeInsets inset = self.textView.textContainerInset;
    inset.top = 65;
    self.textView.textContainerInset = inset;
    [self.btnDeleteImage setHidden:NO];
    [self.imageViewForSelectedImage setHidden:NO];
    //the trick to set height of this textview again.
    [self.textView insertText:@""];
}

#pragma mark - action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==2){//cancel
        [MZAnalytics trackUserAction:@"Canceled Selecting Photo to comment"];
        return;
    }
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    if (buttonIndex==0){
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [MZAnalytics trackUserAction:@"Selecting Photo to comment from Camera"];
    }else{
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [MZAnalytics trackUserAction:@"Selecting Photo to comment from Library"];
    }
    [self presentViewController:pickerController animated:YES completion:NULL];
}

#pragma mark - UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage* image = info[UIImagePickerControllerOriginalImage];
        
        [self showSelectedImage:image];
    });
}

- (void)removeSelectedImage{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selectedImage = nil;
        self.imageViewForSelectedImage.image = nil;
        [self.btnDeleteImage setHidden:YES];
        [self.imageViewForSelectedImage setHidden:YES];
        UIEdgeInsets inset = self.textView.textContainerInset;
        inset.top = 8;
        self.textView.textContainerInset = inset;
        [self.textView refreshFirstResponder];
        [self.textView insertText:@""];
    });
}

#pragma mark - delete image button
- (void)didTapDeleteImage:(id)sender{
    [UIAlertView alertViewWithTitle:@"Delete an image?" message:@"" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Delete"] onDismiss:^(int buttonIndex) {
        [self removeSelectedImage];
    } onCancel:^{
        
    }];
}



#pragma mark - slack textview controller
//- (CGFloat)heightForAutoCompletionView
//{
//    CGFloat cellHeight = 34.0;
//    return cellHeight*self.searchResult.count;
//}

-(BOOL)canShowAutoCompletion{
    return NO;
    /*   NSString *prefix = self.foundPrefix;
     NSString *word = self.foundWord;
     NSArray* array = nil;
     
     if ([prefix isEqualToString:@"@"])
     {
     if (word.length > 0) {
     array = [self.itemList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.name BEGINSWITH[c] %@", word]];
     }
     }
     self.searchResult = [[NSMutableArray alloc] initWithArray:array];
     return self.searchResult.count > 0;*/
}

- (NSString *)keyForTextCaching
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

-(void)didPressLeftButton:(id)sender{
    [MZAnalytics trackUserAction:@"Selecting Photo to comment"];
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose existing Photo", nil];
    [actionSheet showInView:self.view];
    [super didPressLeftButton:sender];
}


-(BOOL)canPressRightButton{
    if (self.selectedImage)
        return YES;
    
    return [super canPressRightButton];
}

- (void)didPressRightButton:(id)sender
{
    NSString* action = [NSString stringWithFormat:@"Commenting on item %@",self.selectedMenuItem.name];
    [MZAnalytics trackBusiness:self.selectedBusiness.name action:action];
    [MZAnalytics trackUserAction:@"Commenting on item"];
    [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    [self.textView refreshFirstResponder];
    
    NSData* imageData = UIImageJPEGRepresentation(self.selectedImage, 0.6);
    [[MZUser currentUser] comment:[self.textView.text trim] imageData:imageData business:self.selectedBusiness item:self.selectedMenuItem block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
            if (error){
                NSString* action = [NSString stringWithFormat:@"Error Commenting on item %@ : %@",self.selectedMenuItem.name,error.localizedDescription];
                [MZAnalytics trackBusiness:self.selectedBusiness.name action:action];
                [MZAnalytics trackUserAction:@"Error Commenting on item"];
                [UIAlertView alertViewWithTitle:@"Error" message:@"Error while trying to comment on item" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Retry"] onDismiss:^(int buttonIndex) {
                    [self didPressRightButton:nil];
                } onCancel:^{
                    
                }];
                return;
            }
            [self.navigationItem.rightBarButtonItem wiggleView];
            
            NSString* action = [NSString stringWithFormat:@"Commented on item %@%@",self.selectedMenuItem.name,self.selectedImage?@" with picture":@""];
            [MZAnalytics trackBusiness:self.selectedBusiness.name action:action];
            [MZAnalytics trackUserAction:[NSString stringWithFormat:@"Commented on item%@",self.selectedImage?@" with picture":@""]];
            
            MZActivity* activity = object;
            if (activity.comment.imageUrls){
                self.selectedMenuItem.imageUrls = activity.comment.imageUrls;
                  NSString* imageUrl = [activity.comment.imageUrls firstObject];
                NSString* cachedName = [NSString stringWithFormat:@"%@",[imageUrl lastPathComponent]];
                
                [self.selectedImage saveToCacheDirectory:cachedName];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            self.selectedImage = nil;
            self.imageViewForSelectedImage.image = nil;
            [self removeSelectedImage];
            [self.textView insertText:@""];
            [self.textView resignFirstResponder];
            self.textView.placeholder = @"Write a comment...";
            // Must call super
            [super didPressRightButton:sender];
            MZItemTableViewCell* cell = (MZItemTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

            [cell didPostComment:nil];
            [self.comments insertObject:object atIndex:0];
            NSArray* indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0]];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }];
    [super didPressRightButton:sender];
}

#pragma mark - share item
- (void)didTapShare:(id)sender{
    
    if (self.selectedMenuItem.url==nil){
        return;
    }
    NSString *string = @"";
    NSURL *URL = [NSURL URLWithString:self.selectedMenuItem.url];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                      applicationActivities:nil];
    [self presentViewController:activityViewController
                       animated:YES
                     completion:^{
                         
                     }];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count+1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        if (indexPath.row==0)
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)];
        else
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (![tableView isEqual:self.tableView]){
        return 50.0;
    }
    
    //first row is menu item
    if (indexPath.row==0){
        return self.cachedCellHeight;
    }else{
        
        MZActivity* data = [self.comments objectAtIndex:indexPath.row-1];
        NSString* itemText = [NSString stringWithFormat:@"%@%@%@",data.byUser.fullname,data.comment.text?@"\n":@"",data.comment.text?data.comment.text:@""];
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:UIColorFromRGB(0x444444)
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:itemText attributes:attribs];
        
        NSRange boldTextRange = [itemText rangeOfString:data.byUser.fullname];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Black" size:15]} range:boldTextRange];
        
        if (data.comment.text!=nil){
            NSRange regularTextRange = [itemText rangeOfString:[NSString stringWithFormat:@"\n%@",data.comment.text]];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:15]} range:regularTextRange];
        }
        CGFloat width =  [UIScreen mainScreen].bounds.size.width - 80;
        CGRect textSize = [attributedText boundsForWidth:width];
        CGFloat height = 72;
        CGFloat pictureHeight = data.comment.imageUrls!=nil?212:0;
        CGFloat halfPadding = 6;
        CGFloat timeHeight = 20;
        height = MAX(textSize.size.height + ceil((textSize.size.height/40.0)),25) + halfPadding + pictureHeight + timeHeight + halfPadding;
        height = MAX(height, 72);
        return height;
    }
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*  if (![tableView isEqual:self.tableView]){
     
     return [self autoCompletionCellForRowAtIndexPath:indexPath];
     
     }*/
    //first row showing menu item;
    if (indexPath.row==0){
        static NSString *cellIdentifier = @"Cell";
        MZItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[MZItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
            cell.preservesSuperviewLayoutMargins = NO;
       
        if (self.isFromLikes==YES){
            cell.showBusinessName = YES;
            cell.suggestedItem = NO;
        }else{
            cell.suggestedItem = self.selectedMenuItem.rank>0.0;
            cell.showBusinessName = NO;
        }
        
        cell.isFullView = YES;
        cell.selectedBusiness = self.selectedBusiness;
        cell.data = self.selectedMenuItem;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *cellIdentifier = @"Comment";
        MZCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[MZCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if ([cell respondsToSelector:@selector(preservesSuperviewLayoutMargins)])
            cell.preservesSuperviewLayoutMargins = NO;
        cell.data = [self.comments objectAtIndex:indexPath.row-1];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MZActivity* data = [self.comments objectAtIndex:indexPath.row-1];
        [[MZUser currentUser] deleteCommentBusiness:self.selectedBusiness item:self.selectedMenuItem comment:data block:^(id object, NSError *error) {
            if (error!=nil){
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.selectedMenuItem.commentCount--;
                [self.comments removeObject:data];
                [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
                MZItemTableViewCell* cell = (MZItemTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                if (cell)
                    [cell updateCommentCount];
                
            });
        }];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0)
        return NO;
    
    MZActivity* data = [self.comments objectAtIndex:indexPath.row-1];
    if ([data.byUser.userId isEqualToString:[MZUser currentUser].userId]){
        return YES;
    }
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
        return NO;
    MZActivity* data = [self.comments objectAtIndex:indexPath.row-1];
    if (data.comment.imageUrls.count==0)
        return NO;
    return YES;
}

#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0)
        return;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MZActivity* data = [self.comments objectAtIndex:indexPath.row-1];
    if (data.comment.imageUrls.count==0)
        return;
    
    [self performSegueWithIdentifier:@"comment" sender:data];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"comment"]){
        [MZAnalytics trackUserAction:@"Viewed comment detail"];
        MZCommentDetailViewController* vc = segue.destinationViewController;
        vc.data = sender;
    }
}


@end
