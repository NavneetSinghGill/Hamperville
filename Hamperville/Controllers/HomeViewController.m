//
//  HomeViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 06/04/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "HomeViewController.h"
#import "RequestManager.h"
#import "HomePageContentViewController.h"
#import "HomePageViewController.h"
#import "LoginViewController.h"

@interface HomeViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *allImages;

@property(weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property(weak, nonatomic) IBOutlet UIButton *loginButton;
@property(weak, nonatomic) IBOutlet UIButton *signUpButton;
@property(weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property(weak, nonatomic) IBOutlet UILabel *logoLinelabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initialSetup];
    
    [self generateSubViewWithImages];
    if (self.navigationController != nil) {
        self.navigationController.navigationBar.hidden = YES;
    }
}



#pragma mark - PageView controller datasource methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((HomePageContentViewController *) viewController).pageIndex;
    [self.pageControl setCurrentPage:index];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.allImages count]) {
        return nil;
    }

    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((HomePageContentViewController *) viewController).pageIndex;
    [self.pageControl setCurrentPage:index];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (HomePageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.allImages count] == 0) || (index >= [self.allImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    HomePageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomePageContentViewController"];
    pageContentViewController.imageName = self.allImages[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.allImages.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - Private methods

- (void)initialSetup {
    
    NSArray *nameOfImages = [NSArray arrayWithObjects:@"SwipeImage1", nil];
    self.allImages = [NSMutableArray array];
    
    for (NSString *image in nameOfImages) {
        [self.allImages addObject:image];
    }
    
    self.loginButton.layer.cornerRadius = 3;
    self.loginButton.clipsToBounds = YES;
    self.signUpButton.layer.cornerRadius = 3;
    self.signUpButton.clipsToBounds = YES;

    self.logoLinelabel.text = @"The Evolution of\nDry Cleaning & Laundry";
}

-(void) generateSubViewWithImages {
    
    if (self.allImages.count > 0) {
        if(self.allImages.count > 1)
        {
            self.pageControl.hidden = NO;
        } else {
            self.pageControl.hidden = YES;
        }
        self.pageControl.numberOfPages = self.allImages.count;
        self.pageControl.currentPage = 0;
        
        if(!self.pageViewController)
        {
            self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
//            self.pageViewController.dataSource = self;
//            self.pageViewController.delegate = self;
            _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 37);
            [self addChildViewController:_pageViewController];
            [self.view addSubview:_pageViewController.view];
            [self.pageViewController didMoveToParentViewController:self];
            [self bringViewsToFront];
        }
        
        HomePageContentViewController *homePageContentViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[homePageContentViewController];
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        
        // Change the size of page view controller
        
    }
}

- (void)bringViewsToFront {
    [self.view bringSubviewToFront:self.pageControl];
    [self.view bringSubviewToFront:self.loginButton];
    [self.view bringSubviewToFront:self.signUpButton];
    [self.view bringSubviewToFront:self.logoImageView];
    [self.view bringSubviewToFront:self.logoLinelabel];
}

#pragma mark - IBAction methods

- (IBAction)logInButtonTapped:(id)sender {    
    
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)signUpButtonTapped:(id)sender {
    NSString *url = @"http://staging.hamperville.com";
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}

@end
