//
//  User.m
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)getUserFromDictionary:(NSDictionary *)dict {
    User *user = [User new];
    
    if ([dict hasValueForKey:@"alternative_phone"]) {
        NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
        [nonNumberCharacterSet invert];
        
        user.alternativePhone = [[[dict valueForKey:@"alternative_phone"] componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
    }
    if ([dict hasValueForKey:@"email"]) {
        user.email = [dict valueForKey:@"email"];
    }
    if ([dict hasValueForKey:@"first_name"]) {
        user.firstName = [dict valueForKey:@"first_name"];
    }
    if ([dict hasValueForKey:@"id"]) {
        user.userID = [dict valueForKey:@"id"];
    }
    if ([dict hasValueForKey:@"last_name"]) {
        user.lastName = [dict valueForKey:@"last_name"];
    }
    if ([dict hasValueForKey:@"primary_phone"]) {
            NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
            [nonNumberCharacterSet invert];
            
            user.primaryPhone = [[[dict valueForKey:@"primary_phone"] componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
    }
    return user;
}

@end
