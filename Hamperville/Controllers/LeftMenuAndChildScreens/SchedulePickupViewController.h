//
//  SchedulePickupViewController.h
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "HampervilleViewController.h"

@class Order;

@interface SchedulePickupViewController : HampervilleViewController

@property(assign, nonatomic) BOOL isModifyModeOn;
@property(strong, nonatomic) Order *orderToModify;

@end
