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

#pragma mark - User
- (void)postUser:(User *)user withCompletionBlock:(requestCompletionBlock)block;
- (void)getUserWithID:(NSString *)user withCompletionBlock:(requestCompletionBlock)block;
- (void)postForgotPasswordWithEmail:(NSString *)email withCompletionBlock:(requestCompletionBlock)block;
@end
