//
//  ServiceInfo.m
//  Hamperville
//
//  Created by stplmacmini11 on 16/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ServiceInfo.h"

@implementation ServiceInfo

+ (ServiceInfo *)getServiceInfoWithServiceID:(NSString *)serviceID andIsAppliedStatus:(BOOL)isApplied {
    ServiceInfo *serviceInfo = [ServiceInfo new];
    serviceInfo.serviceID = serviceID;
    serviceInfo.isApplied = isApplied;
    
    return serviceInfo;
}

+ (ServiceInfo *)getServiceInfoWithServiceID:(NSString *)serviceID isAppliedStatus:(BOOL)isApplied andDifferenceOfDays:(NSInteger)difference {
    ServiceInfo *serviceInfo = [ServiceInfo new];
    serviceInfo.serviceID = serviceID;
    serviceInfo.isApplied = isApplied;
    serviceInfo.difference = difference;
    
    return serviceInfo;
}

@end
