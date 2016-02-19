//
//  MZParticleView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/17/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZParticleView.h"

@interface MZParticleView()

@property (nonatomic,strong) CAEmitterLayer* emitter;
@property (strong, nonatomic) NSArray *emitterCells;
- (void)setupEmitter;

@end

@implementation MZParticleView

-(void)setupEmitter{
    self.clipsToBounds = NO;
    
    CAEmitterCell *explosionCell = [CAEmitterCell emitterCell];
    explosionCell.name = @"explosion";
    explosionCell.alphaRange = 0.20;
    explosionCell.alphaSpeed = -1.0;
    explosionCell.lifetime = 2.0;
    //explosionCell.lifetimeRange = 0.3;
    explosionCell.birthRate = 0;
    explosionCell.velocity = 20.00;
   // explosionCell.velocityRange = 10.00;
   // explosionCell.emissionLongitude = -M_PI / 2;
   // explosionCell.emissionLatitude =  -M_PI / 2;
    explosionCell.yAcceleration = -90.0f;
    //explosionCell.emissionRange = M_PI / 4;
    
    self.emitter = [CAEmitterLayer layer];
    self.emitter.emitterPosition = CGPointMake(50, 0);
    self.emitter.emitterSize = CGSizeMake(5, 5);
     self.emitter.emitterShape = kCAEmitterLayerSphere;
     self.emitter.emitterMode = kCAEmitterLayerOutline;
     self.emitter.emitterSize = CGSizeMake(25, 0);
     self.emitter.emitterCells = @[explosionCell];
     self.emitter.renderMode = kCAEmitterLayerOldestFirst;
     self.emitter.masksToBounds = NO;
     self.emitter.seed = 43545436;
    self.emitter.beginTime = CACurrentMediaTime();
    [self.layer addSublayer:self.emitter];
     self.emitterCells = @[explosionCell];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.emitter.emitterPosition = center;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupEmitter];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEmitter];
    }
    return self;
}

#pragma mark - Methods

- (void)animate {
     [self explode];
}

- (void)explode {
    [self.emitter setValue:@30 forKeyPath:@"emitterCells.explosion.birthRate"];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [self stop];
    });
}

- (void)stop {
    [self.emitter setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}

#pragma mark - Properties

- (void)setParticleImage:(UIImage *)particleImage {
    _particleImage = particleImage;
    for (CAEmitterCell *cell in self.emitterCells) {
        cell.contents = (id)[particleImage CGImage];
    }
}

- (void)setParticleScale:(CGFloat)particleScale {
    _particleScale = particleScale;
    for (CAEmitterCell *cell in self.emitterCells) {
        cell.scale = particleScale;
    }
}

- (void)setParticleScaleRange:(CGFloat)particleScaleRange {
    _particleScaleRange = particleScaleRange;
    for (CAEmitterCell *cell in self.emitterCells) {
        cell.scaleRange = particleScaleRange;
    }
}
@end
