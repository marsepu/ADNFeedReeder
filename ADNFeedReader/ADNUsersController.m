//
//  ADNUsersController.m
//  ADNFeedReader
//
//  Created by Mario Sepulveda on 6/19/13.
//  Copyright (c) 2013 Mario Sepulveda. All rights reserved.
//

#import "ADNUsersController.h"

static ADNUsersController *_kShared = nil;

@interface ADNUsersController ()
@property (nonatomic, strong) NSMutableDictionary* users;
@end

@implementation ADNUsersController

+ (ADNUsersController *)shared
{
  static dispatch_once_t sharedOnceToken;
  dispatch_once(&sharedOnceToken, ^{
    _kShared = [[ADNUsersController alloc] init];
  });
  return _kShared;
}

- (id)init
{
  self =[super init];
  if (self) {
    _users =[NSMutableDictionary new];
  }
  return self;
}

- (ADNUser*)userForID:(id)userID
{
  return [self.users objectForKey:userID];
}

- (void)storeUser:(ADNUser*)user
{
  [[self users] setObject:user forKey:user.userID];
}

- (void)inspectJSONData:(NSData*)jsonData
{
  NSArray* newUsers =[[self class] objectsFromJSONData:jsonData
                                                forKey:@"data"];
  for (ADNUser* aUser in newUsers) {
    [self storeUser:aUser];
  }
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
    ADNUser* object =[[ADNUser alloc] initWithJsonDictionary:objectData];
    [result addObject:object];
  }
  
  if (result.count ==0) return nil;
  return result;
}
@end
