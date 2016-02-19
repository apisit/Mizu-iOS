//
//  MZCustomKerningLabel.m
//  MizuToolkit
//
//  Created by Apisit Toompakdee on 11/14/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZCustomKerningLabel.h"

@implementation MZCustomKerningLabel

- (void)setupView{
    self.clipsToBounds = YES;
}

-(void)setText:(NSString *)text{
    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSKernAttributeName value:@0.8 range:NSMakeRange(0,text.length)];
    [self setAttributedText:attributedString];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}



@end
