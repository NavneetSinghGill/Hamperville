//
//  SchedulePickupViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SchedulePickupViewController.h"
#import "RequestManager.h"

@interface SchedulePickupViewController ()

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



@property(strong, nonatomic) NSMutableDictionary *pickupSlots;
@property(strong, nonatomic) NSMutableArray *pickupDays;
@property(assign, nonatomic) NSInteger pickupLoopCount;
@property(assign, nonatomic) NSInteger pickupDayCount;

@property(strong, nonatomic) NSMutableDictionary *dropOffSlots;
@property(strong, nonatomic) NSMutableArray *dropOffDays;
@property(assign, nonatomic) NSInteger dropOffLoopCount;
@property(assign, nonatomic) NSInteger dropOffDayCount;

@property(strong, nonatomic) NSMutableArray *services;
@property(strong, nonatomic) NSMutableArray *universalCoupons;

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

#pragma mark - Private methods

- (void)schedulePickupAPIcall {
    [[RequestManager alloc] getSchedulePickup:^(BOOL success, id response) {
        if (success) {
            self.dropOffSlots = [response valueForKey:@"drop_off_slots"];
            self.dropOffDays = [[self.dropOffSlots allKeys] mutableCopy];
            
            self.pickupSlots = [response valueForKey:@"pick_up_slots"];
            self.pickupDays = [[self.pickupSlots allKeys] mutableCopy];
            
            self.services = [response valueForKey:@"services"];
            self.universalCoupons = [response valueForKey:@"universal_coupons"];
            
            [self setupAllEntries];
        }
    }];
}

- (void)initialSetup {
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    self.requestPickupButton.layer.cornerRadius = 4;
    
    self.couponView.layer.cornerRadius = 4;
    self.couponView.layer.borderWidth = 1;
    self.couponView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor;
}

- (void)setupAllEntries {
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE";
    NSString *dayName = [[dateFormatter stringFromDate:currentDate] lowercaseString];
    
    [self rearrangePickupDaysForDay:dayName];
    
}

- (void)rearrangePickupDaysForDay:(NSString *)day {
    NSMutableArray *newPickupDays = [NSMutableArray array];
    day = [day lowercaseString];
    if (self.pickupDays.count != 0) {
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
            for (NSString *pickupDay in self.pickupDays) {
                if ([[pickupDay lowercaseString] isEqualToString:[dayParse lowercaseString]]) {
                    [newPickupDays addObject:pickupDay];
                    break;
                }
            }
        }
        self.pickupDays = newPickupDays;
    }
}

#pragma mark - IBAction methods

- (IBAction)pickUpLeftArrowButtonTapped:(id)sender {
    
}

- (IBAction)pickUpRightArrowButtonTapped:(id)sender {
    
}

- (IBAction)pickUpUpArrowButtonTapped:(id)sender {
    
}

- (IBAction)pickUpDownArrowButtonTapped:(id)sender {
    
}

- (IBAction)dropOffLeftArrowButtonTapped:(id)sender {
    
}

- (IBAction)dropOffRightArrowButtonTapped:(id)sender {
    
}

- (IBAction)dropOffUpArrowButtonTapped:(id)sender {
    
}

- (IBAction)dropOffDownArrowButtonTapped:(id)sender {
    
}

- (IBAction)requestPickupButtonTapped:(id)sender {
    
}

@end
