//
//  MZManagerCheckInTableViewCell.m
//  Mizu
//
//  Created by Apisit Toompakdee on 9/10/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZManagerCheckInTableViewCell.h"

@interface MZManagerCheckInTableViewCell()

@property (nonatomic, strong) IBOutlet MZTempAvatarImageView* userImageView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblRefunded;

@end

@implementation MZManagerCheckInTableViewCell


- (void)setupView{

    self.userImageView.name = self.data.user.firstname;
    
    if (self.data.user.profilePicture!=nil){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.data.user.profilePicture] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            if (downloadedImage!=nil){
                dispatch_async(dispatch_get_main_queue(), ^ {
                    self.userImageView.image = downloadedImage;
                });
            }
        }];
        [getImageTask resume];
    }
    
    self.lblTitle.text = self.data.user.fullname;
    

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSMutableString* subtitleString = [[NSMutableString alloc]init];
    [subtitleString appendString:@"★★★★★"];

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
        [refundedAttributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:subTotalTextRange];
        self.lblRefunded.attributedText = refundedAttributeString;
        
    }
}
/*
- (void)setupView{
    
        self.lblName.text = self.data.user.fullname;
    
    if (self.data.isCanceled){
        self.lblDetail.text = [NSString stringWithFormat:@"%@\n%@",[self.data.createdDate timeAgo],@"USER CANCELED"];
    }else{
        self.lblDetail.text = [NSString stringWithFormat:@"%@ • %@%@", [self.data.createdDate timeAgo], self.data.transaction.formattedTotalAmount,self.data.transaction.refunded?@" • REFUNDED":@"" ];
        

        NSMutableString* stars = [[NSMutableString alloc]init];
       
        if (self.data.waitingForFeedback){
            [stars appendString:@"WAITING FOR FEEDBACK"];
        }else{
            for(NSInteger i=0;i<5;i++){
                if (i<self.data.feedback.rating){
                    [stars appendString:@"★"];
                }else{
                    [stars appendString:@"☆"];
                }
            }
            
            if (self.data.feedback.comment){
                [stars appendFormat:@" %@",self.data.feedback.comment];
            }
        }
        
        self.lblDetail.text = [NSString stringWithFormat:@"%@\n%@", self.lblDetail.text,stars];
    }
    
  
    
    
    BOOL currentCheckIn = self.data.checked==NO && self.data.waitingForFeedback==NO && self.data.isCanceled==NO;
    
    if (currentCheckIn){
        self.lblDetail.text = [NSString stringWithFormat:@"%@",[self.data.createdDate timeAgo]];
    }
    
}*/

-(void)setData:(MZCheckIn *)data{
    _data = data;
    [self setupView];
}

-(void)prepareForReuse{
    self.userImageView.image = nil;
}
@end
