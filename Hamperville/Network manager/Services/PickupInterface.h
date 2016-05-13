//
//  PickupInterface.h
//  Hamperville
//
//  Created by stplmacmini11 on 18/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PickupRequest.h"

typedef void (^pickupInterfaceCompletionBlock)(BOOL success, id response);

@interface PickupInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)getSchedulePickupWithPickupRequest:(PickupRequest *)pickupRequest andCompletionBlock:(pickupInterfaceCompletionBlock)block;
- (void)postRequestPickupWithPickupRequest:(PickupRequest *)pickupRequest andCompletionBlock:(pickupInterfaceCompletionBlock)block;

- (void)getOrderHistoryWithPickupRequest:(PickupRequest *)pickupRequest andCompletionBlock:(pickupInterfaceCompletionBlock)block;

@end
