//
//  NetworkHttpClient.h
//  Hamperville
//
//  Created by stplmacmini11 on 08/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^successBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^failureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface NetworkHttpClient : AFHTTPSessionManager

+ (NetworkHttpClient *)sharedInstance;

- (void)postAPIcallWithUrl:(NSString *)url params:(NSDictionary *)params withSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;
- (void)getAPIcallWithUrl:(NSString *)url params:(NSDictionary *)params withSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;
- (void)putAPIcallWithUrl:(NSString *)url params:(NSDictionary *)params withSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;
- (void)deleteAPIcallWithUrl:(NSString *)url params:(NSDictionary *)params withSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;
- (void)multipartApiCallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters data:(NSData *)data name:(NSString *)dataFileName fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(successBlock)success failureBlock:(failureBlock)failure;

- (void)multipartApiCallForHelpWithUrl:(NSString *)url parameters:(NSDictionary *)parameters data:(NSData *)data name:(NSString *)dataFileName fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(successBlock)success failureBlock:(failureBlock)failure;

@end
