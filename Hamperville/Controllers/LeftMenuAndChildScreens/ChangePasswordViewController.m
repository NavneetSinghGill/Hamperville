//
//  ChangePasswordViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 15/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "RequestManager.h"

@interface ChangePasswordViewController () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *currentPassTextField;
@property(weak, nonatomic) IBOutlet UITextField *nwPassTextField;
@property(weak, nonatomic) IBOutlet UITextField *reEnterNwPassTextField;

@property(weak, nonatomic) IBOutlet UIButton *savePassword;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(strong, nonatomic) NSNotification *notification;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    _notification = notification;
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Change Password" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    self.savePassword.layer.cornerRadius = 4;
    
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
    
    self.currentPassTextField.layer.borderWidth = self.nwPassTextField.layer.borderWidth = self.reEnterNwPassTextField.layer.borderWidth = 1;
    
    self.currentPassTextField.layer.borderColor = self.nwPassTextField.layer.borderColor = self.reEnterNwPassTextField.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor;
    
    self.currentPassTextField.layer.cornerRadius = self.nwPassTextField.layer.cornerRadius = self.reEnterNwPassTextField.layer.cornerRadius = 4;
    
    self.reEnterNwPassTextField.returnKeyType = UIReturnKeyDone;
    
    self.currentPassTextField.delegate = self;
    self.nwPassTextField.delegate = self;
    self.reEnterNwPassTextField.delegate = self;
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction methods

- (IBAction)savePasswordButtonTapped:(id)sender {
    if (![ApplicationDelegate hasNetworkAvailable]) {
        [self showToastWithText:kNoNetworkAvailable on:Failure];
        return;
    }
    if ([self.nwPassTextField.text isEqualToString:self.reEnterNwPassTextField.text] && self.nwPassTextField.text.length >= 8 && self.currentPassTextField.text.length >= 8 && self.reEnterNwPassTextField.text.length >= 8) {
        
        if (![self.currentPassTextField.text isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:kUserPassword]]) {
            [self showToastWithText:@"Invalid current password" on:Failure];
            return;
        }
        
        [self.activityIndicator startAnimating];
        [[RequestManager alloc] putChangePasswordWithOldPassword:self.currentPassTextField.text andNwPassword:self.nwPassTextField.text withCompletionBlock:^(BOOL success, id response) {
            [self.activityIndicator stopAnimating];
            if (success) {
                double delayInSeconds = 1.2;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [[NSUserDefaults standardUserDefaults]setValue:self.nwPassTextField.text forKey:kUserPassword];
                    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:kUserID];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                });
                [self showToastWithText:@"Password changed successfully, Please login with new password." on:Success];
            } else {
                [self showToastWithText:response on:Failure];
            }
        }];
    } else if (![self.currentPassTextField.text isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:kUserPassword]]) {
        [self showToastWithText:@"Invalid current password" on:Failure];
    } else if (self.nwPassTextField.text.length < 8){
        [self showToastWithText:@"Minimum 8 characters required in New password field." on:Failure];
    } else if (self.reEnterNwPassTextField.text.length < 8) {
        [self showToastWithText:@"Minimum 8 characters required Re-enter new password field." on:Failure];
    } else if (![self.nwPassTextField.text isEqualToString:self.reEnterNwPassTextField.text]) {
        [self showToastWithText:@"Passwords doesn't match" on:Failure];
    }
}

#pragma mark - TextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.currentPassTextField) {
        [self.nwPassTextField becomeFirstResponder];
//        [self keyboardWillShow:_notification];
    } else if (textField == self.nwPassTextField) {
        [self.reEnterNwPassTextField becomeFirstResponder];
//        [self keyboardWillShow:_notification];
    } else {
        [self.view endEditing:YES];
    }
    return YES;
}

@end
