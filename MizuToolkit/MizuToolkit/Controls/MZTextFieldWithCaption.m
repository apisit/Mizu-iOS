//
//  MZTextFieldWithCaption.m
//  Mizu
//
//  Created by Apisit Toompakdee on 1/16/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZTextFieldWithCaption.h"
#import "MZColor.h"
@interface MZTextFieldWithCaption()
@property (nonatomic, strong) UITapGestureRecognizer* tapToResign;
@end

@implementation MZTextFieldWithCaption

-(void)dealloc{
    [self.lblTitle removeFromSuperview];
    self.lblTitle = nil;
    if (self.tapToResign)
        [self.superview.superview removeGestureRecognizer:self.tapToResign];
    [super resignFirstResponder];
}

-(void)tap:(UITapGestureRecognizer*)gesture{
    [self resignFirstResponder];
}

-(BOOL)resignFirstResponder{
    BOOL returnValue = [super resignFirstResponder];
    if (returnValue){
        [self.superview.superview removeGestureRecognizer:self.tapToResign];
    }
    return returnValue;
}

-(BOOL)becomeFirstResponder{
    
    if (!self.isFirstResponder){
        self.tapToResign = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self.superview.superview addGestureRecognizer:self.tapToResign];
    }
    [super becomeFirstResponder];
    return YES;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.lblTitle.text = title;
}

- (void)setupView{
    self.font = [UIFont fontWithName:@"Avenir-Medium" size:self.font.pointSize];
    //self.textColor = UIColorFromRGB(0x444444);
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width*0.3f, self.frame.size.height);
    
    self.lblTitle = [[UILabel alloc]initWithFrame:rect];
    self.lblTitle.font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Black",@"Avenir"] size:self.font.pointSize];
    self.lblTitle.textColor = [MZColor subTitleColor];
    
    self.lblTitle.text = NSLocalizedString(self.title, nil) ;
    self.lblTitle.backgroundColor = [UIColor clearColor];
    self.lblTitle.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.lblTitle];
}

- (void)drawRect:(CGRect)rect
{
    
    struct CGColor* strokeColor = [MZColor tableSeparatorColor].CGColor;
    if (self.showSeparator){
        CAShapeLayer* line = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, self.frame.size.height);
        CGPathAddLineToPoint(path, NULL, self.frame.size.width, self.frame.size.height);
        line.path = path;
        line.lineWidth = 1;
        line.frame = rect;
        line.strokeColor = strokeColor;
        [self.layer addSublayer:line];
        CGPathRelease(path);
    }
    
    if (self.showTopSeparator){
        CAShapeLayer* line = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, self.frame.size.width,0);
        line.path = path;
        line.lineWidth = 1;
        line.frame = rect;
        line.strokeColor = strokeColor;
        [self.layer addSublayer:line];
        CGPathRelease(path);
    }
    
    UIRectCorner rectCorner = UIRectCornerAllCorners;
    
    if (self.showTopCornerRadius){
        rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight;
    }
    
    if (self.showBottomCornerRadius){
        rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }
    
    if (self.showBottomCornerRadius && self.showTopCornerRadius){
        rectCorner = UIRectCornerAllCorners;
    }
    
    
    if (self.showTopCornerRadius || self.showBottomCornerRadius){
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(rectCorner) cornerRadii:CGSizeMake(5.0, 5.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}


- (CGRect)textRectForBounds:(CGRect)bounds {
    if (self.hideCaption){
        return bounds;
    }
    return CGRectMake((bounds.size.width*0.3)+12, bounds.origin.y , bounds.size.width-((bounds.size.width*0.3)+30) , bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

-(void)prepareForInterfaceBuilder{
    [self setupView];
}

-(void)awakeFromNib{
    [self setupView];
}

-(void)drawPlaceholderInRect:(CGRect)rect{
    [self setValue:[self.textColor colorWithAlphaComponent:0.4] forKeyPath:@"_placeholderLabel.textColor"];
    [super drawPlaceholderInRect:rect];
}

@end
