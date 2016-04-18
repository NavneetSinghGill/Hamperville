//
//  IHampervilleAPIInteractor.h
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Request;

typedef void (^apiInteractorCompletionBlock)(BOOL success, id response);

@protocol IHampervilleAPIInteractor <NSObject>

#pragma mark - Login
- (void)loginWithRequest:(Request *)signupRequest andCompletionBlock:(apiInteractorCompletionBlock)block;

#pragma mark - User
- (void)postUserDetailsWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block;
- (void)getUserWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block;
- (void)postForgotPassWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block;
- (void)putChangePassWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block;
- (void)logoutUserWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block;

#pragma mark - Pickup
- (void)getSchedulePickupWithRequest:(Request *)pickupRequest andCompletionBlock:(apiInteractorCompletionBlock)block;

@end
