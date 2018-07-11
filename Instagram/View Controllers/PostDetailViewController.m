//
//  PostDetailViewController.m
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "PostDetailViewController.h"
#import "Post.h"
#import <ParseUI/ParseUI.h>
#import "UIImageView+AFNetworking.h"

@interface PostDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionText;

@end

@implementation PostDetailViewController

- (void)viewDidLayoutSubviews {
    [self setupImageView];
    [self setupUsernameLabel];
    [self setupCaptionText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setupImageView {
    self.postImageView.file = self.post.image;
    [self.postImageView loadInBackground];
}

-(void) setupUsernameLabel {
    self.usernameLabel.text = self.user.username;
    [self.usernameLabel sizeToFit];
}

- (void) setupCaptionText {
    self.captionText.text = [[NSString stringWithFormat:@"%@: ", self.user.username] stringByAppendingString:self.post[@"caption"]];
    [self.captionText sizeToFit];
}
- (IBAction)returnButtonPressed:(id)sender {
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
