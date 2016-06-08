//
//  SchedulePickupViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

/*********
 
 Wheneven we will do pickup or dropoff calculation, then we
 will pass DayCount - 1. This is for removing the confusing
 whether dayCount = 0 is the first day or DayCount = 1.
 Though DayCount = 1 is the first day but in calculations
 daycount - 1 is the first day, keeping in mind the first index
 of array which is 0.
 
 **********/

#import "SchedulePickupViewController.h"
#import "RequestManager.h"
#import "ServicesCollectionViewCell.h"
#import "CouponTableViewCell.h"
#import "ServiceInfo.h"
#import "Order.h"

typedef enum {
    Pickup = 0,
    DropOff
}Task;

@interface SchedulePickupViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CouponTableViewCellDelegate> {
    NSInteger kCouponTableViewDefaultHeight;
    BOOL reloadCollectionViewToDefault;
    BOOL wasModifiedAtLeastOnce;
}

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

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

@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(weak, nonatomic) IBOutlet UITableView *couponTableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *couponTableViewHeight;

@property(weak, nonatomic) IBOutlet UIButton *requestPickupButton;

@property(strong, nonatomic) NSMutableDictionary *pickupDaysWithSlots;
@property(strong, nonatomic) NSMutableArray *pickupDays;
@property(assign, nonatomic) NSInteger pickupDayCount;
@property(strong, nonatomic) NSMutableArray *pickupSlots;

@property(strong, nonatomic) NSMutableDictionary *dropOffDaysWithSlots;
@property(strong, nonatomic) NSMutableArray *dropOffDays;
@property(assign, nonatomic) NSInteger dropOffDayCount;
@property(strong, nonatomic) NSMutableArray *dropOffSlots;

@property(strong, nonatomic) NSDate *currentPickupDate;
@property(strong, nonatomic) NSDate *currentDropOffDate;

@property(assign, nonatomic) NSInteger difference;

@property(strong, nonatomic) NSMutableArray *services;
@property(strong, nonatomic) NSMutableArray *universalCoupons;

@property(assign, nonatomic) NSTimeInterval weekInSeconds;
@property(assign, nonatomic) NSTimeInterval dayInSeconds;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(strong, nonatomic) NSMutableArray<ServiceInfo *> *selectedServiceIDs;
@property(strong, nonatomic) NSMutableArray *appliedCouponsServiceIDs;
@property(strong, nonatomic) NSMutableArray *appliedCouponsIDAndName;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightContraint;

@property(assign, nonatomic) BOOL isUniversalCouponApplied;

@end

@implementation SchedulePickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.isModifyModeOn) {
        [self setNavigationBarButtonTitle:@"Request Pickup" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    } else {
        [self setNavigationBarButtonTitle:@"Modify Order" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
        [self.requestPickupButton setTitle:@"Modify Order" forState:UIControlStateNormal];
    }
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.scrollView.hidden == NO || [ApplicationDelegate hasNetworkAvailable] == YES) {
        [self schedulePickupAPIcall];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [super networkAvailability];
}

- (void)networkAvailability {
    [super networkAvailability];
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [self schedulePickupAPIcall];
    }
}

#pragma mark - Over ridden methods

- (void)showOrHideLeftMenu {
    [super showOrHideLeftMenu];
    [self.view endEditing:YES];
}

#pragma mark - PRIVATE METHODS -

- (void)schedulePickupAPIcall {
    self.scrollView.hidden = YES;
    [self.activityIndicator startAnimating];
    [[RequestManager alloc] getSchedulePickup:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            self.scrollView.hidden = NO;
            self.dropOffDaysWithSlots = [response valueForKey:@"drop_off_slots"];
            self.dropOffDays = [[self.dropOffDaysWithSlots allKeys] mutableCopy];
            
            self.pickupDaysWithSlots = [response valueForKey:@"pick_up_slots"];
            self.pickupDays = [[self.pickupDaysWithSlots allKeys] mutableCopy];
            
            self.services = [response valueForKey:@"services"];
            self.universalCoupons = [response valueForKey:@"universal_coupons"];
            
            [self.collectionView reloadData];
            [self.couponTableView reloadData];
            
            // Setup for first pickup date
            self.pickupLeftArrowButton.hidden = YES;
            self.dropOffLeftArrowButton.hidden = YES;
            self.pickupDayCount = 1;
            self.dropOffDayCount = 1;
            self.difference = 1;
            [self setupEntriesForDayCount:self.pickupDayCount andStartDate:[NSDate date]];
            
            if (self.isModifyModeOn) {
                [self setupScreenForOrder:self.orderToModify];
            }
        } else if ([response isKindOfClass:[NSString class]] && [response isEqualToString:kNoNetworkAvailable]) {
            [self networkAvailability];
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

- (void)initialSetup {
    if (!self.isModifyModeOn) {
        [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    } else {
        [self setLeftMenuButtons:[NSArray arrayWithObjects:self.backButton, nil]];
    }
    self.requestPickupButton.layer.cornerRadius = 4;
    
    self.pickupPickerView.delegate = self;
    self.pickupPickerView.dataSource = self;
    self.dropOffPickerView.delegate = self;
    self.dropOffPickerView.dataSource = self;

    self.selectedServiceIDs = [NSMutableArray array];
    self.appliedCouponsIDAndName = [NSMutableArray array];
    self.appliedCouponsServiceIDs = [NSMutableArray array];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.scrollView addGestureRecognizer:tapGesture];
    
    self.weekInSeconds = (double)(60*60*24*7);
    self.dayInSeconds = (double)(60*60*24);
    
    UINib *collectionViewNib = [UINib nibWithNibName:@"ServicesCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:collectionViewNib forCellWithReuseIdentifier:@"ServicesCollectionViewCell"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UINib *couponTableViewNib = [UINib nibWithNibName:kCouponTableViewCellNibName bundle:nil];
    [self.couponTableView registerNib:couponTableViewNib forCellReuseIdentifier:kCouponTableViewCellIdentifier];
    
    self.couponTableView.delegate = self;
    self.couponTableView.dataSource = self;
    self.appliedCouponsIDAndName = [NSMutableArray array];
    self.appliedCouponsServiceIDs = [NSMutableArray array];
    kCouponTableViewDefaultHeight = self.couponTableView.frame.size.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)backButtonTapped {
    if (!wasModifiedAtLeastOnce) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)isCouponPresentInUniversalCouponsOfName:(NSString *)couponName {
    for (NSDictionary *coupon in self.universalCoupons) {
        if ([[coupon valueForKey:@"name"] isEqualToString:couponName]) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)isCouponPresentInOtherCouponsOfName:(NSString *)couponName {
    //returns serviceID and couponID in dictionary
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    NSArray *coupons = nil;
    for (NSDictionary *service in self.services) {
        coupons = [service valueForKey:@"coupons"];
        for (NSDictionary *coupon in coupons) {
            if ([[coupon valueForKey:@"name"] isEqualToString:couponName]) {
                [dataDict setValue:[NSString stringWithFormat:@"%ld",[[coupon valueForKey:@"id"] integerValue]] forKey:@"couponID"];
                [dataDict setValue:[NSString stringWithFormat:@"%ld",[[service valueForKey:@"id"] integerValue]] forKey:@"serviceID"];
                return dataDict;
            }
        }
    }
    return nil;
}

- (void)resizeTableViewWithAnimation {
    self.tableViewHeightContraint.constant = kCouponTableViewDefaultHeight * (self.appliedCouponsIDAndName.count + !_isUniversalCouponApplied);
    if (self.isModifyModeOn) {
        self.tableViewHeightContraint.constant = 0;
    }
    [self.couponTableView reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark For Modify Order

- (void)setupScreenForOrder:(Order *)order {//Delay is solving an issue of unselected first cell when screen opens
//    double delayInSeconds = 0.005;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        dispatch_async(dispatch_get_main_queue(), ^{
            [Order printOrder:order];
            //For pickup----
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *pickupDate = [NSDate dateWithTimeIntervalSince1970:[order.pickupDate integerValue]];//[dateFormatter dateFromString:order.pickupDate];
            NSString *pickupDateString = [dateFormatter stringFromDate:pickupDate];
            pickupDate = [dateFormatter dateFromString:pickupDateString];
            NSLog(@"PickupDate %@",pickupDate);
            
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"EEEE";
            NSString *dayName = [[dateFormatter stringFromDate:[NSDate date]] lowercaseString];
            
            //Calculation for Pickup-----------------------------
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSInteger dayCount = 1;
            NSDate *resultantDate;
            for (;;) {
                NSDate *nextDate = [self refreshPickupEntriesWithDayName:dayName andDayCount:dayCount];
                nextDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:nextDate]];
                NSLog(@"\nNextDate: %@\nPickupDate: %@\nEquals: %hhd\n",nextDate, pickupDate, [nextDate isEqualToDate:pickupDate]);
                if ([nextDate compare:pickupDate] == NSOrderedAscending) {
                    NSLog(@"UP");
                    dayCount++;
                    continue;
                } else if ([nextDate compare:pickupDate] == NSOrderedSame) {
                    NSLog(@"MIDDLE");
                    [self setupEntriesForDayCount:1 andStartDate:[NSDate date]];
                    for (NSInteger numberOfTap = 1; numberOfTap < dayCount; numberOfTap++) {
                        [self pickUpRightArrowButtonTapped:self.pickupLeftArrowButton];
                        resultantDate = self.currentPickupDate;
                    }
                    if (resultantDate == nil) {
                        resultantDate = [NSDate date];
                    }
                    break;
                } else {
                    NSLog(@"BOTTOM");
                    //This will arise when pickup date is smaller than first calculated date which should be impossible
                    resultantDate = self.currentPickupDate;
                    [self setupEntriesForDayCount:1 andStartDate:resultantDate];
                    break;
                }
            }
            
            //Select services-----
            
            self.selectedServiceIDs = [NSMutableArray array];
            for (NSInteger serviceCount = 0;serviceCount < self.services.count; serviceCount++) {
                for (NSInteger serviceDetailCount = 0;serviceDetailCount < order.serviceDetail.count; serviceDetailCount++) {
                    //                NSLog(@"Service ID: %@",[self.services[serviceCount] valueForKey:@"id"]);
                    if ([[self.services[serviceCount] valueForKey:@"id"] integerValue] == [[order.serviceDetail[serviceDetailCount] valueForKey:@"id"] integerValue]) {
                        ServiceInfo *serviceInfo = [ServiceInfo new];
                        serviceInfo.serviceID = [self.services[serviceCount] valueForKey:@"id"];
                        serviceInfo.difference = [[self.services[serviceCount] valueForKey:@"day_difference"] integerValue];
                        [self.selectedServiceIDs addObject:serviceInfo];
                    }
                }
            }
            [self.collectionView reloadData];
            
            //For dropoff----
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            NSDate *dropOffDate = [dateFormatter dateFromString:order.deliveryDate];
            
            NSDate *dropOffDate = [NSDate dateWithTimeIntervalSince1970:[order.deliveryDate integerValue]];//[dateFormatter dateFromString:order.pickupDate];
            NSString *dropOffString = [dateFormatter stringFromDate:dropOffDate];
            dropOffDate = [dateFormatter dateFromString:dropOffString];
            
            NSLog(@"%@",dropOffDate);
            
            dayCount = 1;
            for (;;) {
                //        NSDate *nextDate = [self refreshPickupEntriesWithDayName:dayName andDayCount:dayCount];
                NSDate *nextDate = [self refreshDropOffEntriesWithNextDate:resultantDate andDayCount:dayCount];
                nextDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:nextDate]];
                dropOffDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:dropOffDate]];
                if ([nextDate compare:dropOffDate] == NSOrderedAscending) {
                    dayCount++;
                    continue;
                } else if ([nextDate compare:dropOffDate] == NSOrderedSame) {
                    [self refreshDropOffEntriesWithNextDate:resultantDate andDayCount:1];
                    for (NSInteger numberOfTap = 1; numberOfTap < dayCount; numberOfTap++) {
                        [self dropOffRightArrowButtonTapped:self.dropOffRightArrowButton];
                    }
                    break;
                } else {
                    resultantDate = self.currentPickupDate;
                    [self setupEntriesForDayCount:1 andStartDate:resultantDate];
                    break;
                }
            }
            
            //For pickup timeslot
            for (NSInteger index = 0; index < self.pickupSlots.count; index++) {
                if ([[self.pickupSlots[index] valueForKey:@"time_slot"] isEqualToString:order.pickupTimeSlot]) {
                    [self.pickupPickerView selectRow:index inComponent:0 animated:NO];
                    break;
                }
            }
            
            //For dropoff timeslot
            for (NSInteger index = 0; index < self.dropOffSlots.count; index++) {
                if ([[self.dropOffSlots[index] valueForKey:@"time_slot"] isEqualToString:order.deliveryTimeSlot]) {
                    [self.dropOffPickerView selectRow:index inComponent:0 animated:NO];
                    break;
                }
            }
            [self resizeTableViewWithAnimation];
//        });  
//    });
}

#pragma mark Initial Setup method

- (void)setupEntriesForDayCount:(NSInteger)dayCount andStartDate:(NSDate *)startDate {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    NSString *dayName = [[dateFormatter stringFromDate:startDate] lowercaseString];
    
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
    
    nextDate = [nextDate dateByAddingTimeInterval:(self.difference) * self.dayInSeconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    NSString *dayName = [[dateFormatter stringFromDate:nextDate] lowercaseString];
    //Arrange pickupdays according to present day
    [self rearrangeTaskDaysForDay:dayName withTask:DropOff];
    
    //DayCount indicates the number of day
    nextDate = [self getTaskDateWithDayCount:dayCount - 1 withTask:DropOff];
    [self setDropOffEntriesForDate:nextDate];
    self.currentDropOffDate = nextDate;
    return nextDate;
}

#pragma mark Common method

- (void)rearrangeTaskDaysForDay:(NSString *)day withTask:(Task)task {
    NSMutableArray *newTaskDays = [NSMutableArray array];
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
                    [newTaskDays addObject:pickupDay];
                    break;
                }
            }
        }
        if (task == Pickup) {
            self.pickupDays = newTaskDays;
        } else {
            self.dropOffDays = newTaskDays;
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
    
    NSString *taskDay = taskDays[dayCount];

    
    NSDate *currentDate = nil;
    if (task == Pickup) {
        currentDate = [NSDate date];
    } else {
        currentDate = self.currentPickupDate;
        currentDate = [currentDate dateByAddingTimeInterval:(self.difference) * self.dayInSeconds];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    NSString *todaysDay = [[dateFormatter stringFromDate:currentDate] lowercaseString];
    
    NSMutableArray *normalDays = [NSMutableArray arrayWithObjects:@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", nil];
    
    //Just to set the array's first element to todays day
    for (;;) {
        if (![normalDays[0] isEqualToString:[todaysDay lowercaseString]]) {
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
        if (![normalDays[0] isEqualToString:[taskDay lowercaseString]]) {
            NSString *object = normalDays[0];
            [normalDays removeObject:normalDays[0]];
            [normalDays addObject:object];
            dayCountToAdd++;
        } else {
            break;
        }
    }
    [self setTaskTimeSlotsForDay:taskDay withTask:task];
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

- (void)setTaskTimeSlotsForDay:(NSString *)day withTask:(Task)task {
    if (task == Pickup) {
        self.pickupSlots = [self.pickupDaysWithSlots objectForKey:day];
        [self.pickupPickerView reloadAllComponents];
    } else {
        self.dropOffSlots = [self.dropOffDaysWithSlots objectForKey:day];
        [self.dropOffPickerView reloadAllComponents];
    }
}

#pragma mark Notification methods

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height - keyboardBounds.size.height);
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.view.frame.size.height - 64); // - 64 for navigationbar height
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - IBAction methods -

- (IBAction)pickUpLeftArrowButtonTapped:(id)sender {
    NSInteger count = self.pickupDayCount - 1;
    if (count >= 1) {
        [self setupEntriesForDayCount:count andStartDate:[NSDate date]];
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
        [self setupEntriesForDayCount:count andStartDate:[NSDate date]];
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
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    NSString *commaSeparatedServiceIDs = kEmptyString;
    NSInteger count = 0;
    for (count = 0; count < self.selectedServiceIDs.count; count++) {
        if (count == 0) {
            commaSeparatedServiceIDs = self.selectedServiceIDs[0].serviceID;
            continue;
        }
        commaSeparatedServiceIDs = [NSString stringWithFormat:@"%@,%@",commaSeparatedServiceIDs,self.selectedServiceIDs[count].serviceID];
    }
    if ([commaSeparatedServiceIDs isKindOfClass:[NSString class]] && [commaSeparatedServiceIDs length] == 0) {
        [self showToastWithText:@"Select a service" on:Failure];
        return;
    }
    if ([commaSeparatedServiceIDs isKindOfClass:[NSNumber class]]) {
        commaSeparatedServiceIDs = [NSString stringWithFormat:@"%ld",(long)[commaSeparatedServiceIDs integerValue]];
    }
    [dataDictionary setValue:commaSeparatedServiceIDs forKey:@"service_selected"];
    
    NSInteger selectedIndex = [self.pickupPickerView selectedRowInComponent:0];
    NSDictionary *selectedPickupTimeDictionary = [self.pickupSlots objectAtIndex:selectedIndex];
    //    [dataDictionary setValue:[selectedPickupTimeDictionary valueForKey:@"time_slot"] forKey:@"pick_up_time"];
    [dataDictionary setValue:[NSString stringWithFormat:@"%f",[self.currentPickupDate timeIntervalSince1970]] forKey:@"pick_up_time"];
    [dataDictionary setValue:[selectedPickupTimeDictionary valueForKey:@"id"] forKey:@"pick_up_time_slot_id"];
    
    selectedIndex = [self.dropOffPickerView selectedRowInComponent:0];
    selectedPickupTimeDictionary = [self.dropOffSlots objectAtIndex:selectedIndex];
//    [dataDictionary setValue:[selectedPickupTimeDictionary valueForKey:@"time_slot"] forKey:@"drop_off_time"];
    [dataDictionary setValue:[NSString stringWithFormat:@"%f",[self.currentDropOffDate timeIntervalSince1970]] forKey:@"drop_off_time"];
    [dataDictionary setValue:[selectedPickupTimeDictionary valueForKey:@"id"] forKey:@"drop_off_time_slot_id"];
    
    [dataDictionary setValue:self.appliedCouponsIDAndName forKey:@"coupon_code"];
    
    [self.activityIndicator startAnimating];
    if (!self.isModifyModeOn) {
        [[RequestManager alloc] postRequestPickupWithDataDictionary:dataDictionary withCompletionBlock:^(BOOL success, id response) {
            [[self activityIndicator]stopAnimating];
            if (success) {
                self.pickupLeftArrowButton.hidden = YES;
                self.dropOffLeftArrowButton.hidden = YES;
                self.pickupDayCount = 1;
                self.dropOffDayCount = 1;
                self.difference = 1;
                [self setupEntriesForDayCount:self.pickupDayCount andStartDate:[NSDate date]];
                
                self.isUniversalCouponApplied = NO;
                self.selectedServiceIDs = [NSMutableArray array];
                self.appliedCouponsIDAndName = [NSMutableArray array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    reloadCollectionViewToDefault = YES;
                    [self.collectionView reloadData];
                    [self.couponTableView reloadData];
                    
                    [self resizeTableViewWithAnimation];
                    reloadCollectionViewToDefault = NO;
                });
                [self showToastWithText:@"Order successfully placed." on:Success];
            } else {
                [self showToastWithText:response on:Failure];
            }
        }];
    } else {
        dataDictionary[@"order_id"] = self.orderToModify.orderID;
        [[RequestManager alloc] postModifyOrderWithDataDictionary:dataDictionary withCompletionBlock:^(BOOL success, id response) {
            [self.activityIndicator stopAnimating];
            if (success) {
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:LNChangeShouldRefresh];
                [[NSUserDefaults standardUserDefaults]synchronize];
                wasModifiedAtLeastOnce = YES;
                
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                [self showToastWithText:@"Order modified successfully." on:Success];
            } else {
                [self showToastWithText:response on:Failure];
            }
        }];
    }
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

#pragma mark - Collection View -

#pragma mark Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.services.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ServicesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServicesCollectionViewCell" forIndexPath:indexPath];
    cell.serviceDictionary = [self.services objectAtIndex:indexPath.row];
    if (reloadCollectionViewToDefault == YES) {
        [cell setSelectionState:NO];
    }
    [cell setContent];
    for (ServiceInfo *serviceInfo in self.selectedServiceIDs) {
        if ([cell.serviceID integerValue] == [serviceInfo.serviceID integerValue]) {
            [cell setSelectionState:YES];
            return cell;
        }
    }
    [cell setSelectionState:NO];
    return cell;
}

#pragma mark Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectCellAtIndexPath:indexPath];
}

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath {
    ServicesCollectionViewCell *cell = (ServicesCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    self.difference = cell.difference;
    [cell setSelectionState:!cell.serviceImageButton.selected];
    if (cell.serviceImageButton.selected == YES) {
        [self.selectedServiceIDs addObject:[ServiceInfo getServiceInfoWithServiceID:cell.serviceID isAppliedStatus:NO andDifferenceOfDays:cell.difference]];
    } else {
        ServiceInfo *serviceInfoToDelete = nil;
        for (ServiceInfo *serviceInfo in self.selectedServiceIDs) {
            if ([serviceInfo.serviceID integerValue] == [cell.serviceID integerValue]) {
                serviceInfoToDelete = serviceInfo;
                break;
            }
        }
        [self.selectedServiceIDs removeObject:serviceInfoToDelete];
        NSString *couponName = nil;
        for (NSDictionary *coupon in cell.coupons) {
            for (NSString *appliedCouponName in self.appliedCouponsIDAndName) {
                if ([[coupon valueForKey:@"name"] isEqualToString:appliedCouponName]) {
                    couponName = appliedCouponName;
                    break;
                }
            }
        }
        [self.appliedCouponsIDAndName removeObject:couponName];
        [self.couponTableView reloadData];
    }
    NSInteger maxDifference = 1;
    for (ServiceInfo *serviceInfo in self.selectedServiceIDs) {
        if (maxDifference <= serviceInfo.difference) {
            maxDifference = serviceInfo.difference;
        }
    }
    self.difference = maxDifference;
    self.dropOffLeftArrowButton.hidden = YES;
    self.dropOffDayCount = 1;
    [self refreshDropOffEntriesWithNextDate:self.currentPickupDate andDayCount:1];
    [self resizeTableViewWithAnimation];
}

#pragma mark - Table View -

#pragma mark Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponTableViewCell *couponTableViewCell = [tableView dequeueReusableCellWithIdentifier:kCouponTableViewCellIdentifier];
    couponTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    couponTableViewCell.couponTableViewCellDelegate = self;
    couponTableViewCell.index = indexPath.row;
    
    if (indexPath.row < self.appliedCouponsIDAndName.count) {
        couponTableViewCell.textField.text = self.appliedCouponsIDAndName[indexPath.row];
        couponTableViewCell.verifyButton.selected = YES;
//        couponTableViewCell.verifyButton.alpha = 0.5;
        couponTableViewCell.textField.userInteractionEnabled = NO;
    } else {
        couponTableViewCell.textField.text = kEmptyString;
        couponTableViewCell.verifyButton.selected = NO;
//        couponTableViewCell.verifyButton.alpha = 1;
        couponTableViewCell.textField.userInteractionEnabled = YES;
    }
    
    return couponTableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appliedCouponsIDAndName.count + !_isUniversalCouponApplied;
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCouponTableViewDefaultHeight;
}

#pragma mark - Gesture delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.collectionView]) {
        [super closeLeftMenuIfOpen];
        return NO;
    } else if ([touch.view isDescendantOfView:self.scrollView]) {
        FrontViewPosition frontViewPosition = [self.revealViewController frontViewPosition];
        if (frontViewPosition != FrontViewPositionLeft) {
            [super closeLeftMenuIfOpen];
            return YES;
        }
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
}

#pragma mark - Custom delegate methods -

- (void)verifyTapped:(CouponTableViewCell *)couponCell {
    [self.view endEditing:YES];
    if (couponCell.verifyButton.selected == NO) {
        
        if (self.appliedCouponsIDAndName.count == 0) {
            if ([self isCouponPresentInUniversalCouponsOfName:couponCell.textField.text]) {
                //Coupon is universal coupon
                _isUniversalCouponApplied = YES;
                [self.appliedCouponsIDAndName addObject:couponCell.textField.text];
                [self.couponTableView reloadData];
            }
            else {
                NSDictionary *serviceAndCouponIDs = [self isCouponPresentInOtherCouponsOfName:couponCell.textField.text];
                NSString *fetchedServiceID = [serviceAndCouponIDs valueForKey:@"serviceID"];
//                NSString *fetchedCouponID = [serviceAndCouponIDs valueForKey:@"couponID"];
                
                if (serviceAndCouponIDs != nil) {
                    //Coupon is a valid coupon
                    BOOL isServiceSelected = NO;
                    ServiceInfo *serviceInfoToChangeStatusOf = nil;
                    for (ServiceInfo *serviceInfo in self.selectedServiceIDs) {
                        if ([serviceInfo.serviceID isEqualToString:fetchedServiceID]) {
                            isServiceSelected = YES;
                            serviceInfoToChangeStatusOf = serviceInfo;
                        }
                    }
                    if (isServiceSelected) {
                        [self.appliedCouponsIDAndName addObject:couponCell.textField.text];
                        serviceInfoToChangeStatusOf.isApplied = YES;
                        [self.couponTableView reloadData];
                    } else {
                        [self showToastWithText:@"Invalid coupon" on:Failure];
                    }
                } else {
                    [self showToastWithText:@"Invalid coupon" on:Failure];
                }
            }
        } else {
            if ([self isCouponPresentInUniversalCouponsOfName:couponCell.textField.text]) {
                //Coupon is universal coupon
                _isUniversalCouponApplied = YES;
                [self showToastWithText:@"Can't apply Universal coupon" on:Failure];
            } else {
                NSDictionary *serviceAndCouponIDs = [self isCouponPresentInOtherCouponsOfName:couponCell.textField.text];
                NSString *fetchedServiceID = [serviceAndCouponIDs valueForKey:@"serviceID"];
//                NSString *fetchedCouponID = [serviceAndCouponIDs valueForKey:@"couponID"];
                
                if (serviceAndCouponIDs != nil) {
                    //Coupon is a valid coupon
                    BOOL isServiceSelected = NO;
                    ServiceInfo *serviceInfoToChangeStatusOf = nil;
                    for (ServiceInfo *serviceInfo in self.selectedServiceIDs) {
                        if ([serviceInfo.serviceID isEqualToString:fetchedServiceID] && serviceInfo.isApplied == NO) {
                            isServiceSelected = YES;
                            serviceInfoToChangeStatusOf = serviceInfo;
                        }
                    }
                    if (isServiceSelected) {
                        [self.appliedCouponsIDAndName addObject:couponCell.textField.text];
                        serviceInfoToChangeStatusOf.isApplied = YES;
                        [self.couponTableView reloadData];
                    } else {
                        [self showToastWithText:@"Invalid coupon" on:Failure];
                    }
                } else {
                    
                }
            }
        }
        
        [self resizeTableViewWithAnimation];
    } else {
        [self.appliedCouponsIDAndName removeObjectAtIndex:couponCell.index];
        if (self.appliedCouponsIDAndName.count == 0 && _isUniversalCouponApplied) {
            _isUniversalCouponApplied = NO;
        }
        [self resizeTableViewWithAnimation];
    }
}

@end
