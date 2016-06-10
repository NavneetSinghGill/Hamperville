//
//  PickupAndDeliverViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 04/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PickupAndDeliverViewController.h"
#import "RequestManager.h"

@interface PickupAndDeliverViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *options;
@property(assign, nonatomic) NSInteger selectedIndex;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(assign, nonatomic) BOOL prefUpdated;

//TAGS
@property(assign, nonatomic) NSInteger kOptionLabelTag;
@property(assign, nonatomic) NSInteger kOptionIconButtonTag;

@end

@implementation PickupAndDeliverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getPickupAndDeliverPrefs];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Pickup and Deliver" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.selectedIndex = -1;
    self.options = [NSMutableArray arrayWithObjects:@"With the doorman", @"By apartment door", @"Buzz my apartment", @"Call the phone I provide", nil];
    
    //TAGS
    _kOptionIconButtonTag = 5;
    _kOptionLabelTag = 10;
    
    [self.tableView reloadData];
}

- (void)getPickupAndDeliverPrefs {
    [self.activityIndicator startAnimating];
    [[RequestManager alloc]getPickupAndDeliverWithUser:[[Util sharedInstance] getUser]
                                   withCompletionBlock:^(BOOL success, id response) {
                                       [self.activityIndicator stopAnimating];
                                       if (success) {
                                           [self readResponse:response];
                                       } else {
                                           [self showToastWithText:response on:Failure];
                                       }
                                   }];
}

- (void)readResponse:(id)response {
    NSArray *responseArray = (NSArray *)[response valueForKey:@"pickup_deliver_preferences"];
//    self.options = [NSMutableArray array];
    for (NSInteger count = 0; count < responseArray.count; count++) {
//        [self.options addObject:[responseArray[count] valueForKey:@"name"]];
        if ([[responseArray[count] valueForKey:@"is_selected"] boolValue] == YES) {
            self.selectedIndex = count;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Overridden methods

- (void)backButtonTapped {
    [self.tableView reloadData];
    
    if (self.prefUpdated == YES) {
        UILabel *optionLabel = [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]] contentView]viewWithTag:_kOptionLabelTag];
        NSString *method = optionLabel.text;
        [[RequestManager alloc] postPickupAndDeliverWithUser:[[Util sharedInstance] getUser]
                                                   andMethod:method
                                         withCompletionBlock:^(BOOL success, id response) {
                                             if (success) {
                                                 [self showToastWithText:@"Pickup and drop off preference updated successfully." on:Success];
                                             } else {
                                                 [self showToastWithText:response on:Failure];
                                                 [self.tableView reloadData];
                                             }
                                         }];
    }

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
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![ApplicationDelegate hasNetworkAvailable]) {
        [self showToastWithText:kNoNetworkAvailable on:Failure];
        return;
    }
//    NSInteger storePreviousSelection = self.selectedIndex;
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    self.prefUpdated = YES;
//
//    UILabel *optionLabel = [[[tableView cellForRowAtIndexPath:indexPath] contentView]viewWithTag:_kOptionLabelTag];
//    NSString *method = optionLabel.text;
//    [[RequestManager alloc] postPickupAndDeliverWithUser:[[Util sharedInstance] getUser]
//                                               andMethod:method
//                                     withCompletionBlock:^(BOOL success, id response) {
//                                         if (success) {
//                                            [self showToastWithText:@"Pickup and drop off preference updated successfully." on:Success];
//                                         } else {
//                                             [self showToastWithText:response on:Failure];
//                                             self.selectedIndex = storePreviousSelection;
//                                             [self.tableView reloadData];
//                                         }
//                                     }];
}

@end
