//
//  MZTastePreferenceTableViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/11/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZTastePreferenceTableViewController.h"
#import "MZTasteOptionTableViewCell.h"
@interface MZTastePreferenceTableViewController ()

@property (nonatomic, strong) NSArray* data;
@property (nonatomic, strong) IBOutlet UILabel* lblAllDone;
@property (nonatomic, assign) BOOL tried;
@property (nonatomic, assign) BOOL userChangesSomething;
@end

@implementation MZTastePreferenceTableViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self didTapDone:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Food Preferences";
    self.tried = NO;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.tableFooterView = self.lblAllDone;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MZColor styleTableView:self.tableView];
    [MZSetting tastePreferenceQuestions:^(NSArray *list, NSError *error) {
        if (error){
            return;
        }
        self.data = [[NSArray alloc]initWithArray:list];
        [[MZUser currentUser] tastePreferences:^(NSArray *list, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                if (error){
                    return;
                }
                NSArray* tastePreferences = [NSArray arrayWithArray:list];
                for(MZQuestion* question in self.data){
                    BOOL isYES = [tastePreferences containsObject:question.tagForYes];
                    BOOL isNO = [tastePreferences containsObject:question.tagForNo];
                    question.answer = isYES?question.tagForYes:isNO?question.tagForNo:@"";
                }
                [self.tableView reloadData];
            });
        }];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"answeredTasteOption" object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.userChangesSomething = YES;
        MZQuestion* question = [note.userInfo objectForKey:@"data"];
        NSInteger state = [[note.userInfo objectForKey:@"answer"] integerValue]
        ;
        
        if (state==1){
            question.answer = question.tagForYes;
        }else if (state==-1){
            question.answer = question.tagForNo;
        }else if (state==0){
            question.answer = @"";
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - save taste
- (void)saveTaste{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"answer!=%@",@""];
    NSArray* answered = [self.data filteredArrayUsingPredicate:predicate];
    if (answered.count==0){
        [UIAlertView alertViewWithTitle:nil message:@"So that we can suggest the best dishes to you, please tell us what you like." cancelButtonTitle:@"Okay" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
            
        } onCancel:^{
        }];
        return;
    }
    
    if (self.userChangesSomething==NO){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray* answerList = [[NSMutableArray alloc]init];
    for(MZQuestion* question in self.data){
        if (question.answer.length>0){
            if (![answerList containsObject:question.answer]){
                [answerList addObject:question.answer];
            }
        }
    }
    [[MZUser currentUser] saveTastePreferences:answerList block:^(NSArray *list, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        });
        if (error){
         /*   dispatch_async(dispatch_get_main_queue(), ^{
                NSString* message = [NSString stringWithFormat:@"There was a problem while trying to save your taste preferences.%@",@""];
                [UIAlertView alertViewWithTitle:@"Unable to save" message:message cancelButtonTitle:@"Try again" otherButtonTitles:@[@"Do it later"] onDismiss:^(int buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                } onCancel:^{
                    [self saveTaste];
                }];
            });
          */
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"setTastePreferences"];
            [defaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)didTapDone:(id)sender{
    [self saveTaste];
}

#pragma mark - Table view data source
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MZSectionHeaderView *headerView = [[MZSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    headerView.backgroundColor = [MZColor subBackgroundColor];
    headerView.separatorColor = [MZColor tableSeparatorColor];
    headerView.textColor = [MZColor subTitleColor];
    headerView.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
    if (section==0){
        headerView.title = @"FOOD PREFERENCES";
    }
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZTasteOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZTasteOptionTableViewCell" forIndexPath:indexPath];
    MZQuestion* question = [self.data objectAtIndex:indexPath.row];
    cell.data = question;
    [MZColor styleTableViewCell:cell];
    BOOL isYES = [question.answer isEqualToString:question.tagForYes];
    BOOL isNO = [question.answer isEqualToString:question.tagForNo];
    [cell.btnYes setSelected:isYES];
    [cell.btnNo setSelected:isNO];
    return cell;
}
@end
