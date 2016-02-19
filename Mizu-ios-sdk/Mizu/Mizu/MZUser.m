//
//  MZUser.m
//  Mizu
//
//  Created by Apisit Toompakdee on 8/23/14.
//  Copyright (c) 2014 Mizu Inc. All rights reserved.
//

#import "MZUser.h"
#import "Mizu.h"
static NSString* cachedUserFileName=@"MZ_cachedUser.cache";

@implementation MZUser

+(NSString *)resourceName{
    return @"users";
}

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if(self){
        self.userId = [[json objectForKey:@"id"] stringValue];
        self.firstname = [json objectForKey:@"firstname"];
        self.lastname = [json objectForKey:@"lastname"];
        self.email = [json objectForKey:@"email"];
        self.phoneNumber = [json objectForKey:@"phone"];
        self.sessionToken = [json objectForKey:@"access_token"];
        self.phoneVerified = [[json objectForKey:@"phone_verified"] boolValue];
        self.emailVerified = [[json objectForKey:@"email_verified"] boolValue];
        self.gender = [json objectForKey:@"gender"];
        if ([json valueForKey:@"dob"]){
            NSDateFormatter* dobDateFormatter = [[NSDateFormatter alloc]init];
            [dobDateFormatter setDateFormat:@"yyyy-MM-dd'T'00:00:00Z"];
             NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dobDateFormatter setLocale:usLocale];
            self.dateOfBirth = [dobDateFormatter dateFromString:[json valueForKey:@"dob"]];
            if (self.dateOfBirth){
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                _formattedDateOfBirth = [dateFormatter stringFromDate:self.dateOfBirth];
            }
        }
        
        self.profilePicture = [json objectForKey:@"profile_picture"];
        if ([json objectForKey:@"default_tip_percent"]!=nil){
            self.defaultTipPercent = [[json objectForKey:@"default_tip_percent"] doubleValue];
        }
        
        _mizuPayEnabled = [[json objectForKey:@"mizu_pay_enabled"] boolValue];
        
        NSDictionary* account = [json objectForKey:@"social_account"];
        if (account){
            self.socialAccount = [[MZSocialAccount alloc]initWithJson:account];
        }
        NSArray* tastes = [json objectForKey:@"taste_preferences"];
        if (tastes){
            self.tastePreferences = [NSArray arrayWithArray:tastes];
        }
    }
    return self;
}

-(NSString *)fullname{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    [array addObject:self.firstname];
    
    if (self.lastname){
        [array addObject:self.lastname];
    }
    
    return [array componentsJoinedByString:@" "];
}

static MZUser *sharedInstance = nil;
+(instancetype)currentUser{
    if (sharedInstance==nil){
        NSDictionary* json = [MZHelper getJsonByFilename:cachedUserFileName];
        if (json){
            sharedInstance = [[MZUser alloc]initWithJson:json];
        }else{
            sharedInstance = nil;
        }
    }
    return  sharedInstance;
}

-(BOOL)firstLikeDialogShown{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLikeDialogShown"];
}
-(void)setFirstLikeDialogShown:(BOOL)firstLikeDialogShown{
    [[NSUserDefaults standardUserDefaults] setBool:firstLikeDialogShown forKey:@"firstLikeDialogShown"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)refreshWithBlock:(AuthenticationResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@",kBase_API_Endpoint,@"users/me"];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"GET"];
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [MZHelper saveJsonToFilename:cachedUserFileName dictionary:obj];
        sharedInstance = nil;
        block([[MZUser alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

+(void)registerWithFirstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email password:(NSString *)password phoneNumber:(NSString *)phoneNumber dateOfBirth:(NSString*)dob gender:(NSString*)gender socialAccount:(MZSocialAccount*)socialAccount block:(AuthenticationResult)block{
    if (firstname==nil || lastname==nil || email==nil || password==nil || phoneNumber==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@",kBase_API_Endpoint,[MZUser resourceName]];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestProtectedResource:url method:@"POST"];
    
    NSMutableDictionary *params =[[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                  @"firstname":firstname,
                                                                                  @"lastname":lastname,
                                                                                  @"email":email,
                                                                                  @"phone":phoneNumber,
                                                                                  @"password":password,
                                                                                  @"dob":dob,
                                                                                  @"gender":gender,
                                                                                  }];
    
    if (socialAccount){
        [params setObject:[socialAccount toJson]  forKey:@"social_account"];
    }
    
    NSError* dataError=nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(nil,[MZHelper errorRequireParameters]);
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
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            [MZHelper saveJsonToFilename:cachedUserFileName dictionary:obj];
            sharedInstance = nil;
            block([[MZUser alloc]initWithJson:obj],nil);
        });
    }];
    [task resume];
}


+(void)loginWithEmail:(NSString *)email password:(NSString *)password socialAccount:(MZSocialAccount*)socialAccount block:(AuthenticationResult)block{
    if (email==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@",kBase_API_Endpoint,@"login"];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestProtectedResource:url method:@"POST"];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"email":email,
                                                                                   }];
    if (password!=nil){
        [params setObject:password forKey:@"password"];
    }
    
    if (socialAccount){
        [params setObject:[socialAccount toJson]  forKey:@"social_account"];
    }
    
    NSError* dataError=nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(nil,[MZHelper errorRequireParameters]);
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [MZHelper saveJsonToFilename:cachedUserFileName dictionary:obj];
        sharedInstance = nil;
        block([[MZUser alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

+(void)forgotPasword:(NSString *)email block:(ValidResult)block{
    if (email==nil){
        block(NO,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@",kBase_API_Endpoint,@"forgotpassword"];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestProtectedResource:url method:@"POST"];
    NSDictionary *params = @{
                             @"email":email
                             };
    NSError* dataError=nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(NO,[MZHelper errorRequireParameters]);
        return;
    }
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(NO,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(NO,responseError);
            return;
        }
        block(YES,nil);
    }];
    [task resume];
}

- (void)logout{
    
    //delete serilized json file from disk
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:cachedUserFileName];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@",kBase_API_Endpoint,@"logout"];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //don't care the result.
#if DEBUG
        NSLog(@"%@ %@",data,error);
#endif
    }];
    [task resume];
}

-(void)verifyPhoneNumberWithCode:(NSString *)code block:(ValidResult)block{
    if (code==nil){
        block(NO,[MZHelper errorRequireParameters]);
        return;
    }
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/me/verifyphone",kBase_API_Endpoint,[MZUser resourceName]];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"POST"];
    
    NSDictionary *params = @{
                             @"code":code
                             };
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(NO,[MZHelper errorRequireParameters]);
        return;
    }
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(NO,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(NO,responseError);
            return;
        }
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [MZHelper saveJsonToFilename:cachedUserFileName dictionary:obj];
        sharedInstance = nil;
        block(YES,nil);
    }];
    [task resume];
}


-(void)addDefaultCreditCard:(NSString *)cardNumber expMonth:(NSInteger)expMonth expYear:(NSInteger)expYear cvc:(NSString *)cvc block:(SingleRowResult)block{
    if (cardNumber==nil || expMonth<=0 || expYear<=0 || cvc==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/me/%@",kBase_API_Endpoint,[MZUser resourceName],[MZCard resourceName]];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"POST"];
    
    NSDictionary *params = @{
                             @"card_number":cardNumber,
                             @"exp_month":[NSString stringWithFormat:@"%ld",(long)expMonth],
                             @"exp_year":[NSString stringWithFormat:@"%ld",(long)expYear],
                             @"cvc":cvc,
                             };
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(nil,[MZHelper errorRequireParameters]);
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        block([[MZCard alloc]initWithJson:obj],nil);
    }];
    [task resume];
}
-(void)removeCard:(MZCard *)card block:(ValidResult)block{

    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/me/%@/default",kBase_API_Endpoint,[MZUser resourceName],[MZCard resourceName]];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"DEL"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(NO,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(NO,responseError);
            return;
        }

        block(YES,nil);
    }];
    [task resume];
}

- (void)getDefaultCard:(SingleRowResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/me/%@/default",kBase_API_Endpoint,[MZUser resourceName],[MZCard resourceName]];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"GET"];
    
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        block([[MZCard alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

-(void)tastePreferences:(ListResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/preferences/tastes",kBase_API_Endpoint];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"GET"];
    
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }
        NSArray* list = [obj valueForKey:@"tastes"];
        block(list,nil);
    }];
    [task resume];
}

-(void)saveTastePreferences:(NSArray *)list block:(ListResult)block{
    if (list==nil || list.count==0){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/preferences/tastes",kBase_API_Endpoint];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"POST"];
    NSDictionary *params = @{
                             @"tastes":list
                             };
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(nil,[MZHelper errorRequireParameters]);
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }
        NSArray* list = [obj valueForKey:@"tastes"];
        block(list,nil);
    }];
    [task resume];
}



- (void)postActivity:(MZBusiness*)business item:(MZMenuItem*)item activityType:(MizuActivityType)activityType comment:(NSString*)comment imageData:(NSData*)imageData delete:(BOOL)delete block:(SingleRowResult)block{
    
    if (business==nil || item==nil || (activityType==kComment && comment.length==0 && imageData==nil)){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    
    NSString* toDeleteId = @"";
    if (activityType==kComment && delete==true){
        toDeleteId = [NSString stringWithFormat:@"/%@",comment];
    }
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/businesses/%@/items/%@/%@%@",kBase_API_Endpoint,business.objectId,item.objectId,[MZActivity activityNameByType:activityType],toDeleteId];
    
    
    NSString* method = @"POST";
    if (delete==true){
        method = @"DEL";
    }
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:method];
    
    if (activityType==kComment && delete==false){
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        if (comment!=nil && comment.length>0){
            [params setObject:comment forKey:@"comment"];
        }
        if (imageData!=nil){
            NSString* imageBase64 = [imageData base64EncodedStringWithOptions:0];
            [params setObject:imageBase64 forKey:@"image"];
        }
        NSError* dataError = nil;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
        if (dataError!=nil){
            block(nil,[MZHelper errorRequireParameters]);
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }
        MZActivity* activity  = [[MZActivity alloc]initWithJson:obj];
        block(activity,nil);
    }];
    [task resume];
}

- (void)comment:(NSString*)comment imageData:(NSData*)imageData business:(MZBusiness*)business item:(MZMenuItem*)item block:(SingleRowResult)block{
    [self postActivity:business item:item activityType:kComment comment:comment imageData:imageData delete:false block:block];
}

- (void)like:(BOOL)like business:(MZBusiness*)business item:(MZMenuItem*)item block:(SingleRowResult)block{
    [self postActivity:business item:item activityType:kLike comment:nil imageData:nil delete:!like block:block];
}

-(void)deleteCommentBusiness:(MZBusiness *)business item:(MZMenuItem *)item comment:(MZActivity *)comment block:(SingleRowResult)block{
    [self postActivity:business item:item activityType:kComment comment:comment.objectId imageData:nil delete:true block:block];
}

-(void)updateFirstName:(NSString *)firstName lastName:(NSString *)lastName dateOfBirth:(NSString*)dateOfBirth gender:(NSString*)gender block:(SingleRowResult)block{
    if (firstName==nil || lastName==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/me",kBase_API_Endpoint,[MZUser resourceName]];
    NSString* method = @"PUT";
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:method];
    NSDictionary *params = @{
                             @"first_name":firstName,
                             @"last_name":lastName,
                             @"dob":dateOfBirth,
                             @"gender":gender,
                             };
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(nil,[MZHelper errorRequireParameters]);
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }
        [MZHelper saveJsonToFilename:cachedUserFileName dictionary:obj];
        sharedInstance = nil;
        block([[MZUser alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

-(void)saveProfilePicture:(NSData *)imageData block:(SingleRowResult)block{
    if (imageData==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/me/profilepicture",kBase_API_Endpoint,[MZUser resourceName]];
    NSString* method = @"POST";
    NSURL *url = [NSURL URLWithString:endpoint];
    
    NSString *boundary = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    // set your Image Name
    NSString *filename = [NSString stringWithFormat:@"%@.jpg",boundary];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:method];
    [request setURL:url];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profilepicture\"; filename=\"%@.jpg\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:imageData];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error!=nil){
            block(nil,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(nil,responseError);
            return;
        }
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }

        [MZHelper saveJsonToFilename:cachedUserFileName dictionary:obj];
        sharedInstance = nil;
        block([[MZUser alloc]initWithJson:obj],nil);
    }];
}

- (void)recentLikeActivitiesLastId:(NSString*)lastId block:(ListResult)block{
    
    NSString* lastIdQueryString =lastId!=nil?[NSString stringWithFormat:@"?last=%@",lastId]:@"";
    NSString* endpoint =[NSString stringWithFormat:@"%@/users/me/activities/like%@",kBase_API_Endpoint,lastIdQueryString];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"GET"];
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
        NSArray* list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MZActivity* activity = [[MZActivity alloc]initWithJson:obj];
            [listResult addObject:activity];
        }];
        block(listResult,nil);
    }];
    [task resume];
}

- (void)saveDeviceToken:(NSString*)deviceToken deviceInfo:(NSString*)deviceInfo block:(ValidResult)block{
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/users/me/devices",kBase_API_Endpoint];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"PUT"];
    
    NSDictionary *params = @{
                             @"device_token":deviceToken,
                             @"device_info":deviceInfo
                             };
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(NO,[MZHelper errorRequireParameters]);
        return;
    }
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(NO,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(NO,responseError);
            return;
        }
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if (result==nil){
            block(NO,nil);
            return;
        }
        
        if ([[result objectForKey:@"device_token"] isEqualToString:deviceToken]){
            block(YES,nil);
        }
        
    }];
    [task resume];
}


-(void)checkInToBusiness:(MZBusiness*)business note:(NSString*)note block:(SingleRowResult)block{
    
    if (business.objectId==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/%@/%@/%@",kBase_API_Endpoint,[MZBusiness resourceName],business.objectId,@"checkins"];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"POST"];
    
    if (note!=nil){
        NSDictionary *params = @{
                                 @"note":note,
                                 };
        NSError* dataError = nil;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
        if (dataError!=nil){
            block(nil,[MZHelper errorRequireParameters]);
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }
        block([[MZCheckIn alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

-(void)recentCheckInWithBlock:(SingleRowResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/users/me/checkins/recent",kBase_API_Endpoint];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }
        block([[MZCheckIn alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

-(void)cancelRecentCheckInWithBlock:(SingleRowResult)block{
    NSString* endpoint =[NSString stringWithFormat:@"%@/users/me/checkins/recent",kBase_API_Endpoint];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"PUT"];
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }
        block([[MZCheckIn alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

- (void)joinMizuPayWithBlock:(SingleRowResult)block{
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/users/me/joins/pay",kBase_API_Endpoint];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"POST"];
    
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
        NSDictionary* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (obj==nil){
            block(nil,nil);
            return;
        }
        block([[MZUser alloc]initWithJson:obj],nil);
    }];
    [task resume];
}

- (void)updatePhoneNumber:(NSString*)phoneNumber block:(ValidResult)block{
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/users/me/phone",kBase_API_Endpoint];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"PUT"];
    
    NSDictionary *params = @{
                             @"phone":phoneNumber,
                             };
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(NO,[MZHelper errorRequireParameters]);
        return;
    }
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(NO,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(NO,responseError);
            return;
        }
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if (result==nil){
            block(NO,nil);
            return;
        }
        
        if ([[result objectForKey:@"phone"] isEqualToString:phoneNumber]){
            block(YES,nil);
        }
        
    }];
    [task resume];
}

- (void)updateDefaultTipPercent:(double)defaultTipPercent block:(ValidResult)block{
    
    if (defaultTipPercent<0 || defaultTipPercent>100){
        block(NO,nil);
        return;
    }
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/users/me/defaulttip",kBase_API_Endpoint];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"PUT"];
    
    NSDictionary *params = @{
                             @"default_tip_percent":[NSNumber numberWithDouble:defaultTipPercent],
                             };
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(NO,[MZHelper errorRequireParameters]);
        return;
    }
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error!=nil){
            block(NO,error);
            return;
        }
        NSError* responseError = [MZHelper response:response toNSError:data];
        if (responseError!=nil){
            block(NO,responseError);
            return;
        }
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        if (result==nil){
            block(NO,nil);
            return;
        }
        
        if ([[result objectForKey:@"default_tip_percent"] doubleValue] == defaultTipPercent){
            block(YES,nil);
        }
        
    }];
    [task resume];
}


- (void)updateDefaultTipPercentForRecentCheckIn:(double)defaultTipPercent block:(SingleRowResult)block{
    
    if (defaultTipPercent<0 || defaultTipPercent>100){
        block(nil,nil);
        return;
    }
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/users/me/checkins/recent/defaulttip",kBase_API_Endpoint];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:self method:@"PUT"];
    
    NSDictionary *params = @{
                             @"default_tip_percent":[NSNumber numberWithDouble:defaultTipPercent],
                             };
    NSError* dataError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&dataError];
    if (dataError!=nil){
        block(nil,[MZHelper errorRequireParameters]);
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
        
        block([[MZUser alloc]initWithJson:result],nil);
        
    }];
    [task resume];
}


-(void)myBusinesses:(ListResult)block{
    
    NSString* endpoint =[NSString stringWithFormat:@"%@/owner/businesses",kBase_API_Endpoint];
    
    endpoint = [endpoint stringByAddingPercentEscapesUsingEncoding:
                NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:endpoint];
    
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
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
        NSArray* list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [listResult addObject:[[MZBusiness alloc]initWithJson:obj]];
        }];
        block(listResult,nil);
    }];
    [task resume];
}

-(void)checkInHistories:(ListResult)block{
    if (self.userId==nil){
        block(nil,[MZHelper errorRequireParameters]);
        return;
    }
    NSString* endpoint =[NSString stringWithFormat:@"%@/users/me/checkins/histories",kBase_API_Endpoint];
    NSURL *url = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [MZHelper requestUserProtectedResource:url user:[MZUser currentUser] method:@"GET"];
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
        NSArray* obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSMutableArray* listResult = [[NSMutableArray alloc]init];
        [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MZCheckIn* checkIn =[[MZCheckIn alloc]initWithJson:obj];
            [listResult addObject:checkIn];
        }];
        block(listResult,nil);
    }];
    [task resume];
}

@end
