//
//  EditProfileViewController.h
//  Instagram
//
//  Created by Omar Rasheed on 7/12/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@protocol editProfileDelegate

- (void) profileEdited;

@end

@interface EditProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) id<editProfileDelegate> delegate;

@end
