//
//  HampervilleViewController.h
//  Hamperville
//
//  Created by stplmacmini11 on 08/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>

typedef enum {
    Top = 0,
    Bottom
} HeaderPosition;

@interface HampervilleViewController : UIViewController

- (void)showOrHideLeftMenu;

- (UIBarButtonItem *)menuButton;
- (UIBarButtonItem *)backButton;

- (void)setLeftMenuButtons:(NSArray *)barButtons;
- (void)setNavigationBarButtonTitle:(NSString *)title andColor:(UIColor *)color;

- (void)centerTitleButtonTapped;
- (void)backButtonTapped;

- (void)showToastWithText:(NSString *)message on:(HeaderPosition)headerPosition;

@end
