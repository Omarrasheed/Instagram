//
//  CameraPostViewController.h
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cameraPostDelegate

-(void)didPost;

@end

@interface CameraPostViewController : UIViewController

@property (weak, nonatomic) id<cameraPostDelegate> delegate;
@property BOOL posting;

@end
