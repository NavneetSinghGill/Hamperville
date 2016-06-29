//
//  OrderHistoryDetailsViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 02/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "OrderHistoryDetailsViewController.h"
#import "OrderTableViewCell.h"
#import "SchedulePickupViewController.h"
#import "RequestManager.h"

@interface OrderHistoryDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *orderDetailsTableView;
@property(weak, nonatomic) IBOutlet UITableView *numberOfBagsTableView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(strong, nonatomic) NSMutableArray *orderDetailOptions;
@property(strong, nonatomic) NSMutableArray *numberOfBagsOptions;

@property(strong, nonatomic) NSMutableArray *orderDetailEntries;
@property(strong, nonatomic) NSMutableArray *numberOfBagsEntries;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *numberOfBagsTableViewHeightConstraint;

@property(assign, nonatomic) NSInteger cellHeight;

@property(weak, nonatomic) IBOutlet UIView *pendingOrderView;
@property(weak, nonatomic) IBOutlet UIView *acceptedOrderView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *pendingOrderViewHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *acceptedOrderViewHeight;
@property(weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@property(weak, nonatomic) IBOutlet UIView *numberOfBagsHeaderSuperView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *numberOfBagsHeaderSuperViewTopConstraint;

@end

@implementation OrderHistoryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Order Details" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.backButton, nil]];
    
    self.orderDetailsTableView.delegate = self;
    self.orderDetailsTableView.dataSource = self;
    self.numberOfBagsTableView.delegate = self;
    self.numberOfBagsTableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:TVCOrderTableViewCellNibAndIdentifier bundle:nil];
    [self.orderDetailsTableView registerNib:nib forCellReuseIdentifier:TVCOrderTableViewCellNibAndIdentifier];
    [self.numberOfBagsTableView registerNib:nib forCellReuseIdentifier:TVCOrderTableViewCellNibAndIdentifier];
    
    self.cellHeight = 55;
    
    self.order.orderStatus = [self.order.orderStatus stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.order.orderStatus = [[NSString stringWithFormat:@"%@%@",[[self.order.orderStatus substringToIndex:1] uppercaseString],[self.order.orderStatus substringFromIndex:1]] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    [self setupArrays];
    
    [self.orderDetailsTableView reloadData];
    [self.numberOfBagsTableView reloadData];
    
    if ([[self.order.orderStatus lowercaseString] isEqualToString:@"pending"] || [[self.order.orderStatus lowercaseString] isEqualToString:@"accepted"]) {
        self.acceptedOrderViewHeight.constant = 0;
        self.acceptedOrderView.clipsToBounds = YES;
//        self.numberOfBagsHeaderSuperViewTopConstraint.constant = -self.numberOfBagsHeaderSuperView.frame.size.height;
//        self.numberOfBagsTableViewHeightConstraint.constant = 0;
//    } else if ([[self.order.orderStatus lowercaseString] isEqualToString:@"accepted"]) {
//        self.pendingOrderViewHeight.constant = 0;
//        self.pendingOrderView.clipsToBounds = YES;
//        self.orderAmountLabel.text = [NSString stringWithFormat:@"$%.02f",(float)self.order.orderAmount];
//        self.numberOfBagsHeaderSuperViewTopConstraint.constant = -self.numberOfBagsHeaderSuperView.frame.size.height;
//        self.numberOfBagsTableViewHeightConstraint.constant = 0;
    } else {
        self.pendingOrderViewHeight.constant = 0;
        self.pendingOrderView.clipsToBounds = YES;
        self.orderAmountLabel.text = [NSString stringWithFormat:@"$%.02f",(float)self.order.orderAmount];
    }
}

- (void)setupArrays {
    self.orderDetailOptions = [NSMutableArray arrayWithObjects:@"Order ID", @"Pick up date", @"Pick up time slot", @"Drop Off date", @"Drop Off time slot", @"Order status", @"Coupons", @"Special notes", nil];
    
    self.numberOfBagsOptions = [NSMutableArray array];
    for (NSDictionary *dict in self.order.serviceDetail) {
        [self.numberOfBagsOptions addObject:[dict valueForKey:@"name"]];
    }
    
    self.numberOfBagsEntries = [NSMutableArray array];
    for (NSDictionary *dict in self.order.serviceDetail) {
        NSInteger numberOfbags = [[dict valueForKey:@"number_of_bags"] integerValue];
        [self.numberOfBagsEntries addObject:[NSString stringWithFormat:@"%ld",(long)numberOfbags]];
    }
    
    self.numberOfBagsTableViewHeightConstraint.constant = _cellHeight * _numberOfBagsEntries.count;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    self.orderDetailEntries = [NSMutableArray array];
    [self.orderDetailEntries addObject:self.order.orderNumber];
//    dateFormatter.dateFormat = @"";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.order.pickupDate integerValue]]];
    [self.orderDetailEntries addObject:dateString];
    [self.orderDetailEntries addObject:self.order.pickupTimeSlot];
    dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.order.deliveryDate integerValue]]];
    [self.orderDetailEntries addObject:dateString];
    [self.orderDetailEntries addObject:self.order.deliveryTimeSlot];
    [self.orderDetailEntries addObject:self.order.orderStatus];
    [self.orderDetailEntries addObject:self.order.coupons];
    [self.orderDetailEntries addObject:self.order.specialNotes ? self.order.specialNotes:@"-"];
}

#pragma mark - Over ridden methods

- (void)backButtonTapped {
    if (self.isOpenedFromPushNotification) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - IBAction methods

- (IBAction)modifyOrderButtonTapped:(id)sender {
    if (![ApplicationDelegate hasNetworkAvailable]) {
        [self showToastWithText:kNoNetworkAvailable on:Failure];
        return;
    }
    SchedulePickupViewController *schedulePickupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SchedulePickupViewController"];
    schedulePickupViewController.isModifyModeOn = YES;
    schedulePickupViewController.orderToModify = self.order;
    [self.navigationController pushViewController:schedulePickupViewController animated:YES];
}

- (IBAction)cancelOrderButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to cancel this order?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *alertActionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.activityIndicator startAnimating];
        [[RequestManager alloc] postCancelOrderWithOrderID:self.order.orderID withCompletionBlock:^(BOOL success, id response) {
            [self.activityIndicator stopAnimating];
            if (success) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:LNChangeShouldRefresh object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"shouldRefresh", nil]];
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:LNChangeShouldRefresh];
                [[NSUserDefaults standardUserDefaults]synchronize];
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                [self showToastWithText:@"Order cancelled successfully." on:Success];
            } else {
                [self showToastWithText:response on:Failure];
            }
        }];
    }];
    [alertController addAction:alertActionYes];
    [alertController addAction:alertActionNo];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TableView methods -

#pragma mark DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.orderDetailsTableView) {
        return self.orderDetailOptions.count;
    } else if (tableView == self.numberOfBagsTableView) {
        return self.numberOfBagsOptions.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell *orderTableViewCell = [tableView dequeueReusableCellWithIdentifier:TVCOrderTableViewCellNibAndIdentifier];
    if (tableView == self.orderDetailsTableView) {
        orderTableViewCell.orderHeadingLabel.text = [self.orderDetailOptions objectAtIndex:indexPath.row];
        orderTableViewCell.orderInfoLabel.text = [self.orderDetailEntries objectAtIndex:indexPath.row];
        if (self.orderDetailOptions.count - 1 == indexPath.row) {
            orderTableViewCell.bottomLineView.hidden = YES;
        }
    } else {
        orderTableViewCell.orderHeadingLabel.text = [self.numberOfBagsOptions objectAtIndex:indexPath.row];
        orderTableViewCell.orderInfoLabel.text = [self.numberOfBagsEntries objectAtIndex:indexPath.row];
        if (self.numberOfBagsOptions.count - 1 == indexPath.row) {
            orderTableViewCell.bottomLineView.hidden = YES;
        }
    }
    orderTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return orderTableViewCell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

@end
