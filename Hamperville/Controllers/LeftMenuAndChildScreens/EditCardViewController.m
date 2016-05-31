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
}

- (void)backButtonTapped {
    if (_wasUpdated) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setAsPrimaryApiCall {
    [[RequestManager alloc] postSetPrimaryCreditCard:self.creditCardID withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            _wasUpdated = YES;
            [self showToastWithText:[response valueForKey:@"message"] on:Top withDuration:1.8];
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [self showToastWithText:response on:Top];
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
}

@end