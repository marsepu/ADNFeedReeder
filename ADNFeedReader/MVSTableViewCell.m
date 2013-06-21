//
//  MVSTableViewCell.m
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import "MVSTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

static NSMutableDictionary *_kSizesForPostText = nil;

@interface MVSTableViewCell ()
+ (NSMutableDictionary *)sizesForPostText;
@end

@implementation MVSTableViewCell

+ (NSMutableDictionary *)sizesForPostText
{
  static dispatch_once_t sharedOnceToken;
  dispatch_once(&sharedOnceToken, ^{
    _kSizesForPostText = [NSMutableDictionary new];
  });
  return _kSizesForPostText;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.opaque =YES;
    
    _userNameLabel =[[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_userNameLabel];
    _userNameLabel.font =[UIFont boldSystemFontOfSize:16];
    _userNameLabel.opaque =YES;

    _postTextLabel =[[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_postTextLabel];
    _postTextLabel.numberOfLines =0;
    _postTextLabel.font =[UIFont systemFontOfSize:[UIFont systemFontSize]];
    _postTextLabel.lineBreakMode =NSLineBreakByWordWrapping;
    _postTextLabel.opaque =YES;
    
    _avatarImageView =[[UIImageView alloc] initWithFrame:CGRectZero];
    CALayer * l = [_avatarImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    [self.contentView addSubview:_avatarImageView];
  }
  return self;
}

+ (NSString*)reusableCellIdentifier
{
  return @"MVSTableViewCell";
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  _avatarImageView.frame =CGRectMake(8, 8, 64, 64);
  
  CGFloat width =self.frame.size.width-96;
  _userNameLabel.frame =CGRectMake(80, 8, width, 16);
  
  NSValue* sizeValue =[[[self class] sizesForPostText] objectForKey:self.postTextLabel.text];
  if (sizeValue) {
    CGSize size =[sizeValue CGSizeValue];
    _postTextLabel.frame =CGRectMake(80, 24, width, size.height);
  } else {
    _postTextLabel.frame =CGRectMake(80, 24, width, 80);
  }
}

+ (CGFloat)minHeight
{
  return 80;
}

+ (CGFloat)cellHeightFromPostText:(NSString*)postText
{
  CGSize size =[[self class] sizeForPostText:postText];
  return size.height +32;
}

+ (CGSize)calculateSizeForPostText:(NSString*)postText
{
  CGSize size = [postText sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
                     constrainedToSize:CGSizeMake(224, 320)
                         lineBreakMode:NSLineBreakByWordWrapping];
  return size;
}

+ (CGSize)sizeForPostText:(NSString*)postText
{
  CGSize size;
  NSValue* sizeValue =[[[self class] sizesForPostText] objectForKey:postText];
  if (sizeValue ) {
    size =[sizeValue CGSizeValue];
  } else {
    size =[[self class] calculateSizeForPostText:postText];
    sizeValue =[NSValue valueWithCGSize:size];
    [[[self class] sizesForPostText] setObject:sizeValue forKey:postText];
  }
  return size;
}

@end
