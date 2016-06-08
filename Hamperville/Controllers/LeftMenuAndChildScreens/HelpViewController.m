//
//  HelpViewController.m
//  Hamperville
//
//  Created by stplmacmini11 on 02/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "HelpViewController.h"
#import "RequestManager.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface HelpViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate> {
    NSInteger titleLabelDefaultTopConstriantValue;
    BOOL areLogsAttached;
}

@property(weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property(weak, nonatomic) IBOutlet UITextField *titleTextField;

@property(weak, nonatomic) IBOutlet UIButton *attachLogsButton;
@property (strong, nonatomic) UIImage *attachedScreenShot;

@property(weak, nonatomic) IBOutlet UILabel *attachScreenShot;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.attachScreenShot.text = @"Attach Snapshot";
    [self.attachScreenShot setTextColor:[UIColor blackColor]];
    self.attachedScreenShot = nil;
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Help" andColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1.0]];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:self.menuButton, nil]];
    
    self.descriptionTextView.delegate = self;
    self.descriptionTextView.text = @"Write your text here";
    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    
    titleLabelDefaultTopConstriantValue = self.titleLabelTopConstraint.constant;
    
    areLogsAttached = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardBounds;
    UIView *textField = nil;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    if ([self.titleTextField isFirstResponder]) {
        return;
    } else if ([self.descriptionTextView isFirstResponder]) {
        textField = self.descriptionTextView;
    }
    
    CGFloat difference = ( self.view.frame.size.height - keyboardBounds.size.height) - (textField.frame.size.height + textField.frame.origin.y) ;
    
    if (difference < 0) {
        //Note: difference is negative so it's added
        self.titleLabelTopConstraint.constant = titleLabelDefaultTopConstriantValue + difference - (titleLabelDefaultTopConstriantValue - self.titleLabelTopConstraint.constant) - 5; // -5 for extra space
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    self.titleLabelTopConstraint.constant = titleLabelDefaultTopConstriantValue;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (NSString*)encodeToBase64String:(UIImage *)image
{
    return [UIImageJPEGRepresentation(image, 0.2) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

-(UIImage*)imageWithImage:(UIImage*)image;
{
    CGSize newSize = image.size;
//    if (image.size.width > 400) {
//        float proportion = 400/image.size.width;
//        newSize = CGSizeMake((image.size.width/proportion),(image.size.height/proportion));
//    }
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - IBAction methods 

- (IBAction)attachmentButtonTapped:(id)sender {
    [self selectPhoto];
}

- (IBAction)attachLogsButtonTapped:(id)sender {
    ((UIButton *)sender).selected = !((UIButton *)sender).selected;
    areLogsAttached = ((UIButton *)sender).selected;
}

- (IBAction)submitButtonTapped:(id)sender {
    if (self.titleTextField.text.length == 0) {
        [self showToastWithText:@"Enter title" on:Success];
        return;
    }
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    dataDict[@"title"] = self.titleTextField.text;
    dataDict[@"description"] = self.descriptionTextView.text;
    if (self.attachedScreenShot) {
        self.attachedScreenShot = [self imageWithImage:self.attachedScreenShot];
        [dataDict setObject:self.attachedScreenShot forKey:@"image"];
    }
    if (areLogsAttached) {
        [dataDict setObject:[NSNumber numberWithBool:YES] forKey:@"logs"];
    }
    
    [self.activityIndicator startAnimating];
    [[RequestManager alloc] postHelpWithDataDictionary:dataDict withCompletionBlock:^(BOOL success, id response) {
        [self.activityIndicator stopAnimating];
        if (success) {
            
            [[SMobiLogger sharedInterface] startMobiLogger];
            
            [self showToastWithText:response on:Success];
            
            self.attachedScreenShot = nil;
            self.titleTextField.text = @"";
            self.descriptionTextView.text = @"Write your text here";
            self.descriptionTextView.textColor = [UIColor lightGrayColor];
            self.attachLogsButton.selected = NO;
//            areLogsAttached = NO;
            [self.view endEditing:YES];
        } else {
            [self showToastWithText:response on:Failure];
        }
    }];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.attachedScreenShot = chosenImage;
//    [[self attachmentButton] setImage:[UIImage imageNamed:@"popupCancel"] forState:UIControlStateNormal];
//    [[self screenShotButton] setTitle:@"Change screenshot" forState:UIControlStateNormal];
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        NSLog([NSString stringWithFormat:@"%@",[imageRep filename]]);
        self.attachScreenShot.text = [imageRep filename];
        [self.attachScreenShot setTextColor:[UIColor colorWithRed:53/255.0f green:173/255.0f blue:71/255.0f alpha:1.f]];
        NSLog([NSString stringWithFormat:@"%@",self.attachScreenShot.text]);
        [self.view layoutIfNeeded];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - TextView delegate methods -

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write your text here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write your text here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - TextField delegate methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.descriptionTextView becomeFirstResponder];
    return NO;
}

@end
