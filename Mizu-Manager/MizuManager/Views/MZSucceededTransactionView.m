//
//  MZSucceededTransactionView.m
//  MizuManager
//
//  Created by Apisit Toompakdee on 11/21/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZSucceededTransactionView.h"

@interface MZSucceededTransactionView(){
    DidTapOk _block;
}
@property (nonatomic, strong) UILabel* lblDescription;
@property (nonatomic, strong) UILabel* lblTitle;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIVisualEffectView* effectView;

@end

@implementation MZSucceededTransactionView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)didTapOk:(DidTapOk)block{
    _block = block;
}

- (void)show:(NSString*)description{
    self.lblDescription.text = description;
    [UIApplication.sharedApplication.delegate.window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.lblTitle.alpha = 1;
        self.imageView.alpha = 1;
        self.lblDescription.alpha = 1;
    } completion:^(BOOL finished) {

    }];
    
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.frame = CGRectMake(0, 0, 120, 120);
        self.imageView.center = self.center;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)setupView{
    
    
    self.alpha = 0;
    self.frame = UIApplication.sharedApplication.delegate.window.bounds;
    
    CGFloat centerY = self.center.y;
    CGFloat centerX = self.center.x;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  
    self.effectView = [[UIVisualEffectView alloc]initWithFrame:self.bounds];
    self.effectView.effect = blurEffect;
    [self addSubview:self.effectView];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    CGRect rectTitle = CGRectMake(15, centerY - 120 , self.frame.size.width-30, 44);
    self.lblTitle = [[UILabel alloc]initWithFrame:rectTitle];
    self.lblTitle.font = [UIFont fontWithName:@"Avenir-Black" size:17];
    self.lblTitle.textColor = [UIColor whiteColor];
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
    self.lblTitle.alpha = 0;
    self.lblTitle.numberOfLines = 1;
    self.lblTitle.text = @"Payment received";
    [self addSubview:self.lblTitle];

    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checked"]];
    self.imageView.frame = CGRectMake(centerX, centerY, 1, 1);
    self.imageView.alpha = 0;
    [self addSubview:self.imageView];
    
    CGRect rect = CGRectMake(15, centerY + 80 , self.frame.size.width-30, 50);
    self.lblDescription = [[UILabel alloc]initWithFrame:rect];
    self.lblDescription.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    self.lblDescription.textColor = [UIColor whiteColor];
    self.lblDescription.textAlignment = NSTextAlignmentCenter;
    self.lblDescription.alpha = 0;
    self.lblDescription.numberOfLines = 0;
    [self addSubview:self.lblDescription];
    
    
    UIButton* btn = [[UIButton alloc]initWithFrame:self.bounds];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:18];
    [btn setTitle:@"OK" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(self.bounds.size.height - 100 ,0, 0, 0)];
    //btn.showsTouchWhenHighlighted = YES;
    [btn addTarget:self action:@selector(didTapClose:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (IBAction)didTapClose:(id)sender{
    [self removeFromSuperview];
    _block();
}

@end
