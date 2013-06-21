//
//  ADNAvatar.m
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import "ADNAvatar.h"

@implementation ADNAvatar

- (id)initWithJsonDictionary:(NSDictionary*)JSONDictionary
{
  self =[self init];
  if (self) {
    _url =[JSONDictionary objectForKey:@"url"];
    _height =[JSONDictionary objectForKey:@"height"];
    _width =[JSONDictionary objectForKey:@"width"];
    
  }
  return self;
}


@end
