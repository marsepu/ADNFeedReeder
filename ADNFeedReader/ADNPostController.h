//
//  ADNPostController.h
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kADNPOSTCONTROLLER_NOTE_TIMELINE_REFRESHED;

@interface ADNPostController : NSObject

- (void)refreshTimeline;

- (NSArray*)timeline;

- (NSData*)lastJSONData;

+ (ADNPostController *)shared;

@end
