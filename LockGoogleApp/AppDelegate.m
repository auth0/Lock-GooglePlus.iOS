//
//  AppDelegate.m
//  LockGoogleApp
//
//  Created by Hernan Zalazar on 8/14/15.
//  Copyright (c) 2015 Auth0. All rights reserved.
//

#import "AppDelegate.h"
#import "LockGoogleProvider.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[[LockGoogleProvider sharedInstance] authenticator] applicationLaunchedWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[[LockGoogleProvider sharedInstance] authenticator] handleURL:url sourceApplication:sourceApplication];
}

@end
