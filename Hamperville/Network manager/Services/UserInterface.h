//
//  UserInterface.h
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRequest.h"

typedef void (^userInterfaceCompletionBlock)(BOOL success, id response);

@interface UserInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)postUserDetailsWithRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)getUserWithRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)postForgotPasswordWithRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)putChangePasswordWithRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)logoutUserWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)getPriceListWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)postHelpWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)postDeviceDetailWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

#pragma mark Preferences

- (void)getPickupAndDeliverPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)postPickupAndDeliverPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)getNotificationPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)postNotificationPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)getPermanentPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)postPermanentPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)getWashAndFoldPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)postWashAndFoldPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)getSpecialCarePreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)postSpecialCarePreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

- (void)getWashAndPressPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)postWashAndPressPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

#pragma mark Subscription

- (void)getSubscriptionWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)postSubscriptionWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

#pragma mark Address

- (void)getAddressWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)postAddressWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

#pragma mark Credit Card

- (void)postAddCreditCardWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)deleteCreditCardWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)postSetPrimaryCreditCardWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;
- (void)getAlreadyAddedCreditCardsWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block;

@end
