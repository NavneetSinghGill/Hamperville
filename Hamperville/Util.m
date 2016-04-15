//
//  Util.m
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Util.h"

@implementation Util

#pragma mark - Public methods

+ (Util *)sharedInstance {
    static Util *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (User *)getUser {
    User *user = [User new];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    user.userID = [defaults valueForKey:kUserID];
    user.firstName = [defaults valueForKey:@"firstName"];
    user.lastName = [defaults valueForKey:@"lastName"];
    user.primaryPhone = [defaults valueForKey:@"primaryPhone"];
    user.alternativePhone = [defaults valueForKey:@"alternativePhone"];
    
    return user;
}

- (void)saveUser:(User *)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:user.userID forKey:kUserID];
    [defaults setValue:user.firstName forKey:@"firstName"];
    [defaults setValue:user.lastName forKey:@"lastName"];
    [defaults setValue:user.primaryPhone forKey:@"primaryPhone"];
    [defaults setValue:user.alternativePhone forKey:@"alternativePhone"];
    [defaults synchronize];
}

@end
