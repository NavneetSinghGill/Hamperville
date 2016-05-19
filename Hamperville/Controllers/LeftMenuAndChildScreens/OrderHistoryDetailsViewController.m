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

@interface OrderHistoryDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *orderDetailsTableView;
@property(weak, nonatomic) IBOutlet UITableView *numberOfBagsTableView;

@property(strong, nonatomic) NSMutableArray *orderDetailOptions;
@property(strong, nonatomic) NSMutableArray *numberOfBagsOptions;

@property(strong, nonatomic) NSMutableArray *orderDetailEntries;
@property(strong, nonatomic) NSMutableArray *numberOfBagsEntries;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *numberOfBagsTableViewHeightConstraint;

@property(assign, nonatomic) NSInteger cellHeight;

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
    [self setupArrays];
    
    [self.orderDetailsTableView reloadData];
    [self.numberOfBagsTableView reloadData];
}

- (void)setupArrays {
    self.orderDetailOptions = [NSMutableArray arrayWithObjects:@"Order ID", @"Pick up date", @"Pick up time slot", @"Delivery date", @"Delivery time slot", @"Order status", nil];
    
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
    
    self.orderDetailEntries = [NSMutableArray array];
    [self.orderDetailEntries addObject:self.order.orderID];
    [self.orderDetailEntries addObject:self.order.pickupDate];
    [self.orderDetailEntries addObject:self.order.pickupTimeSlot];
    [self.orderDetailEntries addObject:self.order.deliveryDate];
    [self.orderDetailEntries addObject:self.order.deliveryTimeSlot];
    [self.orderDetailEntries addObject:self.order.orderStatus];
}

#pragma mark - Over ridden methods

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)modifyOrder:(id)sender {
    SchedulePickupViewController *schedulePickupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SchedulePickupViewController"];
    schedulePickupViewController.isModifyModeOn = YES;
    schedulePickupViewController.orderToModify = self.order;
    [self.navigationController pushViewController:schedulePickupViewController animated:YES];
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
