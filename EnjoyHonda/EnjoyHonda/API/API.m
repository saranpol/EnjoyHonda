//
//  API.m
//  TAT
//
//  Created by saranpol on 7/3/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "API.h"
#import "AFNetworking.h"
#import "APIClientHttp.h"
#import "APIClientHttps.h"
#import "UIImageView+WebCache.h"
//#import "GAI.h"
//#import "GAIDictionaryBuilder.h"
//#import "GAIFields.h"

@implementation API

@synthesize mClientInfoDict;
@synthesize mDataDict;

static API *instance;

// SAVE KEY
static NSString *M_USER_DATA = @"M_USER_DATA_1";
NSString *sShareURL = @"http://thailandweddingshoneymoons.com";


+ (API*)getAPI {
    if (instance == nil) {
        instance = [[API alloc] init];
    }
    return instance;
}

- (API*)init {
    API *a = [super init];
    
    self.mDataDict = [[NSMutableDictionary alloc] init];
    
    [self initGA];
    
    // #FACEBOOK_BEGIN
//    [self checkFacebookLoginCache];
    // #FACEBOOK_END
    
    
    self.mClientInfoDict = [[NSMutableDictionary alloc] init];
    [mClientInfoDict setValue:API_VERSION forKey:@"apiv"];
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	[mClientInfoDict setValue:appVersionString forKey:@"appv"];
	[mClientInfoDict setValue:@"ios" forKey:@"platform"];
    NSString *mid = [UIDevice currentDevice].model;
	[mClientInfoDict setValue:mid forKey:@"mid"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int w = (int)screenRect.size.width;
    int h = (int)screenRect.size.height;
    int tablet = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        tablet = 1;
        self.mIsTablet = YES;
    }
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        w = w*2;
        h = h*2;
    }
    
    [mClientInfoDict setObject:[NSString stringWithFormat:@"%d", w] forKey:@"w"];
    [mClientInfoDict setObject:[NSString stringWithFormat:@"%d", h] forKey:@"h"];
    [mClientInfoDict setObject:[NSString stringWithFormat:@"%d", tablet] forKey:@"tablet"];
    
    
    return a;
}




// #PERSISTENCE_BEGEIN
#pragma mark - PERSISTENCE

- (id)getObject:(NSString*)key {
    id obj;
    obj = [mDataDict objectForKey:key];
    if(!obj){
        obj = [self loadObject:key];
        if(obj)
            [mDataDict setObject:obj forKey:key];
    }
    return obj;
}

- (id)loadObject:(NSString*)key {
	NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	NSData *d = [u objectForKey:key];
	if(d){
		id obj = [NSKeyedUnarchiver unarchiveObjectWithData:d];
		return obj;
	}
	return nil;
}

- (void)saveObject:(id)obj forKey:(NSString*)key {
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
	NSData *d = [NSKeyedArchiver archivedDataWithRootObject:obj];
	[u setObject:d forKey:key];
	[u setObject:[NSDate date] forKey:[key stringByAppendingString:@"Date"]];
    [u synchronize];
    [mDataDict setObject:obj forKey:key];
}

- (void)deleteObject:(NSString*)key {
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    [u removeObjectForKey:key];
    [u synchronize];
    [mDataDict removeObjectForKey:key];
}

// #PERSISTENCE_END





// #GA_BEGIN
- (void)initGA {
//    // Optional: automatically send uncaught exceptions to Google Analytics.
//    [GAI sharedInstance].trackUncaughtExceptions = YES;
//    
//    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
//    [GAI sharedInstance].dispatchInterval = 20;
//    
//    // Optional: set Logger to VERBOSE for debug information.
//    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
//    
//    // Initialize tracker.
//    [[GAI sharedInstance] trackerWithTrackingId:@"UA-43746789-1"];
}

- (void)trackScreen:(NSString*)screenName title:(NSString*)title {
//    id<GAITracker> defaultTracker = [[GAI sharedInstance] defaultTracker];
//    [defaultTracker send:[[[[GAIDictionaryBuilder createAppView]
//                            set:screenName forKey:kGAIScreenName]
//                           set:title forKey:kGAITitle]
//                          build]];
}

- (void)trackEvent:(NSString*)screenName
             title:(NSString*)title
          category:(NSString*)category
            action:(NSString*)action
             label:(NSString*)label
             value:(NSNumber*)value {
//    id<GAITracker> defaultTracker = [[GAI sharedInstance] defaultTracker];
//
//    [defaultTracker send:[[[[GAIDictionaryBuilder createEventWithCategory:category
//                                                                 action:action
//                                                                  label:label
//                                                                  value:value]
//                            set:screenName forKey:kGAIScreenName]
//                           set:title forKey:kGAITitle]
//                          build]];
}

- (void)trackStartApp {
//    id<GAITracker> defaultTracker = [[GAI sharedInstance] defaultTracker];
//    [defaultTracker send:[[[GAIDictionaryBuilder createEventWithCategory:@"App" action:@"Start" label:nil value:nil]
//                          set:@"start" forKey:kGAISessionControl]
//                          build]];
}

- (void)trackEndApp {
//    id<GAITracker> defaultTracker = [[GAI sharedInstance] defaultTracker];
//    [defaultTracker set:kGAISessionControl value:@"end"];
//    [defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
}

// #GA_END







// #API_BEGIN
#pragma mark - API

- (NSMutableDictionary*)initialParam {
    return [NSMutableDictionary dictionaryWithDictionary:mClientInfoDict];
}

- (void)api_cancel_all_call {
    [[[APIClientHttps sharedClient] operationQueue] cancelAllOperations];
    [[[APIClientHttp sharedClient] operationQueue] cancelAllOperations];
}

- (void)api_call:(NSString*)api_name
           https:(BOOL)https
          params:(NSMutableDictionary*)params
         success:(APISuccess)success
         failure:(APIFail)failure
{
    NSString *postPath = [API_PREFIX stringByAppendingString:api_name];
    
    if(https){
        [[APIClientHttps sharedClient] getPath:postPath
                                     parameters:params
                                        success:^(AFHTTPRequestOperation *operation, id JSON) {
                                            success(JSON);
                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                            failure(error);
                                        }];
    }else{
        [[APIClientHttp sharedClient] getPath:postPath
                                    parameters:params
                                       success:^(AFHTTPRequestOperation *operation, id JSON) {
                                           success(JSON);
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                           failure(error);
                                       }];
    }
}



- (void)api_hilight:(APISuccess)success
            failure:(APIFail)failure
{
    NSMutableDictionary *params = [self initialParam];
    [self api_call:@"hilight" https:NO params:params success:success failure:failure];
}

- (void)api_models:(APISuccess)success
           failure:(APIFail)failure
{
    NSMutableDictionary *params = [self initialParam];
    [self api_call:@"" https:NO params:params success:success failure:failure];
}

- (void)api_model:(NSString*)model_id
          success:(APISuccess)success
          failure:(APIFail)failure {
    NSMutableDictionary *params = [self initialParam];
    [self api_call:[NSString stringWithFormat:@"model/%@", model_id] https:NO params:params success:success failure:failure];
    
}



//- (void)api_login_facebook_id:(NSString*)facebook_id
//        facebook_access_token:(NSString*)facebook_access_token
//                      success:(APISuccess)success
//                      failure:(APIFail)failure
//{
//    NSMutableDictionary *params = [self initialParam];
//    [params setObject:facebook_id forKey:@"facebook_id"];
//    [params setObject:facebook_access_token forKey:@"facebook_access_token"];
//    
//    [self api_call:@"user/login.json" https:NO params:params success:success failure:failure];
//}

// #API_ONLINE_END


    
    

// #Image
- (void)loadImage:(UIImageView*)v url:(NSString*)url {
    UIImageView *iv = v;
    [v setImageWithURL:[NSURL URLWithString:url]
             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                 if(cacheType!=SDImageCacheTypeMemory){
                     [iv setAlpha:0.0];
                     [UIView animateWithDuration:0.3 animations:^{
                         [iv setAlpha:1.0];
                     }];
                 }
             }];
}


// Text
- (CGFloat)getHeightOfFont:(UIFont*)font w:(CGFloat)w text:(NSString*)text {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){w, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size.height;
}








// #FACEBOOK_BEGIN
#pragma mark - FACEBOOK
//
//- (BOOL)isFacebookLogin {
//    if(FBSession.activeSession && [FBSession activeSession].isOpen)
//        return YES;
//    return NO;
//}
//
//- (void)checkFacebookLoginCache {
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        [self loginFacebook:^(FBSession *session, FBSessionState state, NSError *error) {}];
//    }
//}
//
//- (void)loginFacebook:(FBSessionStateHandler)handler {
//    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:handler];
//}
//
//- (void)logoutFacebook {
//    [FBSession.activeSession closeAndClearTokenInformation];
//    [self deleteUser];
//}
// #FACEBOOK_END


// #USER_BEGIN

- (BOOL)isUserLogin {
    NSDictionary *data = [self getObject:M_USER_DATA];
    if(data)
        return YES;
    return NO;
}

- (NSDictionary*)getUser {
    return [self getObject:M_USER_DATA];
}

- (void)saveUser:(NSDictionary*)data {
    [self saveObject:data forKey:M_USER_DATA];
}

- (void)deleteUser {
    [self deleteObject:M_USER_DATA];
}
// #USER_END




@end
