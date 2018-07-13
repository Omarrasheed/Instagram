//
//  EditProfileViewController.h
//  Instagram
//
//  Created by Omar Rasheed on 7/12/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"
#import <ParseUI/ParseUI.h>

@protocol editProfileDelegate

- (void) profileEdited;

@end

@interface EditProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextView *bioTextField;
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) id<editProfileDelegate> delegate;

@end
