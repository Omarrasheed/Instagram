//
//  ProfileViewController.m
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse.h"
#import <ParseUI/ParseUI.h>
#import "ProfileFeedCollectionViewCell.h"
#import "Post.h"
#import "PostDetailViewController.h"
#import "EditProfileViewController.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, editProfileDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *pageTitle;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *postCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *profileCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation ProfileViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    self.usersPosts = [[NSMutableArray alloc] init];
    
    self.user = PFUser.currentUser;
    self.profileImage.file = self.user[@"image"];
    [self.profileImage loadInBackground];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.clipsToBounds = YES;
    
    [self queryForUser];
    
    if (self.tabBarController.selectedIndex == 2) {
        self.user = PFUser.currentUser;
        self.isCurrentUser = YES;
    } else {
        self.isCurrentUser = NO;        
        UIBarButtonItem *xButton =[[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(Back_btn:)];

        self.pageTitle.leftBarButtonItem = xButton;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 0.5)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
}

- (void)viewDidLayoutSubviews {
    [self setupProfileImage];
    [self setupEditProfileButton];
    [self setupPageTitleLabel];
    [self setupUsernameLabel];
    [self setupBioLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCollectionView];
}

-(void) setupBioLabel {
    self.bioLabel.text = self.user[@"bio"];
    [self.bioLabel sizeToFit];
}

-(void)setupUsernameLabel {
    self.usernameLabel.text = self.user[@"fullName"];
    [self.usernameLabel sizeToFit];
}
-(void)setupPageTitleLabel {
    self.pageTitleLabel.title = self.user.username;
}

-(void)setupCollectionView {
    // Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryForUser) forControlEvents:UIControlEventValueChanged];
    [self.profileCollectionView insertSubview:self.refreshControl atIndex:0];
    
    // Layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.5;
    layout.minimumLineSpacing = 2;
    
    // Delegates and stuff
    self.profileCollectionView.collectionViewLayout = layout;
    self.profileCollectionView.delegate = self;
    self.profileCollectionView.dataSource = self;
}

-(void)setupProfileImage {
    self.profileImage.file = self.user[@"image"];
    [self.profileImage loadInBackground];
}
-(void)setupEditProfileButton {
    self.editProfileButton.layer.cornerRadius = 5;
    self.editProfileButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.editProfileButton.layer.borderWidth = 0.5;
}
- (IBAction)tapOnProfileImage:(id)sender {
    [self setupImagePickerVC];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.usersPosts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileFeedCollectionViewCell *cell = [self.profileCollectionView dequeueReusableCellWithReuseIdentifier:@"profileFeedCell" forIndexPath:indexPath];
    
    Post *post = self.usersPosts[indexPath.item];
    PFUser *user = post[@"author"];
    
    cell.post = post;
    cell.user = user;
    cell.postImageView.file = post.image;
    [cell.postImageView loadInBackground];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/3 - 1.5, self.view.frame.size.width/3 - 1.5);
}


- (IBAction)editProfileButtonPressed:(id)sender {
    if (self.isCurrentUser) {
        [self performSegueWithIdentifier:@"editProfileSegue" sender:self.editProfileButton];
    }
}

-(IBAction)Back_btn:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) profileEdited {
    self.usernameLabel.text = PFUser.currentUser[@"fullName"];
    self.bioLabel.text = PFUser.currentUser[@"bio"];
    self.pageTitleLabel.title = PFUser.currentUser.username;
    self.profileImage.file = PFUser.currentUser[@"image"];
    [self.profileImage loadInBackground];
}

- (void)setupImagePickerVC {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    editedImage = [self resizeImage:editedImage withSize:CGSizeMake(375, 300)];
    originalImage = [self resizeImage:originalImage withSize:CGSizeMake(375, 300)];
    
    self.profileImage.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    
    PFUser *user = PFUser.currentUser;
    user[@"image"] = [self getPFFileFromImage:self.profileImage.image];
    [user saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (void) queryForUser {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            if ([self.refreshControl isRefreshing]) {
                self.usersPosts = [[NSMutableArray alloc] init];
            }
            for (Post *post in posts) {
                PFUser *user = post[@"author"];
                if ([user.objectId isEqualToString:self.user.objectId]) {
                    if ([self.refreshControl isRefreshing]) {
                        self.usersPosts = [NSMutableArray arrayWithArray:posts];
                    } else {
                        [self.usersPosts addObject:post];
                    }
                }
            }
            self.postCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.usersPosts.count];
            [self.profileCollectionView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([sender isKindOfClass:[ProfileFeedCollectionViewCell class]]) {
         ProfileFeedCollectionViewCell *cell = sender;
         PostDetailViewController *postDetailViewController = [segue destinationViewController];
         postDetailViewController.post = cell.post;
         postDetailViewController.user = cell.user;
     } else if ([sender isKindOfClass:[UIButton class]]) {
         EditProfileViewController *editProfileVC = [segue destinationViewController];
         editProfileVC.user = PFUser.currentUser;
         editProfileVC.delegate = self;
     }
 }


@end
