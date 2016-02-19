//
//  MZLikeButton.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/17/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZLikeButton.h"
#import "MZParticleView.h"
#import "MZHeartAnimation.h"
#import "UIView+Category.h"
@interface MZLikeButton()

@property (nonatomic, strong) UIImageView* heartImageView;
@property (nonatomic, strong) MZParticleView* particleView;
//@property (nonatomic, strong) MZHeartAnimation* heartAnimation;
@end

@implementation MZLikeButton

-(void)setupView{
    [self addSubview:self.heartImageView];
    self.titleEdgeInsets = UIEdgeInsetsMake(2, 20, 0, 0);
    
    self.particleView = [[MZParticleView alloc] init];
    [self insertSubview:self.particleView atIndex:1];
    self.particleView.frame = _heartImageView.frame;
    self.particleView.particleImage = [UIImage imageNamed:@"heart_red.png"];
    self.particleView.particleScale = 0.2;
    self.particleView.particleScaleRange = 0.01;

//    self.heartAnimation = [[MZHeartAnimation alloc]init];
//    self.heartAnimation.frame = self.heartImageView.frame;
//    [self insertSubview:self.heartAnimation atIndex:0];
    
  
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
        
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    int errorMargin = 10;
    CGRect largerFrame = CGRectMake(0 - errorMargin, 0 - errorMargin, self.frame.size.width + errorMargin, self.frame.size.height + errorMargin);
    return (CGRectContainsPoint(largerFrame, point) == 1) ? self : nil;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected){
        self.heartImageView.image = [UIImage imageNamed:@"heart_red.png"];
    }else{
        self.heartImageView.image = [UIImage imageNamed:@"heart.png"];
    }
}


-(UIImageView *)heartImageView{
    if (_heartImageView!=nil){
        return _heartImageView;
    }
    CGFloat width = 15;
    CGFloat height= 14;
    CGFloat x = 0;
    CGFloat y = ((self.bounds.size.height - height ) / 2);
    _heartImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    _heartImageView.image = [UIImage imageNamed:@"heart.png"];
    return _heartImageView;
}

- (void)like{
      [self.particleView animate];
    [self.heartImageView popOutsideWithDuration:0.4 callBack:^{
      
    }];
   // [self.heartAnimation startAnimating];
}

- (void)unlike{
    [self.heartImageView popInsideWithDuration:0.4];
}

@end
