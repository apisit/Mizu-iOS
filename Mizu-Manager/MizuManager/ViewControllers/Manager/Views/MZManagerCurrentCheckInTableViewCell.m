//
//  MZManagerCurrentCheckInTableViewCell.m
//  MizuManager
//
//  Created by Apisit Toompakdee on 11/17/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZManagerCurrentCheckInTableViewCell.h"


@interface MZManagerCurrentCheckInTableViewCell()

@property (nonatomic, strong) IBOutlet MZTempAvatarImageView* userImageView;
@property (nonatomic, strong) IBOutlet UILabel* lblName;
@property (nonatomic, strong) IBOutlet UILabel* lblDetail;
@property (nonatomic, strong) IBOutlet UILabel* lblNote;

@end

@implementation MZManagerCurrentCheckInTableViewCell



- (void)setupView{
    
    self.userImageView.name = self.data.user.firstname;
    
    if (self.data.note!=nil){
        self.lblNote.text = [NSString stringWithFormat:@"“%@”",self.data.note];
    }
    
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
    
}

-(void)setData:(MZCheckIn *)data{
    _data = data;
    [self setupView];
}

-(void)prepareForReuse{
    self.userImageView.image = nil;
}
@end
