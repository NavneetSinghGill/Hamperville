//
//  DropdownTableViewCell.m
//  Hamperville
//
//  Created by stplmacmini11 on 06/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "DropdownTableViewCell.h"

@implementation DropdownTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)emptyButtonTapped:(id)sender {
    [self.dropDownDelegate dropDownTapped:_index];
}

@end
