//
//  MZBusinessTableViewself.m
//  Mizu
//
//  Created by Apisit Toompakdee on 7/9/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZBusinessTableViewCell.h"
#import <MapKit/MapKit.h>

@implementation MZBusinessTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = UIColorFromRGB(0x303030);
    UIColor *textColor = UIColorFromRGB(0xffffff);
    UIColor *tagTextColor = UIColorFromRGB(0xB3B3B3);
    [self.hourDescription setTitle:self.data.hourDescription forState:UIControlStateNormal];
    self.hourDescription.hidden = self.data.hourDescription.length==0;
    if (self.data.hourDescription.length>0){
        unsigned colorInt = 0;
        [[NSScanner scannerWithString:self.data.hourDescriptionColorHex] scanHexInt:&colorInt];
        self.hourDescription.backgroundColor = UIColorFromRGB(colorInt);
    }
    
    if (self.data.distanceFromCurrentLocation==0){
        self.lblDistance.text = self.data.city;
        [self.btnGetDirections setHidden:YES];
    }else{
        [self.btnGetDirections setHidden:NO];
        self.lblDistance.text = [NSString stringWithFormat:@"%.1fkm",self.data.distanceFromCurrentLocation /1000.0];
    }
    self.verifiedStatus.hidden = !self.data.verified;
    
    self.lblDistance.textColor = tagTextColor;
    NSString* tags = @"";
    if (self.data.tags){
        tags = [self.data.tags componentsJoinedByString:@", "];
    }
    NSString* itemText = [NSString stringWithFormat:@"%@\n%@\n%@",self.data.name,self.data.address,tags];
    CGFloat fontSize = 15.0;
    if ([self.lblName respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:self.lblName.textColor,
                                  NSFontAttributeName:self.lblName.font
                                  };

        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:itemText attributes:attribs];
        
        NSRange businessNameRange = [itemText rangeOfString:self.data.name];
        
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:22],NSForegroundColorAttributeName:textColor} range:businessNameRange];
        
        if (self.data.address){
            NSString* address = [NSString stringWithFormat:@"\n%@\n",self.data.address];
            NSRange regularTextRange = [itemText rangeOfString:address];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:fontSize],NSForegroundColorAttributeName:textColor} range:regularTextRange];
        }
        
        if (self.data.tags){
            NSString* tagsString = [NSString stringWithFormat:@"\n%@",tags];
            NSRange regularTextRange = [itemText rangeOfString:tagsString];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:fontSize],NSForegroundColorAttributeName:tagTextColor} range:regularTextRange];
        }
        
        NSMutableParagraphStyle *titleParagrahStyle = [[NSMutableParagraphStyle alloc] init];
        [titleParagrahStyle setLineSpacing:0.8];
        [titleParagrahStyle setMaximumLineHeight:24];
        
        NSMutableParagraphStyle *detailParagrahStyle = [[NSMutableParagraphStyle alloc] init];
        [detailParagrahStyle setLineSpacing:0.8];
        [detailParagrahStyle setMaximumLineHeight:18];
        
        NSDictionary *titleAttribute = @{NSParagraphStyleAttributeName : titleParagrahStyle};
        NSDictionary *detailAttribute = @{NSParagraphStyleAttributeName : detailParagrahStyle};
        
        [attributedText addAttributes:titleAttribute range:NSMakeRange(0,businessNameRange.length)];
        [attributedText addAttributes:detailAttribute range:NSMakeRange(businessNameRange.length,attributedText.length - businessNameRange.length)];
        
        if (self.data.verified){
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = [UIImage imageNamed:@"verified.png"];
            attachment.bounds = CGRectMake(-2, -9, 30, 30);
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
            [attributedText insertAttributedString:attachmentString atIndex:self.data.name.length];
        }
        
        self.lblName.attributedText = attributedText;
    }else{
        self.lblName.text = itemText;
    }
    self.restaurantImageView.image = nil;
    if (self.data.imageUrls!=nil){
        NSString* imageUrl = [self.data.imageUrls firstObject];
        __block NSString* cachedName = [NSString stringWithFormat:@"business-%@-%@.jpg",self.data.objectId,[imageUrl lastPathComponent]];
        UIImage* image = [UIImage imageFromCacheDirectory:cachedName];
        if (image!=nil){
            dispatch_async(dispatch_get_main_queue(), ^ {
                self.restaurantImageView.image = image;
            });
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
                NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                    UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                    if (downloadedImage!=nil){
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [downloadedImage saveToCacheDirectory:cachedName];
                            self.restaurantImageView.image = downloadedImage;
                        });
                    }
                }];
                [getImageTask resume];
            });
        }
    }
}

-(void)setData:(MZBusiness *)data{
    _data = data;
    [self setupView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor* moreInfoBackgroundColor = self.btnMoreInfo.backgroundColor;
    UIColor* hourDescriptionBackgroundColor = self.hourDescription.backgroundColor;
    [super setSelected:selected animated:animated];
    self.btnMoreInfo.highlighted = NO;
    self.btnMoreInfo.backgroundColor = moreInfoBackgroundColor;
    self.hourDescription.highlighted = NO;
    self.hourDescription.backgroundColor = hourDescriptionBackgroundColor;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor* moreInfoBackgroundColor = self.btnMoreInfo.backgroundColor;
    UIColor* hourDescriptionBackgroundColor = self.hourDescription.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.btnMoreInfo.highlighted = NO;
    self.btnMoreInfo.backgroundColor = moreInfoBackgroundColor;
    self.hourDescription.highlighted = NO;
    self.hourDescription.backgroundColor = hourDescriptionBackgroundColor;
}

-(void)prepareForReuse{
    self.lblName.attributedText = nil;
    self.restaurantImageView.image = nil;
}

- (IBAction)didTapGetDirections:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"direction" object:self.data userInfo:nil];
}

- (IBAction)didTapMoreInfo:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"businessMoreInfo" object:self.data userInfo:nil];
}
@end
