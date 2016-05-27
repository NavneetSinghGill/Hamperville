//
//  CardViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 27/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "CardViewController.h"

@interface CardViewController ()<UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property(weak, nonatomic) IBOutlet UITextField *monthTextField;
@property(weak, nonatomic) IBOutlet UITextField *yearTextField;
@property(weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property(weak, nonatomic) IBOutlet UITextField *cardHolderNameTextField;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Add New Card" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.backButton, nil]];
    
    self.cardNumberTextField.delegate = self;
    self.monthTextField.delegate = self;
    self.yearTextField.delegate = self;
    self.cvvTextField.delegate = self;
    self.cardHolderNameTextField.delegate = self;
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction methods

- (IBAction)saveButtonTapped:(id)sender {
    
}

#pragma mark - TextField Delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length > 0) {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if (textField == self.cardNumberTextField) {
            if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
                if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 16) {
                    return NO;
                } else {
                    return YES;
                }
            } else {
                return NO;
            }
        } else if (textField == self.monthTextField) {
            if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
                if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 2) {
                    return NO;
                } else {
                    return YES;
                }
            } else {
                return NO;
            }
        } else if (textField == self.yearTextField) {
            if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
                if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 2) {
                    return NO;
                } else {
                    return YES;
                }
            } else {
                return NO;
            }
        } else if (textField == self.cvvTextField) {
            if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
                if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 3) {
                    return NO;
                } else {
                    return YES;
                }
            } else {
                return NO;
            }
        }
    }
    return YES;
}

@end
