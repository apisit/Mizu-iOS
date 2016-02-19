//
//  UIStoryboard+Category.h
//  Mizu
//
//  Created by Apisit Toompakdee on 1/20/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Category)
+ (id)registration;
+ (id)signin;
+ (id)business;
+ (id)tastePreferences;
+ (id)prePermissionLocation;
+ (id)waitList;
+ (id)mizuPay;
+ (id)receipt;
+ (id)checkIn;
+ (id)phoneNumberInput;
+ (id)addCard;
+ (id)menuScreen:(NSArray*)menus business:(MZBusiness*)selectedBusiness;
+ (id)businessDetail;
+ (id)editProfile;
+ (id)connectedCard;
+ (id)addNewCard;
+ (id)notificationSettings;
+ (id)transactionHistories;

+ (void)showBusiness;
@end
