//
//  NotificationPreferencesViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 06/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "NotificationPreferencesViewController.h"
#import "RequestManager.h"

@interface NotificationPreferencesViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *options;
@property(assign, nonatomic) NSInteger selectedIndex;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//TAGS
@property(assign, nonatomic) NSInteger kOptionLabelTag;
@property(assign, nonatomic) NSInteger kOptionIconButtonTag;

@property(assign, nonatomic) BOOL isAppNotificationOn;
@property(assign, nonatomic) BOOL isEmailNotificationOn;
@property(assign, nonatomic) BOOL isTextNotificationOn;

@end

@implementation NotificationPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
    
    self.tableView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getNotificationPrefs];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Notification Preferences" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.selectedIndex = 0;
    
    self.options = [NSMutableArray arrayWithObjects:@"App Notifications",@"Text Messages",@"Emails", nil];
    //TAGS
    _kOptionIconButtonTag = 5;
    _kOptionLabelTag = 10;
}

- (void)getNotificationPrefs {
    [self.activityIndicator startAnimating];
    [[RequestManager alloc]getNotificationPrefOfUser:[[Util sharedInstance]getUser] withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        self.tableView.hidden = NO;
        if (success) {
            if ([response hasValueForKey:@"notification_preference"]) {
                NSDictionary *notificationPref = [response valueForKey:@"notification_preference"];
                if ([notificationPref hasValueForKey:@"app_notifications"]) {
                    self.isAppNotificationOn = [[notificationPref valueForKey:@"app_notifications"] boolValue];
                }
                if ([notificationPref hasValueForKey:@"emails_notifications"]) {
                    self.isEmailNotificationOn = [[notificationPref valueForKey:@"emails_notifications"] boolValue];
                }
                if ([notificationPref hasValueForKey:@"text_notifications"]) {
                    self.isTextNotificationOn = [[notificationPref valueForKey:@"text_notifications"] boolValue];
                }
                [self.tableView reloadData];
            }
        } else {
            [self showToastWithText:response on:Failure];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Overridden methods

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView methods -

#pragma mark Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UILabel *optionLabel = (UILabel *)[cell.contentView viewWithTag:_kOptionLabelTag];
    optionLabel.text = [self.options objectAtIndex:indexPath.row];
    
    UIButton *tickButton = (UIButton *)[cell.contentView viewWithTag:_kOptionIconButtonTag];

    if (indexPath.row == 0) {
        tickButton.selected = _isAppNotificationOn;
    } else if (indexPath.row == 1) {
        tickButton.selected = _isTextNotificationOn;
    } else if (indexPath.row == 2) {
        tickButton.selected = _isEmailNotificationOn;
    }
    
    return cell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 37;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        _isAppNotificationOn = !_isAppNotificationOn;
    } else if (indexPath.row == 1) {
        _isTextNotificationOn = !_isTextNotificationOn;
    } else if (indexPath.row == 2) {
        _isEmailNotificationOn = !_isEmailNotificationOn;
    }
    [self.tableView reloadData];
    
    [[RequestManager alloc]postNotificationPrefWithAppNotification:_isAppNotificationOn textNotifications:_isTextNotificationOn andEmail:_isEmailNotificationOn
                                               withCompletionBlock:^(BOOL success, id response) {
                                                   if (success) {
                                                       [self showToastWithText:@"Notification preference updated successfully." on:Success];
                                                   } else {
                                                       [self showToastWithText:response on:Failure];
                                                       if (indexPath.row == 0) {
                                                           _isAppNotificationOn = !_isAppNotificationOn;
                                                       } else if (indexPath.row == 1) {
                                                           _isTextNotificationOn = !_isTextNotificationOn;
                                                       } else if (indexPath.row == 2) {
                                                           _isEmailNotificationOn = !_isEmailNotificationOn;
                                                       }
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [self.tableView reloadData];
                                                       });
                                                   }
                                               }];
}

@end
