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
        [_parameters setValue:[NSNumber numberWithBool:detergentID] forKey:@"detergent_id"];
        [_parameters setValue:[NSNumber numberWithBool:softnerID] forKey:@"softener_id"];
        [_parameters setValue:[NSNumber numberWithBool:drySheetID] forKey:@"dry_sheet_id"];
        self.urlPath = apiPermanentPref;
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
