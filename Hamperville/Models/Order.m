//
//  Order.m
//  Hamperville
//
//  Created by stplmacmini11 on 02/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Order.h"

@implementation Order

+ (Order *)getOrderFromDictionary:(NSDictionary *)dict {
    Order *order = [Order new];
    
    if ([dict hasValueForKey:@"delivery_date"]) {
        order.deliveryDate = [dict valueForKey:@"delivery_date"];
    }
    if ([dict hasValueForKey:@"delivery_time_slot"]) {
        order.deliveryTimeSlot = [dict valueForKey:@"delivery_time_slot"];
    }
    if ([dict hasValueForKey:@"order_amount"]) {
        order.orderAmount = [[dict valueForKey:@"order_amount"] integerValue];
    }
    if ([dict hasValueForKey:@"order_id"]) {
        order.orderID = [dict valueForKey:@"order_id"];
    }
    if ([dict hasValueForKey:@"order_status"]) {
        order.orderStatus = [dict valueForKey:@"order_status"];
    }
    if ([dict hasValueForKey:@"pick_up_date"]) {
        order.pickupDate = [dict valueForKey:@"pick_up_date"];
    }
    if ([dict hasValueForKey:@"pick_up_time_slot"]) {
        order.pickupTimeSlot = [dict valueForKey:@"pick_up_time_slot"];
    }
    if ([dict hasValueForKey:@"service_detail"]) {
        order.serviceDetail = [dict valueForKey:@"service_detail"];
    }
    return order;
}

@end
