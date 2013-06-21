//
//  MVSTableViewCell.h
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVSTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel* userNameLabel;
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UILabel* postTextLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier;
+ (NSString*)reusableCellIdentifier;
+ (CGFloat)minHeight;
+ (CGFloat)cellHeightFromPostText:(NSString*)postText;

@end
