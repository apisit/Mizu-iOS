//
//  MZCommentTableViewCell.m
//  Mizu
//
//  Created by Apisit Toompakdee on 2/8/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZCommentTableViewCell.h"

@implementation MZCommentTableViewCell

-(void)setupVew{
    self.profileImageView.layer.cornerRadius = 5;
    NSString* timeAgo = [self.data.createdDate timeAgo];
    NSString* itemText = [NSString stringWithFormat:@"%@%@%@",self.data.byUser.fullname,self.data.comment.text!=nil?@"\n":@"",self.data.comment.text!=nil?self.data.comment.text:@""];
    self.profileImageView.name = self.data.byUser.firstname;
    self.commentImageView.layer.cornerRadius = 5;
    self.commentImageView.clipsToBounds = YES;
    if (self.data.byUser.profilePicture!=nil){
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.data.byUser.profilePicture] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15];
        NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            if (downloadedImage!=nil){
                dispatch_async(dispatch_get_main_queue(), ^ {
                    self.profileImageView.image = downloadedImage;
                });
            }
        }];
        [getImageTask resume];
    }
    
    if ([self.lblMessage respondsToSelector:@selector(setAttributedText:)]) {
        UIColor* textColor = UIColorFromRGB(0x444444);
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:self.lblMessage.textColor,
                                  NSFontAttributeName:self.lblMessage.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:itemText attributes:attribs];
        
        NSRange boldTextRange = [itemText rangeOfString:self.data.byUser.fullname];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Black" size:self.lblMessage.font.pointSize],NSForegroundColorAttributeName:textColor} range:boldTextRange];
        
        if (self.data.comment.text!=nil){
            NSRange regularTextRange = [itemText rangeOfString:[NSString stringWithFormat:@"\n%@",self.data.comment.text]];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:self.lblMessage.font.pointSize],NSForegroundColorAttributeName:textColor} range:regularTextRange];
        }
        
        if (self.data.comment.imageUrls!=nil && self.data.comment.imageUrls.count>0){
            self.lblTimeConstraint.constant = 211;
            NSString* imageUrl = [self.data.comment.imageUrls firstObject];
            __block NSString* cachedName = [NSString stringWithFormat:@"%@",[imageUrl lastPathComponent]];
            UIImage* commentPicture = [UIImage imageFromCacheDirectory:cachedName];
            if (commentPicture!=nil){
                dispatch_async(dispatch_get_main_queue(), ^ {
                    self.commentImageView.image = commentPicture;
                });
            }else{
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15];
                NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                    UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                    if (downloadedImage!=nil){
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [downloadedImage saveToCacheDirectory:cachedName];
                            self.commentImageView.image = downloadedImage;
                        });
                    }
                }];
                [getImageTask resume];
            }
        }else{
            //no picture
            self.lblTimeConstraint.constant = 0;
        }
        
        if (timeAgo){
            self.lblTime.text = timeAgo;
            self.lblTime.font = [UIFont fontWithName:@"Avenir-Medium" size:self.lblTime.font.pointSize];
        }
        if (attributedText){
            self.lblMessage.attributedText = attributedText;
        }
        
    }
}

-(void)setData:(MZActivity *)data{
    _data = data;
    [self setupVew];
}

-(void)prepareForReuse{
    self.profileImageView.image = nil;
    self.commentImageView.image = nil;
}
@end
