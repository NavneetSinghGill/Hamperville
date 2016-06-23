//
//  InitialViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "InitialViewController.h"
#import "HomeViewController.h"
#import <SWRevealViewController.h>
#import "OrderHistoryDetailsViewController.h"
#import "Order.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setAppropriateController];
}

- (void)setAppropriateController {
    dispatch_async(dispatch_get_main_queue(), ^{
        
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"OrderForOrderHistoryScreen"] != nil) {
                Order *order = [Order getOrderFromDictionary:[[[NSUserDefaults standardUserDefaults]objectForKey:@"OrderForOrderHistoryScreen"] valueForKey:@"PushNotificationData"]];
                
                OrderHistoryDetailsViewController *orderHistoryDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryDetailsViewController"];
                orderHistoryDetailsViewController.order = order;
                orderHistoryDetailsViewController.isOpenedFromPushNotification = YES;
                
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:orderHistoryDetailsViewController];
                navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"OrderForOrderHistoryScreen"];
                
                [self presentViewController:navController animated:YES completion:nil];
                return ;
            }
            
            if ([[NSUserDefaults standardUserDefaults]valueForKey:kUserID] == nil) {
                HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:homeViewController];
                navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:navController animated:YES completion:nil];
            } else {
                [self performSegueWithIdentifier:kToSWController sender:self];
            }
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kToSWController]) {
        segue.destinationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
}

@end
