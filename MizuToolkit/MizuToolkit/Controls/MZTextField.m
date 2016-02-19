//
//  PSTextField.m
//  TableViewCellAnimatingSample
//
//  Created by Apisit Toompakdee on 5/6/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZTextField.h"
@interface MZTextField()
{
    UITapGestureRecognizer* tapToResign;
}
@end

@implementation MZTextField

- (void)setupView{
    self.borderStyle=UITextBorderStyleNone;
    self.clipsToBounds=NO;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setupView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)dealloc{
    if (tapToResign)
        [self removeGestureRecognizer:tapToResign];
    [super resignFirstResponder];
}


-(void)tap:(UITapGestureRecognizer*)gesture{
    [self resignFirstResponder];
}

- (void)drawRect:(CGRect)rect
{
    CAShapeLayer* line = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, self.frame.size.height);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width, self.frame.size.height);
    line.path = path;
    line.lineWidth = 1;
    line.frame = rect;
    line.strokeColor = [self.textColor colorWithAlphaComponent:0.4].CGColor;
    [self.layer addSublayer:line];
    CGPathRelease(path);
}

-(void)drawPlaceholderInRect:(CGRect)rect{
    [self setValue:[self.textColor colorWithAlphaComponent:0.4] forKeyPath:@"_placeholderLabel.textColor"];
    [super drawPlaceholderInRect:rect];
}

-(BOOL)resignFirstResponder{
    BOOL returnValue = [super resignFirstResponder];
    if (returnValue){
        [self.superview removeGestureRecognizer:tapToResign];
    }
    CAShapeLayer* line= (CAShapeLayer*)[self.layer.sublayers objectAtIndex:0];
    line.lineWidth = 1;
    return returnValue;
}
-(BOOL)becomeFirstResponder{
    
    if (!self.isFirstResponder){
        tapToResign =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self.superview addGestureRecognizer:tapToResign];
//        CAShapeLayer* line= [self.layer.sublayers objectAtIndex:0];
//        line.lineWidth = 1.5;
    }
    [super becomeFirstResponder];
    return YES;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y , bounds.size.width-5 , bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
