//
//  SchedulePickupViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SchedulePickupViewController.h"
#import "RequestManager.h"

@interface SchedulePickupViewController ()

@property(strong, nonatomic) NSMutableArray *dropOffSlots;
@property(strong, nonatomic) NSMutableArray *pickupUpSlots;
@property(strong, nonatomic) NSMutableArray *services;
@property(strong, nonatomic) NSMutableArray *universalCoupons;

@end

@implementation SchedulePickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarButtonTitle:@"Request Pickup" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self schedulePickupAPIcall];
}

- (void)schedulePickupAPIcall {
    [[RequestManager alloc] getSchedulePickup:^(BOOL success, id response) {
        if (success) {
            
        }
    }];
}

@end
