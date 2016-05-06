//
//  PermanentPreferencesViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 06/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PermanentPreferencesViewController.h"
#import "DropdownTableViewCell.h"

@interface PermanentPreferencesViewController () <DropDownDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation PermanentPreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - Delegate methods

- (void)dropDownTapped:(NSInteger)index {
    
}

#pragma mark - TableView methods -

#pragma mark Datasourse

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 4;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}



@end
