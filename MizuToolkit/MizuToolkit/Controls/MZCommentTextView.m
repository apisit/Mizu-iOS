//
//  MZCommentTextView.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/19/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZCommentTextView.h"

@interface MZCommentTextView()<UITextViewDelegate>
{
    UITapGestureRecognizer* tapToResign;
}

@end

@implementation MZCommentTextView

-(void)dealloc{
    if (tapToResign)
        [self removeGestureRecognizer:tapToResign];
    [super resignFirstResponder];
}


-(void)tap:(UITapGestureRecognizer*)gesture{
    [self resignFirstResponder];
}

- (void)setupView{
    //self.layer.cornerRadius = 6;
  //  self.layer.borderColor = UIColorFromRGB(0xc8c7cb).CGColor;
    //self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
    self.placeholder = @"Add comment (optional)";
    self.textColor = [UIColor lightGrayColor];
    self.text = self.placeholder;
    self.delegate = self;
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

-(BOOL)resignFirstResponder{
    BOOL returnValue = [super resignFirstResponder];
    if (returnValue){
        [UIApplication.sharedApplication.delegate.window removeGestureRecognizer:tapToResign];
    }
    return returnValue;
}

-(BOOL)becomeFirstResponder{
    
    if (!self.isFirstResponder){
        tapToResign =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [UIApplication.sharedApplication.delegate.window addGestureRecognizer:tapToResign];

    }
    [super becomeFirstResponder];
    return YES;
}


- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 12, 12);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 12, 12);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.placeholder]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeholder;
        textView.textColor = UIColorFromRGB(0x858585);
    }
    [textView resignFirstResponder];
}

@end
