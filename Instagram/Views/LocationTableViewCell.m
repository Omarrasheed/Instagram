//
//  LocationTableViewCell.m
//  Instagram
//
//  Created by Omar Rasheed on 7/11/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "LocationTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation LocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithLocation:(NSDictionary *)location {
    self.locationTitle.text = location[@"name"];
    self.locationAddress.text = [location valueForKeyPath:@"location.address"];
    
    NSArray *categories = location[@"categories"];
    if (categories && categories.count > 0) {
        NSDictionary *category = categories[0];
        NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
        NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
        NSString *urlString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        
        NSURL *url = [NSURL URLWithString:urlString];
        [self.locationImage setImageWithURL:url];
    }
}


@end
