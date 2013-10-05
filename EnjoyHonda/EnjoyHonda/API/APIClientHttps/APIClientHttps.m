#import "APIClientHttps.h"
#import "AFJSONRequestOperation.h"
#import "API.h"

@implementation APIClientHttps

+ (APIClientHttps *)sharedClient {
    static APIClientHttps *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClientHttps alloc] initWithBaseURL:[NSURL URLWithString:API_HTTPS]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
