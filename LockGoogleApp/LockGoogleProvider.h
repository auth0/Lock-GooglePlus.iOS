//
//  LockGoogleProvider.h
//  LockGoogle
//
//  Created by Hernan Zalazar on 8/14/15.
//  Copyright (c) 2015 Auth0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LockGoogle/LockGoogle.h>
#import <Lock/A0Lock.h>

@interface LockGoogleProvider : NSObject

@property (strong, readonly, nonatomic) A0GoogleAuthenticator *authenticator;
@property (strong, readonly, nonatomic) A0Lock *lock;

+ (LockGoogleProvider *)sharedInstance;

@end
