//
//  ServiceInfo.h
//  Hamperville
//
//  Created by stplmacmini11 on 16/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceInfo : NSObject

@property(strong, nonatomic) NSString *serviceID;
@property(assign, nonatomic) BOOL isApplied;
@property(assign, nonatomic) NSInteger difference;

+ (ServiceInfo *)getServiceInfoWithServiceID:(NSString *)serviceID andIsAppliedStatus:(BOOL)isApplied;
+ (ServiceInfo *)getServiceInfoWithServiceID:(NSString *)serviceID isAppliedStatus:(BOOL)isApplied andDifferenceOfDays:(NSInteger)difference;

@end
