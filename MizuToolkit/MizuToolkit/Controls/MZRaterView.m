//
//  MZRaterView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZRaterView.h"

@interface MZRaterView(){
    DidRate _block;
}

@property (nonatomic, strong) NSMutableArray* stars;

@end

@implementation MZRaterView

-(void)drawRect:(CGRect)rect{
    [self setupView];
}

-(void)setupView{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat spacing = 6.0;
    CGFloat starWidth = (width - ((self.maxRate * 2))) / (self.maxRate);
    self.stars = [[NSMutableArray alloc]init];
    for (NSInteger i=0;i<self.maxRate;i++){
        CGFloat x = spacing + (i*starWidth);
        CGRect rect = CGRectMake(x, 0, starWidth, height);
        UIButton* btn = [[UIButton alloc]initWithFrame:rect];
        btn.tag = i;
        UIImage *image = [self.starImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        btn.tintColor = UIColorFromRGB(0x4c4c4c);
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:self.starFilledImage forState:UIControlStateSelected];
        [btn setImage:self.starFilledImage forState:UIControlStateHighlighted | UIControlStateSelected];
        
        [btn addTarget:self action:@selector(didTapStar:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
        [self.stars addObject:btn];
    }
}
-(void)didRate:(DidRate)block{
    _block = block;
}

- (IBAction)didTapStar:(UIButton*)sender{
    [sender setSelected:YES];
    NSInteger index = sender.tag;
    for(UIButton* btn in self.stars){
        [btn setSelected:NO];
        if (btn.tag<=index){
            [btn setSelected:YES];
        }
    }
    self.rate = index+1;
    if (_block)
        _block(self.rate);
}

@end
