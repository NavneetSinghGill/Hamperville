//
//  UserRequest.h
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"
#import "User.h"

@interface UserRequest : Request

@property(strong, nonatomic) User *user;

- (id)initWithUser:(User *)user shouldUpdate:(BOOL)shouldUpdate;
- (id)initWithUserID:(NSString *)userID;
- (id)initWithEmail:(NSString *)email;
- (id)initWithOldPassword:(NSString *)oldPass andNwPassword:(NSString *)nwPass;

- (NSDictionary *)getParams;

@end
