//
//  PostTableViewCell.m
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (void)setPost{
    [self setupPostImage];
    [self setupCaptionText];
}

- (void)setupPostImage {
    self.postImage.file = self.post[@"image"];
    [self.postImage loadInBackground];
}

- (void)setupCaptionText {
    self.captionTextLabel.text = [[NSString stringWithFormat:@"%@: ", self.user.username] stringByAppendingString:self.post[@"caption"]];
    [self.captionTextLabel sizeToFit];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
