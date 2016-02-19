//
//  MZRaterView.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidRate)(double rate);

@interface MZRaterView : UIView

@property (nonatomic, assign) IBInspectable double rate;
@property (nonatomic, assign) IBInspectable NSInteger maxRate;
@property (nonatomic, assign) IBInspectable NSInteger minRate;
@property (nonatomic, strong) IBInspectable UIImage* starImage;
@property (nonatomic, strong) IBInspectable UIImage* starFilledImage;

- (void)didRate:(DidRate)block;

@end
