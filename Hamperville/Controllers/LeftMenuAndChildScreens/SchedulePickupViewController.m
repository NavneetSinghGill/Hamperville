//
//  SchedulePickupViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SchedulePickupViewController.h"

@interface SchedulePickupViewController ()

@end

@implementation SchedulePickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarButtonTitle:@"Request Pickup" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
