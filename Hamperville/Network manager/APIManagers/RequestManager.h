//
//  RequestManager.h
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

typedef void (^requestCompletionBlock)(BOOL success,id response);

@interface RequestManager : NSObject

#pragma mark - Login
- (void)loginWithUserEmail:(NSString *)email andPassword:(NSString *)password withCompletionBlock:(requestCompletionBlock)block;

#pragma mark - User -
- (void)postUser:(User *)user shouldUpdate:(BOOL)shouldUpdate withCompletionBlock:(requestCompletionBlock)block;
- (void)getUserWithID:(NSString *)user withCompletionBlock:(requestCompletionBlock)block;
- (void)postForgotPasswordWithEmail:(NSString *)email withCompletionBlock:(requestCompletionBlock)block;
- (void)putChangePasswordWithOldPassword:(NSString *)oldPass andNwPassword:(NSString *)nwPass withCompletionBlock:(requestCompletionBlock)block;
- (void)logoutUser:(User *)user withCompletionBlock:(requestCompletionBlock)block;

- (void)getPriceList:(requestCompletionBlock)block;

#pragma mark Preferences

- (void)getPickupAndDeliverWithUser:(User *)user withCompletionBlock:(requestCompletionBlock)block;
- (void)postPickupAndDeliverWithUser:(User *)user andMethod:(NSString *)method withCompletionBlock:(requestCompletionBlock)block;

- (void)getNotificationPrefOfUser:(User *)user withCompletionBlock:(requestCompletionBlock)block;
- (void)postNotificationPrefWithAppNotification:(BOOL)app textNotifications:(BOOL)text andEmail:(BOOL)email withCompletionBlock:(requestCompletionBlock)block;

- (void)getPermanentPreferences:(requestCompletionBlock)block;
- (void)postPermanentPreferencesWithDetergentID:(NSString *)detergentID softnerID:(NSString *)softnerID drySheetID:(NSString *)drySheetID withCompletionBlock:(requestCompletionBlock)block;

- (void)getWashAndFoldPreferences:(requestCompletionBlock)block;
- (void)postWashAndFoldPreferencesWithDataDictionary:(NSDictionary *)dataDictionary withCompletionBlock:(requestCompletionBlock)block;

- (void)getSpecialCarePreferences:(requestCompletionBlock)block;
- (void)postSpecialCarePreferencesWithDataDictionary:(NSDictionary *)dataDictionary withCompletionBlock:(requestCompletionBlock)block;

#pragma mark Subscription

- (void)getSubscription:(requestCompletionBlock)block;
- (void)postSubscriptionWithStatus:(BOOL)status andSubscriptionID:(NSString *)subscriptionID withCompletionBlock:(requestCompletionBlock)block;

#pragma mark Address

- (void)getAddress:(requestCompletionBlock)block;
- (void)postAddressWithDataDictionary:(NSDictionary *)dataDictionary withCompletionBlock:(requestCompletionBlock)block;

#pragma mark Credit card

- (void)postAddCreditWithDataDictionary:(NSDictionary *)dataDictionary withCompletionBlock:(requestCompletionBlock)block;
- (void)deleteCreditCard:(NSString *)creditCardID withCompletionBlock:(requestCompletionBlock)block;
- (void)postSetPrimaryCreditCard:(NSString *)creditCardID withCompletionBlock:(requestCompletionBlock)block;
- (void)getAlreadyAddedCreditCards:(requestCompletionBlock)block;

#pragma mark - Pickup

- (void)getSchedulePickup:(requestCompletionBlock)block;
- (void)postRequestPickupWithDataDictionary:(NSDictionary *)dataDictionary withCompletionBlock:(requestCompletionBlock)block;

- (void)getOrderHistoryWithLimit:(NSInteger)limit time:(NSString *)timeStamp andOrderOffset:(NSString *)previousOrderID withCompletionBlock:(requestCompletionBlock)block;

- (void)postModifyOrderWithDataDictionary:(NSDictionary *)dataDictionary withCompletionBlock:(requestCompletionBlock)block;
- (void)postCancelOrderWithOrderID:(NSString *)orderID withCompletionBlock:(requestCompletionBlock)block;

@end
