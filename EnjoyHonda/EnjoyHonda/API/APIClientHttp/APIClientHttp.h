#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface APIClientHttp : AFHTTPClient

+ (APIClientHttp *)sharedClient;

@end
