//
//  MZMenuSectionView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/3/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZMenuSectionView.h"


@interface MZMenuSectionView(){
}

@property (nonatomic, strong) UILabel* lblTitle;
@property (nonatomic, strong) UILabel* lblCurrency;
@end

@implementation MZMenuSectionView

-(void)awakeFromNib{
    [super awakeFromNib];
   
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lblTitle.text = self.title;
    self.lblCurrency.text = self.currencySymbol;
}

- (void)setupView:(CGRect)frame{
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
   /* if (!UIAccessibilityIsReduceTransparencyEnabled()){
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView* blurView =  [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        blurView.frame = self.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.blurredView.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:blurView];
        [self sendSubviewToBack:blurView];
    }*/
    
    self.lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 200, frame.size.height)];
    self.lblTitle.font = [UIFont fontWithName:@"Avenir-Black" size:15];
    self.lblTitle.textColor = UIColorFromRGB(0x444444);
    [self addSubview:self.lblTitle];
    
    self.lblCurrency = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame) - 27 , 0, 24, frame.size.height)];
    self.lblCurrency.font = [UIFont fontWithName:@"Avenir-Black" size:15];
    self.lblCurrency.textAlignment = NSTextAlignmentRight;
    self.lblCurrency.textColor = UIColorFromRGB(0x444444);
    
    [self addSubview:self.lblCurrency];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView:frame];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
