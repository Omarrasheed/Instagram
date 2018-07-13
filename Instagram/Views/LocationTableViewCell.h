//
//  LocationTableViewCell.h
//  Instagram
//
//  Created by Omar Rasheed on 7/11/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;

- (void)updateWithLocation:(NSDictionary *)location;

@end
