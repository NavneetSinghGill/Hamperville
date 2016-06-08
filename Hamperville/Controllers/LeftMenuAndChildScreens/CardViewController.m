//
//  CardViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 27/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "CardViewController.h"
#import "RequestManager.h"

@interface CardViewController ()<UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property(weak, nonatomic) IBOutlet UITextField *monthTextField;
@property(weak, nonatomic) IBOutlet UITextField *yearTextField;
@property(weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property(weak, nonatomic) IBOutlet UIButton *cardTypeImageButton;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(assign, nonatomic) BOOL wasAdded;
@property(strong, nonatomic) NSString *cardType;

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
    
    _wasAdded = NO;
}

- (void)backButtonTapped {
//    if (!_wasAdded) {
        [self.navigationController popViewControllerAnimated:YES];
//    } else {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}

- (void)setCardImageForText:(NSString *)text {
    if ([text hasPrefix:@"4"]) {
        [self.cardTypeImageButton setImage:[UIImage imageNamed:@"visa"] forState:UIControlStateNormal];
        self.cardType = @"Visa";
    } else if ([text hasPrefix:@"34"] || [text hasPrefix:@"37"]) {
        [self.cardTypeImageButton setImage:[UIImage imageNamed:@"americanExpress"] forState:UIControlStateNormal];
        self.cardType = @"American Express";
    } else if ([text hasPrefix:@"50"] || [text hasPrefix:@"51"] || [text hasPrefix:@"52"] || [text hasPrefix:@"53"] || [text hasPrefix:@"54"] || [text hasPrefix:@"55"]) {
        [self.cardTypeImageButton setImage:[UIImage imageNamed:@"mastercard"] forState:UIControlStateNormal];
        self.cardType = @"Master Card";
    } else {
        [self.cardTypeImageButton setImage:[UIImage imageNamed:@"cardImage"] forState:UIControlStateNormal];
        self.cardType = kEmptyString;
    }
}

#pragma mark - IBAction methods

- (IBAction)saveButtonTapped:(id)sender {
    if (self.cardType.length == 0) {
        [self showToastWithText:@"Enter cards of type \'Visa\', \'American Express\' or \'MasterCard\'" on:Failure];
        return;
    }
    if (self.monthTextField.text.length == 0 || self.yearTextField.text.length == 0 || self.cvvTextField.text.length == 0) {
        [self showToastWithText:@"Enter details" on:Failure];
        return;
    }
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    dataDict[@"cc_type"] = self.cardType;
    dataDict[@"cc_last_4_digits"] = self.cardNumberTextField.text;
    dataDict[@"year"] = self.yearTextField.text;
    dataDict[@"month"] = self.monthTextField.text;
    
    [self.activityIndicator startAnimating];
    [[RequestManager alloc] postAddCreditWithDataDictionary:dataDict withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:kChangeRefreshStatusShowCardScreen];
            
            [self showToastWithText:@"Credit card added successfully." on:Success];
            double delayInSeconds = 1.8;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
            _wasAdded = YES;
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
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
                    [self setCardImageForText:[textField.text stringByReplacingCharactersInRange:range withString:string]];
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
                    if ([textField.text stringByReplacingCharactersInRange:range withString:string].length == 2) {
                        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        [self.yearTextField becomeFirstResponder];
                        return NO;
                    }
                    return YES;
                }
            } else {
                return NO;
            }
        } else if (textField == self.yearTextField) {
            if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
                if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 4) {
                    return NO;
                } else {
                    if ([textField.text stringByReplacingCharactersInRange:range withString:string].length == 4) {
                        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
                        [self.cvvTextField becomeFirstResponder];
                        return NO;
                    }
                    return YES;
                }
            } else {
                return NO;
            }
        } else if (textField == self.cvvTextField) {
            if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
                if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 4) {
                    return NO;
                } else {
                    return YES;
                }
            } else {
                return NO;
            }
        }
    } else {
        if (textField == self.cardNumberTextField) {
            [self setCardImageForText:[textField.text stringByReplacingCharactersInRange:range withString:string]];
        }
    }
    return YES;
}

@end
