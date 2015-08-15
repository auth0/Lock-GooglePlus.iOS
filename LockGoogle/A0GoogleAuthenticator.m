// A0GoogleAuthenticator.m
//
// Copyright (c) 2015 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "A0GoogleAuthenticator.h"
#import <Lock/A0Strategy.h>
#import <Lock/A0APIClient.h>
#import <Lock/A0IdentityProviderCredentials.h>
#import <Lock/A0Errors.h>
#import <Lock/A0AuthParameters.h>
#import <UIKit/UIKit.h>
#import "A0GoogleProvider.h"

#define A0LogError(fmt, ...)
#define A0LogVerbose(fmt, ...)
#define A0LogDebug(fmt, ...)

@interface A0GoogleAuthenticator ()

@property (strong, nonatomic) A0GoogleProvider *google;

@end

@implementation A0GoogleAuthenticator

- (instancetype)initWithClientId:(NSString *)clientId {
    return [self initWithClientId:clientId scopes:nil];
}

- (instancetype)initWithClientId:(NSString *)clientId scopes:(NSArray *)scopes {
    self = [super init];
    if (self) {
        _google = [[A0GoogleProvider alloc] initWithClientId:clientId scopes:scopes];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)newAuthenticatorWithClientId:(NSString *)clientId {
    return [[A0GoogleAuthenticator alloc] initWithClientId:clientId];
}

+ (instancetype)newAuthenticatorWithClientId:(NSString *)clientId andScopes:(NSArray *)scopes {
    return [[A0GoogleAuthenticator alloc] initWithClientId:clientId scopes:scopes];
}

- (NSString *)identifier {
    return @"google-oauth2";
}

- (void)authenticateWithParameters:(A0AuthParameters *)parameters
                           success:(void (^)(A0UserProfile *, A0Token *))success
                           failure:(void (^)(NSError *))failure {
    NSAssert(success != nil, @"Must provide a non-nil success block");
    NSAssert(failure != nil, @"Must provide a non-nil failure block");
    A0APIClient *client = [self apiClient];
    NSString *connectionName = [self identifier];
    [self.google authenticateWithScopes:[self scopesFromParameters:parameters] callback:^(NSError *error, NSString *token) {
        if (error) {
            A0LogError(@"Failed to authenticate with Google+ with error %@", error);
            failure(error);
        } else {
            A0LogVerbose(@"Authenticated with Google+");
            A0IdentityProviderCredentials *credentials = [[A0IdentityProviderCredentials alloc] initWithAccessToken:token];
            [client authenticateWithSocialConnectionName:connectionName
                                             credentials:credentials
                                              parameters:parameters
                                                 success:success
                                                 failure:failure];
        }
    }];
    A0LogVerbose(@"Starting Google+ Authentication...");
}

- (void)clearSessions {
    [self.google clearSession];
    A0LogVerbose(@"Cleared Google+ session");
}

- (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    return [self.google handleURL:url sourceApplication:sourceApplication];
}

- (void)handleDidBecomeActive:(NSNotification *)notification {
    [self.google cancelAuthentication];
}

#pragma mark - Utility methods

- (NSArray *)scopesFromParameters:(A0AuthParameters *)parameters {
    NSArray *connectionScopes = parameters.connectionScopes[self.identifier];
    if (connectionScopes.count == 0) {
        return nil;
    }
    A0LogDebug(@"Google scopes %@", connectionScopes);
    return [[NSSet setWithArray:connectionScopes] allObjects];
}

- (A0APIClient *)apiClient {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    return [self.clientProvider apiClient] ?: [A0APIClient sharedClient];
#pragma GCC diagnostic pop
}
@end
