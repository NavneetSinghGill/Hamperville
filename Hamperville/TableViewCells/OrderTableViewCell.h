//
//  OrderTableViewCell.h
//  Hamperville
//
//  Created by stplmacmini11 on 02/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *orderHeadingLabel;
@property(weak, nonatomic) IBOutlet UILabel *orderInfoLabel;
@property(weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
