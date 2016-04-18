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

- (NSDictionary *)getParams {
    if (_parameters != nil) {
        return _parameters;
    }
    return [NSMutableDictionary dictionary];
}

@end
