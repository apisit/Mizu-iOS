//
//  MZTagCircleView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 1/14/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZTagCircleView.h"

@interface MZTagCircleView()

@property (nonatomic,assign) BOOL rendered;

@end

@implementation MZTagCircleView
- (void)didTapTag:(id)sender{
    
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return [super canPerformAction:action withSender:sender];
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)didTapButton:(UIButton*)sender{
    NSString* tag = [self.tags objectAtIndex:sender.tag];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *tagMenuItem = [[UIMenuItem alloc] initWithTitle:tag action:@selector(didTapTag:)];
    [menuController setMenuItems:[NSArray arrayWithObject:tagMenuItem]];
    [self becomeFirstResponder];
    [menuController setTargetRect:sender.frame inView:self];
    [menuController setMenuVisible:YES animated:YES];
}

- (UIImage*)imageForTag:(NSString*)tag{
    NSString* imageName = [tag stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    imageName =  [NSString stringWithFormat:@"%@.png",imageName];
    return [UIImage imageNamed:imageName];
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setupView{
    for(UIView* sub in self.subviews){
        [sub removeFromSuperview];
    }
    NSInteger index = 0;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSMutableString* hConstraintFormat = [[NSMutableString alloc]init];
    if (self.tags.count==0)
        return;
    
    [hConstraintFormat appendString:@"H:|"];
    for(NSString* tag in self.tags){
        UIImage* img =  [self imageForTag:tag];
        if (img){
            CGRect rect = CGRectZero;
            UIButton* btn = [[UIButton alloc]initWithFrame:rect];
            NSString* viewName = [tag stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            [dic setObject:btn forKey:viewName];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            [hConstraintFormat appendFormat:@"-%d-[%@(20)]",index>0?5:0,viewName];
            [btn setImage:img forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = index;
            index++;
            [self addSubview:btn];
            NSString* v = [NSString stringWithFormat:@"V:|[%@]",@"btn"];
            NSArray *constraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:v
                                    options:0
                                    metrics:nil
                                    views:NSDictionaryOfVariableBindings(btn)];
            [self addConstraints:constraints];
        }
    }
    NSArray *viewConstraints =   [NSLayoutConstraint constraintsWithVisualFormat:hConstraintFormat options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:dic];
    [self addConstraints:viewConstraints];
    self.rendered = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

-(void)setTags:(NSArray *)tags{
    _tags = tags;
    [self setupView];
}
@end
