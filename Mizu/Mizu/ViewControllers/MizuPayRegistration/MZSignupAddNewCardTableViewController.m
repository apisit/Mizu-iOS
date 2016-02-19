//
//  MZSignupAddNewCardTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 11/5/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZSignupAddNewCardTableViewController.h"
#import <Stripe/Stripe.h>
#import "CardIO.h"

@interface MZSignupAddNewCardTableViewController ()<STPPaymentCardTextFieldDelegate,CardIOPaymentViewControllerDelegate>

@property (nonatomic) IBOutlet STPPaymentCardTextField* paymentTextField;

@end

@implementation MZSignupAddNewCardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Card Details";
    [CardIOUtilities preload];
   // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [MZColor styleTableView:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSave:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSkip:)];
    self.navigationItem.leftBarButtonItem.tintColor = [MZColor subTitleColor];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.hidesBackButton = YES;
    self.paymentTextField.delegate = self;
    self.paymentTextField.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    self.paymentTextField.textColor = [MZColor titleColor];
    self.paymentTextField.borderWidth = 0;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.paymentTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = textField.valid;
}

#pragma mark -

#pragma mark -
- (void)saveCard:(NSString*)cardNumber expMonth:(NSUInteger)expMonth expYear:(NSUInteger)expYear CVC:(NSString*)cvc{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MZUser currentUser] addDefaultCreditCard:cardNumber expMonth:expMonth expYear:expYear cvc:cvc block:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error!=nil){
                [UIAlertView alertViewWithTitle:@"Error" message:@"Error while trying to save your card. Please try again." cancelButtonTitle:@"Retry"];
                return;
            }
            //go to next screen.
            //taste preferences.
            [self performSegueWithIdentifier:@"taste" sender:nil];
        });
    }];
}

- (IBAction)didTapSkip:(id)sender{
 [self performSegueWithIdentifier:@"taste" sender:nil];
}

-(IBAction)didTapSave:(id)sender{
    [self saveCard:self.paymentTextField.cardNumber expMonth:self.paymentTextField.expirationMonth expYear:self.paymentTextField.expirationYear CVC:self.paymentTextField.cvc];
}


-(IBAction)didTapScanCard:(id)sender{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    
    [self saveCard:info.cardNumber expMonth:info.expiryMonth expYear:info.expiryYear CVC:info.cvv];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MZSectionHeaderView *headerView = [[MZSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [MZColor subBackgroundColor];
    headerView.separatorColor = [MZColor tableSeparatorColor];
    headerView.textColor = [MZColor subTitleColor];
    headerView.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
    if (section==0){
        headerView.title = [@"256-bit SSL bank-level security" uppercaseString];
    }
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
        return 2;
    return 0;
}




-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
        return NO;
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //open card.io
    [self didTapScanCard:nil];
}

@end
