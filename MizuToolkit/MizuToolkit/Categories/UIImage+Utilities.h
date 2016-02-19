//
//  UIImage+Utilities.h
//
//  Created by Apisit Toompakdee on 8/27/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetsLibrary/ALAssetsLibrary.h"
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <ImageIO/ImageIO.h>
@interface UIImage(Utilities)

- (CGRect)convertCropRect:(CGRect)cropRect;
- (UIImage *)croppedImage:(CGRect)cropRect;
- (UIImage *)resizedImage:(CGSize)size imageOrientation:(UIImageOrientation)imageOrientation;

-(UIImage*)cropImageFromLibrary:(CGRect)cropRect;
-(UIImage*)saveToDocumentDirectory:(NSString*)filename;
+(UIImage*)imageFromDocumentDirectory:(NSString*)filename;

- (UIImage *)scaleImageToSize:(CGSize)newSize;

-(UIImage*)saveToCacheDirectory:(NSString*)filename;

-(void)saveImageToAlbum;

+(void)deleteFromCacheDirectory:(NSString*)filename;
+(UIImage*)imageFromCacheDirectory:(NSString*)filename;

+(UIImage*)imageFromASAssetRepresentation:(ALAssetRepresentation *)assetRepresentation;

- (UIImage*)withWhiteBorderLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom;
@end
