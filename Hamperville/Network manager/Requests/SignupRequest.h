//
//  SignupRequest.h
//  Hamperville
//
//  Created by stplmacmini11 on 07/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"

@interface SignupRequest : Request

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

- (id)initWithEmail:(NSString *)email andPassword:(NSString *)password;
- (NSMutableDictionary *)getParams;

@end
