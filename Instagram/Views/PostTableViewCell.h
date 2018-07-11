//
//  PostTableViewCell.h
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <ParseUI/ParseUI.h>

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *captionTextLabel;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) PFUser *user;

- (void)setPost;

@end
