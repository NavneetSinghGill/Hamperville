//
//  HampervilleViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 08/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "HampervilleViewController.h"
#import "SWRevealViewController.h"
#import "Order.h"
#import "OrderHistoryDetailsViewController.h"

@implementation HampervilleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkAvailability)
                                                 name:kNetworkAvailablability
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showOrderScreen:)
                                                 name:kShowOrderScreen
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPushNotificationMessage:) name:kAppReceivedPushNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)showPushNotificationMessage:(NSNotification *)notification {
    if (self.isViewLoaded && self.view.window && notification.userInfo != nil) {
        [self showToastWithText:[notification.userInfo valueForKey:kPushNotificationMessage] on:Success];
    }
}

- (void)showOrderScreen:(NSNotification *)notification {
    if (self.isViewLoaded && self.view.window) {
        if (notification.userInfo != nil) {
            Order *order = [Order getOrderFromDictionary:[notification.userInfo valueForKey:@"PushNotificationData"]];
            OrderHistoryDetailsViewController *orderHistoryDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryDetailsViewController"];
            orderHistoryDetailsViewController.order = order;
            [self.navigationController pushViewController:orderHistoryDetailsViewController animated:YES];
        }
    }
}

- (void)networkAvailability {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        
    } else {
        if (self.isViewLoaded && self.view.window) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Network available" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertActionDismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil ];
            [alertController addAction:alertActionDismiss];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)showOrHideLeftMenu {
    [self.revealViewController performSelector:@selector(revealToggle:) withObject:nil];
}

- (void)backButtonTapped {
    
}

#pragma mark - BarButtons

- (UIBarButtonItem *)menuButton {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 34, 34)];
    leftButton.layer.cornerRadius = leftButton.frame.size.width / 2;
    leftButton.layer.masksToBounds = YES;
    [leftButton setImage:[UIImage imageNamed:@"MenuIcon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(showOrHideLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftBarButton;
}

- (UIBarButtonItem *)backButton {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 34, 34)];
    leftButton.layer.cornerRadius = leftButton.frame.size.width / 2;
    leftButton.layer.masksToBounds = YES;
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftBarButton;
}

#pragma mark - Navigation property setters

- (void)setLeftMenuButtons:(NSArray<UIBarButtonItem *> *)barButtons {
    self.navigationItem.leftBarButtonItems = barButtons;
}

- (void)setRightMenuButtons:(NSArray *)barButtons {
    self.navigationItem.rightBarButtonItems = barButtons;
}

- (void)setNavigationBarButtonTitle:(NSString *)title andColor:(UIColor *)color
{
    UIButton* centralButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    [centralButton setTitle:title forState:UIControlStateNormal];
    [centralButton.titleLabel setFont:[UIFont fontWithName:@"Roboto" size:16.0f]];
    [centralButton setTitleColor:color forState:UIControlStateNormal];
    //    [centralButton setShowsTouchWhenHighlighted:TRUE];
    centralButton.userInteractionEnabled = NO;
    [centralButton addTarget:self action:@selector(centerTitleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = centralButton;
    
}

- (void)centerTitleButtonTapped {
    
}

#pragma mark - View Properties

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self closeLeftMenuIfOpen];
    [self.view endEditing:YES];
}

- (void)closeLeftMenuIfOpen {
    FrontViewPosition frontViewPosition = self.revealViewController.frontViewPosition;
    if (frontViewPosition == FrontViewPositionLeft) {
        // Left menu is closed
    } else if (frontViewPosition == FrontViewPositionRight) {
        // Left menu is open
        [self.revealViewController performSelector:@selector(revealToggle:) withObject:nil];
    }
}

// method name "showToastWithText" was not change as it was used at many places
- (void)showToastWithText:(NSString *)message on:(HeaderResponse)headerResponse {
    
    if ([message isEqualToString:kNoNetworkAvailable]) {
        [self networkAvailability];
    } else {
        if (headerResponse == Success) {
            [ApplicationDelegate showSuccessBannerWithSubtitle:message];
        } else if (headerResponse == Failure) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertActionDismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil ];
            [alertController addAction:alertActionDismiss];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

@end
