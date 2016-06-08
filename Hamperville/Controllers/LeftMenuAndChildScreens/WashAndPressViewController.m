//
//  WashAndPressViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 06/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "WashAndPressViewController.h"
#import "RequestManager.h"

@interface WashAndPressViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *options;
@property(assign, nonatomic) NSInteger selectedIndex;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//TAGS
@property(assign, nonatomic) NSInteger kOptionLabelTag;
@property(assign, nonatomic) NSInteger kOptionIconButtonTag;

@end

@implementation WashAndPressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
    
    [self.activityIndicator startAnimating];
    [[RequestManager alloc] getWashAndPressPreferences:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            if ([response hasValueForKey:@"wash_and_press_preferences"]) {
                NSMutableArray *parseArray = [response valueForKey:@"wash_and_press_preferences"];
                self.options = [NSMutableArray array];
                
                for (NSInteger count = 0; count < parseArray.count; count++) {
                    [self.options addObject:[parseArray[count] valueForKey:@"name"]];
                    if ([[parseArray[count] valueForKey:@"is_selected"] integerValue] == 1) {
                        self.selectedIndex = count;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Wash and Press" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
    
    self.options = [NSMutableArray arrayWithObjects:@"On Boxed",@"On Hanger", nil];
    
    //TAGS
    _kOptionIconButtonTag = 5;
    _kOptionLabelTag = 10;
    
    self.selectedIndex = -1;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *optionLabel = (UILabel *)[cell.contentView viewWithTag:_kOptionLabelTag];
    optionLabel.text = [self.options objectAtIndex:indexPath.row];
    
    UIButton *tickButton = (UIButton *)[cell.contentView viewWithTag:_kOptionIconButtonTag];
    if (self.selectedIndex == indexPath.row) {
        tickButton.selected = YES;
    } else {
        tickButton.selected = NO;
    }
    
    return cell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 37;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![ApplicationDelegate hasNetworkAvailable]) {
        [self showToastWithText:kNoNetworkAvailable on:Failure];
        return;
    }
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"wash_and_press_method"] = self.options[self.selectedIndex];
    [[RequestManager alloc] postWashAndPressPreferencesWithDataDictionary:dict withCompletionBlock:^(BOOL success, id response) {
        if (success) {
            [self showToastWithText:@"Wash and Press preference updated successfully." on:Success];
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

@end
