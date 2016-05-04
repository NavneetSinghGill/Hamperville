//
//  PreferencesViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 04/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PreferencesViewController.h"
#import "PickupAndDeliverViewController.h"

@interface PreferencesViewController () <UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray *options;
@property(strong, nonatomic) NSArray *optionImages;

//TAGS
@property(assign, nonatomic) NSInteger kOptionLabelTag;
@property(assign, nonatomic) NSInteger kOptionIconButtonTag;

@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Preferences" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.options = [NSArray arrayWithObjects:@"How do we pickup and deliver", @"Permanent", @"Wash & Fold", @"Notification", @"Special Care", nil];
    self.optionImages = [NSArray arrayWithObjects:@"Pref_pickup", @"Pref_permanenent", @"Pref_wasandfold", @"Pref_notification", @"Pref_specialCare", nil];
    
    //TAGS
    _kOptionIconButtonTag = 5;
    _kOptionLabelTag = 10;
}

- (void)openPickupAndDeliverScreen {
    PickupAndDeliverViewController *pickupAndDeliverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PickupAndDeliverViewController"];
    [self.navigationController pushViewController:pickupAndDeliverViewController animated:YES];
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
    
    UIButton *optionIconButton = (UIButton *)[cell.contentView viewWithTag:_kOptionIconButtonTag];
    [optionIconButton setImage:[UIImage imageNamed:[self.optionImages objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self openPickupAndDeliverScreen];
            break;
            
        default:
            break;
    }
}

@end
