//
//  SubscriptionViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 19/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SubscriptionViewController.h"

@interface SubscriptionViewController ()

@property(weak, nonatomic) IBOutlet UILabel *subscriptionValueLabel;
@property(weak, nonatomic) IBOutlet UILabel *subscriptionNextRenewalDateLabel;

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Subscription" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
}

#pragma mark - IBAction methods

- (IBAction)changeSubscriptionButtonTapped:(id)sender {
    
}

@end
