//
//  MZTransaction.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/19/15.
//  Copyright (c) 2015 Mizu Inc. All rights reserved.
//

#import "MZTransaction.h"

@implementation MZTransaction

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if (self==nil)
        return nil;
    _objectId = [json valueForKey:@"id"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    _createdDate = [dateFormatter dateFromString:[json valueForKey:@"created"]];
    _amount = [[json valueForKey:@"amount"] integerValue];
    _tipPercent = [[json valueForKey:@"tip_percent"] floatValue];
    _tipAmount = [[json valueForKey:@"tip_amount"] integerValue];
    _totalAmount = [[json valueForKey:@"total_amount"] integerValue];
    _formattedAmount = [json valueForKey:@"formatted_amount"];
    _formattedTipAmount = [json valueForKey:@"formatted_tip_amount"];
    _formattedTotalAmount = [json valueForKey:@"formatted_total_amount"];
    
    if ([json valueForKey:@"charge_succeeded"]){
        _chargeSucceeded = [[json valueForKey:@"charge_succeeded"] boolValue];
        
        if (_chargeSucceeded==NO){
            _errorMessage = [[json valueForKey:@"stripe_charge_response_json"] valueForKey:@"message"];
            
            _errorMessage = [[json valueForKey:@"stripe_token_response_json"] valueForKey:@"message"];
            
        }
    }else{
        _errorMessage = [[json valueForKey:@"stripe_charge_response_json"] valueForKey:@"message"];
        
        _errorMessage = [[json valueForKey:@"stripe_token_response_json"] valueForKey:@"message"];
    }
    
    _refundedDate = [dateFormatter dateFromString:[json valueForKey:@"refunded_date"]];
    _refunded = [[json valueForKey:@"refunded"] boolValue];
    _refundedRemark = [json valueForKey:@"refunded_remark"];
    _refundedAmount = [[json valueForKey:@"refunded_amount"] integerValue];
    _formattedRefundedAmount = [json valueForKey:@"formatted_refunded_amount"];
    _formattedNewTotalAmount = [json valueForKey:@"formatted_new_total_amount"];

    return self;
}

+(NSString *)resourceName{
    return @"transactions";
}

@end
