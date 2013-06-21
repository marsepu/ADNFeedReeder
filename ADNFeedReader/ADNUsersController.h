//
//  ADNUsersController.h
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADNUser.h"

@interface ADNUsersController : NSObject

+ (ADNUsersController *)shared;

- (ADNUser*)userForID:(id)userID;

- (void)storeUser:(ADNUser*)user;

- (void)inspectJSONData:(NSData*)jsonData;

@end
