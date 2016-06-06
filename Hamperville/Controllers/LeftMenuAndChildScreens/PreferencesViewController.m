//
//  PreferencesViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 04/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PreferencesViewController.h"
#import "PickupAndDeliverViewController.h"
#import "NotificationPreferencesViewController.h"
#import "PermanentPreferencesViewController.h"
#import "WashAndFoldPreferencesViewController.h"
#import "SpecialCarePreferencesViewController.h"
#import "WashAndPressViewController.h"

@interface PreferencesViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

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
    
    self.options = [NSArray arrayWithObjects:@"How do we pickup and deliver", @"Permanent", @"Wash & Fold", @"Notification", @"Special Care", @"Wash and Press", nil];
    self.optionImages = [NSArray arrayWithObjects:@"Pref_pickup", @"Pref_permanenent", @"Pref_wasandfold", @"Pref_notification", @"Pref_specialCare", @"washAndpress", nil];
    
    //TAGS
    _kOptionIconButtonTag = 5;
    _kOptionLabelTag = 10;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeLeftMenuIfOpen)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)openPickupAndDeliverScreen {
    PickupAndDeliverViewController *pickupAndDeliverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PickupAndDeliverViewController"];
    [self.navigationController pushViewController:pickupAndDeliverViewController animated:YES];
}

- (void)openNotificationScreen {
    NotificationPreferencesViewController *notificationPreferencesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationPreferencesViewController"];
    [self.navigationController pushViewController:notificationPreferencesViewController animated:YES];
}

- (void)openPermanentPrefScreen {
    PermanentPreferencesViewController *permanentPreferencesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PermanentPreferencesViewController"];
    [self.navigationController pushViewController:permanentPreferencesViewController animated:YES];
}

- (void)openWashAndFoldPrefScreen {
    WashAndFoldPreferencesViewController *washAndFoldPreferencesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WashAndFoldPreferencesViewController"];
    [self.navigationController pushViewController:washAndFoldPreferencesViewController animated:YES];
}

- (void)openSpecialCarePrefScreen {
    SpecialCarePreferencesViewController *specialCarePreferencesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SpecialCarePreferencesViewController"];
    [self.navigationController pushViewController:specialCarePreferencesViewController animated:YES];
}

- (void)openWashAndPressPrefScreen {
    WashAndPressViewController *washAndPressViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WashAndPressViewController"];
    [self.navigationController pushViewController:washAndPressViewController animated:YES];
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
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UILabel *optionLabel = (UILabel *)[cell.contentView viewWithTag:_kOptionLabelTag];
    optionLabel.text = [self.options objectAtIndex:indexPath.row];
    
    UIButton *optionIconButton = (UIButton *)[cell.contentView viewWithTag:_kOptionIconButtonTag];
    [optionIconButton setImage:[UIImage imageNamed:[self.optionImages objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self openPickupAndDeliverScreen];
            break;
        case 1:
            [self openPermanentPrefScreen];
            break;
        case 2:
            [self openWashAndFoldPrefScreen];
            break;
        case 3:
            [self openNotificationScreen];
            break;
        case 4:
            [self openSpecialCarePrefScreen];
            break;
        case 5:
            [self openWashAndPressPrefScreen];
            
        default:
            break;
    }
}

@end
