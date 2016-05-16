//
//  CouponTableViewCell.h
//  Hamperville
//
//  Created by stplmacmini11 on 02/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CouponTableViewCell;

@protocol CouponTableViewCellDelegate <NSObject>

- (void)verifyTapped:(CouponTableViewCell *)couponCell;

@end

@interface CouponTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UITextField *textField;
@property(weak, nonatomic) IBOutlet UIButton *verifyButton;
@property(strong, nonatomic) NSString *serviceID;
@property(assign, nonatomic) NSInteger index;

@property(assign, nonatomic) id<CouponTableViewCellDelegate> couponTableViewCellDelegate;

@end
