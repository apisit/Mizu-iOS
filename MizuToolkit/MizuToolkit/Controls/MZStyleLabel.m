//
//  MZStyleLabel.m
//  Mizu
//
//  Created by Apisit Toompakdee on 5/25/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZStyleLabel.h"

@implementation MZStyleLabel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self renderBoldTag];
}
- (void) setHtml: (NSString*) html
{
    NSError *err = nil;
    self.attributedText =
    [[NSAttributedString alloc]
     initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
     options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
     documentAttributes: nil
     error: &err];
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
}

-(void)renderBoldTag
{
    if ([self respondsToSelector:@selector(setAttributedText:)])
    {
        
        UIFont *boldFont = [UIFont fontWithName:@"Avenir-Black" size:15];
        
        // Create the attributes
        NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                  boldFont, NSFontAttributeName,nil];
        
        
        
        NSString *aText = [NSString stringWithFormat:@"%@",self.text];
        NSRange start = [aText rangeOfString:@"<b>"];
        NSRange end = [aText rangeOfString:@"</b>"];
        if(end.length > 0)
        {
            aText = [aText stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
            aText = [aText stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
            [self setText:aText];
            
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text
                                                                                               attributes:nil];
            
            NSRange boldRange = NSMakeRange(start.location, end.location-start.location-3);
            
            [attributedText setAttributes:subAttrs range:boldRange];
            
            [self setAttributedText:attributedText];
        }
    }
}

@end
