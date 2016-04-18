//
//  PickupRequest.m
//  Hamperville
//
//  Created by stplmacmini11 on 18/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PickupRequest.h"

@interface PickupRequest()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation PickupRequest

- (id)initWithSchedulePickup {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        self.urlPath = [NSString stringWithFormat:@"%@/%@/pickup",apiSchedulePickup, [[[Util sharedInstance]getUser]userID]];
    }
    return self;
}

@end
