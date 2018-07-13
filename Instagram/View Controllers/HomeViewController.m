//
//  HomeViewController.m
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "HomeViewController.h"
#import "RegisterViewController.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "LoginScreenViewController.h"
#import "PostTableViewCell.h"
#import "Post.h"
#import "CameraPostViewController.h"
#import "PostDetailViewController.h"
#import "MBProgressHUD.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, cameraPostDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    self.postsTableView.rowHeight = UITableViewAutomaticDimension;
    self.postsTableView.estimatedRowHeight = 300;
    self.postsTableView.allowsSelection = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullPosts) forControlEvents:UIControlEventValueChanged];
    [self.postsTableView insertSubview:self.refreshControl atIndex:0];
    
    self.tabBarController.delegate = self;
    
    [self pullPosts];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [self.postsTableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.section];
    PFUser *user = post[@"author"];
    cell.post = post;
    cell.user = user;
    [cell setPost];
    
    cell.postImage.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 2;
    [cell.postImage addGestureRecognizer:tap];
    
    cell.postImage.userInteractionEnabled = YES;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (IBAction)logoutButtonPressed:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if (!error) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginScreenViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreenViewController"];
            appDelegate.window.rootViewController = loginViewController;
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.posts count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    Post *post = self.posts[section];
    PFUser *user = post.author;
    /* Create custom view to display section header... */
    UILabel *usernamelabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, tableView.frame.size.width, 20)];
    [usernamelabel setFont:[UIFont boldSystemFontOfSize:16]];
    usernamelabel.text = user.username;
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, tableView.frame.size.width, 20)];
    [locationLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightLight]];
    NSString *locationText = post[@"location"];
    if ([locationText isEqual:@"Select a location..."]) {
        locationLabel.text = @"";
        usernamelabel.frame = CGRectMake(50, 15, tableView.frame.size.width, 20);
    } else {
        locationLabel.text = locationText;
    }
    
    
    PFImageView *image = [[PFImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    image.file = user[@"image"];
    [image loadInBackground];
    image.layer.cornerRadius = 20;
    image.clipsToBounds = YES;
    
    [headerView addSubview:locationLabel];
    [headerView addSubview:usernamelabel];
    [headerView addSubview:image];
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.postsTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.postsTableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.postsTableView.isDragging) {
            self.isMoreDataLoading = true;
            
            
        }
    }
}

-(void)didPost {
    [self pullPosts];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[CameraPostViewController class]]) {
        CameraPostViewController *cameraPostViewController = (CameraPostViewController *) viewController;
        cameraPostViewController.delegate = self;
        cameraPostViewController.posting = NO;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        // handling code
        CGPoint location = [recognizer locationInView:self.postsTableView];
        NSIndexPath *indexPath = [self.postsTableView indexPathForRowAtPoint:location];
        PostTableViewCell *cell = [self.postsTableView cellForRowAtIndexPath:indexPath];
        self.delegate = cell;
        [self.delegate doubleTapHit];
    }
}

- (void)pullPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = [[NSMutableArray alloc] initWithArray: posts];
            [self.postsTableView reloadData];
            [self.refreshControl endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:true];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)pullMorePosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.skip = [self.posts count];
    
    // fetch data asynchronously
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            for (Post *post in posts) {
                [self.posts addObject:post];
            }
            self.isMoreDataLoading = false;
            [self.postsTableView reloadData];
            [self.refreshControl endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:true];
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
    PostTableViewCell *cell = sender;
    PostDetailViewController *postDetailViewController = [segue destinationViewController];
    postDetailViewController.post = cell.post;
    postDetailViewController.user = cell.user;
}

@end
