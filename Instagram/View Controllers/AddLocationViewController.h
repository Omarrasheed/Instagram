//
//  AddLocationViewController.h
//  Instagram
//
//  Created by Omar Rasheed on 7/11/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol locationViewDelegate

- (void)sendLocationTitle:(NSString *)locationTitle;

@end

@interface AddLocationViewController : UIViewController

@property (weak, nonatomic) id<locationViewDelegate> delegate;

@end
