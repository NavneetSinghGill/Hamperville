//
//  NSString+Properties.m
//  GlowVita
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "NSString+Properties.h"

@implementation NSString (Properties)

- (NSString *)append:(NSString *)appendText
{
    return [NSString stringWithFormat:@"%@%@",self, appendText];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
