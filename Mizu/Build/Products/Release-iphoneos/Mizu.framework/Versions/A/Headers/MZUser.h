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
 *  @param block     Return MZUser
 */
- (void)updateFirstName:(NSString*)firstName lastName:(NSString*)lastName block:(SingleRowResult)block;

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
+ (void)registerWithFirstname:(NSString*)firstname lastname:(NSString*)lastname email:(NSString*)email password:(NSString*)password phoneNumber:(NSString*)phoneNumber socialAccount:(MZSocialAccount*)socialAccount  block:(AuthenticationResult)block;

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
 *  Get user's default card
 *
 *  @param block MZCard
 */
- (void)getDefaultCard:(SingleRowResult)block;

/**
 *  Check in to business and table number
 *
 *  @param business    Business object
 *  @param tableNumber Table number
 *  @param block       Return YES or NO
 */
- (void)checkInAt:(MZBusiness*)business table:(NSString*)tableNumber block:(SingleRowResult)block;

/**
 *  Get recent unbilled check-in
 *
 *  @param block MZCheckIn
 */
- (void)recentCheckIn:(SingleRowResult)block;

/**
 *  Place order for the current checkin
 *
 *  @param business Business where user checked in at
 *  @param listOfMZOrderItem    List of MZOrderItem
 *  @param block    Return order detail with total
 */
- (void)placeOrderAt:(MZBusiness*)business withItems:(NSArray*)listOfMZOrderItem block:(SingleRowResult)block;


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

@end
