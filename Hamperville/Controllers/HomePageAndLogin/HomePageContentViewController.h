//
//  HomePageContentViewController.h
//  Hamperville
//
//  Created by stplmacmini11 on 08/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "HampervilleViewController.h"

@interface HomePageContentViewController : HampervilleViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) NSUInteger pageIndex;

@property (strong, nonatomic) NSString *imageName;

@end
