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

@property(strong, nonatomic) UIButton *saveButton;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *yourInfoTopConstraint;

@property(assign, nonatomic) NSInteger kYourInfoTopConstraintDefault;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

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
    self.saveButton.hidden = YES;
    [self getUserCall:[[Util sharedInstance]getUser].userID];
}

#pragma mark - IBAction methods

- (IBAction)changePasswordButtonTapped:(id)sender {
    ChangePasswordViewController *changePasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController pushViewController:changePasswordViewController animated:YES];
}

- (IBAction)logoutButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to logout?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAlertAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.activityIndicator startAnimating];
        [[RequestManager alloc]logoutUser:[[Util sharedInstance]getUser] withCompletionBlock:^(BOOL success, id response) {
            [self.activityIndicator stopAnimating];
            if (success) {
                [[SignupInterface alloc] clearSavedSessionCookies];
                [[Util sharedInstance]saveUser:[User new]];
                [self.revealViewController dismissViewControllerAnimated:NO completion:nil];
            } else {
                [self showToastWithText:response on:Top];
            }
        }];
    }];
    UIAlertAction *noAlertAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:yesAlertAction];
    [alertController addAction:noAlertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)editButtonTapped:(id)sender {
    BOOL invalidEntries = false;
    if (self.editButton.selected == YES) {
        [self dismissKeyboardIfOpen];
        UIAlertController *alertController = [[UIAlertController alloc]init];
        alertController.title = @"Do you want to save your data?";
        UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self initTextFieldsWithUserInfo];
            [self.editButton setSelected:NO];
            [self setUserinteractionForTextFields];
        }];
        UIAlertAction *alertActionYes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[Util sharedInstance]getNumberAsStringFromString:self.primaryPhoneTextField.text].length == 10 &&
                ([[Util sharedInstance]getNumberAsStringFromString:self.alternativePhoneTextField.text].length == 0 ||
                 [[Util sharedInstance]getNumberAsStringFromString:self.alternativePhoneTextField.text].length == 10) &&
                self.firstNameTextField.text.length != 0 && self.lastNameTextField.text.length != 0) {
                if ([[Util sharedInstance]getNumberAsStringFromString:self.alternativePhoneTextField.text].length == 10 &&
                    [self.alternativePhoneTextField.text isEqualToString:self.primaryPhoneTextField.text]) {
                    [self showToastWithText:@"Primary and alternate phone numbers can't be same" on:Top withDuration:3.0];
                    self.saveButton.hidden = NO;
                    self.editButton.selected = YES;
                } else {
                    [self postUserAPI];
                }
            } else {
                [self showToastWithText:@"Please re-check your entries" on:Top];
                self.saveButton.hidden = NO;
                self.editButton.selected = YES;
                [self setUserinteractionForTextFields];
            }
        }];
        [alertController addAction:alertActionNo];
        [alertController addAction:alertActionYes];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([[Util sharedInstance]getNumberAsStringFromString:self.primaryPhoneTextField.text].length != 10) {
        [self showToastWithText:@"Please re-check your entries" on:Top];
        invalidEntries = YES;
    }
    if (!invalidEntries) {
        self.editButton.selected = !self.editButton.selected;
        self.saveButton.hidden = !self.editButton.selected;
        [self setUserinteractionForTextFields];
    }
}

- (void)showOrHideLeftMenu {
    [self dismissKeyboardIfOpen];
    self.saveButton.hidden = YES;
    if (self.editButton.isSelected) {
        UIAlertController *alertController = [[UIAlertController alloc]init];
        alertController.title = @"Do you want to save your data?";
        UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self initTextFieldsWithUserInfo];
            [self.editButton setSelected:NO];
            [super showOrHideLeftMenu];
            [self setUserinteractionForTextFields];
        }];
        UIAlertAction *alertActionYes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[Util sharedInstance]getNumberAsStringFromString:self.primaryPhoneTextField.text].length == 10 &&
                ([[Util sharedInstance]getNumberAsStringFromString:self.alternativePhoneTextField.text].length == 0 ||
                 [[Util sharedInstance]getNumberAsStringFromString:self.alternativePhoneTextField.text].length == 10) &&
                self.firstNameTextField.text.length != 0 && self.lastNameTextField.text.length != 0) {
                if ([[Util sharedInstance]getNumberAsStringFromString:self.alternativePhoneTextField.text].length == 10 &&
                    [self.alternativePhoneTextField.text isEqualToString:self.primaryPhoneTextField.text]) {
                    [self showToastWithText:@"Primary and alternate phone numbers can't be same" on:Top withDuration:3.0];
                    self.saveButton.hidden = NO;
                } else {
                    [super showOrHideLeftMenu];
                    [self.editButton setSelected:NO];
                    [self postUserAPI];
                    [self setUserinteractionForTextFields];
                }
            } else {
                [self showToastWithText:@"Please re-check your entries" on:Top];
                self.saveButton.hidden = NO;
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
    
    if (textField == self.primaryPhoneTextField || textField == self.alternativePhoneTextField) {
        if (string.length > 0) {
            NSString *number = [[Util sharedInstance]getNumberAsStringFromString:string];
            if (number.length == 0) {
                return NO;
            }
        } else {
            NSString *currentNumber = [[Util sharedInstance]getNumberAsStringFromString:textField.text];
            if (currentNumber.length == 0) {
                return NO;
            }
        }
        
        NSString *currentNumber = [[Util sharedInstance]getNumberAsStringFromString:textField.text];
        if ((string.length > 0 && currentNumber.length == 10) || (string.length == 0 && currentNumber.length == 0)) {
            return NO;
        }
        if (string.length == 0) {
            currentNumber = [currentNumber substringToIndex:currentNumber.length - 1];
        } else {
            currentNumber = [NSString stringWithFormat:@"%@%@",currentNumber, string];
        }
        
        NSInteger cursorLocation = 0;
        //Create resultant string
        NSString *resultantStringToSet = @"(";
        for (int count = 0; count < 10; count++) {
            if (count < currentNumber.length) {
                NSRange range = NSMakeRange(count, 1);
                resultantStringToSet = [NSString stringWithFormat:@"%@%@",resultantStringToSet, [currentNumber substringWithRange:range]];
                if (count == 2) {
                    resultantStringToSet = [NSString stringWithFormat:@"%@) ",resultantStringToSet];
                } else if (count == 5) {
                    resultantStringToSet = [NSString stringWithFormat:@"%@-",resultantStringToSet];
                }
                cursorLocation = count + 1;
            } else {
                resultantStringToSet = [NSString stringWithFormat:@"%@_ ",resultantStringToSet];
                if (count == 2) {
                    resultantStringToSet = [NSString stringWithFormat:@"%@) ",resultantStringToSet];
                } else if (count == 5) {
                    resultantStringToSet = [NSString stringWithFormat:@"%@-",resultantStringToSet];
                }
            }
        }
        if (cursorLocation > 6) {
            cursorLocation = cursorLocation + 4;
        } else if (cursorLocation > 3) {
            cursorLocation = cursorLocation + 3;
        } else if (cursorLocation > 0){
            cursorLocation = cursorLocation + 1;
        } else {
            cursorLocation = 1;
        }
        //Set resultant string
        textField.text = resultantStringToSet;
        if (textField == self.alternativePhoneTextField && [[Util sharedInstance]getNumberAsStringFromString:textField.text].length == 0) {
            textField.text = kEmptyString;
        }
        //Set textfield cursor position
        [self selectTextForInput:textField atRange:NSMakeRange(cursorLocation, 0)];
        return NO;
    }
    
    return  YES;
}

- (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Personal Details" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 44, 34)];
    self.saveButton.layer.cornerRadius = self.saveButton.frame.size.width / 2;
    self.saveButton.layer.masksToBounds = YES;
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton.titleLabel setFont:[UIFont fontWithName:@"roboto-regular" size:14.0f]];
    [self.saveButton setTitleColor:[UIColor colorWithRed:51/255.0f green:171/255.0f blue:73/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    
    [self setRightMenuButtons:[NSArray arrayWithObject:saveBarButton]];
    
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

- (void)saveButtonTapped:(UIButton *)button {
    [self editButtonTapped:self.editButton];
    self.saveButton.hidden = YES;
}

- (void)getUserCall:(NSString *)userID {
    [[RequestManager alloc] getUserWithID:userID
                      withCompletionBlock:^(BOOL success, id response) {
                          [self.activityIndicator stopAnimating];
                          if (success) {
                              User *user = (User *)response;
                              [[Util sharedInstance] saveUser:user];
                              [self initTextFieldsWithUserInfo];
                          } else {
                              
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
        //Note: difference is negative so it's added
        self.yourInfoTopConstraint.constant = self.kYourInfoTopConstraintDefault + difference - (self.kYourInfoTopConstraintDefault - self.yourInfoTopConstraint.constant);
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notificaiton {
    CGRect keyboardBounds;
    
    [[notificaiton.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    self.yourInfoTopConstraint.constant = self.kYourInfoTopConstraintDefault;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
