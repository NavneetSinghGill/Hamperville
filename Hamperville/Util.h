//
//  Util.h
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Util : NSObject

@property(strong, nonatomic) User *_user;

+ (Util *)sharedInstance;

- (User *)getUser;

- (void)saveUser:(User *)user;

@end
