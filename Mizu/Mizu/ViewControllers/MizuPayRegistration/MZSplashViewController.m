//
//  MZSplashViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 11/12/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZSplashViewController.h"

@interface MZSplashViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) IBOutlet UIPageControl* pageControl;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* topSpaceHeight;

@end

@implementation MZSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [MZColor backgroundColor];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([UIScreen mainScreen].bounds.size.height > 568){
        self.topSpaceHeight.constant = 40;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)didTapCreateAccount:(id)sender{
    [self performSegueWithIdentifier:@"signup" sender:nil];
}

- (IBAction)didTapSignIn:(id)sender{
    [self performSegueWithIdentifier:@"signin" sender:nil];
}

#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString* identifier = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 400);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pageIndex = lround(self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
    self.pageControl.currentPage = pageIndex;
}
@end
