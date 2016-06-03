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

- (void)multipartApiCallForHelpWithUrl:(NSString *)url parameters:(NSDictionary *)parameters data:(NSData *)data name:(NSString *)dataFileName fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    
    NSMutableDictionary *actualParams = [NSMutableDictionary dictionary];
    actualParams[@"title"] = parameters[@"title"];
    actualParams[@"description"] = parameters[@"description"];
//    NSData *imageFileData;
//    if ([parameters hasValueForKey:@"imageDict"]) {
//        imageFileData = [parameters[@"imageDict"] objectForKey:@"fileData"];
//        actualParams[@"image"] = imageFileData;
//    }
    if ([parameters objectForKey:@"image_"]) {
//        [actualParams setObject:[parameters objectForKey:@"image_"] forKey:@"image"];
    }
    if ([parameters hasValueForKey:@"logDict"]) {
        actualParams[@"logs"] = [parameters[@"logDict"] valueForKey:@"fileData"];
    }
    
    [self POST:url parameters:actualParams
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
        if ([parameters hasValueForKey:@"image_"]) {
//            if ([parameters hasValueForKey:@"imageDict"]) {
                //            NSDictionary *imageDict = [parameters valueForKey:@"imageDict"];
                [formData appendPartWithFileData:data//imageFileData
                                            name:dataFileName//imageDict[@"dataFilename"]
                                        fileName:fileName//imageDict[@"fileName"]
                                        mimeType:mimeType//imageDict[@"mimeType"]
                 ];
//            }
        }
        if ([parameters hasValueForKey:@"logDict"]) {
            NSDictionary *logDict = [parameters valueForKey:@"logDict"];
            [formData appendPartWithFileData:logDict[@"fileData"]
                                        name:logDict[@"dataFilename"]
                                    fileName:logDict[@"fileName"]
                                    mimeType:logDict[@"mimeType"]];
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

@end
