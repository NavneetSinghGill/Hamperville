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
    self.difference = [[serviceDict valueForKey:@"day_difference"] integerValue];
    self.serviceID = [NSString stringWithFormat:@"%@",[serviceDict valueForKey:@"id"]];
    self.serviceImageUrl = [serviceDict valueForKey:@"image_key"];
    self.serviceName = [serviceDict valueForKey:@"name"];
    
    self.coupons = [serviceDict valueForKey:@"coupons"];
}

- (void)updateUI {
    self.serviceNamelabel.text = self.serviceName;
    self.serviceImageButton.layer.cornerRadius = self.serviceImageButton.frame.size.width / 2;
    self.serviceImageButton.layer.masksToBounds = YES;
    self.serviceImageBackgroundBorderView.layer.cornerRadius = self.serviceImageBackgroundBorderView.frame.size.width / 2;
    self.serviceImageBackgroundBorderView.layer.masksToBounds = YES;
    //ImageUrl set
    [self.serviceImageButton sd_setImageWithURL:[NSURL URLWithString:self.serviceImageUrl] forState:UIControlStateNormal];
}

- (void)setSelectionState:(BOOL)isSelected {
    self.serviceImageBackgroundBorderView.hidden = !isSelected;
    self.serviceImageButton.selected = isSelected;
}

@end
