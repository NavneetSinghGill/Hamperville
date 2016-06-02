//
//  NetworkHttpClient.m
//  Hamperville
//
//  Created by stplmacmini11 on 08/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "NetworkHttpClient.h"
#import "NetworkConstants.h"

@implementation NetworkHttpClient

+ (NetworkHttpClient *)sharedInstance {
    static NetworkHttpClient *_networkHttpClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkHttpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        [_networkHttpClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        [[_networkHttpClient requestSerializer] setTimeoutInterval:30];
    });
    
    return _networkHttpClient;
}

#pragma mark - API call methods

- (void)postAPIcallWithUrl:(NSString *)url params:(NSDictionary *)params withSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure {
    [self POST:url
    parameters:params
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           success(task, responseObject);
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           failure(task, error);
       }];
}

- (void)getAPIcallWithUrl:(NSString *)url params:(NSDictionary *)params withSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure {
    [self GET:url
   parameters:params
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          success(task, responseObject);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          failure(task, error);
      }];
}

- (void)putAPIcallWithUrl:(NSString *)url params:(NSDictionary *)params withSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure {
    [self PUT:url
   parameters:params
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          success(task, responseObject);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          failure(task, error);
      }];
}

- (void)deleteAPIcallWithUrl:(NSString *)url params:(NSDictionary *)params withSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure {
    [self DELETE:url
      parameters:params
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
             success(task, responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failure(task, error);
         }];
}

- (void)multipartApiCallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters data:(NSData *)data name:(NSString *)dataFileName fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    
    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:dataFileName fileName:fileName mimeType:mimeType];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

@end
