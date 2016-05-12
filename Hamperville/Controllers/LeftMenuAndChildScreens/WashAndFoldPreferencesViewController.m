//
//  WashAndFoldPreferencesViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 11/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "WashAndFoldPreferencesViewController.h"
#import "DropdownTableViewCell.h"
#import "RequestManager.h"

@interface WashAndFoldPreferencesViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UIGestureRecognizerDelegate> {
    NSInteger tableViewDefaultTopContraintValue;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(weak, nonatomic) IBOutlet UITextView *specialNoteTextView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak, nonatomic) IBOutlet UILabel *specialNotelabel;
@property(weak, nonatomic) IBOutlet UIView *specialTextViewBackgroundBoarderView;
@property(strong, nonatomic) UIButton *saveButton;

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property(strong, nonatomic) NSMutableArray *allEntries;
@property(strong, nonatomic) NSMutableArray *allOptions;
@property(strong, nonatomic) NSMutableArray *singleOption;
@property(strong, nonatomic) NSMutableArray *selectedOptionsIDs;
@property(assign, nonatomic) NSInteger selectedOptionIndex;

@end

@implementation WashAndFoldPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initialSetup];
    [self getWashAndFoldPrefs];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Wash and Fold" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
    
    self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 50, 34)];
    [self.saveButton  setTitleColor:[UIColor colorWithRed:51/255.0f green:171/255.0f blue:73/255.0f alpha:1.0] forState:UIControlStateSelected];
    [self.saveButton  setTitleColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self.saveButton  setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton  addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    self.specialNoteTextView.delegate = self;
    self.specialNoteTextView.layer.cornerRadius = 5;
    tableViewDefaultTopContraintValue = self.tableViewTopConstraint.constant;
    
    self.pickerView.hidden = YES;
    self.specialNotelabel.hidden = YES;
    self.specialNoteTextView.hidden = YES;
    self.specialTextViewBackgroundBoarderView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.scrollView addGestureRecognizer:tapGesture];
    
    UINib *nib = [UINib nibWithNibName:@"DropdownTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"DropdownTableViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)getWashAndFoldPrefs {
    [[RequestManager alloc] getWashAndFoldPreferences:^(BOOL success, id response) {
        self.allEntries = [NSMutableArray array];
        self.allOptions = [NSMutableArray array];
        self.selectedOptionsIDs = [NSMutableArray array];
        
        if (success) {
            self.pickerView.hidden = NO;
            self.specialNotelabel.hidden = NO;
            self.specialNoteTextView.hidden = NO;
            self.specialTextViewBackgroundBoarderView.hidden = NO;
            
            [self parseGetResponse:response];
        } else {
            [self showToastWithText:response on:Top];
        }
    }];
}

- (void)parseGetResponse:(id)response {
    if ([response hasValueForKey:@"special_note"]) {
        self.specialNoteTextView.text = [response valueForKey:@"special_note"];
    }
    if ([response hasValueForKey:@"wash_dry_and_fold_preferences"]) {
        self.allEntries = [response valueForKey:@"wash_dry_and_fold_preferences"];
        
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

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height - keyboardBounds.size.height);
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableViewTopConstraint.constant = tableViewDefaultTopContraintValue;
    
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.view.frame.size.height - 64); // - 64 for navigationbar height
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Over ridden methods

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonTapped:(UIButton *)saveButton {
    if (saveButton.selected == YES) {
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.selectedOptionsIDs[0], @"washer_temperature_dark_id", self.selectedOptionsIDs[1], @"washer_temperature_light_id", self.selectedOptionsIDs[2], @"washer_temperature_white_id", self.selectedOptionsIDs[3], @"dryer_temperature_id", nil];
        if (self.specialNoteTextView.text.length > 0){
            dataDict[@"special_instruction_wdf"] = self.specialNoteTextView.text;
        }
        [self.activityIndicator startAnimating];
        [[RequestManager alloc] postWashAndFoldPreferencesWithDataDictionary:dataDict withCompletionBlock:^(BOOL success, id response) {
            [self.activityIndicator stopAnimating];
            if (success) {
                saveButton.selected = NO;
            } else {
                [self showToastWithText:response on:Top];
            }
        }];
    }
}

#pragma mark - TableView methods -

#pragma mark Datasourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropdownTableViewCell *dropdownTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"DropdownTableViewCell"];
    dropdownTableViewCell.name.text = [self.allEntries[indexPath.row] valueForKey:@"name"];
//    dropdownTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return dropdownTableViewCell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self refreshPickerViewForCellIndex:indexPath.row];
}

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
        [tView setFont:[UIFont fontWithName:@"roboto-regular" size:13.0]];
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
    
    [self.view endEditing:YES];
}

#pragma mark - TextView delegate methods -

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write your text here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write your text here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.saveButton.selected = YES;
    return YES;
}

@end