#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface APIClientHttps : AFHTTPClient

+ (APIClientHttps *)sharedClient;

@end
