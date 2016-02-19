//
//  MZSignupAddPhotoViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 11/16/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZSignupAddPhotoViewController.h"

@interface MZSignupAddPhotoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) IBOutlet UILabel* lblName;
@property (nonatomic, strong) IBOutlet UIImageView* profileImageView;

@end

@implementation MZSignupAddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Your Photo";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(didTapNext:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.lblName.text = [NSString stringWithFormat:@"Hello %@",[MZUser currentUser].firstname];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapProfilePicture:)];
    [self.profileImageView addGestureRecognizer:tap];
    self.profileImageView.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image==nil){
        return;
    }
    image = [image resizedImage:CGSizeMake(320.0, 320.0) imageOrientation:image.imageOrientation];
    self.profileImageView.layer.cornerRadius = self. self.profileImageView.frame.size.width / 2.0;
    self.profileImageView.image = image;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData* data = UIImageJPEGRepresentation(image, 0.6);
    [[MZUser currentUser] saveProfilePicture:data block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        });
    }];
}


#pragma mark - action sheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //action in changing profile picture.
    if (actionSheet.tag==0){
        if (buttonIndex==2){//cancel
            return;
        }
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
        if (buttonIndex==0){
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }else{
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:pickerController animated:YES completion:NULL];
    }
}

#pragma mark - 

- (IBAction)didTapProfilePicture:(id)sender{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose existing Photo", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

-(IBAction)didTapNext:(id)sender{
    [self performSegueWithIdentifier:@"addCard" sender:nil];
}

@end
