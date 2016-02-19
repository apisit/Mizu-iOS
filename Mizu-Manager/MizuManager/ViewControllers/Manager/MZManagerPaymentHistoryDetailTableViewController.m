//
//  MZManagerPaymentHistoryDetailTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 9/10/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZManagerPaymentHistoryDetailTableViewController.h"
#import <MessageUI/MessageUI.h>

@interface MZManagerPaymentHistoryDetailTableViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) IBOutlet UIButton* btnRefund;
@property (nonatomic, strong) IBOutlet UILabel* lblName;
@property (nonatomic, strong) IBOutlet UILabel* lblTime;
@property (nonatomic, strong) IBOutlet UILabel* lblAmount;
@property (nonatomic, strong) IBOutlet UILabel* lblAmountDetail;
@property (nonatomic, strong) IBOutlet UILabel* lblFeedback;
@property (nonatomic, strong) IBOutlet UIActionSheet* actionSheetContact;


@property (nonatomic, strong) IBOutlet MZTempAvatarImageView* profilePicture;


@end

@implementation MZManagerPaymentHistoryDetailTableViewController
- (void)loadData{
    self.profilePicture.name = self.selectedCheckIn.user.fullname;
    if (self.selectedCheckIn.user.profilePicture!=nil){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.selectedCheckIn.user.profilePicture] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15];
        NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            if (downloadedImage!=nil){
                dispatch_async(dispatch_get_main_queue(), ^ {
                    self.profilePicture.image = downloadedImage;
                });
            }
        }];
        [getImageTask resume];
    }
    self.lblName.text = self.selectedCheckIn.user.fullname;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    self.lblTime.text = [NSString stringWithFormat:@"%@ • %@",[self.selectedCheckIn.transaction.createdDate timeAgo],[dateFormatter stringFromDate:self.selectedCheckIn.createdDate]];
    
    self.lblAmount.text = self.selectedCheckIn.transaction.formattedTotalAmount;
    
    NSString* detail = [NSString stringWithFormat:@"%@ • Tip %@",self.selectedCheckIn.card.cardBrandWithLast4,self.selectedCheckIn.transaction.formattedTipAmount];
    self.lblAmountDetail.text = detail;
    
    if  (self.selectedCheckIn.transaction.chargeSucceeded==YES){
        [self.btnRefund removeTarget:self action:@selector(didTapRefund:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnRefund addTarget:self action:@selector(didTapRefund:) forControlEvents:UIControlEventTouchUpInside];
        //already refunded
        if (self.selectedCheckIn.transaction.refunded){
            self.btnRefund.enabled = NO;
            NSString* message = [NSString stringWithFormat:@"Refunded %@ %@",self.selectedCheckIn.transaction.formattedRefundedAmount,[self.selectedCheckIn.transaction.refundedDate timeAgo]];
            [self.btnRefund setTitle:message forState:UIControlStateNormal];
            [self.btnRefund setBackgroundColor:[UIColor lightGrayColor]];
        }
        
    }else  if (self.selectedCheckIn.transaction.chargeSucceeded==NO){
        
        self.btnRefund.enabled = NO;
        NSString* message = [NSString stringWithFormat:@"%@",self.selectedCheckIn.transaction.errorMessage];
        [self.btnRefund setTitle:message forState:UIControlStateNormal];
        [self.btnRefund setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    NSMutableString* stars = [[NSMutableString alloc]init];
    
    if (self.selectedCheckIn.waitingForFeedback){
        [stars appendString:@"WAITING FOR FEEDBACK"];
    }else{
        for(NSInteger i=0;i<5;i++){
            if (i<self.selectedCheckIn.feedback.rating){
                [stars appendString:@"★"];
            }else{
                [stars appendString:@"☆"];
            }
        }
        
        if (self.selectedCheckIn.feedback.comment){
            [stars appendFormat:@"\n%@",self.selectedCheckIn.feedback.comment];
        }
    }
    
    self.lblFeedback.text = [NSString stringWithFormat:@"%@",stars];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Payment History";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didTapAction:)];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
- (IBAction)didTapAction:(id)sender{
    self.actionSheetContact = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Contact Customer", nil];
    [self.actionSheetContact showInView:self.view];
}

#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0){
        return;
    }else if (buttonIndex==1){
        
        NSString *textFieldStr = [NSString stringWithFormat:@"%@", [alertView textFieldAtIndex:0].text];
        
        NSMutableString *textFieldStrValue = [NSMutableString stringWithString:textFieldStr];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setCurrencySymbol:self.selectedCheckIn.business.meta.currencySymbol];
        
        [textFieldStrValue replaceOccurrencesOfString:numberFormatter.currencySymbol
                                           withString:@""
                                              options:NSLiteralSearch
                                                range:NSMakeRange(0, [textFieldStrValue length])];
        
        [textFieldStrValue replaceOccurrencesOfString:numberFormatter.groupingSeparator
                                           withString:@""
                                              options:NSLiteralSearch
                                                range:NSMakeRange(0, [textFieldStrValue length])];
        
        NSDecimalNumber *textFieldNum = [NSDecimalNumber decimalNumberWithString:textFieldStrValue];
        
        
        if ([textFieldNum doubleValue] <= 0)
            return;
        
        NSUInteger amount = [textFieldNum doubleValue] * [self.selectedCheckIn.business.meta.currencyFactor doubleValue];
        
        if (amount>self.selectedCheckIn.transaction.totalAmount){
            NSString* message = [NSString stringWithFormat:@"Refund amount (%@) is greater than charge amount %@",textFieldStr,self.lblAmount.text];
            
            [UIAlertView alertViewWithTitle:nil message:message cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Edit amount"] onDismiss:^(int buttonIndex) {
                [self askPartialRefund];
            } onCancel:^{
                
            }];
            return;
        }
        
        [self refund:amount fullRefund:NO];
        
    }
}
#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSInteger MAX_DIGITS = 8; // 999,999,999.99
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setCurrencySymbol:self.selectedCheckIn.business.meta.currencySymbol];
    NSString *stringMaybeChanged = [NSString stringWithString:string];
    if (stringMaybeChanged.length > 1)
    {
        NSMutableString *stringPasted = [NSMutableString stringWithString:stringMaybeChanged];
        
        [stringPasted replaceOccurrencesOfString:numberFormatter.currencySymbol
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [stringPasted length])];
        
        [stringPasted replaceOccurrencesOfString:numberFormatter.groupingSeparator
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [stringPasted length])];
        
        NSDecimalNumber *numberPasted = [NSDecimalNumber decimalNumberWithString:stringPasted];
        stringMaybeChanged = [numberFormatter stringFromNumber:numberPasted];
    }
    
    UITextRange *selectedRange = [textField selectedTextRange];
    UITextPosition *start = textField.beginningOfDocument;
    NSInteger cursorOffset = [textField offsetFromPosition:start toPosition:selectedRange.start];
    NSMutableString *textFieldTextStr = [NSMutableString stringWithString:textField.text];
    NSUInteger textFieldTextStrLength = textFieldTextStr.length;
    
    [textFieldTextStr replaceCharactersInRange:range withString:stringMaybeChanged];
    
    [textFieldTextStr replaceOccurrencesOfString:numberFormatter.currencySymbol
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [textFieldTextStr length])];
    
    [textFieldTextStr replaceOccurrencesOfString:numberFormatter.groupingSeparator
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [textFieldTextStr length])];
    
    [textFieldTextStr replaceOccurrencesOfString:numberFormatter.decimalSeparator
                                      withString:@""
                                         options:NSLiteralSearch
                                           range:NSMakeRange(0, [textFieldTextStr length])];
    
    if (textFieldTextStr.length <= MAX_DIGITS)
    {
        NSDecimalNumber *textFieldTextNum = [NSDecimalNumber decimalNumberWithString:textFieldTextStr];
        NSDecimalNumber *divideByNum = [[[NSDecimalNumber alloc] initWithInt:10] decimalNumberByRaisingToPower:numberFormatter.maximumFractionDigits];
        NSDecimalNumber *textFieldTextNewNum = [textFieldTextNum decimalNumberByDividingBy:divideByNum];
        NSString *textFieldTextNewStr = [numberFormatter stringFromNumber:textFieldTextNewNum];
        
        textField.text = textFieldTextNewStr;
        
        if (cursorOffset != textFieldTextStrLength)
        {
            NSInteger lengthDelta = textFieldTextNewStr.length - textFieldTextStrLength;
            NSInteger newCursorOffset = MAX(0, MIN(textFieldTextNewStr.length, cursorOffset + lengthDelta));
            UITextPosition* newPosition = [textField positionFromPosition:textField.beginningOfDocument offset:newCursorOffset];
            UITextRange* newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
            [textField setSelectedTextRange:newRange];
        }
    }
    
    return NO;
}


-(void)openEmailDialog{
    if(![MFMailComposeViewController canSendMail]) {
        return;
    }
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc]init];
    mailController.mailComposeDelegate = self;
    NSString* subject = [NSString stringWithFormat:@"From %@",self.selectedCheckIn.business.name];
    [mailController setSubject:subject];
    [mailController setToRecipients:@[self.selectedCheckIn.user.email]];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString* body = [NSString stringWithFormat:@"Hello %@,\n\n\n%@\nTransaction of %@ on %@",self.selectedCheckIn.user.firstname,self.selectedCheckIn.business.name,self.selectedCheckIn.transaction.formattedTotalAmount,[dateFormatter stringFromDate:self.selectedCheckIn.transaction.createdDate]];
    [mailController setMessageBody:body isHTML:NO];
    [self presentViewController:mailController animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark  UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (actionSheet==self.actionSheetContact){
        if (buttonIndex==0){
            //open email dialog
            [self openEmailDialog];
        }
        return;
    }
    
    if (buttonIndex==0){
        [self refund:self.selectedCheckIn.transaction.totalAmount fullRefund:YES];
    }else if (buttonIndex==1){
        [self askPartialRefund];
    }else if (buttonIndex==2){
        return;
    }
}
#pragma mark -
- (void)askPartialRefund{
    NSString* message = [NSString stringWithFormat:@"Full amount (%@)",self.lblAmount.text];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Partial refund amount" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Refund", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType= UIKeyboardTypeDecimalPad;
    [alertView textFieldAtIndex:0].font = [UIFont fontWithName:@"Avenir-Medium" size:20];
    [alertView textFieldAtIndex:0].text = [NSString stringWithFormat:@"%@0.00" ,self.selectedCheckIn.business.meta.currencySymbol];
    [alertView textFieldAtIndex:0].textAlignment = NSTextAlignmentRight;
    [alertView textFieldAtIndex:0].delegate = self;
    [alertView show];
}
#pragma mark -
- (void)refund:(NSUInteger)amount fullRefund:(BOOL)fullRefund{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* remark = @"test remark";
    [self.selectedCheckIn refundPayment:self.selectedCheckIn.transaction fullRefund:fullRefund amount:amount remark:remark block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                [UIAlertView alertViewWithTitle:@"Error" message:error.localizedDescription cancelButtonTitle:@"Dismiss"];
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}
- (IBAction)didTapRefund:(id)sender{
    
    NSString* fullRefund = [NSString stringWithFormat:@"Full amount (%@)",self.lblAmount.text];
    NSString* partialRefund = [NSString stringWithFormat:@"Partial amount (Enter amount)"];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"Refund payment" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:fullRefund,partialRefund, nil];
    [actionSheet showInView:self.view];
}

#pragma mark -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && indexPath.row==0){
        return 145;
    }
    if (indexPath.section==0 && indexPath.row==1){
        return 110;
    }
    if (indexPath.section==1 && indexPath.row==0){
        return 68;
    }
    if (indexPath.section==0 && indexPath.row==2){
        if (self.selectedCheckIn.feedback.comment){
            return [self.selectedCheckIn.feedback.comment textHeightWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 30 font:self.lblFeedback.font] + 30 + 21;
        }
        
        return 44;
    }
    return 0;
}



@end
