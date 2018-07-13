//
//  ProfileFeedCollectionViewCell.h
//  Instagram
//
//  Created by Omar Rasheed on 7/10/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"

@interface ProfileFeedCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) PFUser *user;

@end
