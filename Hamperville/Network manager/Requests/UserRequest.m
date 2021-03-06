//
//  UserRequest.m
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "UserRequest.h"

@interface UserRequest()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation UserRequest

- (id)initWithUser:(User *)user shouldUpdate:(BOOL)shouldUpdate{
    self = [super init];
    if (self) {
        _user = user;
        
        _parameters = [NSMutableDictionary dictionary];
        
        if (user.firstName.length > 0) {
            [_parameters setValue:user.firstName forKey:@"first_name"];
        }
        if (user.lastName.length > 0) {
            [_parameters setValue:user.lastName forKey:@"last_name"];
        }
        if (user.primaryPhone.length > 0) {
            [_parameters setValue:user.primaryPhone forKey:@"primary_phone"];
        }
        if (user.alternativePhone.length > 0) {
            [_parameters setValue:user.alternativePhone forKey:@"alternative_phone"];
        }
        
        if (shouldUpdate) {
            self.urlPath = [NSString stringWithFormat:@"%@%@/update/",apiPostUserUrl, user.userID];
        } else {
            self.urlPath = [NSString stringWithFormat:@"%@%@",apiPostUserUrl, user.userID];
        }
    }
    return self;
}

- (id)initWithUserID:(NSString *)userID {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        self.urlPath = [NSString stringWithFormat:@"%@%@",apiPostUserUrl, userID];
    }
    return self;
}

- (id)initWithEmail:(NSString *)email {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:email forKey:@"email"];
        self.urlPath = apiForgotPassword;
    }
    return self;
}

- (id)initWithOldPassword:(NSString *)oldPass andNwPassword:(NSString *)nwPass {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:oldPass forKey:@"old_password"];
        [_parameters setValue:nwPass forKey:@"new_password"];
        self.urlPath = apiChangePassword;
    }
    return self;
}

- (id)initWithUserToLogout:(User *)user {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:user.userID forKey:@"user_id"];
        self.urlPath = apiLogout;
    }
    return self;
}

- (id)initWithPostDeviceTokenWithDataDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        _parameters[@"cert_type"] = environmentType;
        if ([[NSUserDefaults standardUserDefaults]valueForKey:keyDeviceToken]) {
            _parameters[@"device_id"] = [[NSUserDefaults standardUserDefaults]valueForKey:keyDeviceToken];
        }
        _parameters[@"device_type"] = @"ios";
        self.urlPath = apiDeviceToken;
    }
    return self;
}

- (id)initWithGetPickAndDeliverWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.urlPath = [NSString stringWithFormat:@"%@/pickup_and_delivery",apiGetPickupAndDeliverPref];
    }
    return self;
}

- (id)initWithPostPickAndDeliverWithUser:(User *)user andMethod:(NSString *)method {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:method forKey:@"pickup_deliver_method"];
        self.urlPath = [NSString stringWithFormat:@"%@/pickup_and_delivery",apiPostPickupAndDeliverPref];
    }
    return self;
}

- (id)initWithGetNotificationPrefOfUser:(User *)user {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:user.userID forKey:@"user_id"];
        self.urlPath = apiNotificationPref;
    }
    return self;
}

- (id)initWithPostNotificationPrefWithAppNotification:(BOOL)app textNotifications:(BOOL)text andEmail:(BOOL)email {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:(app == YES)?@"true":@"false" forKey:@"app_notifications"];
        [_parameters setValue:(text == YES)?@"true":@"false" forKey:@"text_notifications"];
        [_parameters setValue:(email == YES)?@"true":@"false" forKey:@"emails_notifications"];
        self.urlPath = apiNotificationPref;
    }
    return self;
}

- (id)initWithPermanentPreferences {
    self = [super init];
    if (self) {
        self.urlPath = apiPermanentPref;
    }
    return self;
}

- (id)initWithPostPermanentPreferencesWithDetergentID:(NSString *)detergentID softnerID:(NSString *)softnerID drySheetID:(NSString *)drySheetID {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:detergentID forKey:@"detergent_id"];
        [_parameters setValue:softnerID forKey:@"softener_id"];
        [_parameters setValue:drySheetID forKey:@"dry_sheet_id"];
        self.urlPath = apiPermanentPref;
    }
    return self;
}

- (id)initWithGetWashAndFoldPreferences {
    self = [super init];
    if (self) {
        self.urlPath = apiWashAndFoldPref;
    }
    return self;
}

- (id)initWithPostWashAndFoldPreferencesWithDataDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if ([dataDictionary hasValueForKey:@"washer_temperature_dark_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"washer_temperature_dark_id"] forKey:@"washer_temperature_dark_id"];
        }
        if ([dataDictionary hasValueForKey:@"washer_temperature_light_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"washer_temperature_light_id"] forKey:@"washer_temperature_light_id"];
        }
        if ([dataDictionary hasValueForKey:@"washer_temperature_white_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"washer_temperature_white_id"] forKey:@"washer_temperature_white_id"];
        }
        if ([dataDictionary hasValueForKey:@"dryer_temperature_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"dryer_temperature_id"] forKey:@"dryer_temperature_id"];
        }
        if ([dataDictionary hasValueForKey:@"bleach_for_white_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"bleach_for_white_id"] forKey:@"bleach_for_white_id"];
        }
        if ([dataDictionary hasValueForKey:@"button_down_shirt_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"button_down_shirt_id"] forKey:@"button_down_shirt_id"];
        }
        if ([dataDictionary hasValueForKey:@"special_instruction_wdf"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"special_instruction_wdf"] forKey:@"special_instruction_wdf"];
        }
        self.urlPath = apiWashAndFoldPref;
    }
    return self;
}

- (id)initWithGetSpecialCarePreferences {
    self = [super init];
    if (self) {
        self.urlPath = apiSpecialCarePref;
    }
    return self;
}

- (id)initWithPostSpecialCarePreferencesWithDataDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if ([dataDictionary hasValueForKey:@"damage_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"damage_id"] forKey:@"damage_id"];
        }
        if ([dataDictionary hasValueForKey:@"shirt_pressing_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"shirt_pressing_id"] forKey:@"shirt_pressing_id"];
        }
        if ([dataDictionary hasValueForKey:@"pant_crease_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"pant_crease_id"] forKey:@"pant_crease_id"];
        }
        if ([dataDictionary hasValueForKey:@"starch_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"starch_id"] forKey:@"starch_id"];
        }
        if ([dataDictionary hasValueForKey:@"special_instruction_care"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"special_instruction_care"] forKey:@"special_instruction_care"];
        }
        self.urlPath = apiSpecialCarePref;
    }
    return self;
}

- (id)initWithGetWashAndPressPreferences {
    self = [super init];
    if (self) {
        self.urlPath = apiWashAndPressPref;
    }
    return self;
}

- (id)initWithPostWashAndPressPreferencesWithDataDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if ([dataDictionary hasValueForKey:@"wash_and_press_method"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"wash_and_press_method"] forKey:@"wash_and_press_method"];
        }
        self.urlPath = apiWashAndPressPref;
    }
    return self;
}

- (id)initWithGetSubscription {
    self = [super init];
    if (self) {
        self.urlPath = apiGetSubscription;
    }
    return self;
}

- (id)initWithPostSubscriptionWithStatus:(BOOL)status andSubscriptionID:(NSString *)subscriptionID {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        _parameters[@"status"] = [NSNumber numberWithBool:status];
        _parameters[@"subscription_id"] = subscriptionID;
        User *user = [[Util sharedInstance]getUser];
        self.urlPath = [NSString stringWithFormat:@"%@%@/modify_subscription",apiPostSubscription,user.userID];
    }
    return self;
}

- (id)initWithGetAddressPreferences {
    self = [super init];
    if (self) {
        self.urlPath = apiAddress;
    }
    return self;
}

- (id)initWithPostAddressWithDataDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if ([dataDictionary hasValueForKey:@"street"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"street"] forKey:@"street"];
        }
        if ([dataDictionary hasValueForKey:@"apartment_number"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"apartment_number"] forKey:@"apartment_number"];
        }
        if ([dataDictionary hasValueForKey:@"city"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"city"] forKey:@"city"];
        }
        if ([dataDictionary hasValueForKey:@"state"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"state"] forKey:@"state"];
        }
        if ([dataDictionary hasValueForKey:@"is_doorman_building"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"is_doorman_building"] forKey:@"is_doorman_building"];
        }
        self.urlPath = apiAddress;
    }
    return self;
}

- (id)initWithPostAddCreditWithDataDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if ([dataDictionary hasValueForKey:@"cc_type"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"cc_type"] forKey:@"cc_type"];
        }
        if ([dataDictionary hasValueForKey:@"cc_last_4_digits"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"cc_last_4_digits"] forKey:@"cc_last_4_digits"];
        }
        if ([dataDictionary hasValueForKey:@"year"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"year"] forKey:@"year"];
        }
        if ([dataDictionary hasValueForKey:@"month"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"month"] forKey:@"month"];
        }
        self.urlPath = apiAddCreditCard;
    }
    return self;
}

- (id)initWithDeleteCreditCard:(NSString *)creditCardID {
    self = [super init];
    if (self) {
        self.urlPath = [NSString stringWithFormat:@"%@%@",apiDeleteCrediCard, creditCardID];
    }
    return self;
}

- (id)initWithPostSetPrimaryCreditCard:(NSString *)creditCardID {
    self = [super init];
    if (self) {
        self.urlPath = [NSString stringWithFormat:@"%@%@%@",apiSetPrimaryCard ,creditCardID ,apiSetPrimaryCardExtendedString];
    }
    return self;
}

- (id)initWithGetAlreadyAddedCreditCards {
    self = [super init];
    if (self) {
        self.urlPath = apiGetAlreadyAddedCreditCards;
    }
    return self;
}

- (id)initWithGetPriceList {
    self = [super init];
    if (self) {
        self.urlPath = apiGetPriceList;
    }
    return self;
}

- (id)initWithPostHelpWithDataDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if ([dataDictionary hasValueForKey:@"title"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"title"] forKey:@"title"];
        }
        if ([dataDictionary hasValueForKey:@"description"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"description"] forKey:@"description"];
        }
        if ([dataDictionary hasValueForKey:@"image"]) {
            UIImage *image = [dataDictionary objectForKey:@"image"];
            
            if (image != nil) {
                self.fileData = UIImagePNGRepresentation(image);//logImageData;
                self.dataFilename = @"image";
                self.fileName = @"image.jpeg";
                self.mimeType = @"image/jpg";
                _parameters[@"image_"] = self.fileData;
                
//                imageDict[@"fileData"] = [UIImagePNGRepresentation(image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];//logImageData;
//                [imageDict setObject:UIImagePNGRepresentation(image) forKey:@"fileData"];
//                imageDict[@"dataFilename"] = @"ios_HampervilleIssueReportScreenshot";
//                imageDict[@"fileName"] = @"image.png";
//                imageDict[@"mimeType"] = @"image";
//                _parameters[@"image"] = imageDict;
            }
        }
        if ([dataDictionary hasValueForKey:@"logs"]) {
            NSMutableDictionary *logDict = [NSMutableDictionary dictionary];
            
            SMobiLogger *mobiLogger = [[SMobiLogger alloc] init];
            NSString *fetchLogString = [mobiLogger fetchLogs];
            
            logDict[@"fileData"] = [fetchLogString dataUsingEncoding:NSUTF8StringEncoding];
            logDict[@"dataFilename"] = @"file";
            logDict[@"fileName"] = @"issue_report.txt";
            logDict[@"mimeType"] = @"text/plain";
            _parameters[@"logDict"] = logDict;
        }
        self.urlPath = apiHelp;
    }
    return self;
}

- (NSDictionary *)getParams {
    if (_parameters != nil) {
        return _parameters;
    }
    return [NSMutableDictionary dictionary];
}

@end
