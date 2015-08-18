//
//  LockGoogleProvider.m
//  LockGoogle
//
//  Created by Hernan Zalazar on 8/14/15.
//  Copyright (c) 2015 Auth0. All rights reserved.
//

#import "LockGoogleProvider.h"

@implementation LockGoogleProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        _authenticator = [A0GoogleAuthenticator newAuthenticator];
        _lock = [A0Lock newLock];
        _authenticator.clientProvider = _lock;

    }
    return self;
}

+ (LockGoogleProvider *)sharedInstance {
    static LockGoogleProvider *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LockGoogleProvider alloc] init];
    });
    return instance;
}

@end
