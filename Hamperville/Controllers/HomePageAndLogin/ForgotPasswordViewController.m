//
//  ForgotPasswordViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 14/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "RequestManager.h"

@interface ForgotPasswordViewController ()

@property(weak, nonatomic) IBOutlet UIButton *sendInstructions;
@property(weak, nonatomic) IBOutlet UITextField *emailTextField;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.sendInstructions setTitle:@"Send me password reset instructions" forState:UIControlStateNormal];
    self.sendInstructions.layer.cornerRadius = 4;
}

- (IBAction)sendInstructions:(id)sender {
    NSRange rangeOfAtTheRate = [self.emailTextField.text rangeOfString:@"@"];
    NSRange rangeOfDot = [self.emailTextField.text rangeOfString:@"."];
    
    if (self.emailTextField.text.length > 5 && rangeOfAtTheRate.location != NSNotFound && rangeOfDot.location != NSNotFound && rangeOfAtTheRate.location < rangeOfDot.location) {
        [self.activityIndicator startAnimating];
        [[RequestManager alloc] postForgotPasswordWithEmail:self.emailTextField.text withCompletionBlock:^(BOOL success, id response) {
            [self.activityIndicator stopAnimating];
            if (success) {
                if ([self.emailTextField isFirstResponder]) {
                    [self showToastWithText:[NSString stringWithFormat:@"Password reset link is sent to %@.",self.emailTextField.text] on:Top];
                } else {
                    [self showToastWithText:[NSString stringWithFormat:@"Password reset link is sent to %@.",self.emailTextField.text] on:Bottom];
                }
                self.emailTextField.text = kEmptyString;
            } else {
                if ([self.emailTextField isFirstResponder]) {
                    [self showToastWithText:response on:Top];
                } else {
                    [self showToastWithText:response on:Bottom];
                }
            }
        }];
    } else {
        if ([self.emailTextField isFirstResponder]) {
            [self showToastWithText:@"Please enter correct email." on:Top];
        } else {
            [self showToastWithText:@"Please enter correct email." on:Bottom];
        }
    }
    [self.emailTextField resignFirstResponder];
}

- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
