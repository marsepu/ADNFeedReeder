//
//  MVSBasicDownloadOperation.h
//
//  Created by Mario Sepulveda on 12/24/12.


/* EXAMPLE
 NSOperationQueue *operationQueue = [NSOperationQueue new];
 MVSBasicDownloadOperation *operation = [[MVSBasicDownloadOperation alloc] initWithURL:[NSURL URLWithString:@"http://www.example.com"]];
 [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
 [operationQueue addOperation:operation]; // operation starts as soon as its added
 [operation release];
*/

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>

extern NSInteger kMVSDOWNLOAD_REQUEST_TIMEOUT_DEFAULT;
extern NSString* const kMVSDOWNLOAD_ERROR_DOMAIN;

extern NSString* const kKVO_IS_CANCELLED;
extern NSString* const kKVO_IS_FINISHED;
extern NSString* const kKVO_IS_EXECUTING;


enum MVSFileExistsEnum {
  MVSFileExistsIsUnknown =-1,
  MVSFileDoesNotExist    =0,
  MVSFileExists          =1
};
typedef NSUInteger MVSFileExistsEnum;


//@"xml"
@interface MVSBasicDownloadOperation :  NSOperation {
  BOOL _executing;
  BOOL _finished;

  NSURLConnection*  _connection;
}

@property (nonatomic, readonly) NSError*        error;
@property (nonatomic, readonly) NSMutableData*  data;
@property (nonatomic, readonly) NSURL*          connectionURL;
@property (nonatomic, readonly) NSString*       saveToFilePath;
@property (nonatomic, readonly) NSString*       mimeType;
@property (nonatomic, readonly) NSInteger       requestTimeOut;
@property (nonatomic, readonly) NSInteger       statusCode;

@property (nonatomic, readonly) NSDictionary*   userInfo;
@property (nonatomic)           BOOL            shouldUseMD5OfUrlStringForSaveToFilePath;
@property (nonatomic, weak) id observer;

- (id)initWithURL:(NSURL*)url;

- (id)initWithURL:(NSURL *)url
   saveToFilePath:(NSString*)saveToFilePath;

- (id)initWithURL:(NSURL *)url
   saveToFilePath:(NSString*)saveToFilePath
         userInfo:(NSDictionary*)userInfo;

+ (NSString*)cacheFilePathByAppendingFileName:(NSString*)fileName;
+ (NSString*)cacheFilePathByAppendingMD5OfString:(NSString*)stringToHash;
+ (NSString*)md5FromString:(NSString*)stringToHash;

+ (NSOperationQueue*)sharedQueue;
@end
