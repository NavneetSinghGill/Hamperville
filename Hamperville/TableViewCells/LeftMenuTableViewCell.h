//
//  LeftMenuTableViewCell.h
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIButton *headingButton;
@property(assign, nonatomic) BOOL isSelected;

- (void)setSelection:(BOOL)isSelected;

@end
