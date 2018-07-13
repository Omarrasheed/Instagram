//
//  HomeViewController.h
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeViewDelegate

-(void)doubleTapHit;

@end

@interface HomeViewController : UIViewController

@property (weak, nonatomic) id<HomeViewDelegate> delegate;

@end

