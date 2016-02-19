//
//  MZTempAvatarImageView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 3/15/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZTempAvatarImageView.h"

@interface MZTempAvatarImageView()

@property (nonatomic, readonly) NSArray* colorList;
@property (nonatomic, readonly) UIColor* randomColor;
@property (nonatomic, strong) UILabel* lblName;
@property (nonatomic, strong) UIView* backgroundView;
@property (nonatomic, strong) UIImageView* largerImageView;
@end

@implementation MZTempAvatarImageView

- (NSArray*)colorList{
    return @[UIColorFromRGB(0xa0cc66),
             UIColorFromRGB(0x66cc66),
             UIColorFromRGB(0xcc6666),
             UIColorFromRGB(0x6688cc),
             UIColorFromRGB(0xb866cc),
             UIColorFromRGB(0x66b5cc),
             UIColorFromRGB(0x66cc9b),
             UIColorFromRGB(0xac66cc),
             UIColorFromRGB(0x66cc9b)];
}

- (UIColor*)randomColor{
    NSArray* colors = self.colorList;
    int r = arc4random() % colors.count;
    return [colors objectAtIndex:r];
}
-(UILabel *)lblName{
    if (_lblName)
        return _lblName;
    
    _lblName = [[UILabel alloc]initWithFrame:self.bounds];
    _lblName.textAlignment = NSTextAlignmentCenter;
    _lblName.backgroundColor = [UIColor clearColor];
    _lblName.textColor = [UIColor whiteColor];
    _lblName.font = [UIFont fontWithName:@"Avenir-Light" size:30];
    [self addSubview:_lblName];
    return _lblName;
}

- (void)setupView{
    self.backgroundColor = self.randomColor;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    UITapGestureRecognizer* tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tap];
}

-(void)setName:(NSString *)name{
    _name = name;
    NSString* firstChar = [[name substringToIndex:1] capitalizedString];
    self.lblName.text = firstChar;
}

-(void)setImage:(UIImage *)image{
    if (image!=nil){
        [super setImage:image];
        [self.lblName setHidden:YES];
    }else{
        [super setImage:nil];
        [self.lblName setHidden:NO];
    }
}

-(void)setRounded:(BOOL)rounded{
    _rounded = rounded;
    if (rounded){
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2.0;
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark -
- (IBAction)didTapToClose:(id)sender{
    [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.largerImageView.alpha = 0;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.largerImageView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
    }];
}

- (IBAction)didTap:(id)sender{
    self.backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
   self.largerImageView = [[UIImageView alloc]initWithImage:self.image];
    self.largerImageView.frame = self.frame;
    self.largerImageView.layer.cornerRadius = self.frame.size.width /2.0f;
    self.largerImageView.clipsToBounds = YES;
    self.largerImageView.alpha = 0;
    self.backgroundView.alpha = 0;
    [self.backgroundView addSubview:self.largerImageView];
    [UIApplication.sharedApplication.delegate.window addSubview:self.backgroundView];
    UITapGestureRecognizer* tapToClose = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapToClose:)];
    [self.backgroundView addGestureRecognizer:tapToClose];
    __block CGRect rect = self.frame;
    rect.size.width = [UIScreen mainScreen].bounds.size.width - 30;
    rect.size.height = rect.size.width;
    [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.largerImageView.alpha = 1;
        self.backgroundView.alpha = 1;
        self.largerImageView.layer.cornerRadius = rect.size.width /2.0f;
        self.largerImageView.frame = rect;
        self.largerImageView.center = CGPointMake(UIApplication.sharedApplication.delegate.window.bounds.size.width/2, UIApplication.sharedApplication.delegate.window.bounds.size.height/2);
    } completion:^(BOOL finished) {
     
    }];
    
}

@end
