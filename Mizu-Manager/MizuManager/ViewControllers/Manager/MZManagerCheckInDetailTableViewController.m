//
//  MZManagerCheckInDetailTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 9/4/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZManagerCheckInDetailTableViewController.h"
#import "MZSucceededTransactionView.h"
@interface MZManagerCheckInDetailTableViewController ()<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField* txtAmount;
@property (nonatomic,weak) IBOutlet UIButton* btnTakePayment;
@property (nonatomic, weak) IBOutlet UILabel* lblName;
@property (nonatomic, weak) IBOutlet MZTempAvatarImageView* profileImageView;
@property (nonatomic, strong) MZSucceededTransactionView* succeededView;
@end

@implementation MZManagerCheckInDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Take Payment";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.btnTakePayment.enabled = YES;
    
    if (self.selectedCheckIn.user.profilePicture!=nil){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.selectedCheckIn.user.profilePicture] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15];
        NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            if (downloadedImage!=nil){
                dispatch_async(dispatch_get_main_queue(), ^ {
                    self.profileImageView.image = downloadedImage;
                });
            }
        }];
        [getImageTask resume];
    }
    
    self.lblName.text = self.selectedCheckIn.user.fullname;
    self.txtAmount.text = [NSString stringWithFormat:@"%@0.00" ,self.selectedCheckIn.business.meta.currencySymbol];
    [self.txtAmount addTarget:self action:@selector(didEnterAmount:) forControlEvents:UIControlEventEditingChanged];
    self.txtAmount.delegate = self;
    self.btnTakePayment.backgroundColor = [MZColor mizuColor];
    [self.txtAmount becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.txtAmount resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - text field delegate

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


#pragma mark -
- (IBAction)didTapClose:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didEnterAmount:(id)sender{
    NSString* text = [self.txtAmount.text trim];
    NSInteger textLength = text.length;
    self.btnTakePayment.enabled = textLength>0;
    
    if (self.btnTakePayment.enabled){
        [self.btnTakePayment setBackgroundColor:[MZColor mizuColor]];
    }else{
        [self.btnTakePayment setBackgroundColor:UIColorFromRGB(0xd9d9d9)];
    }
    
}

#pragma mark -
- (void)takePayment:(NSInteger)amount{
    [self.txtAmount resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.selectedCheckIn takePayment:amount block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                [UIAlertView alertViewWithTitle:@"" message:error.localizedDescription cancelButtonTitle:@"Ok"];
                return;
            }
            MZTransaction* transaction = (MZTransaction*)object;
            NSString* message = [NSString stringWithFormat:@"%@ + Tip %@ Total %@",transaction.formattedAmount,transaction.formattedTipAmount,transaction.formattedTotalAmount];
            
            self.succeededView = [[MZSucceededTransactionView alloc]init];
            [self.succeededView didTapOk:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self.succeededView show:[NSString stringWithFormat:@"From %@\n%@",self.selectedCheckIn.user.fullname,message]];
            
        });
    }];
    
    
}
-(IBAction)didTapTakePayment:(id)sender{
    
    NSString *textFieldStr = [NSString stringWithFormat:@"%@", self.txtAmount.text];
    
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
    
    
    if ([textFieldNum doubleValue] <= 0){
        return;
    }
    
    [self.txtAmount resignFirstResponder];
    
    NSUInteger amount = [textFieldNum doubleValue] * [self.selectedCheckIn.business.meta.currencyFactor doubleValue];
    
    if ([textFieldNum doubleValue]>500){
        NSString* message = [NSString stringWithFormat:@"Charge %@ %@",self.selectedCheckIn.user.fullname,self.txtAmount.text];
        [UIAlertView alertViewWithTitle:@"Please confirm amount" message:message cancelButtonTitle:@"Edit" otherButtonTitles:@[@"Confirm"] onDismiss:^(int buttonIndex) {
            [self takePayment:amount];
        } onCancel:^{
            self.txtAmount.text = [NSString stringWithFormat:@"%@0.00" ,self.selectedCheckIn.business.meta.currencySymbol];
            [self.txtAmount becomeFirstResponder];
        }];
        return;
    }
    [self takePayment:amount];
}

@end
