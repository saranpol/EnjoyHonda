//
//  API.h
//  TAT
//
//  Created by saranpol on 7/3/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import <Foundation/Foundation.h>


#define API_VERSION @"1.0"
#define API_HTTP @"http://www.honda.co.th/"
#define API_HTTPS @"https://www.honda.co.th/"
#define API_PREFIX @"/th/ios/api/"


#define M_hilight @"M_hilight_1"
#define M_models @"M_models_1"
#define M_model @"M_model_"

extern NSString *sShareURL;


typedef void (^APISuccess)(id);
typedef void (^APIFail)(NSError*);

@class PDViewController;

@interface API : NSObject

+ (API *)getAPI;

@property (nonatomic, strong) NSMutableDictionary *mClientInfoDict;
@property (nonatomic, strong) NSMutableDictionary *mDataDict;
@property (nonatomic, assign) BOOL mIsTablet;
//@property (nonatomic, assign) PDViewController *mVC;

// Persistence
- (id)getObject:(NSString*)key;
- (void)saveObject:(id)obj forKey:(NSString*)key;

// GA
- (void)trackScreen:(NSString*)screenName title:(NSString*)title;
- (void)trackEvent:(NSString*)screenName
             title:(NSString*)title
          category:(NSString*)category
            action:(NSString*)action
             label:(NSString*)label
             value:(NSNumber*)value;
- (void)trackStartApp;
- (void)trackEndApp;


// API
- (void)api_cancel_all_call;

- (void)api_hilight:(APISuccess)success
            failure:(APIFail)failure;

- (void)api_models:(APISuccess)success
           failure:(APIFail)failure;

- (void)api_model:(NSString*)model_id
          success:(APISuccess)success
          failure:(APIFail)failure;


// Image
- (void)loadImage:(UIImageView*)v url:(NSString*)url;

// Text
- (CGFloat)getHeightOfFont:(UIFont*)font w:(CGFloat)w text:(NSString*)text;


// Facebook
//- (BOOL)isFacebookLogin;
//- (void)loginFacebook:(FBSessionStateHandler)handler;
//- (void)logoutFacebook;

// USER
- (BOOL)isUserLogin;
- (NSDictionary*)getUser;
- (void)saveUser:(NSDictionary*)data;



@end




