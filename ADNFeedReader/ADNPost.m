//
//  ADNPost.m
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import "ADNPost.h"

@implementation ADNPost

- (id)initWithJsonDictionary:(NSDictionary*)JSONDictionary
{
  self =[self init];
  if (self) {
    _postID =[JSONDictionary objectForKey:@"id"];
    _text =[JSONDictionary objectForKey:@"text"];
    _text =[_text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDictionary* user =[JSONDictionary objectForKey:@"user"];
    _userID =[user objectForKey:@"id"];
  }
  return self;
}
@end
