//
//  CreditCardTableViewCell.h
//  Hamperville
//
//  Created by stplmacmini11 on 31/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCardTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *primaryLabel;
@property(weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property(weak, nonatomic) IBOutlet UIButton *tickButton;

@property(weak, nonatomic) IBOutlet UIView *addCardSuperView;
@property(weak, nonatomic) IBOutlet UIView *addedCardSuperView;

@end
