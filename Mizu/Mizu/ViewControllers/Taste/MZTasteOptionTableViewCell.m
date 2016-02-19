//
//  MZTasteOptionTableViewCell.m
//  Mizu
//
//  Created by Apisit Toompakdee on 4/11/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "MZTasteOptionTableViewCell.h"

@implementation MZTasteOptionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView{
    self.lblTitle.text = self.data.title;
    if (self.data.imageUrl!=nil){
        NSString* imageUrl = self.data.imageUrl;
        
        __block NSString* cachedName = [NSString stringWithFormat:@"%@",[imageUrl lastPathComponent]];
        NSString* localFileName = [NSString stringWithFormat:@"food_%@",cachedName];

       localFileName = [localFileName stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        
        UIImage* image =  [UIImage imageNamed:localFileName];
        if (image==nil){
           image = [UIImage imageFromCacheDirectory:cachedName];
        }
        if (image!=nil){
            dispatch_async(dispatch_get_main_queue(), ^ {
                self.tasteImageView.image = image;
            });
        }else{
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
            NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                if (downloadedImage!=nil){
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [downloadedImage saveToCacheDirectory:cachedName];
                        self.tasteImageView.image = downloadedImage;
                    });
                }
            }];
            [getImageTask resume];
        }
    }
    [self.btnYes addTarget:self action:@selector(didToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnNo addTarget:self action:@selector(didToggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didToggle:(UIButton*)sender{
    BOOL answer = sender.tag==1;
    NSInteger state = 0;
    //state -1 0 1
    //-1 = dislike
    //0 = normal
    //1 = like

    if (answer==YES){
        self.btnYes.selected = !self.btnYes.selected;
        self.btnNo.selected= NO;
        state = self.btnYes.selected?1:0;
    }else{
         self.btnNo.selected = !self.btnNo.selected;
        self.btnYes.selected= NO;
        state = self.btnNo.selected?-1:0;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"answeredTasteOption" object:nil userInfo:@{@"answer":[NSNumber numberWithInteger:state],@"data":self.data}];
}

-(void)prepareForReuse{
    self.tasteImageView.image = nil;
}

-(void)setData:(MZQuestion *)data{
    _data = data;
    [self setupView];
}
@end
