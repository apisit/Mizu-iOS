//
//  MZSectionTableViewCell.m
//  Mizu
//
//  Created by Apisit Toompakdee on 3/1/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZSectionTableViewCell.h"

@implementation MZSectionTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(MZMenuSection *)data{
    _data = data;
    [self setupView];
}

-(void)prepareForReuse{
    self.itemImageView.image = [UIImage imageNamed:@"mizu_placeholder.png"];
}

- (void)setupView{
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName:[UIColor whiteColor]
                              };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.data.name attributes:attribs];
    
    NSRange regularTextRange = [self.data.name rangeOfString:self.data.name];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:22]} range:regularTextRange];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:0.8];
    [paragrahStyle setMaximumLineHeight:27];
    NSDictionary *paragraphAttribute = @{NSParagraphStyleAttributeName : paragrahStyle,};
    [attributedText addAttributes:paragraphAttribute range:NSMakeRange(0,attributedText.length)];
    self.lblTitle.attributedText = attributedText;
    
    self.lblDetail.text = self.data.listItemString;
    self.itemImageView.image = [UIImage imageNamed:@"mizu_placeholder.png"];
    if (self.data.imageUrls!=nil){
        NSString* imageUrl = [self.data.imageUrls firstObject];
        
        __block NSString* cachedName = [NSString stringWithFormat:@"%@",[imageUrl lastPathComponent]];
        UIImage* image = [UIImage imageFromCacheDirectory:cachedName];
        if (image!=nil){
            dispatch_async(dispatch_get_main_queue(), ^ {
                [UIView transitionWithView:self.itemImageView
                                  duration:0.25f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.itemImageView.image = image;
                                } completion:nil];
            });
        }else{
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
            NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                if (downloadedImage!=nil){
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [downloadedImage saveToCacheDirectory:cachedName];
                        [UIView transitionWithView:self.itemImageView
                                          duration:0.25f
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                            self.itemImageView.image = downloadedImage;
                                        } completion:nil];
                    });
                }
            }];
            [getImageTask resume];
        }
    }else{
        self.itemImageView.image = [UIImage imageNamed:@"mizu_placeholder.png"];
    }
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
