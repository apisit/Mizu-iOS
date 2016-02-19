//
//  MZCheckIn.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/24/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZCheckIn.h"

@implementation MZCheckIn

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
    _updatedDate = [json valueForKey:@"updated"];
    
    if ([json valueForKey:@"user"]!=nil){
        _user = [[MZUser alloc]initWithJson:[json valueForKey:@"user"]];
    }
    
    if ([json valueForKey:@"note"]!=nil){
        _note = [json valueForKey:@"note"];
        NSLog(@"%@",_note);
    }
    
    if ([json valueForKey:@"business"]!=nil){
        _business = [[MZBusiness alloc]initWithJson:[json valueForKey:@"business"]];
    }
    
    if ([json valueForKey:@"card"]!=nil){
        _card = [[MZCard alloc]initWithJson:[json valueForKey:@"card"]];
    }
    
    _waitingForFeedback = [[json valueForKey:@"waiting_for_feedback"] boolValue];
    
    _checked = [[json valueForKey:@"checked"] boolValue];
     _isCanceled = [[json valueForKey:@"canceled"] boolValue];
    
    if ([json valueForKey:@"transaction"]!=nil){
        _transaction = [[MZTransaction alloc]initWithJson:[json valueForKey:@"transaction"]];
    }
    
    if ([json valueForKey:@"feedback"]!=nil){
        _feedback = [[MZFeedback alloc]initWithJson:[json valueForKey:@"feedback"]];
    }
    
    
    return self;
}

+(NSString *)resourceName{
    return @"checkins";
}

-(void)takePayment:(NSUInteger)amount block:(SingleRowResult)block{
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/businesses/%@/checkins/%@",kBase_API_Endpoint,self.business.objectId,self.objectId];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"PUT"];
    
    NSDictionary *params = @{
                             @"amount":[NSNumber numberWithUnsignedInteger:amount],
                             };
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(nil,dataError);
        return;
    }
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if (result==nil){
            block(nil,nil);
            return;
        }
        block([[MZTransaction alloc]initWithJson:result],nil);
    }];
    [task resume];
}

-(void)refundPayment:(MZTransaction *)transaction fullRefund:(BOOL)fullRefund amount:(NSUInteger)amount remark:(NSString *)remark block:(SingleRowResult)block{
    
    if (transaction==nil || transaction.objectId==nil || self.objectId==nil || self.business==nil || self.business.objectId==nil){
         block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    
    if (amount>transaction.totalAmount){
        NSError *error = [NSError errorWithDomain:kError_Domain code:400 userInfo:@{NSLocalizedDescriptionKey:@"Refund amount cannot be greater than the transaction."}];
        block(nil,error);
        return;
    }
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/businesses/%@/checkins/%@/transactions/%@/refund",kBase_API_Endpoint,self.business.objectId,self.objectId,transaction.objectId];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"POST"];
    
    if (remark!=nil && remark.length>0){
        NSDictionary *params = @{
                                 @"remark":remark,
                                 @"amount":[NSNumber numberWithUnsignedInteger:amount],
                                 @"full_refund":[NSNumber numberWithBool:fullRefund],
                                 };
        NSError* dataError = nil;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
        if (dataError!=nil){
            block(nil,dataError);
            return;
        }
        [request setHTTPBody:postData];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if (result==nil){
            block(nil,nil);
            return;
        }
        block([[MZTransaction alloc]initWithJson:result],nil);
    }];
    [task resume];
}

@end
