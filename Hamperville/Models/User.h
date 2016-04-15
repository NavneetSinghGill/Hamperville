//
//  User.h
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(strong, nonatomic) NSString *userID;
@property(strong, nonatomic) NSString *firstName;
@property(strong, nonatomic) NSString *lastName;
@property(strong, nonatomic) NSString *primaryPhone;
@property(strong, nonatomic) NSString *alternativePhone;
@property(strong, nonatomic) NSString *email;

+ (User *)getUserFromDictionary:(NSDictionary *)dict;

@end
