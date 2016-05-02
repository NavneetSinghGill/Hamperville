//
//  NetworkConstants.m
//  Hamperville
//
//  Created by stplmacmini11 on 11/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "NetworkConstants.h"

NSString *baseUrl = @"http://staging.hamperville.com";

NSString *kSuccessStatus = @"Success";
NSString *kSuccess = @"Yes";
NSString *kFailure = @"No";

#pragma mark - API urls

NSString *kLoginUrl = @"/api/v1/login/";

NSString *apiPostUserUrl = @"/api/v1/users/";
NSString *apiForgotPassword = @"/api/v1/forgot_password/";
NSString *apiChangePassword = @"/api/v1/change_password/";
NSString *apiLogout = @"/api/v1/logout/";

NSString *apiSchedulePickup = @"/api/v1/schedule/";
NSString *apiOrderHistory = @"/api/v1/orders/history";