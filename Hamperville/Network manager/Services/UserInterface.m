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
                self.block(YES, [response valueForKey:@"data"]);
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
