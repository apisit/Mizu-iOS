//
//  MZWebViewViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 3/14/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZWebViewViewController.h"

@interface MZWebViewViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MZWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.webTitle;
    self.screenName = self.title;
    NSURL* url = [NSURL URLWithString:self.url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.webView loadRequest:request];
    
    if (!self.hideCloseButton){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(didTapClose:)];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapClose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
