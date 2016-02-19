//
//  MZQuestion.h
//  Mizu
//
//  Created by Apisit Toompakdee on 2/5/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import <Mizu/Mizu.h>

/**
 *  MZQuestion taste preference question
 */
@interface MZQuestion : MZBaseObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSString* tagForYes;
@property (nonatomic, strong) NSString* tagForNo;

@end
