//
//  ADNPostController.m
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import "ADNPostController.h"

#import "MVSBasicDownloadOperation.h"
#import "ADNPost.h"
#import "ADNUsersController.h"

NSString* const kADNPOSTCONTROLLER_NOTE_TIMELINE_REFRESHED =@"kADNPOSTCONTROLLER_NOTE_TIMELINE_REFRESHED";

static ADNPostController *_kShared = nil;

@interface ADNPostController ()
@property (nonatomic, strong) NSArray* posts;
@property (nonatomic, strong) NSData* lastJSONData;
@end

@implementation ADNPostController


+ (ADNPostController *)shared
{
  static dispatch_once_t sharedOnceToken;
  dispatch_once(&sharedOnceToken, ^{
    _kShared = [[ADNPostController alloc] init];
  });
  return _kShared;
}

- (void)refreshTimeline
{
  NSURL* url =[NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
  MVSBasicDownloadOperation* operation =[[MVSBasicDownloadOperation alloc] initWithURL:url];
  
  [operation addObserver:self
              forKeyPath:kKVO_IS_FINISHED
                 options:NSKeyValueObservingOptionNew
                 context:NULL];
  
  [[MVSBasicDownloadOperation sharedQueue] addOperation:operation];
  [[MVSBasicDownloadOperation sharedQueue] setSuspended:NO];
}

- (NSArray*)timeline
{
  return [self.posts copy];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)operation
                        change:(NSDictionary *)change
                       context:(void *)context
{
  
  if (keyPath == kKVO_IS_FINISHED && [operation isFinished] == NO) return;
  
  [operation removeObserver:self
                 forKeyPath:kKVO_IS_FINISHED
                    context:NULL];
  
  if ([operation isKindOfClass:[MVSBasicDownloadOperation class]]) {
    [self _downloadFinished:operation];
    return;
  }
  
  [super observeValueForKeyPath:keyPath
                       ofObject:operation
                         change:change
                        context:context];
}

-(void)_downloadFinished:(MVSBasicDownloadOperation*)downloadOperation
{
  self.lastJSONData =[downloadOperation.data copy];
  self.posts =[[self class] objectsFromJSONData:downloadOperation.data
                                         forKey:@"data"];
  
  [[ADNUsersController shared] inspectJSONData:self.lastJSONData];

  [[NSNotificationCenter defaultCenter] postNotificationName:kADNPOSTCONTROLLER_NOTE_TIMELINE_REFRESHED
                                                      object:self];
}

+ (NSArray*)objectsFromJSONData:(NSData *)data
                         forKey:(NSString*)theKey
{
  if (data ==nil) return nil;
  
  NSDictionary* json =[NSJSONSerialization JSONObjectWithData:data
                                                      options:kNilOptions
                                                        error:nil];
  if (json ==nil) return nil;
  
  if (theKey ==nil) theKey =@"objects";
  
  NSArray* objects =[json objectForKey:theKey];
  return [self objectsFromJSONArray:objects];
}

+ (NSArray*)objectsFromJSONDictionary:(NSDictionary*)json
                               forKey:(NSString*)theKey
{
  if (json ==nil) return nil;
  NSArray* objects =[json objectForKey:theKey];
  return [self objectsFromJSONArray:objects];
}

+ (NSArray*)objectsFromJSONArray:(NSArray*)objects
{
  if (objects.count ==0) {
    NSLog(@"no objects were recieved!");
    return nil;
  }
  
  NSMutableArray* result =[[NSMutableArray alloc] init];
  for (NSDictionary* objectData in objects) {
    ADNPost* post =[[ADNPost alloc] initWithJsonDictionary:objectData];
    [result addObject:post];
  }
  
  if (result.count ==0) return nil;
  return result;
}

- (NSData*)lastJSONData
{
  return [_lastJSONData copy];
}

@end
