//
//  LoginViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 11/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestManager.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController() <UITextFieldDelegate> {
    NSInteger kLogoTopConstraintDefaultValue;
}

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UIView *userNameView;
@property(weak, nonatomic) IBOutlet UIView *passwordView;
@property(weak, nonatomic) IBOutlet UIButton *loginButton;

@property(weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;


@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

#pragma mark - View Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.userNameTextField becomeFirstResponder];
}


#pragma mark - IBAction methods

- (IBAction)loginButtonTapped:(id)sender {
    if (self.userNameTextField.text.length < 1) {
        [self showToastWithText:@"Enter username" on:Bottom];
    } else if (self.passwordTextField.text.length < 1) {
        [self showToastWithText:@"Enter password" on:Bottom];
    } else {
        [self.activityIndicator startAnimating];
        [[RequestManager alloc] loginWithUserEmail:self.userNameTextField.text andPassword:self.passwordTextField.text withCompletionBlock:^(BOOL success, id response) {
            if (success){
                NSString *userId = (NSString *)response;
                
                NSLog(@"UserId: %@", userId);
                
                [self getUserCall:userId];
            } else {
                [self showToastWithText:response on:Bottom];
                [self.activityIndicator stopAnimating];
            }
        }];
    }
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
    ForgotPasswordViewController *forgotPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}

#pragma mark - Private methods

- (void)getUserCall:(NSString *)userID {
    [[RequestManager alloc] getUserWithID:userID
                      withCompletionBlock:^(BOOL success, id response) {
                          [self.activityIndicator stopAnimating];
                          if (success) {
                              User *user = (User *)response;
                              [[Util sharedInstance] saveUser:user];
                              [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                          } else {
                              [self showToastWithText:response on:Bottom];
                          }
                      }];
}

- (void)openLoginViewController {
    dispatch_async(dispatch_get_main_queue(), ^{

    });
}

- (void)initialSetup {
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.titleLabel.text = @"The Evolution of\nDry Cleaning & Laundry";
    
    self.userNameView.layer.cornerRadius = 3;
    self.userNameView.clipsToBounds = YES;
    self.userNameView.layer.borderWidth = 1;
    [self.userNameView.layer setBorderColor:[UIColor colorWithRed:134/255.0f green:134/255.0f blue:134/255.0f alpha:1.0].CGColor];
    
    self.passwordView.layer.cornerRadius = 3;
    self.passwordView.clipsToBounds = YES;
    self.passwordView.layer.borderWidth = 1;
    [self.passwordView.layer setBorderColor:[UIColor colorWithRed:134/255.0f green:134/255.0f blue:134/255.0f alpha:1.0].CGColor];
    
    self.loginButton.layer.cornerRadius = 3;
    
    kLogoTopConstraintDefaultValue = self.logoTopConstraint.constant;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark Notification Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds;
    UITextField *textField = nil;
    UIView *viewOfTextField = nil;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    if ([self.userNameTextField isFirstResponder]) {
        textField = self.userNameTextField;
        viewOfTextField = self.userNameView;
    } else if ([self.passwordTextField isFirstResponder]) {
        textField = self.passwordTextField;
        viewOfTextField = self.passwordView;
    }
    
    CGFloat difference = ( self.view.frame.size.height - keyboardBounds.size.height) - (textField.frame.size.height + viewOfTextField.frame.origin.y) ;
    
    if (difference < 0) {
        //Note: difference is negative so it's added
        self.logoTopConstraint.constant = kLogoTopConstraintDefaultValue + difference - (kLogoTopConstraintDefaultValue - self.logoTopConstraint.constant);
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    self.logoTopConstraint.constant = kLogoTopConstraintDefaultValue;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - TextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
