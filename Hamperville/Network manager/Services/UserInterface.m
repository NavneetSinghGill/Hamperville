//
//  UserInterface.m
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "UserInterface.h"
#import "APIInteractorProvider.h"
#import "IHampervilleAPIInteractor.h"

@implementation UserInterface

- (void)postUserDetailsWithRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postUserDetailsWithRequest:userRequest
                            andCompletionBlock:^(BOOL success, id response) {
                                [self parseGeneralMessageResponse:response];
                            }];
}

- (void)getUserWithRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getUserWithRequest:userRequest
                           andCompletionBlock:^(BOOL success, id response) {
                               [self parseGetUserResponse:response];
                           }];
}

- (void)postForgotPasswordWithRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postForgotPassWithRequest:userRequest
                                  andCompletionBlock:^(BOOL success, id response) {
                                      [self parseForgotPasswordResponse:response];
                                  }];
}

- (void)putChangePasswordWithRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider putChangePassWithRequest:userRequest
                                 andCompletionBlock:^(BOOL success, id response) {
                                     [self parseForgotPasswordResponse:response];
                                 }];
}

- (void)logoutUserWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider logoutUserWithRequest:userRequest
                              andCompletionBlock:^(BOOL success, id response) {
                                  [self parseGeneralMessageResponse:response];
                              }];
}

- (void)getPriceListWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getPriceListWithRequest:userRequest
                              andCompletionBlock:^(BOOL success, id response) {
                                  [self parseGeneralDataResponse:response];
                              }];
}

- (void)postHelpWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postHelpWithRequest:userRequest
                                andCompletionBlock:^(BOOL success, id response) {
                                    [self parseGeneralDataResponse:response];
                                }];
}

- (void)postDeviceDetailWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postDeviceDetailWithRequest:userRequest
                            andCompletionBlock:^(BOOL success, id response) {
                                [self parseGeneralDataResponse:response];
                            }];
}

#pragma mark Preferences

- (void)getPickupAndDeliverPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getPickupAndDeliverPreferencesWithRequest:userRequest
                                                  andCompletionBlock:^(BOOL success, id response) {
                                                      [self parseGeneralDataResponse:response];
                                                  }];
}

- (void)postPickupAndDeliverPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postPickupAndDeliverPreferencesWithRequest:userRequest
                                                   andCompletionBlock:^(BOOL success, id response) {
                                                       [self parseGeneralMessageResponse:response];
                                                   }];
}

- (void)getNotificationPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getNotificationPreferencesWithRequest:userRequest
                                              andCompletionBlock:^(BOOL success, id response) {
                                                  [self parseGeneralDataResponse:response];
                                              }];
}

- (void)postNotificationPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postNotificationPreferencesWithRequest:userRequest
                                              andCompletionBlock:^(BOOL success, id response) {
                                                  [self parseGeneralDataResponse:response];
                                              }];
}

- (void)getPermanentPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getPermanentPreferencesWithRequest:userRequest
                                           andCompletionBlock:^(BOOL success, id response) {
                                               [self parseGeneralDataResponse:response];
                                           }];
}

- (void)postPermanentPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postPermanentPreferencesWithRequest:userRequest
                                           andCompletionBlock:^(BOOL success, id response) {
                                               [self parseGeneralDataResponse:response];
                                           }];
}

- (void)getWashAndFoldPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getWashAndFoldPreferencesWithRequest:userRequest
                                            andCompletionBlock:^(BOOL success, id response) {
                                                [self parseGeneralDataResponse:response];
                                            }];
}

- (void)postWashAndFoldPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postWashAndFoldPreferencesWithRequest:userRequest
                                             andCompletionBlock:^(BOOL success, id response) {
                                                 [self parseGeneralDataResponse:response];
                                             }];
}

- (void)getSpecialCarePreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getSpecialCarePreferencesWithRequest:userRequest
                                             andCompletionBlock:^(BOOL success, id response) {
                                                 [self parseGeneralDataResponse:response];
                                             }];
}

- (void)postSpecialCarePreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postSpecialCarePreferencesWithRequest:userRequest
                                              andCompletionBlock:^(BOOL success, id response) {
                                                  [self parseGeneralDataResponse:response];
                                              }];
}

- (void)getWashAndPressPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getWashAndPressPreferencesWithRequest:userRequest
                                             andCompletionBlock:^(BOOL success, id response) {
                                                 [self parseGeneralDataResponse:response];
                                             }];
}

- (void)postWashAndPressPreferencesWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postWashAndPressPreferencesWithRequest:userRequest
                                              andCompletionBlock:^(BOOL success, id response) {
                                                  [self parseGeneralDataResponse:response];
                                              }];
}

#pragma mark Subscription

- (void)getSubscriptionWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getSpecialCarePreferencesWithRequest:userRequest
                                              andCompletionBlock:^(BOOL success, id response) {
                                                  [self parseGeneralDataResponse:response];
                                              }];
}

- (void)postSubscriptionWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postSpecialCarePreferencesWithRequest:userRequest
                                              andCompletionBlock:^(BOOL success, id response) {
                                                  [self parseGeneralDataResponse:response];
                                              }];
}

#pragma mark Address

- (void)getAddressWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getAddressWithRequest:userRequest
                                              andCompletionBlock:^(BOOL success, id response) {
                                                  [self parseGeneralDataResponse:response];
                                              }];
}

- (void)postAddressWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postAddressWithRequest:userRequest
                                              andCompletionBlock:^(BOOL success, id response) {
                                                  [self parseGeneralDataResponse:response];
                                              }];
}

#pragma mark Credit Card

- (void)postAddCreditCardWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postAddCreditCardWithRequest:userRequest
                               andCompletionBlock:^(BOOL success, id response) {
                                   [self parseGeneralDataResponse:response];
                               }];
}

- (void)deleteCreditCardWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider deleteCreditCardWithRequest:userRequest
                               andCompletionBlock:^(BOOL success, id response) {
                                   [self parseGeneralDataResponse:response];
                               }];
}

- (void)postSetPrimaryCreditCardWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider postSetPrimaryCreditCardWithRequest:userRequest
                               andCompletionBlock:^(BOOL success, id response) {
                                   [self parseGeneralDataResponse:response];
                               }];
}

- (void)getAlreadyAddedCreditCardsWithUserRequest:(UserRequest *)userRequest andCompletionBlock:(userInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider getAlreadyAddedCreditCardsWithRequest:userRequest
                               andCompletionBlock:^(BOOL success, id response) {
                                   [self parseGeneralDataResponse:response];
                               }];
}

#pragma mark - Parsing methods

- (void)parseGeneralMessageResponse:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if ([response hasValueForKey:kSuccessStatus]) {
            success = [response valueForKey:kSuccessStatus];
            if (success == kSuccess)
            {
                self.block(YES, [response valueForKey:@"message"]);
            }
            else
            {
                NSString *errorMessage = nil;
                if([response hasValueForKey:@"message"])
                {
                    errorMessage = [response valueForKey:@"message"];
                }
                _block(NO, errorMessage);
            }
        }
    }
    else if([response isKindOfClass:[NSError class]])
    {
        NSString *errorMessage = ((NSError *)response).localizedDescription;
        _block(NO, errorMessage);
    }
    else
    {
        _block(NO, nil);
    }
}

- (void)parseGeneralDataResponse:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if ([response hasValueForKey:kSuccessStatus]) {
            success = [response valueForKey:kSuccessStatus];
            if (success == kSuccess)
            {
                if ([response hasValueForKey:@"data"]) {
                    self.block(YES, [response valueForKey:@"data"]);
                } else if([response hasValueForKey:@"message"]){
                    self.block(YES, [response valueForKey:@"message"]);
                } else {
                    self.block(YES, @"Success");
                }
            }
            else
            {
                if ([response hasValueForKey:@"data"]) {
                    NSString *errorMessage = nil;
                    if([[response valueForKey:@"data"] hasValueForKey:@"message"])
                    {
                        errorMessage = [[response valueForKey:@"data"] valueForKey:@"message"];
                    }
                    _block(NO, errorMessage);
                } else {
                    NSString *errorMessage = nil;
                    if([response hasValueForKey:@"message"])
                    {
                        errorMessage = [response valueForKey:@"message"];
                    }
                    _block(NO, errorMessage);
                }
            }
        }
    }
    else if([response isKindOfClass:[NSError class]])
    {
        NSString *errorMessage = ((NSError *)response).localizedDescription;
        _block(NO, errorMessage);
    }
    else
    {
        _block(NO, nil);
    }
}

- (void)parseGetUserResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]])
    {
        if ([response hasValueForKey:@"data"])
        {
            User *user = [User getUserFromDictionary:[response valueForKey:@"data"]];
            self.block(YES, user);
        }
        else
        {
            NSString *errorMessage = nil;
            if([response hasValueForKey:@"message"])
            {
                errorMessage = [response valueForKey:@"message"];
            }
            _block(NO, errorMessage);
        }
    }
    else if([response isKindOfClass:[NSError class]])
    {
        NSString *errorMessage = ((NSError *)response).localizedDescription;
        _block(NO, errorMessage);
    }
    else
    {
        _block(NO, nil);
    }
}

- (void)parseForgotPasswordResponse:(id)response {
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        if ([response hasValueForKey:kSuccessStatus]) {
            success = [response valueForKey:kSuccessStatus];
            if (success == kSuccess)
            {
                self.block(YES, [response valueForKey:@"message"]);
            }
            else
            {
                NSString *errorMessage = nil;
                if([response hasValueForKey:@"message"])
                {
                    errorMessage = [response valueForKey:@"message"];
                }
                _block(NO, errorMessage);
            }
        }
    }
    else if([response isKindOfClass:[NSError class]])
    {
        NSString *errorMessage = ((NSError *)response).localizedDescription;
        _block(NO, errorMessage);
    }
    else
    {
        _block(NO, nil);
    }
}

@end
