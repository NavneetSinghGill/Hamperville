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
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

NSInteger kTableViewCellLabelTag = 10;

@interface OrderHistoryViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(strong, nonatomic) NSMutableArray *orders;
@property(assign, nonatomic) BOOL hasMore;
@property(assign, nonatomic) NSInteger timeStamp;
@property(assign, nonatomic) NSInteger orderOffset;

@property(retain, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation OrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orders = nil;
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.shouldRefresh == YES) {
        [self.activityIndicator startAnimating];
        [[RequestManager alloc] getOrderHistoryWithLimit:10 time:kEmptyString andOrderOffset:kEmptyString withCompletionBlock:^(BOOL success, id response) {
            [self.activityIndicator stopAnimating];
            if (success) {
                self.orders = [response valueForKey:@"order_history"];
                self.hasMore = [[response valueForKey:@"hasMore"] boolValue];
                if (self.hasMore) {
                    self.timeStamp = [[response valueForKey:@"timestamp"] integerValue];
                    self.orderOffset = [[response valueForKey:@"orderOffset"] integerValue];
                }
                [self.tableView reloadData];
            } else {
                if ([response isKindOfClass:[NSString class]]) {
                    [self showToastWithText:response on:Top];
                }
            }
        }];
        self.shouldRefresh = NO;
    }
}

#pragma mark - Private methods -

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Order History" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeLeftMenuIfOpen)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.triggerVerticalOffset = 50;
    [self.refreshControl addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = self.refreshControl;
}

- (void)loadMore {
    if (self.orders.count == 0 || self.hasMore == NO) {
        [self.refreshControl endRefreshing];
        return;
    }
    [[RequestManager alloc] getOrderHistoryWithLimit:10 time:[NSString stringWithFormat:@"%ld",(long)self.timeStamp] andOrderOffset:[NSString stringWithFormat:@"%ld",(long)self.orderOffset] withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            [self.orders addObjectsFromArray:[response valueForKey:@"order_history"]];
            self.hasMore = [[response valueForKey:@"hasMore"] boolValue];
            if (self.hasMore) {
                self.timeStamp = [[response valueForKey:@"timestamp"] integerValue];
                self.orderOffset = [[response valueForKey:@"orderOffset"] integerValue];
            }
            [self.tableView reloadData];
        } else {
            if ([response isKindOfClass:[NSString class]]) {
                [self showToastWithText:response on:Top];
            }
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Gesture delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.tableView]) {
        FrontViewPosition frontViewPosition = [self.revealViewController frontViewPosition];
        if (frontViewPosition != FrontViewPositionLeft) {
            return YES;
        }
        [super closeLeftMenuIfOpen];
        return NO;
    }
    return NO;
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
    
    return cell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderHistoryDetailsViewController *orderHistoryDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryDetailsViewController"];
    orderHistoryDetailsViewController.order = [self.orders objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:orderHistoryDetailsViewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self closeLeftMenuIfOpen];
}

@end
