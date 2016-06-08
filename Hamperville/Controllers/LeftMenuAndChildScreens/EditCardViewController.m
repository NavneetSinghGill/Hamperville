//
//  EditCardViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 31/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "EditCardViewController.h"
#import "RequestManager.h"

@interface EditCardViewController ()

@property(weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property(weak, nonatomic) IBOutlet UIButton *primaryButton;
@property(weak, nonatomic) IBOutlet UIButton *deleteButton;
@property(weak, nonatomic) IBOutlet UIButton *imageButton;

@property(assign, nonatomic) BOOL wasUpdated;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation EditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Edit Card" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.backButton, nil]];
    
    self.cardNumberLabel.text = [NSString stringWithFormat:@"**** **** %@",self.creditCardNumber];
    
    if (_isPrimary) {
        self.primaryButton.alpha = 0.5;
        self.deleteButton.alpha = 0.5;
    }
    _wasUpdated = NO;
    
    if ([_cardType isEqualToString:@"Visa"]) {
        [self.imageButton setImage:[UIImage imageNamed:@"visa"] forState:UIControlStateNormal];
    } else if ([_cardType isEqualToString:@"American Express"]) {
        [self.imageButton setImage:[UIImage imageNamed:@"americanExpress"] forState:UIControlStateNormal];
    } else if ([_cardType isEqualToString:@"Master Card"]) {
        [self.imageButton setImage:[UIImage imageNamed:@"mastercard"] forState:UIControlStateNormal];
    }
}

- (void)backButtonTapped {
//    if (_wasUpdated) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    } else {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)setAsPrimaryApiCall {
    [[RequestManager alloc] postSetPrimaryCreditCard:self.creditCardID withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:kChangeRefreshStatusShowCardScreen];
            
            _wasUpdated = YES;
            [self showToastWithText:[response valueForKey:@"message"] on:Success];
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

- (void)deleteApiCall {
    [[RequestManager alloc] deleteCreditCard:self.creditCardID withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeRefreshStatusShowCardScreen" object:nil];
            _wasUpdated = YES;
            [self showToastWithText:[response valueForKey:@"message"] on:Success];
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

#pragma mark - IBAction methods

- (IBAction)setAsPrimaryButtonTapped:(id)sender {
    if (_isPrimary) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Credit card is already set to primary." message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionDismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil ];
        [alertController addAction:alertActionDismiss];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self.activityIndicator startAnimating];
    [self setAsPrimaryApiCall];
}

- (IBAction)deleteButtonTapped:(id)sender {
    if (_isPrimary) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Primary Credit card can't be deleted." message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionDismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil ];
        [alertController addAction:alertActionDismiss];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to delete this card?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertActionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.activityIndicator startAnimating];
        [self deleteApiCall];
    } ];
    UIAlertAction *alertActionNo = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil ];
    [alertController addAction:alertActionYes];
    [alertController addAction:alertActionNo];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
