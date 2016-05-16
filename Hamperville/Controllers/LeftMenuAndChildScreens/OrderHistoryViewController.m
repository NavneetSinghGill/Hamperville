//
//  OrderHistoryViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 28/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "RequestManager.h"
#import "Order.h"
#import "OrderHistoryDetailsViewController.h"

NSInteger kTableViewCellLabelTag = 10;

@interface OrderHistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(strong, nonatomic) NSMutableArray *orders;

@end

@implementation OrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orders = nil;
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.activityIndicator startAnimating];
    [[RequestManager alloc] getOrderHistoryWithLimit:5 time:[[NSDate date]timeIntervalSince1970] andOrderOffset:-1 withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            self.orders = response;
            [self.tableView reloadData];
        } else {
            if ([response isKindOfClass:[NSString class]]) {
                [self showToastWithText:response on:Top];
            }
        }
    }];
}

#pragma mark - Private methods -

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Order History" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - TableView methods -

#pragma mark Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Order *order = [self.orders objectAtIndex:indexPath.row];
    ((UILabel *)[cell viewWithTag:kTableViewCellLabelTag]).text = [NSString stringWithFormat:@"Order: %@",order.orderID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderHistoryDetailsViewController *orderHistoryDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryDetailsViewController"];
    orderHistoryDetailsViewController.order = [self.orders objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:orderHistoryDetailsViewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self closeLeftMenuIfOpen];
}

@end
