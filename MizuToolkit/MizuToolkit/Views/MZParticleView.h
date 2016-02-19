//
//  MZParticleView.h
//  Mizu
//
//  Created by Apisit Toompakdee on 4/17/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZParticleView : UIView
@property (strong, nonatomic) UIImage *particleImage;
@property (assign, nonatomic) CGFloat particleScale;
@property (assign, nonatomic) CGFloat particleScaleRange;
- (void)animate;
@end
