//
//  HampervilleViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 08/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "HampervilleViewController.h"
#import "SWRevealViewController.h"

@implementation HampervilleViewController

- (void)showOrHideLeftMenu {
    [self.revealViewController performSelector:@selector(revealToggle:) withObject:nil];
}

- (UIBarButtonItem *)menuButton {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 34, 34)];
    leftButton.layer.cornerRadius = leftButton.frame.size.width / 2;
    leftButton.layer.masksToBounds = YES;
    [leftButton setImage:[UIImage imageNamed:@"MenuIcon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(showOrHideLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftBarButton;
}

- (void)setLeftMenuButtons:(NSArray *)barButtons {
    self.navigationItem.leftBarButtonItems = barButtons;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    FrontViewPosition frontViewPosition = self.revealViewController.frontViewPosition;
    if (frontViewPosition == FrontViewPositionLeft) {
        // Left menu is closed
    } else if (frontViewPosition == FrontViewPositionRight) {
        // Left menu is open
        [self showOrHideLeftMenu];
    }
    [self.view endEditing:YES];
}

- (void)showToastWithText:(NSString *)message on:(HeaderPosition)headerPosition {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageFont = [UIFont fontWithName:@"roboto-regular" size:10.0];
    style.backgroundColor = [UIColor colorWithRed:51/255.0f green:171/255.0f blue:73/255.0f alpha:1.0];
    
    NSValue *value = nil;
    if (headerPosition == Top) {
        value = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width / 2, 60)];
    } else if (headerPosition == Bottom) {
        value = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 60)];
    }
    
    [self.view makeToast:message duration:1 position:value style:style];
}

@end
