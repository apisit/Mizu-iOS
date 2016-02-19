//
//  MZMenuTableViewCell.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/3/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import "MZItemTableViewCell.h"

@implementation MZItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    UIColor* color;
    for (UIButton* btn in self.tagView.subviews){
        color = btn.backgroundColor;
    }
    [super setSelected:selected animated:animated];
    
    for (UIButton* btn in self.tagView.subviews){
        btn.backgroundColor = color;
    }
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    UIColor* color;
    for (UIButton* btn in self.tagView.subviews){
        color = btn.backgroundColor;
    }
    [super setHighlighted:highlighted animated:animated];
    
    for (UIButton* btn in self.tagView.subviews){
        btn.backgroundColor = color;
    }
}

- (void)updateLikeCount{
    self.btnLike.selected = self.data.userLiked;
    if (self.data.likeCount>0){
        NSString* likes = [NSString stringWithFormat:@"%ld Like%@",(long)self.data.likeCount,self.data.likeCount>1?@"s":@""];
        [self.btnLike setTitle:likes forState:UIControlStateNormal];
    }else{
        [self.btnLike setTitle:@"Like" forState:UIControlStateNormal];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize size = [self.btnLike.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.btnLike.titleLabel.font}];
        self.widthConstraint.constant = size.width+21;
    });
}

- (void)updateCommentCount{
    if (self.data.commentCount>0){
        [self.btnCommentCount setTitle:[NSString stringWithFormat:@"%ld Comment%@",(long)self.data.commentCount,self.data.commentCount>1?@"s":@""] forState:UIControlStateNormal];
    }else{
        [self.btnCommentCount setTitle:[NSString stringWithFormat:@"%@",@"Comment"] forState:UIControlStateNormal];
    }
}

-(void)prepareForReuse{
    if (self.btnAddPicture.tag==0 && self.isFullView)
        self.itemImageView.image = [UIImage imageNamed:@"mizu_placeholder.png"];
    else
        self.itemImageView.image = [UIImage imageNamed:@"addPhoto.png"];
}

- (void)didTapLike:(UIButton*)sender{
    self.btnLike.layer.zPosition = 1000;
    self.layer.zPosition = 100;
    sender.selected = !sender.isSelected;
    if (sender.selected){
        [self.btnLike like];
        self.data.likeCount++;
        [MZAnalytics trackUserAction:@"Liked item"];
        NSString* action = [NSString stringWithFormat:@"Liked item %@",self.data.name];
        [MZAnalytics trackBusiness:self.selectedBusiness.name action:action];
        
        if ([MZUser currentUser].firstLikeDialogShown==NO){
            [UIAlertView alertViewWithTitle:@"Your first like" message:@"Keep telling us what you like and get even better recommendations." cancelButtonTitle:@"Yum!"];
            [[MZUser currentUser] setFirstLikeDialogShown:YES];
        }
        
    }else{
        [self.btnLike unlike];
        self.data.likeCount--;
        [MZAnalytics trackUserAction:@"UnLiked item"];
        NSString* action = [NSString stringWithFormat:@"Unliked item %@",self.data.name];
        [MZAnalytics trackBusiness:self.selectedBusiness.name action:action];
        
        //post notifiation to liked item page to remove from the list
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unlikeItemFromItemDetailPage" object:self.data];
    }
    
    self.data.userLiked = sender.selected;
    [self updateLikeCount];

   
    
    [[MZUser currentUser] like:sender.selected business:self.selectedBusiness item:self.data block:^(id object, NSError *error) {
       
    }];

}

- (void)didPostComment:(id)sender{
    self.data.commentCount++;
    [self updateCommentCount];
}

- (void)setupView{
    
    self.lblBusinessName.hidden = !self.showBusinessName;
    if (self.showBusinessName){
        self.lblBusinessName.text = [NSString stringWithFormat:@"   AT %@    ",[self.selectedBusiness.name uppercaseString]];
    }
    
    self.itemImageView.layer.cornerRadius = self.isFullView?0:5;
    self.addPhotoImageView.layer.cornerRadius = 5.0;
    self.lblSuggestedForYou.hidden = !self.suggestedItem;
    [self.btnLike addTarget:self action:@selector(didTapLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLike setSelected:self.data.userLiked];
    if (self.isFullView){
        [self.btnLike setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    }else{
        [self.btnLike setTitleColor:UIColorFromRGB(0x444444) forState:UIControlStateSelected];
    }
    self.tagView.tags = self.data.tags;
    self.tagView.hidden = self.data.tags==0;
    float factor = [self.selectedBusiness.meta.currencyFactor floatValue];
    self.lblPrice.text = [NSString stringWithFormat:@"%.2f",(CGFloat)(self.data.price / factor)];
    if (self.data.price <=0.0){
        self.lblPrice.hidden = YES;
    }else{
        self.lblPrice.hidden = NO;
    }
    
    [self.lblPrice setFont:[UIFont fontWithName:@"Avenir-Medium" size:self.lblPrice.font.pointSize]];
    if (self.isFullView){
        self.lblPrice.textColor = UIColorFromRGB(0xffffff);
    }else{
        self.lblPrice.textColor = UIColorFromRGB(0x808080);
    }
    
    
    [self updateCommentCount];
    [self updateLikeCount];
    
    
    self.spacingConstraint.constant = -12;
    self.bottomSpaceConstraint.constant = 32;
    
    
    BOOL bigText = self.inMenuScreen && self.isFullView;
    if (bigText){
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
        self.lblSuggestedItemName.attributedText = attributedText;
    }
    
    CGFloat detailHeight = 0;
    CGFloat nameHeight = 0;
    
    //in comment screen.
    if (self.isFullView==YES && self.inMenuScreen==NO){
        
        if (self.data.name) {
            NSString* itemText = self.data.name;
            UIColor* textColor = UIColorFromRGB(0xffffff);
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName: self.lblName.textColor,
                                      NSFontAttributeName:self.lblName.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:itemText attributes:attribs];
            
            NSRange boldTextRange = [itemText rangeOfString:self.data.name];
            NSString* fontName =@"Avenir-Black";
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:self.lblName.font.pointSize],NSForegroundColorAttributeName:textColor} range:boldTextRange];
            
            /* NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
             [paragrahStyle setLineSpacing:0.8];
             [paragrahStyle setMaximumLineHeight:17];
             NSDictionary *paragraphAttribute = @{NSParagraphStyleAttributeName : paragrahStyle,};
             [attributedText addAttributes:paragraphAttribute range:NSMakeRange(0,attributedText.length)];*/
            self.lblName.attributedText = attributedText;
            CGFloat width = [UIScreen mainScreen].bounds.size.width - 94;
            CGRect textSize = [attributedText boundsForWidth:width];
            nameHeight = textSize.size.height;
        }
        
        self.lblDetail.hidden = !self.data.detail;
        
        if (self.data.detail) {
            NSString* itemText = self.data.detail;
            UIColor* textColor = UIColorFromRGB(0xb3b3b3);
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName: self.lblName.textColor,
                                      NSFontAttributeName:self.lblName.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:itemText attributes:attribs];
            
            NSRange textRange = [itemText rangeOfString:self.data.detail];
            NSString* fontName =@"Avenir-Medium";
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:self.lblDetail.font.pointSize],NSForegroundColorAttributeName:textColor} range:textRange];
            
            /* NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
             [paragrahStyle setLineSpacing:0.8];
             [paragrahStyle setMaximumLineHeight:17];
             NSDictionary *paragraphAttribute = @{NSParagraphStyleAttributeName : paragrahStyle,};
             [attributedText addAttributes:paragraphAttribute range:NSMakeRange(0,attributedText.length)];*/
            self.lblDetail.attributedText = attributedText;
            CGFloat width =  [UIScreen mainScreen].bounds.size.width - 24;
            CGRect textSize = [attributedText boundsForWidth:width];
            detailHeight = textSize.size.height;
        }else{
            CGRect frame =  self.lblDetail.frame;
            frame.size.height = 0;
            self.lblDetail.frame = frame;
        }
        self.bottomSpaceConstraint.constant = detailHeight+30;
        self.spacingConstraint.constant = detailHeight==0?-15:detailHeight-15;
    }
    
    //in menu screen
    if (self.isFullView==NO && bigText==NO){
        self.lblName.text = self.data.name;
        self.lblDetail.text = self.data.detail;
    }
    
    //in comment screen and no detail text
    if (self.data.detail==nil && self.isFullView==YES && self.inMenuScreen==NO){
        self.commentScreenNameAndDetailVerticalSpacing.constant = -22;
    }
    
    if (self.data.tags!=nil){
        if (self.isFullView==NO){
            self.spacingConstraint.constant = self.tagView.height-4;
            self.tagView.onDarkBakcground = NO;
        }else{
            if (self.inMenuScreen==YES){
                self.bottomSpaceConstraint.constant = self.tagView.height + self.lblDetail.frame.size.height + 42;
                self.spacingConstraint.constant = self.tagView.height + self.lblDetail.frame.size.height-4;
                
            }else{
                //in comment screen.
                if (self.data.detail!=nil){
                    self.commentScreenDetailAndLikeVerticalSpacing.constant = self.tagView.height - 3;
                    self.tagViewTopConstraint.constant = detailHeight + 5;
                }else{
                    self.commentScreenDetailAndLikeVerticalSpacing.constant = self.tagView.height - 6;
                }
            }
            
            self.tagView.onDarkBakcground = YES;
        }
        self.tagView.tags = self.data.tags;
    }
    
    
    
    
    
    self.addPhotoImageView.hidden = self.data.imageUrls!=nil;
    if (self.isFullView){
        self.itemImageView.image = [UIImage imageNamed:@"mizu_placeholder.png"];
    }else{
        self.itemImageView.image = [UIImage imageNamed:@"addPhoto.png"];
    }
    if (self.data.imageUrls!=nil){
        NSString* imageUrl = [self.data.imageUrls firstObject];
        __block NSString* cachedName = [NSString stringWithFormat:@"%@",[imageUrl lastPathComponent]];
        UIImage* image = [UIImage imageFromCacheDirectory:cachedName];
        if (image!=nil){
            dispatch_async(dispatch_get_main_queue(), ^ {
                self.itemImageView.image = image;
            });
        }else{
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
            NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                if (downloadedImage!=nil){
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [downloadedImage saveToCacheDirectory:cachedName];
                        self.itemImageView.image = downloadedImage;
                    });
                }
            }];
            [getImageTask resume];
        }
    }else{
        if (self.isFullView){
            self.itemImageView.image = [UIImage imageNamed:@"mizu_placeholder.png"];
        }else{
            self.itemImageView.image = [UIImage imageNamed:@"addPhoto.png"];
        }
    }
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

-(void)setData:(MZMenuItem *)data{
    _data = data;
    [self setupView];
}

@end
