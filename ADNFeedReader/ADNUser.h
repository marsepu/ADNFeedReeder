//
//  ADNUser.h
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADNAvatar;

@interface ADNUser : NSObject
@property (nonatomic, strong) NSNumber* userID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) ADNAvatar* avatar;

- (id)initWithJsonDictionary:(NSDictionary*)JSONDictionary;
@end
