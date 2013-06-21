//
//  ADNPost.h
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADNPost : NSObject
@property (nonatomic, strong) NSNumber* postID;
@property (nonatomic, strong) NSNumber* userID;
@property (nonatomic, strong) NSString* text;
@property (nonatomic) CGFloat heightInTableviewCell;

- (id)initWithJsonDictionary:(NSDictionary*)JSONDictionary;
@end
