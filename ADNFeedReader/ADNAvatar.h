//
//  ADNAvatar.h
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADNAvatar : NSObject
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSNumber* height;
@property (nonatomic, strong) NSNumber* width;

- (id)initWithJsonDictionary:(NSDictionary*)JSONDictionary;

@end
