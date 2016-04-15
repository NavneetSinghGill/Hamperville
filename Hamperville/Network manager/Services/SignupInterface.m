//
//  SignupInterface.m
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SignupInterface.h"
#import "APIInteractorProvider.h"

@implementation SignupInterface

- (void)loginWithRequest:(SignupRequest *)signupRequest andCompletionBlock:(signupInterfaceCompletionBlock)block {
    _block = block;
    id apiInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [apiInteractorProvider loginWithRequest:signupRequest andCompletionBlock:^(BOOL success, id response) {
        [self parseLoginResponse:response];
    }];
}

#pragma mark - Parsing methods

- (void)parseLoginResponse:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *success = nil;
        
        if ([response hasValueForKey:@"user_id"])
        {
            NSString *userId =  [response valueForKey:@"user_id"];
            self.block(YES, userId);
        }
        else
        {
            NSString *errorMessage = nil;
            if([response hasValueForKey:@"message"])
            {
                errorMessage = [response valueForKey:@"message"];
            }
            _block([success integerValue], errorMessage);
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
