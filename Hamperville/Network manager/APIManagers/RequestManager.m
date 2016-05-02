//
//  RequestManager.m
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "RequestManager.h"

#import "SignupInterface.h"
#import "SignupRequest.h"

#import "User.h"
#import "UserInterface.h"
#import "UserRequest.h"

#import "PickupInterface.h"
#import "PickupRequest.h"

@implementation RequestManager

#pragma mark - Login

- (void)loginWithUserEmail:(NSString *)email andPassword:(NSString *)password withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[SignupInterface alloc] loginWithRequest:[[SignupRequest alloc] initWithEmail:email andPassword:password] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

#pragma mark - User

- (void)postUser:(User *)user shouldUpdate:(BOOL)shouldUpdate withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] postUserDetailsWithRequest:[[UserRequest alloc] initWithUser:user shouldUpdate:shouldUpdate]
                                andCompletionBlock:^(BOOL success, id response) {
                                    block(success, response);
                                }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)getUserWithID:(NSString *)userID withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] getUserWithRequest:[[UserRequest alloc] initWithUserID:userID]
                               andCompletionBlock:^(BOOL success, id response) {
                                   block(success, response);
                               }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)postForgotPasswordWithEmail:(NSString *)email withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] postForgotPasswordWithRequest:[[UserRequest alloc] initWithEmail:email] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    } else {
        block(NO,kNoNetworkAvailable);
    }
}

- (void)putChangePasswordWithOldPassword:(NSString *)oldPass andNwPassword:(NSString *)nwPass withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] putChangePasswordWithRequest:[[UserRequest alloc] initWithOldPassword:oldPass andNwPassword:nwPass] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    } else {
        block(NO,kNoNetworkAvailable);
    }
}

- (void)logoutUser:(User *)user withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc]logoutUserWithUserRequest:[[UserRequest alloc] initWithUserToLogout:user] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

#pragma mark - Pickup

- (void)getSchedulePickup:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[PickupInterface alloc] getSchedulePickupWithPickupRequest:
         [[PickupRequest alloc] initWithSchedulePickup] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)getOrderHistoryWithLimit:(NSInteger)limit time:(NSDate *)timeStamp andOrderOffset:(NSInteger)previousOrderID withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[PickupInterface alloc] getOrderHistoryWithPickupRequest:
         [[PickupRequest alloc] initWithOrderHistoryRecordLimit:limit
                                                           time:timeStamp
                                                 andOrderOffset:previousOrderID]
                                               andCompletionBlock:^(BOOL success, id response) {
                                                   block(success, response);
                                               }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

@end
