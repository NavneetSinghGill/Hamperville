//
//  UIView+VZView.m
//  Cliquepick
//
//  Created by stplmacmini on 29/07/15.
//  Copyright (c) 2015 VeoZen. All rights reserved.
//

#import "UIView+HVView.h"

@implementation UIView (HVView)

@dynamic borderColor,borderWidth,cornerRadius,circularView;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}

- (void)setCircularView:(BOOL)circularView {
    if (circularView) {
        [self.layer setCornerRadius:self.frame.size.width/2];
        [self.layer setMasksToBounds:YES];
    }
};

@end
