//
//  SignupInterface.h
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignupRequest.h"

typedef void (^signupInterfaceCompletionBlock)(BOOL success, id response);

@interface SignupInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)loginWithRequest:(SignupRequest *)signupRequest andCompletionBlock:(signupInterfaceCompletionBlock)block;

- (NSMutableArray *)getSavedSessionCookies;

- (BOOL)setSavedSessionCookies;

- (void)saveSessionCookies:(NSString *)urlPath;

- (void)clearSavedSessionCookies;

@end
