//
//  ShowCreditCardsViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 31/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ShowCreditCardsViewController.h"
#import "RequestManager.h"
#import "CreditCardTableViewCell.h"
#import "CardViewController.h"
#import "EditCardViewController.h"

@interface ShowCreditCardsViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger tableViewCellHeight;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property(weak, nonatomic) IBOutlet UILabel *amountLabel;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(strong, nonatomic) NSMutableArray *allCreditCards;

@end

@implementation ShowCreditCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initialSetup];
    [self.activityIndicator startAnimating];
    [self getAllCreditCards];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Payment" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.backButton, nil]];
    
    tableViewCellHeight = 55;
    
    [self registerNib];
}

- (void)registerNib {
    UINib *nib = [UINib nibWithNibName:TVCCreditCardTableViewCellNibAndIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TVCCreditCardTableViewCellNibAndIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self reloadTableView];
}

- (void)getAllCreditCards {
    [[RequestManager alloc] getAlreadyAddedCreditCards:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            if ([response hasValueForKey:@"credit_balance"]) {
                self.amountLabel.text = [NSString stringWithFormat:@"$ %.02f",[[response valueForKey:@"credit_balance"] floatValue]];
            }
            if ([response hasValueForKey:@"credit_cards"]) {
                self.allCreditCards = [response valueForKey:@"credit_cards"];
            }
            [self reloadTableView];
        } else {
            [self showToastWithText:response on:Top];
        }
    }];
}

- (void)openCardScreen {
    CardViewController *cardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CardViewController"];
    [self.navigationController pushViewController:cardViewController animated:YES];
}

- (void)openEditCardScreen {
    EditCardViewController *editCardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCardViewController"];
    [self.navigationController pushViewController:editCardViewController animated:YES];
}

- (void)reloadTableView {
    self.tableViewHeightConstraint.constant = (self.allCreditCards.count + 1) * tableViewCellHeight;
    [self.tableView reloadData];
}

- (void)backButtonTapped {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - TableView methods -

#pragma mark Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCreditCards.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditCardTableViewCell *creditCardTableViewCell = [tableView dequeueReusableCellWithIdentifier:TVCCreditCardTableViewCellNibAndIdentifier];
    creditCardTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.allCreditCards.count) {
        creditCardTableViewCell.addedCardSuperView.hidden = YES;
        creditCardTableViewCell.addCardSuperView.hidden = NO;
    } else {
        creditCardTableViewCell.addedCardSuperView.hidden = NO;
        creditCardTableViewCell.addCardSuperView.hidden = YES;
        
        NSString *cardNumberString = [self.allCreditCards[indexPath.row] valueForKey:@"cc_last_4_digits"];
        creditCardTableViewCell.cardNumberLabel.text = [NSString stringWithFormat:@"**** %@",cardNumberString];
        if ([[self.allCreditCards[indexPath.row] valueForKey:@"is_primary"] boolValue] == YES) {
            creditCardTableViewCell.primaryLabel.hidden = NO;
        } else {
            creditCardTableViewCell.primaryLabel.hidden = YES;
        }
        
        NSString *type = [self.allCreditCards[indexPath.row] valueForKey:@"cc_type"];
        if ([type isEqualToString:@"Visa"]) {
            [creditCardTableViewCell.imageButton setImage:[UIImage imageNamed:@"visa"] forState:UIControlStateNormal];
        } else if ([type isEqualToString:@"American Express"]) {
            [creditCardTableViewCell.imageButton setImage:[UIImage imageNamed:@"americanExpress"] forState:UIControlStateNormal];
        } else if ([type isEqualToString:@"Master Card"]) {
            [creditCardTableViewCell.imageButton setImage:[UIImage imageNamed:@"mastercard"] forState:UIControlStateNormal];
        }
    }
    return creditCardTableViewCell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![ApplicationDelegate hasNetworkAvailable]) {
        [self showToastWithText:kNoNetworkAvailable on:Top];
        return;
    }
    if (indexPath.row == self.allCreditCards.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self openCardScreen];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            EditCardViewController *editCardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCardViewController"];
            
            NSString *creditCardID = [self.allCreditCards[indexPath.row] valueForKey:@"id"];
            editCardViewController.creditCardID = creditCardID;
            NSString *creditCardNumber = [self.allCreditCards[indexPath.row] valueForKey:@"cc_last_4_digits"];
            editCardViewController.creditCardNumber = creditCardNumber;
            editCardViewController.isPrimary = [[self.allCreditCards[indexPath.row] valueForKey:@"is_primary"] boolValue];
            editCardViewController.cardType = [self.allCreditCards[indexPath.row] valueForKey:@"cc_type"];
            
            [self.navigationController pushViewController:editCardViewController animated:YES];
        });
    }
}

@end
