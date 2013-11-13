//
//  EHAppDelegate.m
//  EnjoyHonda
//
//  Created by saranpol on 9/25/56 BE.
//  Copyright (c) 2556 saranpol. All rights reserved.
//

#import "EHAppDelegate.h"

@implementation EHAppDelegate

// #CLEAR_CRASH_BEGIN
static NSString *sCLEAR_CRASH = @"CLEAR_CRASH";
// #CLEAR_CRASH_END

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // #CLEAR_CRASH_BEGIN
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:sCLEAR_CRASH]){
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [ud removePersistentDomainForName:appDomain];
    }
    [ud setObject:[NSNumber numberWithInt:1] forKey:sCLEAR_CRASH];
	[ud synchronize];
    // #CLEAR_CRASH_END
    
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]];
    
    [NSThread sleepForTimeInterval:1.0];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    // #CLEAR_CRASH_BEGIN
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:sCLEAR_CRASH];
	[ud synchronize];
    // #CLEAR_CRASH_END
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
