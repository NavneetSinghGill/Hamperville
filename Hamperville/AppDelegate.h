//
//  AppDelegate.h
//  Hamperville
//
//  Created by stplmacmini11 on 06/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ALAlertBanner.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define Utils [Util sharedInstance]

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (ALAlertBanner *)showFailureBannerOnTopWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (ALAlertBanner *)showSuccessBannerOnTopWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (ALAlertBanner *)showSuccessBannerWithSubtitle:(NSString *)subtitle;
- (ALAlertBanner *)showSuccessBannerWithSubtitle:(NSString *)subtitle withObject:(id)object;

- (BOOL)hasNetworkAvailable;

@end

