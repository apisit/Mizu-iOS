//
//  MZCommentDetailViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 2/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZCommentDetailViewController.h"

@interface MZCommentDetailViewController ()<UIScrollViewDelegate>

@end

@implementation MZCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Comment detail";
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.data.comment.imageUrls!=nil && self.data.comment.imageUrls.count>0){
        NSString* imageUrl = [self.data.comment.imageUrls firstObject];
        __block NSString* cachedName = [NSString stringWithFormat:@"%@",[imageUrl lastPathComponent]];
        UIImage* commentPicture = [UIImage imageFromCacheDirectory:cachedName];
        self.imageView.image = commentPicture;
    }
    UITapGestureRecognizer* tapToClose = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapClose:)];
    [self.view addGestureRecognizer:tapToClose];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didTapClose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - scrollview delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
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
