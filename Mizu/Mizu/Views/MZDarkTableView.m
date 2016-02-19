//
//  MZDarkTableView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 10/30/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZDarkTableView.h"

@implementation MZDarkTableView

- (void)setupView{
    self.backgroundColor = [MZColor tableBackgroundColor];
    self.separatorColor = [MZColor tableSeparatorColor];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)prepareForInterfaceBuilder{
    [super prepareForInterfaceBuilder];
    [self setupView];
}

@end
