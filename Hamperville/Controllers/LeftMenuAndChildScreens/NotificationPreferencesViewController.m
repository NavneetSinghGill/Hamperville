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

@end

@implementation NotificationPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
    
    [self.activityIndicator startAnimating];
    [[RequestManager alloc]getNotificationPrefOfUser:[[Util sharedInstance]getUser] withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            
        } else {
            [self showToastWithText:response on:Top];
        }
    }];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Notification Preferences" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.selectedIndex = 0;
    
    self.options = [NSMutableArray arrayWithObjects:@"a",@"b",@"c", nil];
    //TAGS
    _kOptionIconButtonTag = 5;
    _kOptionLabelTag = 10;
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
    if (self.selectedIndex == indexPath.row) {
        tickButton.selected = YES;
    } else {
        tickButton.selected = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 37;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger storePreviousSelection = self.selectedIndex;
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    
}

@end
