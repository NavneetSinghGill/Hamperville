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

#pragma mark Preferences

- (void)getPickupAndDeliverWithUser:(User *)user withCompletionBlock:(requestCompletionBlock)block;
- (void)postPickupAndDeliverWithUser:(User *)user andMethod:(NSString *)method withCompletionBlock:(requestCompletionBlock)block;
- (void)getNotificationPrefOfUser:(User *)user withCompletionBlock:(requestCompletionBlock)block;
- (void)postNotificationPrefWithAppNotification:(BOOL)app textNotifications:(BOOL)text andEmail:(BOOL)email withCompletionBlock:(requestCompletionBlock)block;

#pragma mark - Pickup

- (void)getSchedulePickup:(requestCompletionBlock)block;
- (void)getOrderHistoryWithLimit:(NSInteger)limit time:(NSDate *)timeStamp andOrderOffset:(NSInteger)previousOrderID withCompletionBlock:(requestCompletionBlock)block;

@end
