//
//  SignupRequest.m
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SignupRequest.h"
#import "NetworkConstants.h"

@interface SignupRequest()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation SignupRequest

- (id)initWithEmail:(NSString *)email andPassword:(NSString *)password {
    self = [super init];
    if (self) {
        _email = email;
        _password = password;
        
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:email forKey:@"email"];
        [_parameters setValue:password forKey:@"password"];
        self.urlPath = kLoginUrl;
    }
    return self;
}

- (NSDictionary *)getParams {
    if (_parameters != nil) {
        return _parameters;
    }
    return [NSMutableDictionary dictionary];
}

@end
