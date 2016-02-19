//
//  PSCheckoutTransition.h
//  Print Studio 2
//
//  Created by Apisit Toompakdee on 5/21/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZMovingLeftTransition : NSObject<UIViewControllerAnimatedTransitioning>
-(id)initWithOperation:(UINavigationControllerOperation)viewOperation;
+(id)withOperation:(UINavigationControllerOperation)viewOperation;
@end
