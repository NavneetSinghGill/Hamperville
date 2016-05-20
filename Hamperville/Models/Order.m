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
    if ([dict hasValueForKey:@"total_amount"]) {
        order.orderAmount = [[dict valueForKey:@"total_amount"] integerValue];
    }
    if ([dict hasValueForKey:@"id"]) {
        order.orderID = [NSString stringWithFormat:@"%ld",[[dict valueForKey:@"id"] integerValue]];
    }
    if ([dict hasValueForKey:@"state"]) {
        order.orderStatus = [dict valueForKey:@"state"];
    }
    if ([dict hasValueForKey:@"pickup_date"]) {
        order.pickupDate = [dict valueForKey:@"pickup_date"];
    }
    if ([dict hasValueForKey:@"pick_up_time_slot"]) {
        order.pickupTimeSlot = [dict valueForKey:@"pick_up_time_slot"];
    }
    if ([dict hasValueForKey:@"service_detail"]) {
        order.serviceDetail = [dict valueForKey:@"service_detail"];
    }
    return order;
}

+ (void)printOrder:(Order *)order {
    NSLog(@"\n\nOrder ID\t\t: %@ \nPickup date\t\t: %@ \nPickup timeslot\t: %@ \nDelivery date\t\t: %@ \nDelivery timeslot\t: %@ \nOrder amount\t\t: %ld \nOrder status\t\t: %@ \nOrder service detail: %@",order.orderID,order.pickupDate,order.pickupTimeSlot,order.deliveryDate,order.deliveryTimeSlot,(long)order.orderAmount,order.orderStatus,order.serviceDetail);
}

@end
