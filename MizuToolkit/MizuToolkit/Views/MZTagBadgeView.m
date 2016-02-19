//
//  MZTagBadgeView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 6/21/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZTagBadgeView.h"
#import "MZTagBadgeViewButton.h"
#import "NSString+Utilities.h"
@interface MZTagBadgeView()

@property (nonatomic,assign) BOOL rendered;
@property (nonatomic, assign) NSInteger line;
@end

@implementation MZTagBadgeView

+ (CGFloat)heightByTags:(NSArray*)tags width:(CGFloat)width{
    NSInteger numberOfLine = 0;
    CGFloat lineWidth = 0;
    for(NSString* tag in tags){
        NSString* title = [tag uppercaseString];
        if (title.length>0){
            UIFont* font = [UIFont fontWithName:@"Avenir-Medium" size:10];
            CGFloat labelWidth = [title textWidthWithFont:font] + 12;
            lineWidth = lineWidth + labelWidth;
            if (lineWidth>width){
                numberOfLine++;
                lineWidth=0;
            }
        }
    }
    return ((numberOfLine+1) * 24);
}

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


-(void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setupView{
    for(UIView* sub in self.subviews){
        [sub removeFromSuperview];
    }
    self.clipsToBounds = YES;
    NSInteger index = 0;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSMutableString* hConstraintFormat = [[NSMutableString alloc]init];
    if (self.tags.count==0)
        return;
    
    [hConstraintFormat appendString:@"H:|"];
    CGFloat lineWidth = 0;
    self.line = 0;
    BOOL firstButton = YES;
    NSInteger numberOfTagInLine = 0;
    for(NSString* tag in self.tags){
        NSString* title = [tag uppercaseString];
        if (title.length>0){
            numberOfTagInLine++;
            CGRect rect = CGRectZero;
            MZTagBadgeViewButton* btn = [[MZTagBadgeViewButton alloc]initWithFrame:rect];
            btn.backgroundColor = [UIColor clearColor];
            NSString* viewName = [tag stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            [dic setObject:btn forKey:viewName];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            btn.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:10];
            btn.userInteractionEnabled = NO;
            btn.layer.backgroundColor = UIColorFromRGB(0xb3b3b3).CGColor;
            
            btn.highlighted = NO;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = index;
            btn.layer.cornerRadius = 3;
            if (self.onDarkBakcground){
                btn.layer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                //[btn setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
            }
            [self addSubview:btn];
            
            
            CGFloat width = [title textWidthWithFont:btn.titleLabel.font] + 12;
            lineWidth = (lineWidth + width);
            
            if (lineWidth>([UIScreen mainScreen].bounds.size.width - 80)){
                NSArray *viewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hConstraintFormat options:NSLayoutFormatAlignAllBaseline metrics:nil views:dic];
                [self addConstraints:viewConstraints];
                if (index<self.tags.count){
                    hConstraintFormat = [[NSMutableString alloc]init];
                    [hConstraintFormat appendString:@"H:|"];
                    self.line++;
                    lineWidth = 0;
                    firstButton = YES;
                    numberOfTagInLine = 0;
                }
            }
            [hConstraintFormat appendFormat:@"-%d-[%@(%f)]",firstButton?0:4,viewName,width];
            firstButton = NO;
            
            NSString* v = [NSString stringWithFormat:@"V:|-%f-[%@(20)]",self.line*24.0,@"btn"];
            NSArray *constraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:v
                                    options:0
                                    metrics:nil
                                    views:NSDictionaryOfVariableBindings(btn)];
            [self addConstraints:constraints];
            
            index++;
        }
    }
    NSArray *viewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:hConstraintFormat options:NSLayoutFormatAlignAllBaseline metrics:nil views:dic];
    [self addConstraints:viewConstraints];
    
    self.rendered = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.height = ((self.line+1) * 25)-5;
    [self invalidateIntrinsicContentSize];
}


-(CGSize)intrinsicContentSize{
    if  (self.tags.count==0) return CGSizeZero;
    
    CGSize size = CGSizeMake(240,  ((self.line+1) * 25)-5);
    CGRect frame = self.frame;
    frame.size.height = size.height;
    self.height = size.height;
    self.frame = frame;
    return size;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsUpdateConstraints];
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
