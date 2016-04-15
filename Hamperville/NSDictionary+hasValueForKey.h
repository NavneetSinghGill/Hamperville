//
//  NSDictionary+hasValueForKey.h
//  VeoZen
//
//  Copyright (c) 2014 VeoZen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary_hasValueForKey : NSDictionary



@end

@interface NSDictionary (HasValueForKey)

- (BOOL)hasValueForKey:(NSString *)key;

@end
