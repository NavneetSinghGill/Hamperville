//
//  PermanentPreferencesViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 06/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PermanentPreferencesViewController.h"
#import "DropdownTableViewCell.h"
#import "RequestManager.h"

@interface PermanentPreferencesViewController () <DropDownDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate> {
    NSInteger pickerSuperViewDefaultBottomContraintValue;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(strong, nonatomic) UIButton *saveButton;
@property(weak, nonatomic) IBOutlet UIView *pickerSuperView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *pickerSuperViewBottomConstraint;

@property(strong, nonatomic) NSMutableArray *allEntries;
@property(strong, nonatomic) NSMutableArray *allOptions;
@property(strong, nonatomic) NSMutableArray *singleOption;
@property(strong, nonatomic) NSMutableArray *selectedOptionsIDs;
@property(assign, nonatomic) NSInteger selectedOptionIndex;

@property(strong, nonatomic) NSMutableArray *entries;

@end

@implementation PermanentPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
    
    self.pickerView.hidden = YES;
    self.tableView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getPermanentPref];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Permanent Preferences" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 50, 34)];
    [self.saveButton  setTitleColor:[UIColor colorWithRed:51/255.0f green:171/255.0f blue:73/255.0f alpha:1.0] forState:UIControlStateSelected];
    [self.saveButton  setTitleColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.saveButton  setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton  addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    pickerSuperViewDefaultBottomContraintValue = -self.pickerSuperView.frame.size.height;
    self.entries = [NSMutableArray arrayWithObjects:@"Detergents", @"Softeners", @"Dryer Sheets", nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"DropdownTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"DropdownTableViewCell"];
}

- (void)getPermanentPref {
    [self.activityIndicator startAnimating];
    [[RequestManager alloc]getPermanentPreferences:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        self.allEntries = [NSMutableArray array];
        self.allOptions = [NSMutableArray array];
        self.selectedOptionsIDs = [NSMutableArray array];

        if (success) {
            [self parseGetResponse:response];
            self.pickerView.hidden = NO;
            self.tableView.hidden = NO;
            self.saveButton.hidden = NO;
        } else {
            [self showToastWithText:response on:Top];
            self.pickerView.hidden = YES;
            self.tableView.hidden = NO;
            self.saveButton.hidden = YES;
        }
    }];
}

- (void)parseGetResponse:(id)response {
    if ([response hasValueForKey:@"permanent_preferences"]) {
        self.allEntries = [response valueForKey:@"permanent_preferences"];
        
        for (NSDictionary *dict in self.allEntries) {
            [self.allOptions addObject:[self createMutableOption:[dict valueForKey:@"options"]]];
            NSMutableArray *option = [dict valueForKey:@"options"];
            
            for (NSInteger count = 0; count < option.count; count++) {
                NSDictionary *optionsPart = option[count];
                if ([[optionsPart valueForKey:@"is_selected"] boolValue] == YES) {
                    [self.selectedOptionsIDs addObject:[optionsPart valueForKey:@"id"]];
                    break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.allEntries.count > 0 && ((NSArray *)[self.allEntries[0] valueForKey:@"options"]).count > 0) {
                [self refreshPickerViewForCellIndex:0];
                self.selectedOptionIndex = 0;
            }
            [self.tableView reloadData];
        });
    }
}

- (NSMutableArray *)createMutableOption:(NSArray *)arrayObject {
    NSMutableArray *mutableArrayObject = [NSMutableArray array];
    for (NSDictionary *product in arrayObject) {
        [mutableArrayObject addObject:[product mutableCopy]];
    }
    return mutableArrayObject;
}

- (void)refreshPickerViewForCellIndex:(NSInteger)index {
    self.selectedOptionIndex = index;
    self.singleOption = self.allOptions[index];
    [self.pickerView reloadAllComponents];
    
    NSInteger count = 0;
    for (count = 0; count < self.singleOption.count; count++) {
        NSDictionary *optionsPart = self.singleOption[count];
        if ([[optionsPart valueForKey:@"is_selected"] boolValue] == YES) {
            break;
        }
    }
    [self.pickerView selectRow:count inComponent:0 animated:NO];
}

#pragma mark - IBaction methods -

- (IBAction)doneButtonTapped:(id)sender {
    self.pickerSuperViewBottomConstraint.constant = pickerSuperViewDefaultBottomContraintValue;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - Over ridden methods

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonTapped:(UIButton *)saveButton {
    if (saveButton.selected == YES) {
        [self.activityIndicator startAnimating];
        [[RequestManager alloc]postPermanentPreferencesWithDetergentID:self.selectedOptionsIDs[0] softnerID:self.selectedOptionsIDs[1] drySheetID:self.selectedOptionsIDs[2] withCompletionBlock:^(BOOL success, id response) {
            [self.activityIndicator stopAnimating];
            if (success) {
                saveButton.selected = NO;
                [self showToastWithText:@"Permanent preference updated successfully." on:Top withDuration:1.5];
            } else {
                [self showToastWithText:response on:Top];
            }
        }];
    }
}

#pragma mark - Delegate methods

- (void)dropDownTapped:(NSInteger)index {
    if (![ApplicationDelegate hasNetworkAvailable]) {
        [self networkAvailability];
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self refreshPickerViewForCellIndex:indexPath.row];
    
    self.pickerSuperViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - TableView methods -

#pragma mark Datasourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropdownTableViewCell *dropdownTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"DropdownTableViewCell"];
//    dropdownTableViewCell.name.text = [self.allEntries[indexPath.row] valueForKey:@"name"];
    dropdownTableViewCell.name.text = [self.entries objectAtIndex:indexPath.row];
    dropdownTableViewCell.dropDownDelegate = self;
    dropdownTableViewCell.index = indexPath.row;
    dropdownTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return dropdownTableViewCell;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

#pragma mark - PickerView methods -

#pragma mark PickerView Delegate and Datasource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.singleOption.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [tView setTextColor:[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0]];
        [tView setFont:[UIFont fontWithName:@"roboto-regular" size:15.0]];
        tView.textAlignment = NSTextAlignmentCenter;
    }
    // Fill the label text here
    NSDictionary *option = self.singleOption[row];
    tView.text = [option valueForKey:@"name"];
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *optionsSelectedProduct = self.singleOption[row];
    self.selectedOptionsIDs[self.selectedOptionIndex] = [optionsSelectedProduct valueForKey:@"id"];
    self.saveButton.selected = YES;
    
    NSMutableArray *option = self.allOptions[self.selectedOptionIndex];
    for (NSMutableDictionary *product in option) {
        [product setValue:[NSNumber numberWithBool:NO] forKey:@"is_selected"];
    }
    NSDictionary *selectedProduct = option[row];
    [selectedProduct setValue:[NSNumber numberWithBool:YES] forKey:@"is_selected"];
    ((NSMutableArray *)self.allOptions[self.selectedOptionIndex])[row] = selectedProduct;
}

@end
