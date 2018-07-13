//
//  ProfileViewController.h
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *pageTitleLabel;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSMutableArray *usersPosts;
@property BOOL isCurrentUser;

@end
