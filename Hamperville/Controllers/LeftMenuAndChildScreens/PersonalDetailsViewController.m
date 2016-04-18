//
//  PersonalDetailsViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 13/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PersonalDetailsViewController.h"
#import "RequestManager.h"
#import "User.h"
#import "ChangePasswordViewController.h"
#import "LeftMenuViewController.h"
#import "SignupInterface.h"

@interface PersonalDetailsViewController ()<UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property(weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property(weak, nonatomic) IBOutlet UITextField *primaryPhoneTextField;
@property(weak, nonatomic) IBOutlet UITextField *alternativePhoneTextField;

@property(weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property(weak, nonatomic) IBOutlet UIButton *logoutButton;
@property(weak, nonatomic) IBOutlet UIButton *editButton;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *yourInfoTopConstraint;

@property(assign, nonatomic) NSInteger kYourInfoTopConstraintDefault;

@end

@implementation PersonalDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setUserinteractionForTextFields];
    [self initTextFieldsWithUserInfo];
}

#pragma mark - IBAction methods

- (IBAction)changePasswordButtonTapped:(id)sender {
    ChangePasswordViewController *changePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController pushViewController:changePasswordViewController animated:YES];
}

- (IBAction)logoutButtonTapped:(id)sender {
    [[RequestManager alloc]logoutUser:[[Util sharedInstance]getUser] withCompletionBlock:^(BOOL success, id response) {
        [[SignupInterface alloc] clearSavedSessionCookies];
    }];
    [[Util sharedInstance]saveUser:[User new]];
    [self.revealViewController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)editButtonTapped:(id)sender {
    BOOL invalidEntries = false;
    if (self.editButton.selected == YES && self.primaryPhoneTextField.text.length == 10 && (self.alternativePhoneTextField.text.length == 0 || self.alternativePhoneTextField.text.length == 10)) {
        [self dismissKeyboardIfOpen];
        UIAlertController *alertController = [[UIAlertController alloc]init];
        alertController.title = @"Do you want to save your data?";
        UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self initTextFieldsWithUserInfo];
        }];
        UIAlertAction *alertActionYes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self postUserAPI];
        }];
        [alertController addAction:alertActionNo];
        [alertController addAction:alertActionYes];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (self.primaryPhoneTextField.text.length != 10) {
        [self showToastWithText:@"Please re-check your entries" on:Top];
        invalidEntries = YES;
    }
    if (!invalidEntries) {
        self.editButton.selected = !self.editButton.selected;
        [self setUserinteractionForTextFields];
    }
}

- (void)showOrHideLeftMenu {
    [self dismissKeyboardIfOpen];
    if (self.editButton.isSelected) {
        UIAlertController *alertController = [[UIAlertController alloc]init];
        alertController.title = @"Do you want to save your data?";
        UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self initTextFieldsWithUserInfo];
            [self.editButton setSelected:NO];
            [super showOrHideLeftMenu];
        }];
        UIAlertAction *alertActionYes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.primaryPhoneTextField.text.length == 10 && (self.alternativePhoneTextField.text.length == 0 || self.alternativePhoneTextField.text.length == 10)) {
                [super showOrHideLeftMenu];
                [self.editButton setSelected:NO];
                [self postUserAPI];
            } else {
                [self showToastWithText:@"Please re-check your entries" on:Top];
            }
        }];
        [alertController addAction:alertActionNo];
        [alertController addAction:alertActionYes];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [super showOrHideLeftMenu];
    }
}

#pragma mark - TextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
    } else if (textField == self.lastNameTextField) {
        [self.primaryPhoneTextField becomeFirstResponder];
    } else if (textField == self.primaryPhoneTextField) {
        [self.alternativePhoneTextField becomeFirstResponder];
    } else if (textField == self.alternativePhoneTextField){
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return  YES;
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Personal Details" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    
    self.changePasswordButton.layer.cornerRadius = 4;
    self.changePasswordButton.layer.borderWidth = 1;
    self.changePasswordButton.layer.borderColor = [UIColor colorWithRed:44/255.0f green:159/255.0f blue:57/255.0f alpha:1.0].CGColor;
    
    self.logoutButton.layer.cornerRadius = 4;
    
    self.kYourInfoTopConstraintDefault = self.yourInfoTopConstraint.constant;
    [self registerNotifications];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.primaryPhoneTextField.delegate = self;
    self.alternativePhoneTextField.delegate = self;
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)initTextFieldsWithUserInfo {
    User *user = [[Util sharedInstance]getUser];
    self.firstNameTextField.text = user.firstName;
    self.lastNameTextField.text = user.lastName;
    self.primaryPhoneTextField.text = user.primaryPhone;
    self.alternativePhoneTextField.text = user.alternativePhone;
}

- (void)dismissKeyboardIfOpen {
    if ([self.firstNameTextField isFirstResponder]) {
        [self.firstNameTextField resignFirstResponder];
    } else if ([self.lastNameTextField isFirstResponder]) {
        [self.lastNameTextField resignFirstResponder];
    } else if ([self.primaryPhoneTextField isFirstResponder]) {
        [self.primaryPhoneTextField resignFirstResponder];
    } else if ([self.alternativePhoneTextField isFirstResponder]) {
        [self.alternativePhoneTextField resignFirstResponder];
    }
}

- (void)setUserinteractionForTextFields {
    self.firstNameTextField.userInteractionEnabled = self.lastNameTextField.userInteractionEnabled = self.primaryPhoneTextField.userInteractionEnabled = self.alternativePhoneTextField.userInteractionEnabled = self.editButton.selected;
}

- (void)postUserAPI {
    User *userToUpdate = [User new];
    userToUpdate.firstName = self.firstNameTextField.text;
    userToUpdate.lastName = self.lastNameTextField.text;
    userToUpdate.primaryPhone = self.primaryPhoneTextField.text;
    userToUpdate.alternativePhone = self.alternativePhoneTextField.text;
    userToUpdate.userID = [[[Util sharedInstance] getUser]userID];
    
    [[RequestManager alloc] postUser:userToUpdate shouldUpdate:YES
                 withCompletionBlock:^(BOOL success, id response) {
                     if (success) {
                         [[Util sharedInstance]saveUser:userToUpdate];
                         if ([self.revealViewController.rearViewController isKindOfClass:[LeftMenuViewController class]]) {
                             LeftMenuViewController *leftMenuViewController = (LeftMenuViewController *)self.revealViewController.rearViewController;
                             [leftMenuViewController refreshUser];
                         }
                     } else {
                         [self initTextFieldsWithUserInfo];
                         if ([response isKindOfClass:[NSArray class]]) {
                             NSArray *responseArray = (NSArray *) response;
                             [self showToastWithText:[NSString stringWithFormat:@"%@\n%@", responseArray[0], responseArray[1]] on:Top];
                         } else {
                             [self showToastWithText:response on:Top];
                         }
                     }
                 }];
}

#pragma mark - Notification methods

- (void)keyboardWillShow:(NSNotification *)notificaiton {
    CGRect keyboardBounds;
    UITextField *textField = nil;
    
    [[notificaiton.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    if ([self.firstNameTextField isFirstResponder]) {
        textField = self.firstNameTextField;
    } else if ([self.lastNameTextField isFirstResponder]) {
        textField = self.lastNameTextField;
    } else if ([self.primaryPhoneTextField isFirstResponder]) {
        textField = self.primaryPhoneTextField;
    } else if ([self.alternativePhoneTextField isFirstResponder]) {
        textField = self.alternativePhoneTextField;
    }
    
    CGFloat difference = ( self.view.frame.size.height - keyboardBounds.size.height) - (textField.frame.size.height + textField.frame.origin.y) ;
    
    if (difference < 0) {
        self.yourInfoTopConstraint.constant = self.kYourInfoTopConstraintDefault - difference;
    }
}

- (void)keyboardWillHide:(NSNotification *)notificaiton {
    CGRect keyboardBounds;
    
    [[notificaiton.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    self.yourInfoTopConstraint.constant = self.kYourInfoTopConstraintDefault;
}

@end
