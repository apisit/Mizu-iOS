//
//  UIStoryboard+Category.m
//  Mizu
//
//  Created by Apisit Toompakdee on 1/20/15.
//  Copyright (c) 2015 Mizu. All rights reserved.
//

#import "UIStoryboard+Category.h"
#import "MZMenuViewController.h"
#import "MZSectionTableViewController.h"
#import "MZMenuListTableViewController.h"
#import "MZAppDelegate.h"

@implementation UIStoryboard (Category)

+ (id)registration{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Registration" bundle:nil];
    return [storyboard instantiateInitialViewController];
}
+(id)signin{
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZSignInViewController"];
}

+ (id)business{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Business" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

+ (id)tastePreferences{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Taste" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

+ (id)waitList{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WaitList" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

+ (id)mizuPay{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MizuPay" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

+ (id)receipt{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MizuPay" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZRecieptTableViewController"];
}

+(id)checkIn{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MizuPay" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZCurrentCheckInTableViewController"];
}

+(id)phoneNumberInput{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MizuPay" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZPhoneNumberTableViewController"];
}
+(id)addCard{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MizuPay" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZAddCardViewController"];
}


+ (id)menuScreen:(NSArray*)menus business:(MZBusiness*)selectedBusiness;{
    
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Business" bundle:nil];
    if (menus.count==1){
        MZMenu* menu = [menus firstObject];
        if (menu.sections.count==1){
           MZMenuViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"MZMenuViewController"];
            vc.selectedBusiness = selectedBusiness;
            MZMenuSection* section = [menu.sections firstObject];
            vc.selectedSection = section;
            return vc;
        }else{
            //more than one section
            MZSectionTableViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"MZSectionTableViewController"];
            vc.selectedBusiness = selectedBusiness;
            vc.selectedMenu = menu;
            return vc;
        }
        
    }else{
        //more than one menu.
        MZMenuListTableViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"MZMenuListTableViewController"];
        vc.selectedBusiness = selectedBusiness;
        vc.data = menus;
        return vc;
    }
}

+(id)businessDetail{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Business" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZBusinessDetailTableViewController"];
}

+(id)editProfile{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Options" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZEditProfileTableViewController"];
}
+(id)connectedCard{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Options" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZConnectedCardTableViewController"];
}
+(id)addNewCard{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Options" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZAddNewCardTableViewController"];
}


+(id)notificationSettings{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Options" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZNotificationSettingTableViewController"];
}

+(id)transactionHistories{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Options" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZTransactionHistoryTableViewController"];
}

+ (id)prePermissionLocation{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PrePermission" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"MZLocationPermissionViewController"];
}

+(void)showBusiness{
    UINavigationController *initialViewController = [UIStoryboard business];
    
    MZAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = initialViewController;
    [appDelegate.window makeKeyAndVisible];
    initialViewController.view.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        initialViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

@end
