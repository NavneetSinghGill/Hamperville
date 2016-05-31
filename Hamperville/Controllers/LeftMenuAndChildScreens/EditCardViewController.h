//
//  EditCardViewController.h
//  Hamperville
//
//  Created by stplmacmini11 on 31/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "HampervilleViewController.h"

@interface EditCardViewController : HampervilleViewController

@property(strong, nonatomic) NSString *creditCardID;
@property(strong, nonatomic) NSString *creditCardNumber;
@property(assign, nonatomic) BOOL isPrimary;

@end
