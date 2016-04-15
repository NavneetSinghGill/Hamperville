//
//  LeftMenuTableViewCell.m
//  Hamperville
//
//  Created by stplmacmini11 on 12/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "LeftMenuTableViewCell.h"

@implementation LeftMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelection:(BOOL)isSelected {
    if (isSelected) {
        [self.headingButton setTitleColor:[UIColor colorWithRed:51/255.0f green:171/255.0f blue:73/255.0f alpha:1.0] forState:UIControlStateNormal];
        self.isSelected = YES;
    } else {
        [self.headingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.isSelected = NO;
    }
}

@end
