//
//  ADNUser.m
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import "ADNUser.h"
#import "ADNAvatar.h"

@implementation ADNUser

- (id)initWithJsonDictionary:(NSDictionary*)JSONDictionary
{
  self =[self init];
  if (self) {
    NSDictionary* userDictionary =[JSONDictionary objectForKey:@"user"];
    _userID =[userDictionary objectForKey:@"id"];
    _name =[userDictionary objectForKey:@"name"];
    _userName =[userDictionary objectForKey:@"username"];
    
    NSDictionary* avatarDictionary =[userDictionary objectForKey:@"avatar_image"];
    _avatar = [[ADNAvatar alloc] initWithJsonDictionary:avatarDictionary];
    
  }
  return self;
}

@end
