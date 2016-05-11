//
//  DropdownTableViewCell.h
//  Hamperville
//
//  Created by stplmacmini11 on 06/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownDelegate <NSObject>

- (void)dropDownTapped:(NSInteger)index;

@end

@interface DropdownTableViewCell : UITableViewCell

@property(assign, nonatomic) NSInteger index;
@property(weak, nonatomic) IBOutlet UILabel *name;
@property(strong, nonatomic) id<DropDownDelegate> dropDownDelegate;

@end
