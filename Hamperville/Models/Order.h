//
//  Order.h
//  Hamperville
//
//  Created by stplmacmini11 on 02/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property(strong, nonatomic) NSString *deliveryDate;
@property(strong, nonatomic) NSString *deliveryTimeSlot;
@property(assign, nonatomic) float orderAmount;
@property(strong, nonatomic) NSString *orderID;
@property(strong, nonatomic) NSString *orderNumber;
@property(strong, nonatomic) NSString *orderStatus;
@property(strong, nonatomic) NSString *pickupDate;
@property(strong, nonatomic) NSString *pickupTimeSlot;
@property(strong, nonatomic) NSMutableArray *serviceDetail;
@property(strong, nonatomic) NSString *coupons;
@property(strong, nonatomic) NSString *specialNotes;

+ (Order *)getOrderFromDictionary:(NSDictionary *)dict;
+ (void)printOrder:(Order *)order;

@end
