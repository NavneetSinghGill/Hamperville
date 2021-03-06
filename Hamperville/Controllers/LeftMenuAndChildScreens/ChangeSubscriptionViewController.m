//
//  ChangeSubscriptionViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 20/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ChangeSubscriptionViewController.h"
#import "RequestManager.h"

@interface ChangeSubscriptionViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSInteger pickerSuperViewDefaultBottomContraintValue;
}

@property(weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(weak, nonatomic) IBOutlet UIView *pickerSuperView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *pickerSuperViewBottomConstraint;
@property(weak, nonatomic) IBOutlet UISwitch *statusSwitch;

@property(assign, nonatomic) BOOL newStatus;

@property(weak, nonatomic) IBOutlet UILabel *selectLabel;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak, nonatomic) IBOutlet UIView *subsctiptionPlanSuperView;

@property(strong, nonatomic) NSMutableArray *savedSubscriptions;

@end

@implementation ChangeSubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Change Subscription" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.backButton, nil]];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    pickerSuperViewDefaultBottomContraintValue = 0;
    [self.statusSwitch setOn:self.oldStatus animated:NO];
    
    NSInteger count = 0;
    for (NSDictionary *subscription in self.allSubscriptions) {
        if ([[[subscription valueForKey:@"subscription_plan"] valueForKey:@"id"] integerValue] == self.currentSubscriptionPlanID) {
            [self.pickerView selectRow:count inComponent:0 animated:NO];
            NSString *amountText = [[subscription valueForKey:@"subscription_plan"] valueForKey:@"amount"];
            self.selectLabel.text = [NSString stringWithFormat:@"$ %@",amountText];
            break;
        }
        count++;
    }
    
    self.newStatus = self.oldStatus;
    self.subsctiptionPlanSuperView.hidden = !self.newStatus;
    
    [self refreshSubscriptions];
}

- (void)refreshSubscriptions {
    self.savedSubscriptions = [NSMutableArray array];
    for (NSDictionary *subscription in self.allSubscriptions) {
        if (!([[[subscription valueForKey:@"subscription_plan"] valueForKey:@"id"] integerValue] == self.currentSubscriptionPlanID)) {
            [self.savedSubscriptions addObject:subscription];
        }
    }
}

#pragma mark - Over ridden methods

- (void)backButtonTapped {
    if (self.newStatus) {
        if ((self.newStatus == YES && self.nextRenewalDate != nil) || self.newStatus == NO) {
            [self.updateDelegate updateViewsWithStatus:self.newStatus subscriptionID:self.currentSubscriptionPlanID andNextRenewalDate:self.nextRenewalDate];
        } else {
            [self.updateDelegate updateViewsWithStatus:self.newStatus];
        }
    } else {
        [self.updateDelegate updateViewsWithStatus:self.newStatus];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction methods

- (IBAction)dropDownButtonTapped:(id)sender {
    if (self.savedSubscriptions.count == 0) {
        [self showToastWithText:@"No active subscriptions available" on:Failure];
        return;
    }
    self.pickerSuperViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)saveButtonTapped:(id)sender {
    self.newStatus = [self.statusSwitch isOn];
    if (self.newStatus == true && self.currentSubscriptionPlanID == 0) {
        [self showToastWithText:@"Select plan" on:Failure];
        return;
    }
    [self.activityIndicator startAnimating];
    [[RequestManager alloc]postSubscriptionWithStatus:self.newStatus andSubscriptionID:[NSString stringWithFormat:@"%ld",(long)self.currentSubscriptionPlanID] withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            if ([response hasValueForKey:@"subscription_status"]) {
                self.newStatus = [[response valueForKey:@"subscription_status"] boolValue];
                if (self.newStatus) {
                    self.currentSubscriptionPlanID = [[response valueForKey:@"subscription_plan_id"] integerValue];
                    self.nextRenewalDate = [NSDate dateWithTimeIntervalSince1970:[[response valueForKey:@"next_subscription_date"] integerValue]];
                }
            }
            [self refreshSubscriptions];
            [self showToastWithText:@"Subscription updated successfully." on:Success];
            
            double delayInSeconds = 1.8;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self backButtonTapped];
            });
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

- (IBAction)doneButtonTapped:(id)sender {
    self.pickerSuperViewBottomConstraint.constant = -self.pickerSuperView.frame.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    NSString *amountText = [[self.savedSubscriptions[[self.pickerView selectedRowInComponent:0]] valueForKey:@"subscription_plan"] valueForKey:@"amount"];
    self.selectLabel.text = [NSString stringWithFormat:@"$ %@",amountText];
    self.currentSubscriptionPlanID = [[[self.savedSubscriptions[[self.pickerView selectedRowInComponent:0]] valueForKey:@"subscription_plan"] valueForKey:@"id"] integerValue];
}

- (IBAction)statusSwitchTapped:(UISwitch *)sender {
    self.subsctiptionPlanSuperView.hidden = ![sender isOn];
    if (self.pickerSuperViewBottomConstraint.constant == 0) {
        self.pickerSuperViewBottomConstraint.constant = -self.pickerSuperView.frame.size.height;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - PickerView methods -

#pragma mark PickerView Delegate and Datasource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.savedSubscriptions.count;
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
    NSDictionary *option = self.savedSubscriptions[row];
    tView.text = [[option valueForKey:@"subscription_plan"] valueForKey:@"amount"];
    return tView;
}

@end
