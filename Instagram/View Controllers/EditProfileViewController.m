//
//  EditProfileViewController.m
//  Instagram
//
//  Created by Omar Rasheed on 7/12/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "EditProfileViewController.h"
#import <ParseUI/ParseUI.h>
#import "MBProgressHUD.h"

@interface EditProfileViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextView *bioTextField;

@end

@implementation EditProfileViewController

- (void)viewDidLayoutSubviews {
    self.profilePicture.file = PFUser.currentUser[@"image"];
    [self.profilePicture loadInBackground];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bioTextField.delegate = self;
    // Do any additional setup after loading the view.
    [self.nameTextField becomeFirstResponder];
}

- (IBAction)changeProfilePic:(id)sender {
    
}

- (void)textViewDidChange:(UITextView *)textView {
    [textView sizeToFit];
}
- (IBAction)doneButtonPressed:(id)sender {
    PFUser.currentUser.username = self.usernameTextField.text;
    PFUser.currentUser[@"bio"] = self.bioTextField.text;
    PFUser.currentUser[@"fullName"] = self.nameTextField.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.delegate profileEdited];
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}
- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
