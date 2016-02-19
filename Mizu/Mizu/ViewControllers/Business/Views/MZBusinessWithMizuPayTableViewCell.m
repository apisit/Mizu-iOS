//
//  MZBusinessWithMizuPayTableViewCell.m
//  Mizu
//
//  Created by Apisit Toompakdee on 10/26/15.
//  Copyright © 2015 Mizu. All rights reserved.
//

#import "MZBusinessWithMizuPayTableViewCell.h"

@interface MZBusinessWithMizuPayTableViewCell()

@property (nonatomic, strong) IBOutlet UILabel* lblName;
@property (nonatomic, strong) IBOutlet UILabel* lblDetail;
@property (nonatomic, strong) IBOutlet UIButton* btnDirection;
@property (nonatomic, strong) IBOutlet UIImageView* restaurantImageView;

@end

@implementation MZBusinessWithMizuPayTableViewCell

- (void)setupView{
    [MZColor styleTableViewCell:self];
    self.lblName.textColor = [MZColor titleColor];
    self.lblDetail.textColor = [MZColor subTitleColor];
    self.btnDirection.hidden = NO;
    CGFloat distance = self.data.distanceFromCurrentLocation /1000.0;
    NSString* distanceText = [NSString stringWithFormat:@"%.1fkm away",distance];
    if (distance<1.0){
        distanceText = [NSString stringWithFormat:@"%ldm away",(long)self.data.distanceFromCurrentLocation];
    }
    BOOL locationDisabled = [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied;
    if (distance<0.001){
        distanceText = @"You are here";
    }
    
    if (self.data.distanceFromCurrentLocation<50 || distance>50){
        self.btnDirection.hidden = YES;
    }
    
    if (locationDisabled){
        self.btnDirection.hidden = YES;
        distanceText = self.data.city;
    }
    
    self.lblDetail.text = [NSString stringWithFormat:@"%@ ● %@",distanceText,self.data.address];
    self.lblName.text = self.data.name;
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

-(void)prepareForReuse{
    self.restaurantImageView.image = nil;
}

- (IBAction)didTapRoute:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didTapRoute" object:nil userInfo:@{@"data":self.data}];
}

@end
