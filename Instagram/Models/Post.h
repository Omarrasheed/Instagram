//
//  Post.h
//  Instagram
//
//  Created by Omar Rasheed on 7/9/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse.h"

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString * _Nonnull postID;
@property (nonatomic, strong) NSString * _Nonnull userID;
@property (nonatomic, strong) PFUser * _Nonnull author;

@property (nonatomic, strong) NSString * _Nullable caption;
@property (nonatomic, strong) PFFile * _Nonnull image;
@property (nonatomic, strong) NSNumber * _Nonnull likeCount;
@property (nonatomic, strong) NSNumber * _Nonnull commentCount;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption location:(NSString *_Nullable)location withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
