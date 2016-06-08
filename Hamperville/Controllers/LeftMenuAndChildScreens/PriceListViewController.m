//
//  PriceListViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 02/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PriceListViewController.h"
#import "RequestManager.h"

@interface PriceListViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
    NSInteger tableviewHeight;
    NSInteger leftLabelTag;
    NSInteger rightLabelTag;
    NSInteger bottomLineTag;
    NSInteger subscriptionHeaderHeight;
    NSInteger serviceHeaderHeight;
}

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet UITableView *subscriptionTableview;
@property(weak, nonatomic) IBOutlet UITableView *serviceTableview;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *subscriptionTableviewHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *serviceTableviewHeightConstraint;

@property(strong, nonatomic) NSMutableArray *subscriptions;
@property(strong, nonatomic) NSMutableArray *services;
@property(strong, nonatomic) NSMutableArray *showableServices;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation PriceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.activityIndicator startAnimating];
    [self getPriceList];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Price List" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    [self setRightMenuButtons:[NSArray arrayWithObject:self.coverageButton]];
    
    tableviewHeight = 55;
    leftLabelTag = 10;
    rightLabelTag = 20;
    bottomLineTag = 30;
    subscriptionHeaderHeight = 40;
    serviceHeaderHeight = 35;
    
    self.subscriptionTableview.dataSource = self;
    self.subscriptionTableview.delegate = self;
    
    self.serviceTableview.dataSource = self;
    self.serviceTableview.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeLeftMenuIfOpen)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (UIBarButtonItem *)coverageButton {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 34, 34)];
    rightButton.layer.cornerRadius = rightButton.frame.size.width / 2;
    rightButton.layer.masksToBounds = YES;
    [rightButton setImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(redirectToCoverageAreaLink) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    return rightBarButton;
}

- (void)redirectToCoverageAreaLink {
    NSURL *url = [NSURL URLWithString:@"http://staging.hamperville.com/coverage_areas"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)getPriceList {
    [[RequestManager alloc] getPriceList:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            if ([response hasValueForKey:@"subscriptions"]) {
                self.subscriptions = [response valueForKey:@"subscriptions"];
            }
            if ([response hasValueForKey:@"services"]) {
                self.services = [response valueForKey:@"services"];
                self.showableServices = [NSMutableArray array];
                for (NSDictionary *serviceDict in self.services) {
                    if (((NSArray *)[serviceDict valueForKey:@"products"]).count > 0) {
                        [self.showableServices addObject:serviceDict];
                    }
                }
            }
            [self reloadSubscriptionsTableView];
            [self reloadServiceTableView];
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

- (void)reloadSubscriptionsTableView {
    self.subscriptionTableviewHeightConstraint.constant = self.subscriptions.count * tableviewHeight + subscriptionHeaderHeight;
    [self.subscriptionTableview reloadData];
}

- (void)reloadServiceTableView {
    NSInteger totalHeight = 0;
    for (NSDictionary *serviceDict in self.showableServices) {
        totalHeight+= serviceHeaderHeight;
        totalHeight+= ((NSArray *)[serviceDict valueForKey:@"products"]).count * tableviewHeight;
    }
    self.serviceTableviewHeightConstraint.constant = totalHeight;
    [self.serviceTableview reloadData];
}

#pragma mark - Gesture delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_serviceTableview] || [touch.view isDescendantOfView:_subscriptionTableview]) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.subscriptionTableview) {
        return 1;
    } else {
        return self.showableServices.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.subscriptionTableview) {
        return self.subscriptions.count;
    } else {
        return ((NSArray *)[self.showableServices[section] valueForKey:@"products"]).count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.subscriptionTableview) {
        UITableViewCell *subscriptionCell = [tableView dequeueReusableCellWithIdentifier:TVCPriceListSubscriptionCellIdentifier];
        
        UILabel *traversingLabel = [subscriptionCell viewWithTag:leftLabelTag];
        traversingLabel.text = [NSString stringWithFormat:@"$ %@",[self.subscriptions[indexPath.row] valueForKey:@"amount"]];
        traversingLabel = [subscriptionCell viewWithTag:rightLabelTag];
        traversingLabel.text = [NSString stringWithFormat:@"%@%%",[self.subscriptions[indexPath.row] valueForKey:@"percentage_discount"]];
        
        if (self.subscriptions.count - 1 == indexPath.row) {
            [subscriptionCell viewWithTag:bottomLineTag].hidden = YES;
        } else {
            [subscriptionCell viewWithTag:bottomLineTag].hidden = NO;
        }
        
        subscriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return subscriptionCell;
    } else {
        UITableViewCell *serviceCell = [tableView dequeueReusableCellWithIdentifier:TVCPriceListServiceCellIdentifier];
        NSArray *products = [self.showableServices[indexPath.section] valueForKey:@"products"];
        
        UILabel *traversingLabel = [serviceCell viewWithTag:leftLabelTag];
        traversingLabel.text = [NSString stringWithFormat:@"%@",[products[indexPath.row] valueForKey:@"name"]];
        traversingLabel = [serviceCell viewWithTag:rightLabelTag];
        traversingLabel.text = [NSString stringWithFormat:@"$ %@",[products[indexPath.row] valueForKey:@"amount"]];
        
        if (((NSArray *)[self.showableServices[indexPath.section] valueForKey:@"products"]).count - 1 == indexPath.row) {
            [serviceCell viewWithTag:bottomLineTag].hidden = YES;
        } else {
            [serviceCell viewWithTag:bottomLineTag].hidden = NO;
        }
        
        serviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return serviceCell;
    }
    return [[UITableViewCell alloc]init];
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableviewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.subscriptionTableview) {
        UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:TVCPriceListSubscriptionHeaderIdentifier];
        return headerCell;
    } else {
        UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:TVCPriceListServiceHeaderIdentifier];
        
        UILabel *traversingLabel = [headerCell viewWithTag:leftLabelTag];
        traversingLabel.text = [NSString stringWithFormat:@"%@",[self.showableServices[section] valueForKey:@"name"]];
        
        return headerCell;
    }
    return [UIView alloc];
}

@end
