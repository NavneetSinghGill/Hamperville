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

- (id)initWithOrderHistoryRecordLimit:(NSInteger)limit time:(NSDate *)timeStamp andOrderOffset:(NSInteger)previousOrderID {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        _parameters[@"limit"] = [NSNumber numberWithInteger:limit];
        _parameters[@"timestamp"] = timeStamp;
        if (previousOrderID != -1) {
            _parameters[@"orderOffset"] = [NSNumber numberWithInteger:previousOrderID];
        }
        self.urlPath = apiOrderHistory;
    }
    return self;
}

@end
