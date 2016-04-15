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

#pragma mark public method

// Session methods
- (NSMutableArray *)getSavedSessionCookies
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *httpCookies = nil;
    
    httpCookies = [userDefaults objectForKey:kSessionCookies];
    return httpCookies;
}

- (BOOL)setSavedSessionCookies
{
    NSMutableArray *httpCookies = [self getSavedSessionCookies];
    if(httpCookies.count)
    {
        for (NSDictionary* cookieProperties in httpCookies)
        {
            NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        return YES;
    }
    return NO;
}

- (void)saveSessionCookies:(NSString *)urlPath
{
    if([urlPath isEqualToString:kLoginUrl] )
    {
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        NSArray *httpCookies = [cookies cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl, urlPath]]];
        NSMutableArray *sessionCookies = [[NSMutableArray alloc]init];
        for (NSHTTPCookie* cookie in httpCookies)
        {
            [sessionCookies addObject:cookie.properties];
        }
        
        if(sessionCookies.count)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:sessionCookies forKey:kSessionCookies];
            [userDefaults synchronize];
        }
    }
}

- (void)clearSavedSessionCookies
{
    for (NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kSessionCookies];
    [userDefaults synchronize];
}

@end
