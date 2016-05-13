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
        self.urlPath = [NSString stringWithFormat:@"%@/pickup",apiSchedulePickup];
    }
    return self;
}

- (id)initWithRequestPickup:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _parameters = [NSMutableDictionary dictionary];
        if ([dataDictionary hasValueForKey:@"service_selected"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"service_selected"] forKey:@"service_selected"];
        }
        if ([dataDictionary hasValueForKey:@"pick_up_time"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"pick_up_time"] forKey:@"pick_up_time"];
        }
        if ([dataDictionary hasValueForKey:@"pick_up_time_slot_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"pick_up_time_slot_id"] forKey:@"pick_up_time_slot_id"];
        }
        if ([dataDictionary hasValueForKey:@"drop_off_time"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"drop_off_time"] forKey:@"drop_off_time"];
        }
        if ([dataDictionary hasValueForKey:@"drop_off_time_slot_id"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"drop_off_time_slot_id"] forKey:@"drop_off_time_slot_id"];
        }
        if ([dataDictionary hasValueForKey:@"coupon_code"]) {
            [_parameters setValue:[dataDictionary valueForKey:@"coupon_code"] forKey:@"coupon_code"];
        }
        self.urlPath = apiRequestPickup;
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

- (NSDictionary *)getParams {
    if (_parameters != nil) {
        return _parameters;
    }
    return [NSMutableDictionary dictionary];
}

@end
