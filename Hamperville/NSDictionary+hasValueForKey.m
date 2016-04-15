//
//  NSDictionary+hasValueForKey.m
//  VeoZen
//
//  Copyright (c) 2014 VeoZen. All rights reserved.
//

#import "NSDictionary+hasValueForKey.h"

@implementation NSDictionary_hasValueForKey


@end

@implementation NSDictionary (HasValueForKey)

- (BOOL)hasValueForKey:(NSString *)key
{
    if([self valueForKey:key] && [self valueForKey:key] != [NSNull alloc])
        return YES;
    else
        return NO;
}


@end
