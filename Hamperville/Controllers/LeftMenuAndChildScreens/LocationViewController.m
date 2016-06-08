//
//  LocationViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 23/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "LocationViewController.h"
#import "RequestManager.h"
#import "LocationTableViewCell.h"

#define kTableViewCellTextFieldTag 20

@interface LocationViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSInteger kTableViewCellHeight;
    NSInteger kHeaderDefaultTopConstraintValue;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIButton *editButton;
@property(weak, nonatomic) IBOutlet UIButton *doorManButton;
@property(weak, nonatomic) IBOutlet UIView *headerView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopConstraint;

@property(strong, nonatomic) NSMutableArray *headings;

@property(strong, nonatomic) UIButton *saveButton;

@property(assign, nonatomic) BOOL areFieldsEditable;
@property(assign, nonatomic) BOOL wereFieldsEdited;

@property(assign, nonatomic) BOOL isEditionAllowed;

@property(strong, nonatomic) NSMutableArray *addressInfo;
@property(assign, nonatomic) BOOL isDoorMan;

@property(assign, nonatomic) NSInteger selectedTextFieldCellIndex;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
    [self getAddress];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Location" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.backButton, nil]];
    
    self.headings = [NSMutableArray arrayWithObjects:@"Street name", @"Apartment name", @"City name", @"Sate name", @"Zip code", nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 44, 34)];
    self.saveButton.layer.cornerRadius = self.saveButton.frame.size.width / 2;
    self.saveButton.layer.masksToBounds = YES;
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton.titleLabel setFont:[UIFont fontWithName:@"roboto-regular" size:14.0f]];
    [self.saveButton setTitleColor:[UIColor colorWithRed:51/255.0f green:171/255.0f blue:73/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    
    [self setRightMenuButtons:[NSArray arrayWithObject:saveBarButton]];
    
    self.saveButton.hidden = YES;
    self.areFieldsEditable = NO;
    self.wereFieldsEdited = NO;
    self.isEditionAllowed = NO;
    
    self.doorManButton.userInteractionEnabled = NO;
    
    kTableViewCellHeight = 55;
    self.tableViewHeight.constant = self.headings.count * kTableViewCellHeight;
    kHeaderDefaultTopConstraintValue = self.headerTopConstraint.constant;
    
    [self registerNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark Notification Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    CGFloat difference = ( self.view.frame.size.height - keyboardBounds.size.height) - (kHeaderDefaultTopConstraintValue + self.headerView.frame.size.height + kTableViewCellHeight * (self.selectedTextFieldCellIndex + 2)) ;
    
    if (difference < 0) {
        //Note: difference is negative so it's added
        self.headerTopConstraint.constant = kHeaderDefaultTopConstraintValue + difference - (kHeaderDefaultTopConstraintValue - self.headerTopConstraint.constant);
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    self.headerTopConstraint.constant = kHeaderDefaultTopConstraintValue;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)registerNib {
    UINib *nib = [UINib nibWithNibName:TVCLocationTableViewCellNibAndIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TVCLocationTableViewCellNibAndIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonTapped:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath;
    LocationTableViewCell *tableViewCell;
    for (NSInteger index = 0; index < [self.tableView numberOfRowsInSection:0]; index++) {
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        tableViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (tableViewCell.textField.text.length > 0) {
            if (index == 0) {
                dataDict[@"street"] = tableViewCell.textField.text;
            } else if (index == 1) {
                dataDict[@"apartment_number"] = tableViewCell.textField.text;
            } else if (index == 2) {
                dataDict[@"city"] = tableViewCell.textField.text;
            } else if (index == 3) {
                dataDict[@"state"] = tableViewCell.textField.text;
            }
        } else {
            [self showToastWithText:@"Fill the remaining details" on:Failure];
            return;
        }
    }
    [dataDict setValue:[NSNumber numberWithBool:self.doorManButton.selected] forKey:@"is_doorman_building"];
    [[RequestManager alloc] postAddressWithDataDictionary:dataDict withCompletionBlock:^(BOOL success, id response) {
        if (success) {
            [self showToastWithText:@"Address successfully updated." on:Success];
            self.saveButton.hidden = YES;
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self backButtonTapped];
            });
            
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

- (void)getAddress {
    [[RequestManager alloc] getAddress:^(BOOL success, id response) {
        self.addressInfo = [NSMutableArray array];
        if (success) {
            if ([response hasValueForKey:@"address"]) {
                NSDictionary *address = [response valueForKey:@"address"];
                
                [self.addressInfo addObject:[address valueForKey:@"street"]];
                [self.addressInfo addObject:[address valueForKey:@"apartment_number"]];
                [self.addressInfo addObject:[address valueForKey:@"city"]];
                [self.addressInfo addObject:[address valueForKey:@"state"]];
                [self.addressInfo addObject:[NSString stringWithFormat:@"%ld",(long)[[address valueForKey:@"zipcode"] integerValue]]];
                
                self.isDoorMan = [[address valueForKey:@"is_doorman_building"] boolValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableViewHeight.constant = self.headings.count * kTableViewCellHeight;
                    [self.tableView reloadData];
                    self.doorManButton.selected = self.isDoorMan;
                });
            }
            self.isEditionAllowed = [[response valueForKey:@"is_editable"] boolValue];
            if (self.isEditionAllowed) {
                self.editButton.hidden = YES;
            }
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

- (void)fieldTextFieldEditingChanged:(UITextField *)textField {
    self.wereFieldsEdited = YES;
    self.saveButton.hidden = NO;
    if (textField.tag == 1) {
        
    } else if (textField.tag == 2) {
        
    } else if (textField.tag == 3) {
        
    } else if (textField.tag == 4) {
        
    } else if (textField.tag == 5) {
        
    }
}

- (void)fieldTextFieldTapped:(UITextField *)textField {
    self.headerTopConstraint.constant = kHeaderDefaultTopConstraintValue;
    self.selectedTextFieldCellIndex = textField.tag - 1;
}

#pragma mark - IBAction methods

- (IBAction)editButtonTapped:(id)sender {
    if (self.editButton.selected == NO && ![ApplicationDelegate hasNetworkAvailable]) {
        [self showToastWithText:@"Cant't edit in offline mode" on:Failure];
        return;
    }
    if (self.isEditionAllowed) {
        [self showToastWithText:@"Address can not be updated because doorman service is active" on:Failure];
        return;
    }
    self.editButton.selected = !self.editButton.selected;
    self.saveButton.hidden = NO;
    if (self.editButton.selected) {
        self.areFieldsEditable = self.doorManButton.userInteractionEnabled = self.editButton.selected;
        [self.tableView reloadData];
    }
    [self.view endEditing:YES];
}

- (IBAction)doorManButtonTapped:(id)sender {
    self.doorManButton.selected = !self.doorManButton.selected;
    self.saveButton.hidden = NO;
}

#pragma mark - Table view methods -

#pragma mark Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.headings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationTableViewCell *locationTableViewCell = [tableView dequeueReusableCellWithIdentifier:TVCLocationTableViewCellNibAndIdentifier];
    locationTableViewCell.textField.userInteractionEnabled = self.areFieldsEditable;
    if (indexPath.row == self.addressInfo.count - 1) {
        locationTableViewCell.textField.userInteractionEnabled = NO;
    }
    //Tags can later be used to identify cell tapped.
    [locationTableViewCell.textField setTag:indexPath.row + 1];
    
    [locationTableViewCell.textField addTarget:self action:@selector(fieldTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [locationTableViewCell.textField addTarget:self action:@selector(fieldTextFieldTapped:) forControlEvents:UIControlEventEditingDidBegin];
    
    locationTableViewCell.textField.placeholder = self.headings[indexPath.row];
    if (self.addressInfo && self.addressInfo.count > 0) {
        locationTableViewCell.textField.text = self.addressInfo[indexPath.row];
    }
    locationTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == self.headings.count - 1) {
        [locationTableViewCell.textField setTextColor:[UIColor lightGrayColor]];
    } else {
        [locationTableViewCell.textField setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
    }
    
    return locationTableViewCell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

@end
