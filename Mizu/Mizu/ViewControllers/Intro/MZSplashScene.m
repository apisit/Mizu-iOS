//
//  MZSplashScene.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/24/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZSplashScene.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
@interface MZSplashScene()

@property (nonatomic, strong) NSMutableArray* listTexture;
@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic, strong) NSMutableArray* nodeList;
@property (nonatomic, strong) SKAction* blopSound;
@property (nonatomic, assign) BOOL leftSide;
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation MZSplashScene

#define degreesToRadians(d) (M_PI * (d) / 180.0f)

-(NSMutableArray *)listTexture{
    if (_listTexture)
        return _listTexture;
    
    _listTexture = [[NSMutableArray alloc]init];
    
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self BEGINSWITH 'food_'"];
    NSArray *onlyFoodIcons = [dirContents filteredArrayUsingPredicate:fltr];
    _listTexture = [NSMutableArray arrayWithArray:onlyFoodIcons];
    return _listTexture;
}

- (NSString*)nodeName{
    NSString* name = [NSString stringWithFormat:@"node-%ld",(unsigned long)self.nodeList.count];
    [self.nodeList addObject:name];
    
    if (self.nodeList.count==100){
        [self clearAllNode];
    }
    return name;
}


-(NSString*)randomTexture{
    int index = arc4random() % self.listTexture.count;
    return [self.listTexture objectAtIndex:index];
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor whiteColor];
        self.nodeList = [[NSMutableArray alloc]init];
        
        CGRect physicFrame = self.frame;
        physicFrame.size.height += 50;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:physicFrame];
        self.physicsWorld.gravity = CGVectorMake(0, -0.05);
        
        SKNode* floor = [SKNode node];
        floor.position = CGPointMake(0, 20);
        floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 0)];
        floor.physicsBody.dynamic = NO;
        [self addChild:floor];
        
        self.blopSound = [SKAction playSoundFileNamed:@"blop.m4a" waitForCompletion:NO];
  
       
        
        self.motionManager = [[CMMotionManager alloc]init];
        if ([self.motionManager isAccelerometerAvailable] == YES) {
            NSTimeInterval updateInterval = 0.50;
            [self.motionManager setAccelerometerUpdateInterval:updateInterval];
            [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                CGFloat x = accelerometerData.acceleration.x;
                CGFloat y = accelerometerData.acceleration.y;
                self.physicsWorld.gravity = CGVectorMake(x, y);
            }];
        }
    }
    return self;
}

- (void)addNewNode:(id)sender{
    CGFloat randomX = arc4random() % (int)(self.frame.size.width);
    CGFloat x = randomX;
    CGFloat y = self.frame.size.height + 20;
    [self addChild:[self newParticle:CGPointMake(x, y)]];
}


- (void)popout:(CGPoint)point{
    SKAction *newIcon = [SKAction runBlock:^{
        UIImage* image = [UIImage imageNamed:[self randomTexture]];
        
        SKSpriteNode* node = [SKSpriteNode spriteNodeWithImageNamed:[self randomTexture]];
        CGFloat width = image.size.width;
        node.name = [self nodeName];
        node.position = CGPointMake(self.frame.size.width/2,(self.frame.size.height/2)+20);
        node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:width/2];
        node.physicsBody.dynamic = YES;
        node.physicsBody.affectedByGravity = YES;
        node.physicsBody.allowsRotation = YES;
        node.physicsBody.usesPreciseCollisionDetection = YES;
        node.zRotation = degreesToRadians(arc4random() % (int)360.0);
        [self addChild:node];
        CGFloat vX = self.leftSide?2:-2;
        self.leftSide =! self.leftSide;
        CGFloat randomVectorY = ((arc4random() % 100)/100.0f);
        randomVectorY = MAX(0.8,randomVectorY);
        [node.physicsBody applyImpulse:CGVectorMake(vX,6)];
    }];
    BOOL playing = [AVAudioSession sharedInstance].isOtherAudioPlaying;
    if (playing){
        [self runAction:[SKAction group:@[newIcon]]];
    }else{
        [self runAction:[SKAction group:@[newIcon,self.blopSound]]];
    }
}


- (SKNode *)newParticle:(CGPoint)position
{
    UIImage* image = [UIImage imageNamed:[self randomTexture]];
    SKSpriteNode* node = [SKSpriteNode spriteNodeWithImageNamed:[self randomTexture]];
    CGFloat width = image.size.width;
    node.name = [self nodeName];
    node.position = position;
    node.physicsBody.dynamic = YES;
    node.physicsBody.affectedByGravity = YES;
    node.physicsBody.allowsRotation = YES;
    node.physicsBody.angularVelocity = 1;
    node.physicsBody.usesPreciseCollisionDetection = YES;
    node.zRotation = degreesToRadians(arc4random() % (int)360.0);
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:width/2];
    return node;
}

- (void)clearAllNode{
    if (self.children==nil || self.children.count==0){
        return;
    }
    [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint center = CGPointMake(self.frame.size.width/2,(self.frame.size.height/2));
        SKAction* move = [SKAction moveTo:center duration:1.0];
        move.timingMode = SKActionTimingEaseInEaseOut;
        SKAction* scale = [SKAction scaleTo:0 duration:1.0];
        SKNode* node = obj;
        SKAction *group = [SKAction group:@[move, scale]];
        [node runAction:group completion:^{
            [node removeFromParent];
            [self.nodeList removeObject:node.name];
        }];
    }];
}

-(void)shake{
    [self clearAllNode];
}

-(void)endShake{

}

- (void)pause{
    [self.timer invalidate];
    self.timer=nil;
}
- (void)start{
    CGFloat time = 1.0;
     self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(addNewNode:) userInfo:nil repeats:YES];
    [self.timer fire];
}

@end
