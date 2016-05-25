//
//  LocationTableViewCell.h
//  Hamperville
//
//  Created by stplmacmini11 on 25/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UITextField *textField;
@property(assign, nonatomic) NSInteger index;

@end
