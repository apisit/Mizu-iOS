//
//  MZSplashScene.h
//  Mizu
//
//  Created by Apisit Toompakdee on 4/24/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@interface MZSplashScene : SKScene

- (void)shake;
- (void)endShake;
- (void)clearAllNode;
- (void)popout:(CGPoint)point;
- (void)pause;
- (void)start;
@end
