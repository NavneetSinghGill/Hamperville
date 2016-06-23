//
//  AppDelegate.m
//  Hamperville
//
//  Created by stplmacmini11 on 06/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworkReachabilityManager.h>
#import "HomeViewController.h"
#import "SignupInterface.h"

@interface AppDelegate ()

@property(assign, nonatomic) BOOL isNetworkAvailable;

void uncaughtExceptionHandler(NSException *exception);

@end

@implementation AppDelegate

void uncaughtExceptionHandler(NSException *exception)
{
    NSString *errorMessage = [NSString stringWithFormat:@"Error: Application Crashed while launching At: %s, \n Exception Description: %@. \n  \n", __FUNCTION__, [exception description]];
    
    // Save response in MobiLogger
    [[SMobiLogger sharedInterface] error:@"Uncaught Exception." withDescription:errorMessage];
    
    NSLog(@"Uncaught Exception: %@", errorMessage);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[SignupInterface alloc] setSavedSessionCookies];
    
    [self setupNetworkMonitoring];
    
    //Register (APNS) Remote notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound
                                                                                             |UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
//    [[NSUserDefaults standardUserDefaults] setObject: forKey:@"OrderForOrderHistoryScreen"]
    NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (dictionary != nil) {       
        [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithObjectsAndKeys:[[dictionary valueForKey:@"aps"] valueForKey:@"data"],kPushNotificationData, nil] forKey:@"OrderForOrderHistoryScreen"];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[SMobiLogger sharedInterface] startMobiLogger];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceTokenString forKey:keyDeviceToken];
    [userDefaults synchronize];
    
    // Save response in MobiLogger
    [[SMobiLogger sharedInterface] info:@"Application registered for receiveing remote notifications." withDescription:[NSString stringWithFormat:@"At: %s, \n [Param: [Device Id: %@]]. \n  \n", __FUNCTION__, deviceTokenString]];
    
    NSLog([NSString stringWithFormat:@"Device token: %@", deviceToken]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[SMobiLogger sharedInterface] info:@"Application received remote notification." withDescription:[NSString stringWithFormat:@"At: %s, \n Error: %@\n", __FUNCTION__, error.localizedDescription]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo != nil) {
        [[SMobiLogger sharedInterface] info:@"Application received remote notification." withDescription:[NSString stringWithFormat:@"At: %s, \n Aps: %@\n", __FUNCTION__, [userInfo valueForKey:@"aps"]]];
        [[NSNotificationCenter defaultCenter]postNotificationName:kAppReceivedPushNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"],kPushNotificationMessage, nil]];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kShowOrderScreen object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[userInfo valueForKey:@"aps"] valueForKey:@"data"],kPushNotificationData, nil]];
    }
}

#pragma mark - AFNetworking methods

-(void)setupNetworkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"online");
                self.isNetworkAvailable = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkAvailablability object:nil];
//                [[ALAlertBannerManager sharedManager] hideAllAlertBanners];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoNetworkNotification object:nil];
                
                // Save response in MobiLogger
                [[SMobiLogger sharedInterface] error:@"Network Available." withDescription:nil];
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            default:
                self.isNetworkAvailable = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkAvailablability object:nil];
                // Save response in MobiLogger
                [[SMobiLogger sharedInterface] error:@"Network UnAvailable." withDescription:nil];
                
                NSLog(@"offline");
//                self.isBannerVisible = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoNetworkNotification object:nil];
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (BOOL)hasNetworkAvailable
{
    [[SMobiLogger sharedInterface] info:[NSString stringWithFormat:@"%s", __FUNCTION__] withDescription:[NSString stringWithFormat:@"Info: isNetworkAvailable: %d", self.isNetworkAvailable]];
    return self.isNetworkAvailable;
}

#pragma mark - Banner Methods


- (ALAlertBanner *)showSuccessBannerWithSubtitle:(NSString *)subtitle {
    return [self showSuccessBannerOnTopWithTitle:@"Hamperville" subtitle:subtitle];
}

- (ALAlertBanner *)showSuccessBannerOnTopWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    return [self showBannerWithTitle:title subtitle:subtitle style:ALAlertBannerStyleNone position:ALAlertBannerPositionTop];
}

- (ALAlertBanner *)showBannerWithTitle:(NSString *)title subtitle:(NSString *)subtitle style:(ALAlertBannerStyle)style position:(ALAlertBannerPosition)position
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.window
                                                        style:style
                                                     position:position
                                                        title:title
                                                     subtitle:subtitle];
    [banner show];
    return banner;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Systango.Hamperville" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Hamperville" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Hamperville.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
