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

#pragma mark - User -

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

#pragma mark Preferences

- (void)getPickupAndDeliverWithUser:(User *)user withCompletionBlock:(requestCompletionBlock)block{
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] getPickupAndDeliverPreferencesWithUserRequest:[[UserRequest alloc] initWithGetPickAndDeliverWithUser:user]
                                                          andCompletionBlock:^(BOOL success, id response) {
                                                              block(success, response);
                                                          }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)postPickupAndDeliverWithUser:(User *)user andMethod:(NSString *)method withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] postPickupAndDeliverPreferencesWithUserRequest:[[UserRequest alloc] initWithPostPickAndDeliverWithUser:user andMethod:method]
                                                          andCompletionBlock:^(BOOL success, id response) {
                                                              block(success, response);
                                                          }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)getNotificationPrefOfUser:(User *)user withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] getNotificationPreferencesWithUserRequest:[[UserRequest alloc]initWithGetNotificationPrefOfUser:user]
                                                      andCompletionBlock:^(BOOL success, id response) {
                                                          block(success, response);
                                                      }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)postNotificationPrefWithAppNotification:(BOOL)app textNotifications:(BOOL)text andEmail:(BOOL)email withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] postNotificationPreferencesWithUserRequest:[[UserRequest alloc]initWithPostNotificationPrefWithAppNotification:app textNotifications:text andEmail:email]
                                                       andCompletionBlock:^(BOOL success, id response) {
                                                           block(success, response);
                                                       }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)getPermanentPreferences:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] getPermanentPreferencesWithUserRequest:[[UserRequest alloc] initWithPermanentPreferences]
                                                   andCompletionBlock:^(BOOL success, id response) {
                                                       block(success, response);
                                                   }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)postPermanentPreferencesWithDetergentID:(NSString *)detergentID softnerID:(NSString *)softnerID drySheetID:(NSString *)drySheetID withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] postPermanentPreferencesWithUserRequest:
         [[UserRequest alloc] initWithPostPermanentPreferencesWithDetergentID:detergentID
                                                                    softnerID:softnerID
                                                                   drySheetID:drySheetID]
                                                    andCompletionBlock:^(BOOL success, id response) {
                                                        block(success, response);
                                                    }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)getWashAndFoldPreferences:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] getWashAndFoldPreferencesWithUserRequest:[[UserRequest alloc] initWithGetWashAndFoldPreferences]
                                                     andCompletionBlock:^(BOOL success, id response) {
                                                         block(success, response);
                                                     }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)postWashAndFoldPreferencesWithDataDictionary:(NSDictionary *)dataDictionary withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] postWashAndFoldPreferencesWithUserRequest:[[UserRequest alloc] initWithPostWashAndFoldPreferencesWithDataDictionary:dataDictionary]
                                                     andCompletionBlock:^(BOOL success, id response) {
                                                         block(success, response);
                                                     }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)getSpecialCarePreferences:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] getSpecialCarePreferencesWithUserRequest:[[UserRequest alloc] initWithGetSpecialCarePreferences]
                                                     andCompletionBlock:^(BOOL success, id response) {
                                                         block(success, response);
                                                     }];
    } else {
        block(NO, kNoNetworkAvailable);
    }
}

- (void)postSpecialCarePreferencesWithDataDictionary:(NSDictionary *)dataDictionary withCompletionBlock:(requestCompletionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] postSpecialCarePreferencesWithUserRequest:[[UserRequest alloc] initWithPostSpecialCarePreferencesWithDataDictionary:dataDictionary]
                                                      andCompletionBlock:^(BOOL success, id response) {
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
