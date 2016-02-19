//
//  MZUser.h
//  Mizu
//
//  Created by Apisit Toompakdee on 8/23/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MizuBlock.h"
#import "MZBaseObject.h"

@class MZCard;
@class MZBusiness;
@class MZCheckIn;
@class MZMenuItem;
@class MZActivity;
@class MZSocialAccount;
/**
 *  MZUser provides functions related to user.
 */
@interface MZUser : MZBaseObject

/**
 *  Access token
 */
@property (nonatomic, retain) NSString *sessionToken;
/**
 *  User Id
 */
@property (nonatomic, retain) NSString *userId;
/**
 *  First name
 */
@property (nonatomic, retain) NSString *firstname;
/**
 *  Last name
 */
@property (nonatomic, retain) NSString *lastname;
/**
 *  Email address
 */
@property (nonatomic, retain) NSString *email;
/**
 *  Phone number
 */
@property (nonatomic, retain) NSString *phoneNumber;
/**
 *  Phone number verification status
 */
@property (nonatomic, assign) BOOL phoneVerified;

/**
 *  Email verification status
 */
@property (nonatomic, assign) BOOL emailVerified;

/**
 *  Fullname readonly field
 */
@property (nonatomic, readonly) NSString* fullname;

/**
 *  Social account if any
 */
@property (nonatomic, retain) MZSocialAccount* socialAccount;

/**
 *  Profile picture url
 */
@property (nonatomic, retain) NSString* profilePicture;

/**
 *  Taste preferences.
 */
@property (nonatomic, strong) NSArray* tastePreferences;

/**
 *  Date of birth.
 */
@property (nonatomic, retain) NSDate *dateOfBirth;

/**
 *  Gender
 */
@property (nonatomic, retain) NSString *gender;

/**
 *  Formatted Date of birth. format: dd/MM/YYYY e.g. 15/05/1980
 */
@property (nonatomic, readonly) NSString *formattedDateOfBirth;

/**
 *  Default tip in percentage.
 */
@property (nonatomic, assign) double defaultTipPercent;

/**
 *  Is Mizu pay enabled for this user.
 */
@property (nonatomic, readonly) BOOL mizuPayEnabled;

@property (nonatomic, assign) BOOL firstLikeDialogShown;

/**
 *  Get current logged in user.
 *
 *  @return current logged in user.
 */
+ (MZUser*)currentUser;

/**
 *  Refresh current user
 *
 *  @return current logged in user.
 */
- (void)refreshWithBlock:(AuthenticationResult)block;

/**
 *  Update user first name and last name
 *
 *  @param firstName First name
 *  @param lastName  Last name
 *  @param dateOfBirth  Date of birth in dd/MM/YYYY. e.g. 15/05/1980
 *  @param gender  Gender
 *  @param block     Return MZUser
 */
- (void)updateFirstName:(NSString*)firstName lastName:(NSString*)lastName dateOfBirth:(NSString*)dateOfBirth gender:(NSString*)gender block:(SingleRowResult)block;

/**
 *  Signup. User will have to verify his/her phone number.
 *
 *  @param firstname   First name
 *  @param lastname    Last name
 *  @param email       Email address
 *  @param password    Password
 *  @param phoneNumber Valid phone number with country code e.g. +14153223323
 *  @param socialAccount Signup with Social service. only facebook.
 *  @param block       Return MZUser otherwise NSError
 */
+ (void)registerWithFirstname:(NSString*)firstname lastname:(NSString*)lastname email:(NSString*)email password:(NSString*)password phoneNumber:(NSString*)phoneNumber dateOfBirth:(NSString*)dob gender:(NSString*)gender socialAccount:(MZSocialAccount*)socialAccount block:(AuthenticationResult)block;

/**
 *  Login with email and password
 *
 *  @param email    Email address
 *  @param password Password
 *  @param socialAccount Signup with Social service. only facebook.
 *  @param block    Return MZUser otherwise NSError
 */
+ (void)loginWithEmail:(NSString*)email password:(NSString*)password socialAccount:(MZSocialAccount*)socialAccount block:(AuthenticationResult)block;

/**
 *  Forgot password
 *
 *  @param email Email address
 *  @param block Return YES/NO
 */
+ (void)forgotPasword:(NSString*)email block:(ValidResult)block;

/**
 *  Logout
 */
- (void)logout;

/**
 *  Verify phone number with 4 digit code sent to user's phone number.
 *
 *  @param code  4 digits code
 *  @param block Return YES or NO
 */
- (void)verifyPhoneNumberWithCode:(NSString*)code block:(ValidResult)block;

/**
 *  Add default credit card
 *
 *  @param cardNumber 16 digits card number
 *  @param expMonth   Expiration month
 *  @param expYear    Expiration year
 *  @param cvc        CVC
 *  @param block Return YES or NO
 */
- (void)addDefaultCreditCard:(NSString*)cardNumber expMonth:(NSInteger)expMonth expYear:(NSInteger)expYear cvc:(NSString*)cvc block:(SingleRowResult)block;


/**
 *  Remove user's card
 *
 *  @param card MZCard
 *  @param block BOOL, NSError
 */
- (void)removeCard:(MZCard*)card block:(ValidResult)block;

/**
 *  Get user's default card
 *
 *  @param block MZCard
 */
- (void)getDefaultCard:(SingleRowResult)block;


/**
 *  Get taste preferences array of string
 *
 *  @param block Return array of string
 */
- (void)tastePreferences:(ListResult)block;

/**
 *  Save taste preferences
 *
 *  @param list  Array of string
 *  @param block return array of string
 */
- (void)saveTastePreferences:(NSArray*)list block:(ListResult)block;

/**
 *  POST Comment to menu item
 *
 *  @param business selected MZBusiness
 *  @param item     selected MZMenuItem
 *  @param block    return saved result
 */
- (void)comment:(NSString*)comment imageData:(NSData*)imageData business:(MZBusiness*)business item:(MZMenuItem*)item block:(SingleRowResult)block;


/**
 *  Like/Unlike menu item
 *
 *  @param like like or unlike
 *  @param business selected MZBusiness
 *  @param item     selected MZMenuItem
 *  @param block    return saved result
 */
- (void)like:(BOOL)like business:(MZBusiness*)business item:(MZMenuItem*)item block:(SingleRowResult)block;


/**
 *  Delete comment by user
 *
 *  @param business selected MZBusiness
 *  @param item     selected MZMenuItem
 *  @param comment  selected MZActivity
 *  @param block    return deleted resule
 */
- (void)deleteCommentBusiness:(MZBusiness*)business item:(MZMenuItem*)item comment:(MZActivity*)comment block:(SingleRowResult)block;

/**
 *  Update profle picture
 *
 *  @param imageData imageData
 *  @param block     return saved result
 */
- (void)saveProfilePicture:(NSData*)imageData block:(SingleRowResult)block;

/**
 *  Get 50 recent like activities..
 *
 *  @param block  NSArray of MZActivity
 *  @param lastId last returned Id. (blank means getting latest 50)
 */
- (void)recentLikeActivitiesLastId:(NSString*)lastId block:(ListResult)block;

/**
 *  Saving user device token
 *
 *  @param deviceToken  Device token.
 *  @param deviceInfo Device info.
 *  @param block  Valid result
 */
- (void)saveDeviceToken:(NSString*)deviceToken deviceInfo:(NSString*)deviceInfo block:(ValidResult)block;

/**
 *  Check in to Business
 *
 *  @param business business to check-in
 *  @param note note to check-in
 *  @param block return MZCheckIn otherwise NSError
 */
- (void)checkInToBusiness:(MZBusiness*)business note:(NSString*)note block:(SingleRowResult)block;


/**
 *  Get current check in
 *
 *  @param block MZCheckIn,NSError
 */
- (void)recentCheckInWithBlock:(SingleRowResult)block;


/**
 *  Cancel current check in
 *
 *  @param block MZCheckIn,NSError
 */
- (void)cancelRecentCheckInWithBlock:(SingleRowResult)block;


/**
 *  Join mizu pay
 *
 *  @param block MZUser,NSError
 */
- (void)joinMizuPayWithBlock:(SingleRowResult)block;

/**
 *  Update phone number
 *
 *  @param phoneNumber Valid Phone number
 *  @param block       BOOL,NSError
 */
- (void)updatePhoneNumber:(NSString*)phoneNumber block:(ValidResult)block;

/**
 *  Update default tip percent for current check-in
 *
 *  @param defaultTipPercent Tip percent
 *  @param block             MZUser,NSError
 */
- (void)updateDefaultTipPercentForRecentCheckIn:(double)defaultTipPercent block:(SingleRowResult)block;

/**
 *  Update tip percent for product
 *
 *  @param defaultTipPercent Tip percent
 *  @param block             BOOL,NSError
 */
- (void)updateDefaultTipPercent:(double)defaultTipPercent block:(ValidResult)block;

/**
 *  Load Businesses that I am manager at.
 *
 *  @param block NSArray MZBusiness, NSErrror
 */
- (void)myBusinesses:(ListResult)block;

/**
 *  Check in histories (Authorized user only)
 *
 *  @param block MZCheckIn,NSError
 */
- (void)checkInHistories:(ListResult)block;


@end
