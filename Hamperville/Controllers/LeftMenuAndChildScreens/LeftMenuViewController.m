//
//  LeftMenuViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuTableViewCell.h"
#import <SWRevealViewController.h>
#import "PersonalDetailsViewController.h"
#import "SchedulePickupViewController.h"
#import "OrderHistoryViewController.h"
#import "PreferencesViewController.h"
#import "SettingsViewController.h"
#import "SubscriptionViewController.h"
#import "PriceListViewController.h"
#import "HelpViewController.h"

@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) NSMutableArray *allHeadings;
@property(strong, nonatomic) NSMutableArray *allImageName;

@property(assign, nonatomic) NSInteger selectedRowIndex;

//Headers controllers

@property(strong, nonatomic) PersonalDetailsViewController *personalDetailsViewController;
@property(strong, nonatomic) SchedulePickupViewController *schedulePickupViewController;
@property(strong, nonatomic) OrderHistoryViewController *orderHistoryViewController;
@property(strong, nonatomic) PreferencesViewController *preferencesViewController;
@property(strong, nonatomic) SettingsViewController *settingsViewController;
@property(strong, nonatomic) SubscriptionViewController *subscriptionViewController;
@property(strong, nonatomic) PriceListViewController *priceListViewController;
@property(strong, nonatomic) HelpViewController *helpViewController;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
    self.selectedRowIndex = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.allHeadings = [NSMutableArray arrayWithObjects:@"User Name",@"Request Pickup",@"History",@"Preferences",@"Subscription",@"Settings",@"Price List", @"Help", nil];
    
    User *user = [[Util sharedInstance]getUser];
    NSString *userName = [NSString stringWithFormat:@"%@ %@",user.firstName, user.lastName];
    self.allHeadings[0] = userName;
    
    [self.tableView reloadData];
}

#pragma mark - TableView Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allHeadings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftMenuTableViewCell *leftMenuTableViewCell = [tableView dequeueReusableCellWithIdentifier:kLeftMenuTableViewCellIdentifier];
    [leftMenuTableViewCell.headingButton setTitle:self.allHeadings[indexPath.row] forState:UIControlStateNormal];
    [leftMenuTableViewCell.imageButton setImage:[UIImage imageNamed:self.allImageName[indexPath.row]] forState:UIControlStateNormal];
    
    if (indexPath.row == self.selectedRowIndex){
        [leftMenuTableViewCell setSelection:YES];
    } else {
        [leftMenuTableViewCell setSelection:NO];
    }
    leftMenuTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return leftMenuTableViewCell;
}

#pragma mark - TableView Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.view.frame.size.height - 40 ) / self.allHeadings.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRowIndex = indexPath.row;
    switch (indexPath.row) {
        case 0:
            [self openPersonalDetailsScreen];
            break;
        case 1:
            [self openSchedulePickupScreen];
            break;
        case 2:
            [self openOrderHistoryScreen];
            break;
        case 3:
            [self openPreferenceScreen];
            break;
        case 4:
            [self openSubscriptionScreen];
            break;
        case 5:
            [self openSettingScreen];
            break;
        case 6:
            [self openPriceListScreen];
            break;
        case 7:
            [self openHelpScreen];
            break;
        case 8:
            break;
        case 9:
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)initialSetup {
    self.allHeadings = [NSMutableArray arrayWithObjects:@"User Name",@"Request Pickup",@"History",@"Preferences",@"Subscription",@"Settings",@"Price List",@"Coverage Area", @"Help", @"Write a Review", nil];

    self.allImageName = [NSMutableArray arrayWithObjects:@"user", @"pickup", @"history", @"preference", @"subscription", @"setting", @"pricelist", @"help", nil];
    
    User *user = [[Util sharedInstance]getUser];
    NSString *userName = [NSString stringWithFormat:@"%@ %@",user.firstName, user.lastName];
    self.allHeadings[0] = userName;
    
    [self registerNib];
}

- (void)refreshUser {
    User *user = [[Util sharedInstance]getUser];
    NSString *userName = [NSString stringWithFormat:@"%@ %@",user.firstName, user.lastName];
    self.allHeadings[0] = userName;
    
    [self.tableView reloadData];
}

- (void)registerNib {
    UINib *nib = [UINib nibWithNibName:kLeftMenuTableViewCellNibName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kLeftMenuTableViewCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)openPersonalDetailsScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.personalDetailsViewController) {
            self.personalDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalDetailsViewController"];
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.personalDetailsViewController];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    });
}

- (void)openSchedulePickupScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.schedulePickupViewController) {
            self.schedulePickupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SchedulePickupViewController"];
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.schedulePickupViewController];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    });
}

- (void)openOrderHistoryScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.orderHistoryViewController) {
            self.orderHistoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
        }
        self.orderHistoryViewController.shouldRefresh = YES;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.orderHistoryViewController];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    });
}

- (void)openPreferenceScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.preferencesViewController) {
            self.preferencesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PreferencesViewController"];
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.preferencesViewController];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    });
}

- (void)openSettingScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.settingsViewController) {
            self.settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.settingsViewController];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    });
}

- (void)openSubscriptionScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.subscriptionViewController) {
            self.subscriptionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubscriptionViewController"];
        }
        self.subscriptionViewController.shouldRefresh = YES;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.subscriptionViewController];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    });
}

- (void)openPriceListScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.priceListViewController) {
            self.priceListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PriceListViewController"];
        }
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.priceListViewController];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    });
}

- (void)openHelpScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.helpViewController) {
            self.helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
        }
        self.helpViewController.imageChanged = NO;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.helpViewController];
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
    });
}

@end
