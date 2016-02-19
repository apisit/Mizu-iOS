//
//  MZIntroViewController.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/2/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZIntroViewController.h"

@interface MZIntroViewController()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UIView *mizuLogo;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoVertialContraint;

@property (strong, nonatomic) IBOutlet UILabel *lblWelcome;
@property (strong, nonatomic) IBOutlet UILabel *lblTagLine;

@end

@implementation MZIntroViewController


-(void)viewDidLoad{
    [super viewDidLoad];

    self.collectionView.alpha = 0;
    self.screenName = @"Intro Screen";
    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x252525);
    self.pageControl.pageIndicatorTintColor = UIColorFromRGB(0xd4d4d4);
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    self.pageControl.alpha = 0;
    self.mizuLogo.alpha = 0;
    self.lblWelcome.alpha = 0;
    self.lblTagLine.alpha = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.logoVertialContraint.constant = 168;
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1
                        options:0
                     animations:^{
                         self.mizuLogo.alpha = 1;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5 animations:^{
                             self.lblWelcome.alpha = 1;
                             self.lblTagLine.alpha = 1;
                             self.pageControl.alpha = 1;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5 animations:^{
                                 self.collectionView.alpha = 1;
                             } completion:^(BOOL finished) {
                                  self.viewContainer.alpha = 0;
                             }];
                         }];
                     }];
    
    [self updatePageControl];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellId = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if (indexPath.row==3){
        cell.backgroundColor = UIColorFromRGB(0x252525);
        self.view.backgroundColor = UIColorFromRGB(0x252525);
    }else{

        self.view.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size;
}

#pragma mark - scroll delegate
- (void)updatePageControl{
    NSInteger page = floor(self.collectionView.contentOffset.x / self.collectionView.bounds.size.width);
    if (page==3){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xffffff);
        self.pageControl.pageIndicatorTintColor = UIColorFromRGB(0x4d4d4d);
        self.view.backgroundColor = UIColorFromRGB(0x252525);
    }else{

        self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x252525);
        self.pageControl.pageIndicatorTintColor = UIColorFromRGB(0xd4d4d4);
        self.view.backgroundColor = UIColorFromRGB(0xffffff);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updatePageControl];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self updatePageControl];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = floor(scrollView.contentOffset.x / self.collectionView.bounds.size.width);
    self.pageControl.currentPage = page;
}
@end
