//
//  PickupRequest.h
//  Hamperville
//
//  Created by stplmacmini11 on 18/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"

@interface PickupRequest : Request

- (id)initWithSchedulePickup;
- (id)initWithRequestPickup:(NSDictionary *)dataDictionary;

- (id)initWithOrderHistoryRecordLimit:(NSInteger)limit time:(NSString *)timeStamp andOrderOffset:(NSString *)previousOrderID;

@end
