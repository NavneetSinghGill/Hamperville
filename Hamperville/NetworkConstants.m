//
//  NetworkConstants.m
//  Hamperville
//
//  Created by stplmacmini11 on 11/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "NetworkConstants.h"

NSString *baseUrl = @"http://staging.hamperville.com";
//NSString *baseUrl = @"http://52.24.184.147";
//NSString *baseUrl = @"http://api.hamperville.com";
//NSString *baseUrl = @"http://192.168.1.28:3001";

NSString *environmentType = @"development";
//NSString *environmentType = @"distribution";

NSString *kSuccessStatus = @"Success";
NSString *kSuccess = @"Yes";
NSString *kFailure = @"No";
NSString *kNoNetworkNotification = @"NoNetworkNotification";

#pragma mark - API urls

NSString *kLoginUrl = @"/api/v1/login/";

NSString *apiPostUserUrl = @"/api/v1/users/";
NSString *apiForgotPassword = @"/api/v1/forgot_password/";
NSString *apiChangePassword = @"/api/v1/change_password/";
NSString *apiLogout = @"/api/v1/logout/";

NSString *apiDeviceToken = @"/api/v1/devices";

NSString *apiRequestPickup = @"/api/v1/orders";

NSString *apiGetPickupAndDeliverPref = @"/api/v1/customer_preferences/";
NSString *apiPostPickupAndDeliverPref = @"/api/v1/customer_preferences/";
NSString *apiNotificationPref = @"/api/v1/customer_preferences/notification";
NSString *apiPermanentPref = @"/api/v1/customer_preferences/permanent";
NSString *apiWashAndFoldPref = @"/api/v1/customer_preferences/wash_dry_and_fold";
NSString *apiSpecialCarePref = @"/api/v1/customer_preferences/special_care";
NSString *apiWashAndPressPref = @"api/v1/customer_preferences/wash_and_press";

NSString *apiSchedulePickup = @"/api/v1/schedule/";
NSString *apiOrderHistory = @"/api/v1/orders/";

NSString *apiGetSubscription = @"/api/v1/subscriptions";
NSString *apiPostSubscription = @"/api/v1/users/";

NSString *apiAddress = @"/api/v1/users/address/";

NSString *apiModifyOrder = @"/api/v1/orders/update";
NSString *apiCancelOrder = @"/api/v1/orders/cancel";

NSString *apiAddCreditCard = @"/api/v1/credit_card";
NSString *apiDeleteCrediCard = @"/api/v1/credit_card/";
NSString *apiSetPrimaryCard = @"/api/v1/credit_card/"; NSString *apiSetPrimaryCardExtendedString = @"/make_primary";
NSString *apiGetAlreadyAddedCreditCards = @"/api/v1/credit_card";

NSString *apiGetPriceList = @"api/v1/subscriptions/price_list";

NSString *apiHelp = @"/api/v1/users/report_issue";

