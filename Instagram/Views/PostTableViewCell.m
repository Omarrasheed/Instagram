//
//  PostTableViewCell.m
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "PostTableViewCell.h"
#import <DateTools.h>
#import "HomeViewController.h"

@implementation PostTableViewCell 

- (void)setPost{
    [self setupPostImage];
    [self setupCaptionText];
    [self setupLikeButton];
    [self setupLikeCountLabel];
    [self setupDateTimeLabel];
}
- (void)setupDateTimeLabel {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate  * _Nullable dateTime = self.post.createdAt;
    
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    // Convert Date to String
    NSString *dateTimeString = [formatter stringFromDate:dateTime];
    
    NSDate *now = [NSDate date];
    
    NSInteger daysApart = [now daysFrom:dateTime];
    NSInteger hoursApart = [now hoursFrom:dateTime];
    NSInteger minutesApart = [now minutesFrom:dateTime];
    NSInteger secondsApart = [now secondsFrom:dateTime];
    // Convert Date to String according to post time
    if (daysApart < (NSInteger)7) {
        if (daysApart < 1) {
            if (hoursApart < 1) {
                if (minutesApart < 1) {
                    if (secondsApart == 1) {
                        self.dateTImeLabel.text = [NSString stringWithFormat:@"%ld SECOND AGO", secondsApart];
                    } else {
                        self.dateTImeLabel.text = [NSString stringWithFormat:@"%ld SECONDS AGO", secondsApart];
                    }
                } else {
                    if (minutesApart == 1) {
                        self.dateTImeLabel.text = [NSString stringWithFormat:@"%ld MINUTE AGO", minutesApart];
                    } else {
                        self.dateTImeLabel.text = [NSString stringWithFormat:@"%ld MINUTES AGO", minutesApart];
                    }
                }
            } else {
                if (hoursApart == 1) {
                    self.dateTImeLabel.text = [NSString stringWithFormat:@"%ld HOUR AGO", hoursApart];
                } else {
                    self.dateTImeLabel.text = [NSString stringWithFormat:@"%ld HOURS AGO", hoursApart];
                }
            }
        } else {
            self.dateTImeLabel.text = [NSString stringWithFormat:@"%ld DAYS AGO", daysApart];
        }
    } else {
        self.dateTImeLabel.text = dateTimeString;
    }
}
- (void)setupPostImage {
    self.postImage.file = self.post[@"image"];
    [self.postImage loadInBackground];
}

- (void)setupCaptionText {
    self.captionTextLabel.text = self.post[@"caption"];
    [self.captionTextLabel sizeToFit];
}

-(void)setupLikeCountLabel {
    int likeCount = [self.post.likeCount intValue];
    if (likeCount == 1) {
        self.likeCount.text = [NSString stringWithFormat:@"%@ Like", self.post[@"likeCount"]];
    } else {
        self.likeCount.text = [NSString stringWithFormat:@"%@ Likes", self.post[@"likeCount"]];
    }
    [self.likeCount sizeToFit];
}

- (void) setupLikeButton {
    [self.likeButton setImage:[UIImage imageNamed:@"Instagram-Heart-Transparent"] forState:UIControlStateNormal];
    NSMutableArray *likedUsers = self.post[@"likedUsers"];
    for (PFUser *user in likedUsers) {
        if ([PFUser.currentUser.objectId isEqualToString:user.objectId]) {
            [self.likeButton setImage:[UIImage imageNamed:@"instagram-Red-Heart"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)likeButtonTapped:(id)sender {
    if ([self.likeButton.imageView.image isEqual:[UIImage imageNamed:@"instagram-Red-Heart"]]) {
        self.post[@"liked"] = @NO;
        [self.likeButton setImage:[UIImage imageNamed:@"Instagram-Heart-Transparent"] forState:UIControlStateNormal];
        int num = [self.post.likeCount intValue];
        self.post.likeCount = [NSNumber numberWithInteger:(NSInteger)(num - 1)];
        NSMutableArray *likedUsers = self.post[@"likedUsers"];
        for (PFUser *user in likedUsers) {
            if (user.objectId == PFUser.currentUser.objectId) {
                [likedUsers removeObject:user];
            }
        }
        self.post[@"likedUsers"] = likedUsers;
        [self.post saveInBackground];
    } else {
        self.post[@"liked"] = @YES;
        [self.likeButton setImage:[UIImage imageNamed:@"instagram-Red-Heart"] forState:UIControlStateNormal];
        int num = [self.post.likeCount intValue];
        self.post.likeCount = [NSNumber numberWithInteger:((NSInteger)num + 1)];
        NSMutableArray *likedUsers = self.post[@"likedUsers"];
        [likedUsers addObject:PFUser.currentUser];
        self.post[@"likedUsers"] = likedUsers;
        [self.post saveInBackground];
    }
    [self setupLikeCountLabel];
}

-(void)doubleTapHit {
    NSLog(@"got here");
    [self likeButtonTapped:nil];
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
