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

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, cameraPostDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    self.postsTableView.rowHeight = UITableViewAutomaticDimension;
    self.postsTableView.estimatedRowHeight = 300;
    
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    Post *post = self.posts[section];
//    PFUser *user = post[@"author"];
//    return user.username;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    
    Post *post = self.posts[section];
    PFUser *user = post.author;
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, tableView.frame.size.width, 40)];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    label.text = user.username;
    [headerView addSubview:label];
    
    PFImageView *image = [[PFImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    image.file = user[@"image"];
    [image loadInBackground];
    image.layer.cornerRadius = 20;
    image.clipsToBounds = YES;
    [headerView addSubview:image];
    return headerView;
}

- (void)pullPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.postsTableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
