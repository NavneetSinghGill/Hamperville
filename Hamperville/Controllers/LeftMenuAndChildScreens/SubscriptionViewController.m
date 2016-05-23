//
//  SubscriptionViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 19/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "RequestManager.h"
#import "ChangeSubscriptionViewController.h"

@interface SubscriptionViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UpdateSubscriptionDelegate> {
    
}

@property(weak, nonatomic) IBOutlet UIView *subscriptionOnView;
@property(weak, nonatomic) IBOutlet UIView *subscriptionOffView;

@property(weak, nonatomic) IBOutlet UILabel *subscriptionValueLabel;
@property(weak, nonatomic) IBOutlet UILabel *subscriptionNextRenewalDateLabel;
@property(weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(strong, nonatomic) NSMutableArray *allSubscriptions;
@property(assign, nonatomic) BOOL status;
@property(strong, nonatomic) NSDate *nextRenewalDate;
@property(assign, nonatomic) NSInteger currentSubscriptionPlanID;

@end

@implementation SubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.shouldRefresh) {
        self.subscriptionOffView.hidden = YES;
        self.subscriptionOnView.hidden = YES;
        [self getSubscriptionStatus];
    }
    self.shouldRefresh = NO;
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Subscription" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    
    self.subscriptionOffView.hidden = YES;
    self.subscriptionOnView.hidden = YES;
    
    self.allSubscriptions = [NSMutableArray array];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)getSubscriptionStatus {
    [self.activityIndicator startAnimating];
    [[RequestManager alloc]getSubscription:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            if ([response hasValueForKey:@"subscription_status"]) {
                BOOL status = [[response valueForKey:@"subscription_status"] boolValue];
                self.status = status;
                if (status) {
                    self.subscriptionOnView.hidden = NO;
                    self.subscriptionOffView.hidden = YES;
                } else {
                    self.subscriptionOnView.hidden = YES;
                    self.subscriptionOffView.hidden = NO;
                }
                self.allSubscriptions = [response valueForKey:@"sam_subscriptions"];
                if ([response hasValueForKey:@"next_subscription_date"]) {
                    self.nextRenewalDate = [NSDate dateWithTimeIntervalSince1970:[[response valueForKey:@"next_subscription_date"] integerValue]];
                    self.subscriptionNextRenewalDateLabel.text = [self getFormattedDateForRenewalDate:self.nextRenewalDate];
                }
                if ([response hasValueForKey:@"subscription_plan_id"]) {
                    self.currentSubscriptionPlanID = [[response valueForKey:@"subscription_plan_id"] integerValue];
                    for (NSDictionary *subscription in self.allSubscriptions) {
                        if ([[subscription valueForKey:@"subscription_plan"] valueForKey:@"id"] == [response valueForKey:@"subscription_plan_id"]) {
                            self.subscriptionValueLabel.text = [NSString stringWithFormat:@"$ %@",[[subscription valueForKey:@"subscription_plan"] valueForKey:@"amount"]];
                        }
                    }
                }
            }
        } else {
            [self showToastWithText:response on:Top];
        }
    }];
}

- (void)openChangeSubscriptionScreen {
    ChangeSubscriptionViewController *changeSubscriptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeSubscriptionViewController"];
    changeSubscriptionViewController.updateDelegate = self;
    changeSubscriptionViewController.allSubscriptions = self.allSubscriptions;
    changeSubscriptionViewController.status = self.status;
    if (self.subscriptionOffView.hidden == YES) { // OR subscriberOnView.hidden == NO
        changeSubscriptionViewController.currentSubscriptionPlanID = self.currentSubscriptionPlanID;
    }
    [self.navigationController pushViewController:changeSubscriptionViewController animated:YES];
}

- (NSString *)getFormattedDateForRenewalDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *resultantString = @"Next Renewal Date ";
    dateFormatter.dateFormat = @"dd";
    resultantString = [NSString stringWithFormat:@"%@%@",resultantString, [dateFormatter stringFromDate:date]];
    dateFormatter.dateFormat = @"MMMM";
    resultantString = [NSString stringWithFormat:@"%@ %@",resultantString, [dateFormatter stringFromDate:date]];
    dateFormatter.dateFormat = @"YYYY";
    resultantString = [NSString stringWithFormat:@"%@, %@",resultantString, [dateFormatter stringFromDate:date]];
    return resultantString;
}

#pragma mark - IBAction methods

- (IBAction)changeSubscriptionButtonTapped:(id)sender {
//    [self postSubscription];
    [self openChangeSubscriptionScreen];
}

- (IBAction)subscribeNowButtonTapped:(id)sender {
    [self openChangeSubscriptionScreen];
}

#pragma mark - Custom delegate methods

- (void)updateViewsWithStatus:(BOOL)status subscriptionID:(NSInteger)subscriptionID andNextRenewalDate:(NSDate *)renewalDate {
    self.status = status;
    self.subscriptionOffView.hidden = status;
    self.subscriptionOnView.hidden = !status;
    self.currentSubscriptionPlanID = subscriptionID;
    for (NSDictionary *subscription in self.allSubscriptions) {
        if ([[[subscription valueForKey:@"subscription_plan"] valueForKey:@"id"] integerValue] == subscriptionID) {
            self.subscriptionValueLabel.text = [NSString stringWithFormat:@"$ %@",[[subscription valueForKey:@"subscription_plan"] valueForKey:@"amount"]];
        }
    }
    self.nextRenewalDate = renewalDate;
    self.subscriptionNextRenewalDateLabel.text = [self getFormattedDateForRenewalDate:renewalDate];
}

- (void)updateViewsWithStatus:(BOOL)status {
    self.status = status;
    self.subscriptionOffView.hidden = status;
    self.subscriptionOnView.hidden = !status;
}

#pragma mark - PickerView methods -

#pragma mark PickerView Delegate and Datasource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.allSubscriptions.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [tView setTextColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]];
        [tView setFont:[UIFont fontWithName:@"roboto-regular" size:13.0]];
        tView.textAlignment = NSTextAlignmentCenter;
    }
    // Fill the label text here
    NSDictionary *option = self.allSubscriptions[row];
    tView.text = [option valueForKey:@"amount"];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *optionsSelectedProduct = self.allSubscriptions[row];
//    self.selectedOptionsIDs[self.selectedOptionIndex] = [optionsSelectedProduct valueForKey:@"id"];
//    
//    NSMutableArray *option = self.allOptions[self.selectedOptionIndex];
//    for (NSMutableDictionary *product in option) {
//        [product setValue:[NSNumber numberWithBool:NO] forKey:@"is_selected"];
//    }
//    NSDictionary *selectedProduct = option[row];
//    [selectedProduct setValue:[NSNumber numberWithBool:YES] forKey:@"is_selected"];
//    ((NSMutableArray *)self.allOptions[self.selectedOptionIndex])[row] = selectedProduct;
    
    [self.view endEditing:YES];
}

@end
