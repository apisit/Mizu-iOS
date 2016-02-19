//
//  PSAlertView.m
//  Print Studio 2
//
//  Created by Apisit Toompakdee on 7/10/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "APAlertView.h"

@interface APAlertView()



@end

@implementation APAlertView

static NSInteger dialogViewTag = 99;
static UIView* backgroundView;
static PSAlertViewDismissBlock _didDismiss;
static PSAlertViewCancelBlock _didCancel;
static CGRect _fromRect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (void)closePopup:(NSInteger)buttonIndex{
    UIView* dialogView = [backgroundView viewWithTag:dialogViewTag];
    [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        dialogView.alpha=0;
        backgroundView.alpha=0;
        dialogView.frame = _fromRect;
    } completion:^(BOOL finished) {
        if (finished)
            [backgroundView removeFromSuperview];
    }];
    
    if (buttonIndex==-1){
        _didCancel();
    }else{
        _didDismiss(buttonIndex);
    }
}

+ (void)didTap:(id)sender{
    UIButton *btn = sender;
    [self closePopup:btn.tag];
}

+ (void)alertWithTitle:(NSString*)title message:(NSString*)message fromRect:(CGRect)fromRect cancelButtonTitle:(NSString*)cancelTitle otherButtonTitles:(NSArray*)otherTitles onDismiss:(PSAlertViewDismissBlock)onDismiss onCancel:(PSAlertViewCancelBlock)onCancel{

    _didDismiss = onDismiss;
    _didCancel = onCancel;
    _fromRect = fromRect;
    
    UIFont* defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
     UIFont* titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    UIColor* dialogColor = [UIColorFromRGB(0x56b440) colorWithAlphaComponent:0.9];//[[UIColor whiteColor] colorWithAlphaComponent:0.9];
    UIColor* buttonBackGroundColor = UIColorFromRGB(0x4ea238);
    UIColor* textColor = [UIColor whiteColor];
    UIWindow* window= [[UIApplication sharedApplication] keyWindow];
    CGRect screenRect= [UIScreen mainScreen].bounds;
    backgroundView= [[UIView alloc]initWithFrame:screenRect];
    backgroundView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    CGFloat width = 260;
    CGFloat height = 100;
    CGFloat x = (screenRect.size.width - width) /2;
    CGFloat y = (screenRect.size.height - height) /2 - 100;
    CGRect dialogRect = CGRectMake(x, y, width, height);

    UIView* dialogView = [[UIView alloc]initWithFrame:dialogRect];
    dialogView.tag = dialogViewTag;
    dialogView.backgroundColor = [UIColor clearColor];
    dialogView.clipsToBounds=YES;
    dialogView.backgroundColor = dialogColor;
    dialogView.layer.cornerRadius=6;
    dialogView.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogView.layer.shadowOffset = CGSizeMake(1, 1);
    dialogView.layer.shadowOpacity = 1.0;
    dialogView.layer.masksToBounds = YES;
    
    CGRect titleRect= CGRectMake(0, 0, CGRectGetWidth(dialogRect)-40, 40);
    UILabel* titleView= [[UILabel alloc]initWithFrame:titleRect];
    titleView.alpha=0;
    titleView.text=title;
    titleView.font=titleFont;
    titleView.textAlignment=NSTextAlignmentCenter;
    titleView.textColor=textColor;
    titleView.autoresizesSubviews=YES;
    titleView.clipsToBounds=YES;
    titleView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    titleView.backgroundColor=[UIColor clearColor];
    titleView.numberOfLines = 0;
   // [titleView sizeToFit];
    [dialogView addSubview:titleView];
    
    CGRect messageRect = CGRectMake(0, 0, CGRectGetWidth(dialogRect)-80, 80);
    UILabel* messageView= [[UILabel alloc]initWithFrame:messageRect];
    messageView.alpha=0;
    messageView.numberOfLines = 0;
    messageView.text=message;
    messageView.font=defaultFont;
    messageView.textAlignment=NSTextAlignmentCenter;
    messageView.textColor=textColor;
    messageView.autoresizesSubviews=YES;
    messageView.clipsToBounds=YES;
    messageView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    messageView.backgroundColor=[UIColor clearColor];
    
    if (message){
        UIFont *messageFont = defaultFont;
        CGSize messageSize = [message sizeWithAttributes:@{NSFontAttributeName:messageFont}];
        [dialogView addSubview:messageView];
        dialogRect.size.height+=(messageSize.height+10);
        messageRect.size.height=dialogRect.size.height;
        messageView.frame=messageRect;
    }
    
    dialogView.alpha=0;
    dialogView.frame=fromRect;
    [backgroundView addSubview:dialogView];
    [window addSubview:backgroundView];
   
    UIButton* btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(dialogRect)-43, otherTitles==nil?CGRectGetWidth(dialogRect):130, 44)];
    btnCancel.tag = -1; //fix tag for cancel button
    [btnCancel setTitle:cancelTitle forState:UIControlStateNormal];
    btnCancel.titleLabel.font = titleFont;
    [btnCancel setTitleColor:textColor forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnCancel addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.backgroundColor = buttonBackGroundColor;
    [dialogView addSubview:btnCancel];
    
    if (otherTitles!=nil){
        UIButton* btnOther = [[UIButton alloc]initWithFrame:CGRectMake(131, CGRectGetHeight(dialogRect)-43, 129, 44)];
        btnOther.tag = 0; //fix tag for cancel button
        [btnOther setTitle:[otherTitles firstObject] forState:UIControlStateNormal];
        btnOther.titleLabel.font = titleFont;
        [btnOther setTitleColor:textColor forState:UIControlStateNormal];
        [btnOther setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [btnOther addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
        btnOther.backgroundColor = buttonBackGroundColor;
        [dialogView addSubview:btnOther];
    }
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        dialogView.alpha=1;
        dialogView.frame=dialogRect;
        titleView.alpha=1;
        messageView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
@end
