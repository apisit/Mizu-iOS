//
//  MZEditProfileTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 10/30/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZEditProfileTableViewController.h"

@interface MZEditProfileTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField* txtFirstName;
@property (nonatomic, strong) IBOutlet UITextField* txtLastName;
@property (nonatomic, strong) IBOutlet UITextField* txtEmail;
@property (nonatomic, strong) IBOutlet UITextField* txtPhone;
@property (nonatomic, strong) IBOutlet UITextField* txtGender;
@property (nonatomic, strong) IBOutlet UITextField* txtDOB;
@property (nonatomic, strong) IBOutlet UIDatePicker* dobPicker;
@property (nonatomic, strong) IBOutlet MZTempAvatarImageView* profileImageView;
@property (nonatomic, assign) BOOL selectedCustomGender;
@property (nonatomic, strong) UIActionSheet* actionShetGender;

@property UITapGestureRecognizer* tapToResign;
@end

@implementation MZEditProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
 
    self.tableView.allowsSelection = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [MZColor styleTableView:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTapSave:)];
    
    self.profileImageView.name = [MZUser currentUser].firstname;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapProfilePicture:)];
    [self.profileImageView addGestureRecognizer:tap];
    self.txtFirstName.text = [MZUser currentUser].firstname;
    self.txtLastName.text = [MZUser currentUser].lastname;
    
    if ([MZUser currentUser].profilePicture!=nil){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[MZUser currentUser].profilePicture] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        
        NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                if (downloadedImage){
                    self.profileImageView.image = downloadedImage;
                }
            });
        }];
        [getImageTask resume];
    }
    self.txtEmail.text = [MZUser currentUser].email;
    self.txtEmail.enabled = NO;
    self.txtEmail.textColor = [MZColor subTitleColor];
    self.txtPhone.text = [MZUser currentUser].phoneNumber;
    self.txtPhone.enabled = NO;
    self.txtPhone.textColor = [MZColor subTitleColor];
    self.txtDOB.enabled = YES;
    self.txtDOB.textColor = [MZColor titleColor];
    self.txtDOB.delegate = self;
    self.txtDOB.text = [MZUser currentUser].formattedDateOfBirth;
    self.txtGender.text = [MZUser currentUser].gender;
    self.txtGender.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [MZAnalytics trackUserAction:@"Successfully Changed Profile Picture"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image==nil){
        return;
    }
    image = [image resizedImage:CGSizeMake(320.0, 320.0) imageOrientation:image.imageOrientation];
    self.profileImageView.image = image;
    NSData* data = UIImageJPEGRepresentation(image, 0.6);
    [[MZUser currentUser] saveProfilePicture:data block:^(id object, NSError *error) {
        
    }];
}


#pragma mark - action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet==self.actionShetGender){
        if (buttonIndex==0){
            self.txtGender.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        }else if (buttonIndex==1){
            self.txtGender.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        }else if (buttonIndex==2){
            self.txtGender.text = @"";
            self.selectedCustomGender = YES;
            [self.txtGender becomeFirstResponder];
        }
        return;
    }
    
    //action in changing profile picture.
    if (actionSheet.tag==0){
        if (buttonIndex==2){//cancel
            [MZAnalytics trackUserAction:@"Cancel Change Profile Picture"];
            return;
        }
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
        if (buttonIndex==0){
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:pickerController animated:YES completion:NULL];
    }
}

#pragma mark - Actions
- (IBAction)didTapToResign:(id)sender{
    [self.txtDOB resignFirstResponder];
    [self.dobPicker resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapToResign];
}

- (IBAction)didChangeDOB:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    self.txtDOB.text = [dateFormatter stringFromDate:[self.dobPicker date]];
}

- (IBAction)didTapProfilePicture:(id)sender{
    [MZAnalytics trackUserAction:@"Change Profile Picture"];
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose existing Photo", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

- (IBAction)didTapSave:(id)sender{
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    
    //nothing change we don't call server.
    if ([[MZUser currentUser].firstname isEqualToString:[self.txtFirstName.text trim]] && [[MZUser currentUser].lastname isEqualToString:[self.txtLastName.text trim]] && [[MZUser currentUser].formattedDateOfBirth isEqualToString:[self.txtDOB.text trim]] && [[MZUser currentUser].gender isEqualToString:[self.txtGender.text trim]]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
        
    [MZAnalytics trackUserAction:@"change name"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //save mzuser
    [[MZUser currentUser] updateFirstName:[self.txtFirstName.text trim] lastName:[self.txtLastName.text trim] dateOfBirth:[self.txtDOB.text trim] gender:[self.txtGender.text trim] block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==4){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
        return 88;
    
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

#pragma mark - text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.txtGender){
        self.selectedCustomGender=NO;
        [self.txtGender resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtGender && self.selectedCustomGender==NO){
        [self.txtDOB resignFirstResponder];
        [self.dobPicker resignFirstResponder];
        
        self.actionShetGender = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Female",@"Male",@"Custom", nil];
        [self.actionShetGender showInView:self.view];
        return NO;
    }
    
    //init uidatepicker
    if (textField == self.txtDOB && self.dobPicker==nil){
        self.dobPicker = [[UIDatePicker alloc]init];
        self.dobPicker.datePickerMode = UIDatePickerModeDate;
        if ([MZUser currentUser].dateOfBirth){
            [self.dobPicker setDate:[MZUser currentUser].dateOfBirth];
        }
        self.dobPicker.maximumDate = [NSDate date];
        [self.dobPicker addTarget:self action:@selector(didChangeDOB:) forControlEvents:UIControlEventValueChanged];
        self.txtDOB.inputView = self.dobPicker;
    }
    self.tapToResign = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapToResign:)];
    [self.view addGestureRecognizer:self.tapToResign];
    return YES;
}

@end
