//
//  MVSBasicDownloadOperation.m
//
//  Created by Mario Sepulveda on 12/24/12.
//

#import "MVSBasicDownloadOperation.h"

NSInteger kMVSDOWNLOAD_REQUEST_TIMEOUT_DEFAULT =10;

static NSString* _kKVC_ERROR_KEY          =@"error";
static NSString* _kKVC_DATA_KEY           =@"data";
static NSString* _kKVC_CONNECTION_URL_KEY =@"connectionURL";
static NSString* _kKVC_SAVETOFILEPATH_KEY =@"saveToFilePath";
static NSString* _kKVC_MIMETYPE_KEY       =@"mimeType";
static NSString* _kKVC_REQUESTTIMEOUT_KEY =@"requestTimeOut";
static NSString* _kKVC_STATUSCODE_KEY     =@"statusCode";
static NSString* _kKVC_USERINFO_KEY       =@"userInfo";
static NSString* _kKVC_SHOULDUSEMD5OFURLSTRINGFORSAVETOFILEPATH_KEY =@"shouldUseMD5OfUrlStringForSaveToFilePath";

//static NSString* _kKVC__KEY =@"";

NSString* const kMVSDOWNLOAD_ERROR_DOMAIN =@"MVSBasicDownloadOperation";
NSString* const _kMIMETYPE_TEXT           =@"text";

NSString* const kKVO_IS_CANCELLED        =@"isCancelled";
NSString* const kKVO_IS_FINISHED         =@"isFinished";
NSString* const kKVO_IS_EXECUTING        =@"isExecuting";
//NSString* const _k

NSInteger _kHTTP_OK =200;

@implementation MVSBasicDownloadOperation

#pragma mark - KVC
//===========================================================
// - (void)setNilValueForKey:
//
//===========================================================
- (void)setNilValueForKey:(NSString *)theKey
{

  [super setNilValueForKey:theKey];
}

//===========================================================
// - (NSArray *)keyPaths
//
//===========================================================
- (NSArray *)keyPaths
{
  NSArray *result = [NSArray arrayWithObjects:
                     _kKVC_ERROR_KEY,
                     _kKVC_DATA_KEY,
                     _kKVC_CONNECTION_URL_KEY,
                     _kKVC_SAVETOFILEPATH_KEY,
                     _kKVC_MIMETYPE_KEY,
                     _kKVC_REQUESTTIMEOUT_KEY,
                     _kKVC_STATUSCODE_KEY,
                     _kKVC_SHOULDUSEMD5OFURLSTRINGFORSAVETOFILEPATH_KEY,
                     _kKVC_USERINFO_KEY,
                     nil];

  return result;
}

//===========================================================
// - (void)startObservingObject:
//
//===========================================================
- (void)startObservingObject:(id)thisObject
{
  if ([thisObject respondsToSelector:@selector(keyPaths)]) {
    NSArray *keyPathsArray = [thisObject keyPaths];
    for (NSString *keyPath in keyPathsArray) {
      [thisObject addObserver:self
                   forKeyPath:keyPath
                      options:NSKeyValueObservingOptionOld
                      context:NULL];
    }
  }
}
- (void)stopObservingObject:(id)thisObject
{
  if ([thisObject respondsToSelector:@selector(keyPaths)]) {
    NSArray *keyPathsArray = [thisObject keyPaths];
    for (NSString *keyPath in keyPathsArray) {
      [thisObject removeObserver:self
                      forKeyPath:keyPath];
    }
  }
}

//===========================================================
// - (NSString *)descriptionForKeyPaths
//
//===========================================================
- (NSString *)descriptionForKeyPaths
{
  NSMutableString *desc = [NSMutableString string];
  [desc appendString:@"\n\n"];
  [desc appendFormat:@"Class name: %@\n", NSStringFromClass([self class])];

  NSArray *keyPathsArray = [self keyPaths];
  for (NSString *keyPath in keyPathsArray) {
    [desc appendFormat: @"%@: %@\n", keyPath, [self valueForKey:keyPath]];
  }

  return [NSString stringWithString:desc];
}
- (NSString *)description
{
  return [self descriptionForKeyPaths];
}

//===========================================================
// + (BOOL)automaticallyNotifiesObserversForKey:
//
//===========================================================
+ (BOOL)automaticallyNotifiesObserversForKey: (NSString *)theKey
{
  if ([theKey isEqualToString:_kKVC_ERROR_KEY])          return NO;
  if ([theKey isEqualToString:_kKVC_DATA_KEY])           return NO;
  if ([theKey isEqualToString:_kKVC_CONNECTION_URL_KEY]) return NO;
  if ([theKey isEqualToString:_kKVC_SAVETOFILEPATH_KEY]) return NO;
  if ([theKey isEqualToString:_kKVC_MIMETYPE_KEY])       return NO;
  if ([theKey isEqualToString:_kKVC_REQUESTTIMEOUT_KEY]) return NO;
  if ([theKey isEqualToString:_kKVC_STATUSCODE_KEY])     return NO;
  if ([theKey isEqualToString:_kKVC_SHOULDUSEMD5OFURLSTRINGFORSAVETOFILEPATH_KEY]) return NO;
  if ([theKey isEqualToString:_kKVC_USERINFO_KEY])       return NO;
  if ([theKey isEqualToString:kKVO_IS_CANCELLED])       return NO;
  if ([theKey isEqualToString:kKVO_IS_FINISHED])       return NO;
  if ([theKey isEqualToString:kKVO_IS_EXECUTING])       return NO;
//  NSLog(@"theKey =%@", theKey);
  return [super automaticallyNotifiesObserversForKey:theKey];
}

#pragma mark - Initialization & Memory Management

- (id)initWithURL:(NSURL *)url
{
  return [self initWithURL:url
            saveToFilePath:nil];
}

- (id)initWithURL:(NSURL *)url
   saveToFilePath:(NSString*)saveToFilePath
{
  return [self initWithURL:url
            saveToFilePath:saveToFilePath
                  userInfo:nil];
}

- (id)initWithURL:(NSURL *)url
   saveToFilePath:(NSString*)saveToFilePath
         userInfo:(NSDictionary*)userInfo
{
  if( (self = [super init]) ) {
    _requestTimeOut =kMVSDOWNLOAD_REQUEST_TIMEOUT_DEFAULT;
    _connectionURL  =[url copy];
    _saveToFilePath =saveToFilePath;
    _userInfo       =userInfo;
    _shouldUseMD5OfUrlStringForSaveToFilePath =YES;
  }
  return self;  
}

- (void)dealloc
{
  if (_connection) [_connection cancel];
  _connection     = nil;
  _connectionURL  =nil;
  _data           =nil;
  _error          =nil;
}

#pragma mark - Start & Utility Methods

// This method is just for convenience. It cancels the URL connection if it
// still exists and finishes up the operation.
- (void)done
{
  if ( _connection ) [_connection cancel];
  _connection = nil;

  if (_observer) {
    // Alert anyone that we are finished
    [self willChangeValueForKey:kKVO_IS_EXECUTING];
    _executing = NO;
    [self didChangeValueForKey:kKVO_IS_EXECUTING];
    
    [self willChangeValueForKey:kKVO_IS_FINISHED];
    _finished  = YES;
    [self didChangeValueForKey:kKVO_IS_FINISHED];

//  } else {
//    NSLog(@"_observer is nil");
  }
}

- (void)canceled {
	// Code for being cancelled
  _error = [[NSError alloc] initWithDomain:kMVSDOWNLOAD_ERROR_DOMAIN
                                      code:123
                                  userInfo:nil];

  [self done];

}

- (void)start
{
  // Ensure that this operation starts on the main thread
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(start)
                           withObject:nil
                        waitUntilDone:NO];
    return;
  }

  // Ensure that the operation should exute
  if( _finished || [self isCancelled] ) {
    [self done];
    return;
  }

  // From this point on, the operation is officially executing--remember, isExecuting
  // needs to be KVO compliant!
  [self willChangeValueForKey:kKVO_IS_EXECUTING];
  _executing = YES;
  [self didChangeValueForKey:kKVO_IS_EXECUTING];

  // Create the NSURLConnection--this could have been done in init, but we delayed
  // until no in case the operation was never enqueued or was cancelled before starting
  NSURLRequest* request =[NSURLRequest requestWithURL:_connectionURL
                                          cachePolicy:NSURLRequestReloadIgnoringCacheData
                                      timeoutInterval:self.requestTimeOut];
  _connection = [[NSURLConnection alloc] initWithRequest:request
                                                delegate:self];
}


#pragma mark - Overrides

- (BOOL)isConcurrent
{
  return YES;
}

- (BOOL)isExecuting
{
  return _executing;
}

- (BOOL)isFinished
{
  return _finished;
}


#pragma mark - Delegate Methods for NSURLConnection

// The connection failed
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
  // Check if the operation has been cancelled
  if ([self isCancelled]) {
    [self canceled];
		return;
  }
	
//  _statusCode =NSNotFound;
  _data   =nil;
  _error  =[error copy];
  [self done];
}

// The connection received more data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  // Check if the operation has been cancelled
  if([self isCancelled]) {
    [self canceled];
		return;
  }

  [_data appendData:data];
}

// Initial response
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
  // Check if the operation has been cancelled
  if([self isCancelled]) {
    [self canceled];
		return;
  }

  NSHTTPURLResponse* httpResponse =(NSHTTPURLResponse*)response;
  _statusCode = [httpResponse statusCode];
//  NSLog(@"%@, statusCode: %i", httpResponse, _statusCode);
  if (_statusCode == _kHTTP_OK) {
    long long contentLength = [response expectedContentLength];
    if (contentLength == NSURLResponseUnknownLength) contentLength = 10240;
    _data = [[NSMutableData alloc] initWithCapacity:(NSUInteger)contentLength];
    _mimeType = [httpResponse.MIMEType copy];
    return;
  }
  
  NSString* statusError  = [NSString stringWithFormat:NSLocalizedString(@"HTTP Error: %ld", nil), _statusCode];
  NSDictionary* userInfo = [NSDictionary dictionaryWithObject:statusError forKey:NSLocalizedDescriptionKey];
  _error = [[NSError alloc] initWithDomain:kMVSDOWNLOAD_ERROR_DOMAIN
                                      code:_statusCode
                                  userInfo:userInfo];
  [self done];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  // Check if the operation has been cancelled
  if([self isCancelled]) {
    [self canceled];
		return;
  }
  
  if (self.data.length > 0) {
    if (self.shouldUseMD5OfUrlStringForSaveToFilePath && self.saveToFilePath.length == 0) {
      _saveToFilePath = [[self class] cacheFilePathByAppendingMD5OfString:self.connectionURL.absoluteString];
    }
    
    if (self.saveToFilePath.length > 0) {
      [self.data writeToFile:self.saveToFilePath
                  atomically:NO];
    }
  }
  
  [self done];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {

  if ([self.mimeType rangeOfString:_kMIMETYPE_TEXT].location == NSNotFound) {
    // cache everything that is not text
    return cachedResponse;
  }
  return nil;
}

#pragma mark - CUSTOM

+ (NSString*)cacheFilePathByAppendingFileName:(NSString*)fileName
{
  static NSString* cacheDirectoryPath =nil;
  if (cacheDirectoryPath ==nil) {
    NSArray* paths =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    cacheDirectoryPath =[paths objectAtIndex:0];
  }
  
	return [cacheDirectoryPath stringByAppendingPathComponent:fileName];
}

+ (NSString*)cacheFilePathByAppendingMD5OfString:(NSString*)stringToHash
{
  NSString* filename  =[self md5FromString: stringToHash];
	return    [[self class] cacheFilePathByAppendingFileName:filename];
}

+ (NSString *)md5FromString:(NSString*)stringToHash
{
	const char *cStr = [stringToHash UTF8String];
  NSUInteger length = strlen(cStr);
	unsigned char result[16];
	CC_MD5( cStr, (CC_LONG)length, result );
  
	NSString *upperCaseMd5 = [NSString stringWithFormat:
                            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                            result[0], result[1], result[2], result[3],
                            result[4], result[5], result[6], result[7],
                            result[8], result[9], result[10], result[11],
                            result[12], result[13], result[14], result[15]
                            ];
  
	return [upperCaseMd5 lowercaseString];
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
//  NSLog(@"observer =%@", observer);
  _observer =observer;
  [super addObserver:observer forKeyPath:keyPath options:options context:context];
}


static NSOperationQueue *_kSharedQueue = nil;
+ (NSOperationQueue*)sharedQueue
{
  static dispatch_once_t sharedOnceToken;
  dispatch_once(&sharedOnceToken, ^{
    _kSharedQueue = [[NSOperationQueue alloc] init];
  });
  return _kSharedQueue;
}

@end
