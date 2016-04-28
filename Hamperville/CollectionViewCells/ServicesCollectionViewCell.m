//
//  ServicesCollectionViewCell.m
//  Hamperville
//
//  Created by stplmacmini11 on 27/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ServicesCollectionViewCell.h"

@implementation ServicesCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - Public methods

- (void)setContent {
    [self setServiceWithServiceDict:self.serviceDictionary];
    [self updateUI];
}

#pragma mark - Private methods

- (void)setServiceWithServiceDict:(NSMutableDictionary *)serviceDict {
    self.difference = [[serviceDict valueForKey:@"number_of_days_to_complete_order"] integerValue];
    self.serviceID = [serviceDict valueForKey:@"service_id"];
    self.serviceImageUrl = [serviceDict valueForKey:@"service_image_url"];
    self.serviceName = [serviceDict valueForKey:@"service_name"];
    
    self.coupons = [serviceDict valueForKey:@"coupons"];
}

- (void)updateUI {
    self.serviceNamelabel.text = self.serviceName;
    //ImageUrl set
}

@end
