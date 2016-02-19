//
//  MZBaseTextField.m
//  MizuToolkit
//
//  Created by Apisit Toompakdee on 11/5/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZBaseTextField.h"

@interface MZBaseTextField()
@property UITapGestureRecognizer* tapToResign;

@end

@implementation MZBaseTextField

-(void)dealloc{
    if (self.tapToResign)
        [self removeGestureRecognizer:self.tapToResign];
    [super resignFirstResponder];
}

-(void)drawPlaceholderInRect:(CGRect)rect{
    [self setValue:[self.textColor colorWithAlphaComponent:0.4] forKeyPath:@"_placeholderLabel.textColor"];
    [super drawPlaceholderInRect:rect];
}

-(void)tap:(UITapGestureRecognizer*)gesture{
    [self resignFirstResponder];
}

-(BOOL)resignFirstResponder{
    BOOL returnValue = [super resignFirstResponder];
    if (returnValue){
        [UIApplication.sharedApplication.delegate.window removeGestureRecognizer:self.tapToResign];
    }
    return returnValue;
}

-(BOOL)becomeFirstResponder{
    
    if (!self.isFirstResponder){
        self.tapToResign =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [UIApplication.sharedApplication.delegate.window addGestureRecognizer:self.tapToResign];
    }
    [super becomeFirstResponder];
    return YES;
}
@end
