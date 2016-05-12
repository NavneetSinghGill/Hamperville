//
//  RealHampervilleAPI.m
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "RealHampervilleAPI.h"
#import "Request.h"
#import "AFHTTPSessionManager.h"
#import "NetworkHttpClient.h"
#import "Constants.h"
#import "SignupInterface.h"

@implementation RealHampervilleAPI {
    BOOL isForbiddenRetry;
    Request *VMRequest;
}

#pragma mark - Login

- (void)loginWithRequest:(Request *)signupRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithPostObject:signupRequest
                withCompletionBlock:^(BOOL success, id response) {
                    block(success, response);
                }];
}

#pragma mark - User -

- (void)postUserDetailsWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithPostObject:userRequest
                withCompletionBlock:^(BOOL success, id response) {
                    block(success, response);
                }];
}

- (void)getUserWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithGetObject:userRequest
               withCompletionBlock:^(BOOL success, id response) {
                   block(success, response);
               }];
}

- (void)postForgotPassWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithPostObject:userRequest
                withCompletionBlock:^(BOOL success, id response) {
                    block(success, response);
                }];
}

- (void)putChangePassWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithPutObject:userRequest
               withCompletionBlock:^(BOOL success, id response) {
                   block(success, response);
               }];
}

- (void)logoutUserWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithDeleteObject:userRequest
                  withCompletionBlock:^(BOOL success, id response) {
                      block(success, response);
                  }];
}

#pragma mark Preferences

- (void)getPickupAndDeliverPreferencesWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithGetObject:userRequest
               withCompletionBlock:^(BOOL success, id response) {
                   block(success, response);
               }];
}

- (void)postPickupAndDeliverPreferencesWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithPostObject:userRequest
                withCompletionBlock:^(BOOL success, id response) {
                    block(success, response);
                }];
}

- (void)getNotificationPreferencesWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithGetObject:userRequest
               withCompletionBlock:^(BOOL success, id response) {
                   block(success, response);
               }];
}

- (void)postNotificationPreferencesWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithPostObject:userRequest
                withCompletionBlock:^(BOOL success, id response) {
                    block(success, response);
                }];
}

- (void)getPermanentPreferencesWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithGetObject:userRequest
               withCompletionBlock:^(BOOL success, id response) {
                   block(success, response);
               }];
}

- (void)postPermanentPreferencesWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithPostObject:userRequest
                withCompletionBlock:^(BOOL success, id response) {
                    block(success, response);
                }];
}

- (void)getWashAndFoldPreferencesWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithGetObject:userRequest
               withCompletionBlock:^(BOOL success, id response) {
                   block(success, response);
               }];
}

- (void)postWashAndFoldPreferencesWithRequest:(Request *)userRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithPostObject:userRequest
                withCompletionBlock:^(BOOL success, id response) {
                    block(success, response);
                }];
}

#pragma mark - Pickup

- (void)getSchedulePickupWithRequest:(Request *)pickupRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithGetObject:pickupRequest
               withCompletionBlock:^(BOOL success, id response) {
                   block(success, response);
               }];
}

- (void)getOrderHistoryWithRequest:(Request *)pickupRequest andCompletionBlock:(apiInteractorCompletionBlock)block {
    [self interactAPIWithGetObject:pickupRequest
               withCompletionBlock:^(BOOL success, id response) {
                   block(success, response);
               }];
}

#pragma mark - API interactor methods

- (void)interactAPIWithPostObject:(Request *)postObject withCompletionBlock:(apiInteractorCompletionBlock)block {
    [self initialSetupWithRequest:postObject requestType:RequestPOST];
    [[NetworkHttpClient sharedInstance] postAPIcallWithUrl:postObject.urlPath
                                                    params:[postObject getParams]
                                          withSuccessBlock:^(NSURLSessionDataTask *task, id responseObject) {
                                              [self handleSuccessResponse:task
                                                                 response:responseObject
                                                                withBlock:block];
                                              [[SignupInterface alloc] saveSessionCookies:postObject.urlPath];
                                          }
                                           andFailureBlock:^(NSURLSessionDataTask *task, NSError *error) {
                                               [self handleError:error
                                                       operation:task
                                                       withBlock:block];
                                           }];
}

- (void)interactAPIWithGetObject:(Request *)getObject withCompletionBlock:(apiInteractorCompletionBlock)block {
    [self initialSetupWithRequest:getObject requestType:RequestGET];
    [[NetworkHttpClient sharedInstance] getAPIcallWithUrl:getObject.urlPath
                                                   params:[getObject getParams]
                                         withSuccessBlock:^(NSURLSessionDataTask *task, id responseObject) {
                                             [self handleSuccessResponse:task
                                                                response:responseObject
                                                               withBlock:block];
                                             [[SignupInterface alloc] saveSessionCookies:getObject.urlPath];
                                         }
                                          andFailureBlock:^(NSURLSessionDataTask *task, NSError *error) {
                                              [self handleError:error
                                                      operation:task
                                                      withBlock:block];
                                          }];
}

- (void)interactAPIWithPutObject:(Request *)putObject withCompletionBlock:(apiInteractorCompletionBlock)block {
    [self initialSetupWithRequest:putObject requestType:RequestPUT];
    [[SignupInterface alloc] setSavedSessionCookies];
    [[NetworkHttpClient sharedInstance] putAPIcallWithUrl:putObject.urlPath
                                                   params:[putObject getParams]
                                         withSuccessBlock:^(NSURLSessionDataTask *task, id responseObject) {
                                             [self handleSuccessResponse:task
                                                                response:responseObject
                                                               withBlock:block];
                                         }
                                          andFailureBlock:^(NSURLSessionDataTask *task, NSError *error) {
                                              [self handleError:error
                                                      operation:task
                                                      withBlock:block];
                                          }];
}

- (void)interactAPIWithDeleteObject:(Request *)deleteObject withCompletionBlock:(apiInteractorCompletionBlock)block {
    [self initialSetupWithRequest:deleteObject requestType:RequestDELETE];
    [[NetworkHttpClient sharedInstance] deleteAPIcallWithUrl:deleteObject.urlPath
                                                      params:[deleteObject getParams]
                                            withSuccessBlock:^(NSURLSessionDataTask *task, id responseObject) {
                                                [self handleSuccessResponse:task
                                                                   response:responseObject
                                                                  withBlock:block];
                                            }
                                             andFailureBlock:^(NSURLSessionDataTask *task, NSError *error) {
                                                 [self handleError:error
                                                         operation:task
                                                         withBlock:block];
                                             }];
}

#pragma mark - Private methods

//Handling success response
- (void)handleSuccessResponse:(NSURLSessionDataTask *)task response:(id)responseObject withBlock:(apiInteractorCompletionBlock)block {
    
    NSHTTPURLResponse *responseStatus = (NSHTTPURLResponse *)task.response;
    //    NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"Success:- URL:%@\n response::%@", task.currentRequest.URL, responseObject);
    
    if(responseStatus.statusCode == kResponseStatusSuccess) {
        if (responseObject) {
            responseObject = [responseObject mutableCopy];
            [responseObject setValue:kSuccess forKey:kSuccessStatus];
            block(YES, responseObject);
        }
    } else {
        block(NO, nil);
    }
}

//Handling Error response
- (void)handleError:(NSError *)error operation:(NSURLSessionDataTask *)task withBlock:(apiInteractorCompletionBlock)block  {
    NSDictionary *errorResponse = [NSDictionary dictionary];
    if (error.localizedRecoverySuggestion != nil) {
        
        NSError *errorData;
        errorResponse = [NSJSONSerialization JSONObjectWithData: [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding]
                                                        options: NSJSONReadingMutableContainers
                                                          error: &errorData];
        NSHTTPURLResponse *responseStatus = (NSHTTPURLResponse *)task.response;
        
        if([self isForbiddenResponse:responseStatus.statusCode]) {
            return;
        }
        NSLog(@"\n Error :Failure with error: %@", [error localizedRecoverySuggestion]);
        errorResponse ? block(NO, errorResponse) : block(NO, error);
    } else if (error.localizedDescription != nil) {
        NSLog(@"\n Error :Failure with error: %@", [error localizedDescription]);
        
        NSLog(@"%@",error);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        
        NSMutableDictionary *serializedData = nil;
        if (errorData != nil) {
            serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        } else {
            serializedData = [NSMutableDictionary dictionaryWithObject:error.localizedDescription forKey:@"message"];
        }
        serializedData = [serializedData mutableCopy];
        [serializedData setValue:kFailure forKey:kSuccessStatus];
        NSLog(@"Failure error serialised - %@",serializedData);
        block(NO, serializedData);
    }
    
}

- (void)initialSetupWithRequest:(Request *)request requestType:(NSInteger)requestType {
    VMRequest = request;
    VMRequest.requestType = requestType;
    NSLog(@"Info: Performing API call [Request:%@] with [URL:%@] [params: %@]", [request class], request.urlPath, [request getParams]);
}

- (BOOL)isForbiddenResponse:(NSInteger)statusCode {
    if(statusCode == kResponseStatusForbidden && isForbiddenRetry == NO) {
        isForbiddenRetry = YES;
        return YES;
    }
    return NO;
}

@end
