//
//  PostDetailViewController.h
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <ParseUI/ParseUI.h>

@interface PostDetailViewController : UIViewController

@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;

@end
