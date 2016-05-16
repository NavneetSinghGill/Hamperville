//
//  NetworkConstants.m
//  Hamperville
//
//  Created by stplmacmini11 on 11/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "NetworkConstants.h"

//NSString *baseUrl = @"http://staging.hamperville.com";
//NSString *baseUrl = @"http://192.168.1.172:3001";
NSString *baseUrl = @"http://192.168.1.28:3001";

NSString *kSuccessStatus = @"Success";
NSString *kSuccess = @"Yes";
NSString *kFailure = @"No";

#pragma mark - API urls

NSString *kLoginUrl = @"/api/v1/login/";

NSString *apiPostUserUrl = @"/api/v1/users/";
NSString *apiForgotPassword = @"/api/v1/forgot_password/";
NSString *apiChangePassword = @"/api/v1/change_password/";
NSString *apiLogout = @"/api/v1/logout/";

NSString *apiRequestPickup = @"/api/v1/orders";

NSString *apiGetPickupAndDeliverPref = @"/api/v1/customer_preferences/";
NSString *apiPostPickupAndDeliverPref = @"/api/v1/customer_preferences/";
NSString *apiNotificationPref = @"/api/v1/customer_preferences/notification";
NSString *apiPermanentPref = @"/api/v1/customer_preferences/permanent";
NSString *apiWashAndFoldPref = @"/api/v1/customer_preferences/wash_dry_and_fold";
NSString *apiSpecialCarePref = @"/api/v1/customer_preferences/special_care";

NSString *apiSchedulePickup = @"/api/v1/schedule/";
NSString *apiOrderHistory = @"/api/v1/orders/";

