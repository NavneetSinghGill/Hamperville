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

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:kUserID] == nil) {
        HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        homeViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:homeViewController animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:kToSWController sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kToSWController]) {
        segue.destinationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
}

@end
