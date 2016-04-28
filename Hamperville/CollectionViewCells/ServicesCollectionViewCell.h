//
//  ServicesCollectionViewCell.h
//  Hamperville
//
//  Created by stplmacmini11 on 27/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesCollectionViewCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIButton *serviceImageButton;
@property(weak, nonatomic) IBOutlet UILabel *serviceNamelabel;

@property(strong, nonatomic) NSMutableDictionary *serviceDictionary;

@property(assign, nonatomic) NSInteger difference;
@property(strong, nonatomic) NSString *serviceID;
@property(strong, nonatomic) NSString *serviceImageUrl;
@property(strong, nonatomic) NSString *serviceName;
@property(strong, nonatomic) NSMutableArray *coupons;

- (void)setContent;

@end
