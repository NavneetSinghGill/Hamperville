//
//  ChangeSubscriptionViewController.h
//  Hamperville
//
//  Created by stplmacmini11 on 20/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "HampervilleViewController.h"

@protocol UpdateSubscriptionDelegate <NSObject>

- (void)updateViewsWithStatus:(BOOL)status subscriptionID:(NSInteger)subscriptionID andNextRenewalDate:(NSDate *)renewalDate;
- (void)updateViewsWithStatus:(BOOL)status;

@end

@interface ChangeSubscriptionViewController : HampervilleViewController

@property(strong, nonatomic) NSMutableArray *allSubscriptions;
@property(assign, nonatomic) BOOL status;
@property(assign, nonatomic) NSInteger currentSubscriptionPlanID;
@property(strong, nonatomic) NSDate *nextRenewalDate;
@property(strong, nonatomic) id<UpdateSubscriptionDelegate> updateDelegate;

@end
