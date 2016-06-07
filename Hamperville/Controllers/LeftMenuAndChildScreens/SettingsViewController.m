//
//  SettingsViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 17/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SettingsViewController.h"
#import "LocationViewController.h"
#import "ShowCreditCardsViewController.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray *options;
@property(strong, nonatomic) NSArray *optionImages;

//TAGS
@property(assign, nonatomic) NSInteger kOptionLabelTag;
@property(assign, nonatomic) NSInteger kOptionIconButtonTag;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Settings" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.options = [NSArray arrayWithObjects:@"Location", @"Payment", nil];//, @"Notification", nil];
    self.optionImages = [NSArray arrayWithObjects:@"Location", @"Payment", nil];//, @"Pref_notification", nil];
    
    //TAGS
    _kOptionIconButtonTag = 5;
    _kOptionLabelTag = 10;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeLeftMenuIfOpen)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)openLocationScreen {
    LocationViewController *locationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

- (void)openCardScreen {
    ShowCreditCardsViewController *showCreditCardsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowCreditCardsViewController"];
    [self.navigationController pushViewController:showCreditCardsViewController animated:YES];
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
            [self openLocationScreen];
            break;
        case 1:
            [self openCardScreen];
            break;
        default:
            break;
    }
}

@end
