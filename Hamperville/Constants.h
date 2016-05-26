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

#pragma mark - TableViewCell constants

extern NSString *kLeftMenuTableViewCellNibName;
extern NSString *kLeftMenuTableViewCellIdentifier;

extern NSString *kCouponTableViewCellNibName;
extern NSString *kCouponTableViewCellIdentifier;

extern NSString *TVCOrderTableViewCellNibAndIdentifier;

extern NSString *TVCLocationTableViewCellNibAndIdentifier;

#pragma mark - Segue Identifiers

extern NSString *kToSWController;

#pragma mark - Messages

extern NSString *kNoNetworkAvailable;

#pragma mark - Local notifications

extern NSString *LNChangeShouldRefresh;

