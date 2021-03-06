//
//  Constants.h
//  Hamperville
//
//  Created by stplmacmini11 on 06/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Numerical Constants

static const int kStatusSuccess = 1;
static const int kResponseStatusSuccess = 200;
static const int kResponseStatusAccepted = 202;
static const int kResponseStatusForbidden = 401;

extern NSString *kEmptyString;

extern NSString *kUserID;

extern NSString *kSessionCookies;

extern NSString *kNetworkAvailablability;

extern NSString *kRememberMe;
extern NSString *kUserEmail;
extern NSString *kUserPassword;

extern NSString *keyDeviceToken;

extern NSString *kAppReceivedPushNotification;
extern NSString *kPushNotificationMessage;

extern NSString *kShowOrderScreen;
extern NSString *kPushNotificationData;

#pragma mark - TableViewCell constants

extern NSString *kLeftMenuTableViewCellNibName;
extern NSString *kLeftMenuTableViewCellIdentifier;

extern NSString *kCouponTableViewCellNibName;
extern NSString *kCouponTableViewCellIdentifier;

extern NSString *TVCOrderTableViewCellNibAndIdentifier;

extern NSString *TVCLocationTableViewCellNibAndIdentifier;

extern NSString *TVCCreditCardTableViewCellNibAndIdentifier;

extern NSString *TVCPriceListSubscriptionHeaderIdentifier;
extern NSString *TVCPriceListSubscriptionCellIdentifier;
extern NSString *TVCPriceListServiceHeaderIdentifier;
extern NSString *TVCPriceListServiceCellIdentifier;

#pragma mark - Segue Identifiers

extern NSString *kToSWController;

#pragma mark - Messages

extern NSString *kNoNetworkAvailable;

#pragma mark - Local notifications

extern NSString *LNChangeShouldRefresh;

#pragma mark - UserDefault keys

extern NSString *kChangeRefreshStatusShowCardScreen;

