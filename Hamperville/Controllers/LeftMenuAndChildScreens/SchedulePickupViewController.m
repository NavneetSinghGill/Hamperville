//
//  SchedulePickupViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SchedulePickupViewController.h"
#import "RequestManager.h"

typedef enum {
    Pickup = 0,
    DropOff
}Task;

@interface SchedulePickupViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(weak, nonatomic) IBOutlet UIButton *pickupLeftArrowButton;
@property(weak, nonatomic) IBOutlet UIButton *pickupRightArrowButton;
@property(weak, nonatomic) IBOutlet UIButton *pickupUpArrowButton;
@property(weak, nonatomic) IBOutlet UIButton *pickupDownArrowButton;
@property(weak, nonatomic) IBOutlet UIPickerView *pickupPickerView;
@property(weak, nonatomic) IBOutlet UILabel *pickupDateLabel;
@property(weak, nonatomic) IBOutlet UILabel *pickupDayLabel;
@property(weak, nonatomic) IBOutlet UILabel *pickupMonthLabel;

@property(weak, nonatomic) IBOutlet UIButton *dropOffLeftArrowButton;
@property(weak, nonatomic) IBOutlet UIButton *dropOffRightArrowButton;
@property(weak, nonatomic) IBOutlet UIButton *dropOffUpArrowButton;
@property(weak, nonatomic) IBOutlet UIButton *dropOffDownArrowButton;
@property(weak, nonatomic) IBOutlet UIPickerView *dropOffPickerView;
@property(weak, nonatomic) IBOutlet UILabel *dropOffDateLabel;
@property(weak, nonatomic) IBOutlet UILabel *dropOffDayLabel;
@property(weak, nonatomic) IBOutlet UILabel *dropOffMonthLabel;

@property(weak, nonatomic) IBOutlet UIButton *washAndFoldServiceButton;
@property(weak, nonatomic) IBOutlet UIButton *washAndPressServiceButton;
@property(weak, nonatomic) IBOutlet UIButton *dryCleanServiceButton;

@property(weak, nonatomic) IBOutlet UIView *couponView;
@property(weak, nonatomic) IBOutlet UITextField *couponTextField;

@property(weak, nonatomic) IBOutlet UIButton *requestPickupButton;



@property(strong, nonatomic) NSMutableDictionary *pickupDaysWithSlots;
@property(strong, nonatomic) NSMutableArray *pickupDays;
//@property(assign, nonatomic) NSInteger pickupLoopCount;
@property(assign, nonatomic) NSInteger pickupDayCount;
@property(strong, nonatomic) NSMutableArray *pickupSlots;

@property(strong, nonatomic) NSMutableDictionary *dropOffDaysWithSlots;
@property(strong, nonatomic) NSMutableArray *dropOffDays;
//@property(assign, nonatomic) NSInteger dropOffLoopCount;
@property(assign, nonatomic) NSInteger dropOffDayCount;
@property(strong, nonatomic) NSMutableArray *dropOffSlots;

@property(strong, nonatomic) NSDate *currentPickupDate;
@property(strong, nonatomic) NSDate *currentDropOffDate;

@property(assign, nonatomic) NSInteger difference;

@property(strong, nonatomic) NSMutableArray *services;
@property(strong, nonatomic) NSMutableArray *universalCoupons;

@property(assign, nonatomic) NSTimeInterval weekInSeconds;
@property(assign, nonatomic) NSTimeInterval dayInSeconds;

@end

@implementation SchedulePickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarButtonTitle:@"Request Pickup" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self initialSetup];
    [self schedulePickupAPIcall];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - PRIVATE METHODS -

- (void)schedulePickupAPIcall {
    [[RequestManager alloc] getSchedulePickup:^(BOOL success, id response) {
        if (success) {
            self.dropOffDaysWithSlots = [response valueForKey:@"drop_off_slots"];
            self.dropOffDays = [[self.dropOffDaysWithSlots allKeys] mutableCopy];
            
            self.pickupDaysWithSlots = [response valueForKey:@"pick_up_slots"];
            self.pickupDays = [[self.pickupDaysWithSlots allKeys] mutableCopy];
            
            self.services = [response valueForKey:@"services"];
            self.universalCoupons = [response valueForKey:@"universal_coupons"];
            
            // Setup for first pickup date
            self.pickupLeftArrowButton.hidden = YES;
            self.dropOffLeftArrowButton.hidden = YES;
            self.pickupDayCount = 1;
            self.dropOffDayCount = 1;
            self.difference = 1;
            [self setupPickupEntriesForDayCount:self.pickupDayCount];
        }
    }];
}

- (void)initialSetup {
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    self.requestPickupButton.layer.cornerRadius = 4;
    
    self.couponView.layer.cornerRadius = 4;
    self.couponView.layer.borderWidth = 1;
    self.couponView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor;
    
    self.pickupPickerView.delegate = self;
    self.pickupPickerView.dataSource = self;
    self.dropOffPickerView.delegate = self;
    self.dropOffPickerView.dataSource = self;
    
    self.weekInSeconds = (double)(60*60*24*7);
    self.dayInSeconds = (double)(60*60*24);
}

#pragma mark Initial Setup method

- (void)setupPickupEntriesForDayCount:(NSInteger)dayCount {
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    NSString *dayName = [[dateFormatter stringFromDate:currentDate] lowercaseString];
    
    //Calculation for Pickup-----------------------------
    NSDate *nextDate = [self refreshPickupEntriesWithDayName:dayName andDayCount:dayCount];
    
    //Calculation for DropOff-----------------------------
    [self refreshDropOffEntriesWithNextDate:nextDate andDayCount:self.dropOffDayCount];
}

#pragma mark Refresh Variables for any task

- (NSDate *)refreshPickupEntriesWithDayName:(NSString *)dayName andDayCount:(NSInteger)dayCount{
    //Arrange pickupdays according to present day
    [self rearrangeTaskDaysForDay:dayName withTask:Pickup];
    
    //DayCount indicates the number of day
    NSDate *nextDate = [self getTaskDateWithDayCount:dayCount - 1 withTask:Pickup];
    [self setPickupEntriesForDate:nextDate];
    self.currentPickupDate = nextDate;
    return nextDate;
}

- (NSDate *)refreshDropOffEntriesWithNextDate:(NSDate *)nextDate andDayCount:(NSInteger)dayCount{
    //Calculation for dropOff----------------------------
    
    //    nextDate = [nextDate dateByAddingTimeInterval:_difference * _dayInSeconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    NSString *dayName = [[dateFormatter stringFromDate:nextDate] lowercaseString];
    //Arrange pickupdays according to present day
    [self rearrangeTaskDaysForDay:dayName withTask:DropOff];
    
    //DayCount indicates the number of day
    nextDate = [self getTaskDateWithDayCount:dayCount withTask:DropOff];
    [self setDropOffEntriesForDate:nextDate];
    self.currentDropOffDate = nextDate;
    return nextDate;
}

#pragma mark Common method

- (void)rearrangeTaskDaysForDay:(NSString *)day withTask:(Task)task {
    NSMutableArray *newPickupDays = [NSMutableArray array];
    day = [day lowercaseString];
    NSMutableArray *taskDays = nil;
    if (task == Pickup) {
        taskDays = self.pickupDays;
    } else {
        taskDays = self.dropOffDays;
    }
    if (taskDays.count != 0) {
        NSMutableArray *normalDays = [NSMutableArray arrayWithObjects:@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", nil];
        for (;;) {
            if (![normalDays[0] isEqualToString:day]) {
                NSString *object = normalDays[0];
                [normalDays removeObject:normalDays[0]];
                [normalDays addObject:object];
            } else {
                break;
            }
        }
        for (NSString *dayParse in normalDays) {
            for (NSString *pickupDay in taskDays) {
                if ([[pickupDay lowercaseString] isEqualToString:[dayParse lowercaseString]]) {
                    [newPickupDays addObject:pickupDay];
                    break;
                }
            }
        }
        if (task == Pickup) {
            self.pickupDays = newPickupDays;
        } else {
            self.dropOffDays = newPickupDays;
        }
    }
}

- (NSString *)shortDay:(NSString *)dayName {
    return [[dayName substringToIndex:3] uppercaseString];
}

- (NSDate *)getTaskDateWithDayCount:(NSInteger)dayCount withTask:(Task)task {
    NSMutableArray *taskDays = nil;
    if (task == Pickup) {
        taskDays = self.pickupDays;
    } else {
        taskDays = self.dropOffDays;
    }
    NSInteger loop = dayCount / taskDays.count;
    dayCount = dayCount % taskDays.count;
    
    NSString *pickupDay = taskDays[dayCount];

    
    NSDate *currentDate = nil;
    if (task == Pickup) {
        currentDate = [NSDate date];
    } else {
        currentDate = self.currentPickupDate;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    NSString *todaysDay = [[dateFormatter stringFromDate:currentDate] lowercaseString];
    
    NSMutableArray *normalDays = [NSMutableArray arrayWithObjects:@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", nil];
    
    //Just to set the array's first element to todays day
    for (;;) {
        if (![normalDays[0] isEqualToString:todaysDay]) {
            NSString *object = normalDays[0];
            [normalDays removeObject:normalDays[0]];
            [normalDays addObject:object];
        } else {
            break;
        }
    }
    
    NSInteger dayCountToAdd = 0;
    //Now calculate day count
    for (;;) {
        if (![normalDays[0] isEqualToString:pickupDay]) {
            NSString *object = normalDays[0];
            [normalDays removeObject:normalDays[0]];
            [normalDays addObject:object];
            dayCountToAdd++;
        } else {
            break;
        }
    }
    [self setPickupTimeSlotsForDay:pickupDay withTask:task];
    NSTimeInterval totalDaysToAdd = (((double)dayCountToAdd * (double)self.dayInSeconds) + ((double)loop * (double)self.weekInSeconds));
    NSDate *nextDate = [currentDate dateByAddingTimeInterval:totalDaysToAdd];
    return nextDate;
}

#pragma mark UI update for a Date (Both task)

- (void)setPickupEntriesForDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    self.pickupDayLabel.text = [self shortDay:[dateFormatter stringFromDate:date]];
    dateFormatter.dateFormat = @"dd";
    self.pickupDateLabel.text = [dateFormatter stringFromDate:date];
    dateFormatter.dateFormat = @"MMM";
    self.pickupMonthLabel.text = [[dateFormatter stringFromDate:date] uppercaseString];
}

- (void)setDropOffEntriesForDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    self.dropOffDayLabel.text = [self shortDay:[dateFormatter stringFromDate:date]];
    dateFormatter.dateFormat = @"dd";
    self.dropOffDateLabel.text = [dateFormatter stringFromDate:date];
    dateFormatter.dateFormat = @"MMM";
    self.dropOffMonthLabel.text = [[dateFormatter stringFromDate:date] uppercaseString];
}

- (void)setPickupTimeSlotsForDay:(NSString *)day withTask:(Task)task {
    if (task == Pickup) {
        self.pickupSlots = [self.pickupDaysWithSlots objectForKey:day];
        [self.pickupPickerView reloadAllComponents];
    } else {
        self.dropOffSlots = [self.dropOffDaysWithSlots objectForKey:day];
        [self.dropOffPickerView reloadAllComponents];
    }
}

#pragma mark - IBAction methods -

- (IBAction)pickUpLeftArrowButtonTapped:(id)sender {
    NSInteger count = self.pickupDayCount - 1;
    if (count >= 1) {
        [self setupPickupEntriesForDayCount:count];
        if (count == 1) {
            self.pickupLeftArrowButton.hidden = YES;
        }
        self.pickupRightArrowButton.hidden = NO;
        self.pickupDayCount--;
        self.dropOffLeftArrowButton.hidden = YES;
        self.dropOffRightArrowButton.hidden = NO;
        self.dropOffDayCount = 1;
        [self refreshDropOffEntriesWithNextDate:self.currentPickupDate andDayCount:self.dropOffDayCount];
    }
}

- (IBAction)pickUpRightArrowButtonTapped:(id)sender {
    NSInteger count = self.pickupDayCount + 1;
    if (count <= 10) {
        [self setupPickupEntriesForDayCount:count];
        if (count == 10) {
            self.pickupRightArrowButton.hidden = YES;
        }
        self.pickupLeftArrowButton.hidden = NO;
        self.pickupDayCount++;
        self.dropOffLeftArrowButton.hidden = YES;
        self.dropOffRightArrowButton.hidden = NO;
        self.dropOffDayCount = 1;
        [self refreshDropOffEntriesWithNextDate:self.currentPickupDate andDayCount:self.dropOffDayCount];
    }
}

- (IBAction)pickUpUpArrowButtonTapped:(id)sender {
    NSInteger index = [self.pickupPickerView selectedRowInComponent:0];
    if (index > 0) {
        [self.pickupPickerView selectRow:index - 1 inComponent:0 animated:YES];
    }
}

- (IBAction)pickUpDownArrowButtonTapped:(id)sender {
    NSInteger index = [self.pickupPickerView selectedRowInComponent:0];
    if (index < self.pickupSlots.count - 1) {
        [self.pickupPickerView selectRow:index + 1 inComponent:0 animated:YES];
    }
}

- (IBAction)dropOffLeftArrowButtonTapped:(id)sender {
    NSInteger count = self.dropOffDayCount - 1;
    if (count >= 1) {
        [self refreshDropOffEntriesWithNextDate:self.currentPickupDate andDayCount:count];
        if (count == 1) {
            self.dropOffLeftArrowButton.hidden = YES;
        }
        self.dropOffRightArrowButton.hidden = NO;
        self.dropOffDayCount--;
    }
}

- (IBAction)dropOffRightArrowButtonTapped:(id)sender {
    NSInteger count = self.dropOffDayCount + 1;
    if (count <= 10) {
//        [self setupPickupEntriesForDayCount:count];
        [self refreshDropOffEntriesWithNextDate:self.currentPickupDate andDayCount:count];
        if (count == 10) {
            self.dropOffRightArrowButton.hidden = YES;
        }
        self.dropOffLeftArrowButton.hidden = NO;
        self.dropOffDayCount++;
    }
}

- (IBAction)dropOffUpArrowButtonTapped:(id)sender {
    NSInteger index = [self.dropOffPickerView selectedRowInComponent:0];
    if (index > 0) {
        [self.dropOffPickerView selectRow:index - 1 inComponent:0 animated:YES];
    }
}

- (IBAction)dropOffDownArrowButtonTapped:(id)sender {
    NSInteger index = [self.dropOffPickerView selectedRowInComponent:0];
    if (index < self.dropOffSlots.count - 1) {
        [self.dropOffPickerView selectRow:index + 1 inComponent:0 animated:YES];
    }
}

- (IBAction)requestPickupButtonTapped:(id)sender {
    
}

#pragma mark - PickerView Delegate and Datasource methods -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.pickupPickerView) {
        return self.pickupSlots.count;
    } else {
        return self.dropOffSlots.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.pickupPickerView) {
        NSDictionary *singleTimeSlot = self.pickupSlots[row];
        return [singleTimeSlot valueForKey:@"time_slot"];
    } else {
        NSDictionary *singleTimeSlot = self.dropOffSlots[row];
        return [singleTimeSlot valueForKey:@"time_slot"];
    }
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
    if (pickerView == self.pickupPickerView) {
        NSDictionary *singleTimeSlot = self.pickupSlots[row];
        tView.text = [singleTimeSlot valueForKey:@"time_slot"];
    } else {
        NSDictionary *singleTimeSlot = self.dropOffSlots[row];
        tView.text = [singleTimeSlot valueForKey:@"time_slot"];
    }
    return tView;
}

@end
