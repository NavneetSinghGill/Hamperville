//
//  ChangePasswordViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 15/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "RequestManager.h"

@interface ChangePasswordViewController ()

@property(weak, nonatomic) IBOutlet UITextField *currentPassTextField;
@property(weak, nonatomic) IBOutlet UITextField *nwPassTextField;
@property(weak, nonatomic) IBOutlet UITextField *reEnterNwPassTextField;

@property(weak, nonatomic) IBOutlet UIButton *savePassword;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Change Password" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    self.savePassword.layer.cornerRadius = 4;
    
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
    
    self.currentPassTextField.layer.borderWidth = self.nwPassTextField.layer.borderWidth = self.reEnterNwPassTextField.layer.borderWidth = 1;
    
    self.currentPassTextField.layer.borderColor = self.nwPassTextField.layer.borderColor = self.reEnterNwPassTextField.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor;
    
    self.currentPassTextField.layer.cornerRadius = self.nwPassTextField.layer.cornerRadius = self.reEnterNwPassTextField.layer.cornerRadius = 4;
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction methods

- (IBAction)savePasswordButtonTapped:(id)sender {
    if ([self.nwPassTextField.text isEqualToString:self.reEnterNwPassTextField.text] && self.nwPassTextField.text.length >= 8 && self.currentPassTextField.text.length >= 8 && self.reEnterNwPassTextField.text.length >= 8) {
        [[RequestManager alloc] putChangePasswordWithOldPassword:self.currentPassTextField.text andNwPassword:self.nwPassTextField.text withCompletionBlock:^(BOOL success, id response) {
            if (success) {
                
            } else {
                
            }
        }];
    } else if (self.nwPassTextField.text.length < 8 || self.reEnterNwPassTextField.text.length < 8){
        [self showToastWithText:@"Minimum 8 characters required." on:Top];
    }   else if (![self.nwPassTextField.text isEqualToString:self.reEnterNwPassTextField.text]) {
        [self showToastWithText:@"Passwords doesn't match" on:Top];
    }
}

@end
