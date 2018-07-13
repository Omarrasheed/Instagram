//
//  CameraPostViewController.m
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "CameraPostViewController.h"
#import "Post.h"
#import "MBProgressHUD.h"
#import <ParseUI/ParseUI.h>
#import "AddLocationViewController.h"

@interface CameraPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, locationViewDelegate>

@property (strong, nonatomic) UIImage *postImage;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextView *CaptionTextView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearLocationButton;

@end

@implementation CameraPostViewController

- (IBAction)viewTapped:(id)sender {
    [self.CaptionTextView resignFirstResponder];
}
- (IBAction)xButtonTapped:(id)sender {
    self.locationLabel.text = @"Select a location...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    if (!self.posting) {
        self.CaptionTextView.text = @"Enter caption...";
        self.CaptionTextView.textColor = [UIColor lightGrayColor];
        self.posting = YES;
    }
}

- (void)viewDidLayoutSubviews {
    self.CaptionTextView.scrollEnabled = NO;
    self.CaptionTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.CaptionTextView.layer.borderColor = [UIColor.lightGrayColor CGColor];
    self.CaptionTextView.layer.borderWidth = 2;
    self.CaptionTextView.delegate = self;
    self.CaptionTextView.layer.cornerRadius = 6;
    
    self.profileImageView.file = PFUser.currentUser[@"image"];
    self.profileImageView.layer.cornerRadius = 22;
    [self.profileImageView loadInBackground];
    
    self.clearLocationButton.layer.borderColor = [[UIColor blueColor] CGColor];
    self.clearLocationButton.layer.borderWidth = 1;
    self.clearLocationButton.layer.cornerRadius = self.clearLocationButton.frame.size.height/2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)imagePressed:(id)sender {
    NSLog(@"hit func");
    [self setupImagePickerVC:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (IBAction)postButtonPressed:(id)sender {
    if ([self.postImageView.image isEqual:[UIImage imageNamed:@"image_placeholder"]]) {
        [self createAlert:@"Please select an Image"];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *captionText =@"";
        if (![self.CaptionTextView.text isEqualToString:@"Enter caption..."]) {
            captionText = self.CaptionTextView.text;
        }
        [Post postUserImage:self.postImageView.image withCaption:captionText location: self.locationLabel.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                [self.delegate didPost];
                [self.CaptionTextView resignFirstResponder];
                self.postImageView.image = nil;
                self.tabBarController.selectedIndex = 0;
                self.posting = NO;
            }
        }];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    self.tabBarController.selectedIndex = 0;
    self.posting = YES;
}

- (IBAction)photoGallerySelected:(id)sender {
    [self setupImagePickerVC:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)cameraButton:(id)sender {
    [self setupImagePickerVC:UIImagePickerControllerSourceTypeCamera];
}

- (void)textViewDidChange:(UITextView *)textView {
    [textView sizeToFit];
}

- (void)sendLocationTitle:(NSString *)locationTitle {
    NSLog(@"hit");
    self.locationLabel.text = locationTitle;
}

- (void)textViewDidBeginEditing:(UITextView *)textView\
{
    NSLog(@"here");
    if ([textView.text isEqualToString:@"Enter caption..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Enter caption...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    editedImage = [self resizeImage:editedImage withSize:CGSizeMake(375, 300)];
    originalImage = [self resizeImage:originalImage withSize:CGSizeMake(375, 300)];
    
    self.postImage = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.postImageView.image = self.postImage;
    self.posting = YES;
}

- (void)setupImagePickerVC: (UIImagePickerControllerSourceType) source {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else {
        imagePickerVC.sourceType = source;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)createAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                         }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UIButton class]]) {
        AddLocationViewController *locationViewController = [segue destinationViewController];
        locationViewController.delegate = self;
    }
}


@end
