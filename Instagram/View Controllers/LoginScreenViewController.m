//
//  ViewController.m
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "LoginScreenViewController.h"
#import "Parse.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"

@interface LoginScreenViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;

@end

@implementation LoginScreenViewController
- (IBAction)viewTapped:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.PasswordTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIColor *topColor = [UIColor colorWithRed:241.0/255.0 green:178.0/255.0 blue:122.0/255.0 alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithRed:219.0/255.0 green:86.0/255.0 blue:147.0/255.0 alpha:1.0];
    
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    
    //Add gradient to view
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}
- (IBAction)loginButtonPressed:(id)sender {
    if (![self.usernameTextField.text isEqual:@""] || ![self.PasswordTextField.text isEqual:@""]) {
        [self loginUser: self.usernameTextField.text password:self.PasswordTextField.text];
    } else {
        [self createAlert:@"Please complete all fields"];
    }
}

- (IBAction)registerButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"registerSegue" sender:self.registerButton];
}

- (void)loginUser: (NSString *)username password:(NSString *)password {
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self createAlert:@"Invalid Username/Password"];
        } else {
            NSLog(@"User logged in successfully");
            
            [self performSegueWithIdentifier:@"loginSegue" sender:self.registerButton];
        }
    }];
}

- (void)createAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                         }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
