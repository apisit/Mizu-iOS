//
//  MZCheckInHistoryTableViewCell.m
//  Mizu
//
//  Created by Apisit Toompakdee on 11/4/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZCheckInHistoryTableViewCell.h"

@interface MZCheckInHistoryTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblRefunded;


@end

@implementation MZCheckInHistoryTableViewCell

- (void)setupView{
    [MZColor styleTableViewCell:self];
    self.lblTitle.textColor = [MZColor titleColor];
    self.lblSubTitle.textColor = [MZColor subTitleColor];
    self.lblSubTotal.textColor = [MZColor titleColor];
    self.lblTitle.text =self.data.business.name;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSMutableString* subtitleString = [[NSMutableString alloc]init];
    [subtitleString appendString:@"★★★★★"];
    //    for(NSInteger i=0;i<5;i++){
    //        if (i<self.data.feedback.rating){
    //            [subtitleString appendString:@"★"];
    //        }else{
    //            [subtitleString appendString:@"★"];
    //        }
    //    }
    if (self.data.feedback.comment.length>0){
        [subtitleString appendFormat:@"\n“%@”",self.data.feedback.comment];
    }
    [subtitleString appendFormat:@"\n%@",[dateFormatter stringFromDate:self.data.createdDate]];
    
    NSMutableAttributedString *subTitleAttributeString = [[NSMutableAttributedString alloc] initWithString:subtitleString];
    NSRange subTitleTextRange = NSMakeRange(0, self.data.feedback.rating);
    [subTitleAttributeString setAttributes:@{NSForegroundColorAttributeName:[MZColor mizuColor]} range:subTitleTextRange];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:1.2];
    [paragrahStyle setMaximumLineHeight:30];
    NSDictionary *paragraphAttribute = @{NSParagraphStyleAttributeName : paragrahStyle,};
    [subTitleAttributeString addAttributes:paragraphAttribute range:NSMakeRange(0,subtitleString.length)];
    
    self.lblSubTitle.attributedText = subTitleAttributeString;
    
    self.lblSubTotal.text = self.data.transaction.formattedTotalAmount;
    self.lblRefunded.hidden = !self.data.transaction.refunded;
    
    if (self.data.transaction.refunded){
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString: self.lblSubTotal.text];
        NSRange textRange = NSMakeRange(0, [attributeString length]);
        [attributeString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:15]} range:textRange];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:textRange];
        
        self.lblSubTotal.attributedText = attributeString;
        
        
        NSString* newTotal = [NSString stringWithFormat:@"NEW TOTAL %@",self.data.transaction.formattedNewTotalAmount];
        self.lblRefunded.text = [NSString stringWithFormat:@"REFUNDED %@\n%@",self.data.transaction.formattedRefundedAmount,newTotal];
        
        NSMutableAttributedString *refundedAttributeString = [[NSMutableAttributedString alloc] initWithString:self.lblRefunded.text];
        NSRange subTotalTextRange = [self.lblRefunded.text rangeOfString:newTotal];
        [refundedAttributeString setAttributes:@{NSForegroundColorAttributeName:[MZColor titleColor]} range:subTotalTextRange];
        self.lblRefunded.attributedText = refundedAttributeString;
        
    }else{
        self.lblSubTotal.textColor = [MZColor titleColor];
    }
}

-(void)setData:(MZCheckIn *)data{
    _data = data;
    [self setupView];
}

@end
