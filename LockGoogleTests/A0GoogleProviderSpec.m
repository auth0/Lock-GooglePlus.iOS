// A0GoogleProviderSpec.m
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

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import <Google/SignIn.h>
#import <Lock/A0ErrorCode.h>
#import "A0GoogleProvider.h"

@interface A0GoogleProvider (Testing) <GIDSignInDelegate, GIDSignInUIDelegate>
- (instancetype)initWithAuthentication:(GIDSignIn *)authentication clientId:(NSString *)clientId scopes:(NSArray *)scopes;
- (instancetype)initWithAuthentication:(GIDSignIn *)authentication scopes:(NSArray *)scopes;
@property (copy, nonatomic) A0GoogleAuthentication onAuthentication;
@property (assign, nonatomic) BOOL authenticating;
@end

#define kClientId @"RANDOMUUID.apps.googleusercontent.com"
#define kScope @"GoogleScope"

SpecBegin(A0GoogleProvider)

__block GIDSignIn *authentication;
__block A0GoogleProvider *google;

beforeEach(^{
    authentication = MKTMock([GIDSignIn class]);
    google = [[A0GoogleProvider alloc] initWithAuthentication:authentication clientId:kClientId scopes:@[kScope]];
});

describe(@"initialize", ^{

    beforeEach(^{
        authentication = MKTMock([GIDSignIn class]);
    });

    context(@"with clientId parameter", ^{

        beforeEach(^{
            google = [[A0GoogleProvider alloc] initWithAuthentication:authentication clientId:kClientId scopes:@[kScope]];
        });

        it(@"should set client id", ^{
            [MKTVerify(authentication) setClientID:kClientId];
        });

        it(@"should set scopes", ^{
            [MKTVerify(authentication) setScopes:@[kScope]];
        });

        it(@"should set delegates", ^{
            [MKTVerify(authentication) setDelegate:google];
            [MKTVerify(authentication) setUiDelegate:google];
        });

    });

    context(@"without clientId parameter", ^{

        beforeEach(^{
            google = [[A0GoogleProvider alloc] initWithAuthentication:authentication scopes:@[kScope]];
        });

        it(@"should set client id", ^{
            [MKTVerifyCount(authentication, MKTNever()) setClientID:kClientId];
        });

        it(@"should set scopes", ^{
            [MKTVerify(authentication) setScopes:@[kScope]];
        });

        it(@"should set delegates", ^{
            [MKTVerify(authentication) setDelegate:google];
            [MKTVerify(authentication) setUiDelegate:google];
        });
        
    });

});

describe(@"authenticate", ^{

    context(@"with no scopes", ^{
        it(@"should start flow", ^{
            [google authenticateWithScopes:nil callback:^(NSError *error, NSString *token) {}];
            [MKTVerify(authentication) signIn];
        });

        it(@"should not set scopes", ^{
            [google authenticateWithScopes:nil callback:^(NSError *error, NSString *token) {}];
            [MKTVerifyCount(authentication, MKTTimes(1)) setScopes:HC_anything()];
        });
    });

    context(@"with scopes", ^{

        NSArray *scopes = @[@"first", @"second"];

        it(@"should start flow", ^{
            [google authenticateWithScopes:scopes callback:^(NSError *error, NSString *token) {}];
            [MKTVerify(authentication) signIn];
        });

        it(@"should not set scopes", ^{
            [google authenticateWithScopes:scopes callback:^(NSError *error, NSString *token) {}];
            [MKTVerify(authentication) setScopes:scopes];
        });
    });

    context(@"with server clientId", ^{
        it(@"should start flow", ^{
            google.serverClientId = @"Server ClientId";
            [google authenticateWithScopes:nil callback:^(NSError *error, NSString *token) {}];
            [MKTVerify(authentication) signIn];
        });

        it(@"should set serverClientId", ^{
            NSString *serverClientId = @"Server ClientId";
            google.serverClientId = serverClientId;
            [google authenticateWithScopes:nil callback:^(NSError *error, NSString *token) {}];
            [MKTVerify(authentication) setServerClientID:serverClientId];
        });

    });

    context(@"cancelled authentication", ^{

        it(@"should send error to callback", ^{
            waitUntil(^(DoneCallback done) {
                [google authenticateWithScopes:nil callback:^(NSError *error, NSString *token) {
                    expect(token).to.beNil();
                    expect(error.domain).to.equal(@"com.auth0");
                    expect(error.code).to.equal(A0ErrorCodeGooglePlusCancelled);
                    done();
                }];
                [google cancelAuthentication];
            });
        });

        it(@"should do nothing if authentication is in place", ^{
            GIDGoogleUser *user = MKTMock(GIDGoogleUser.class);
            GIDAuthentication *auth = MKTMock(GIDAuthentication.class);
            [MKTGiven([user authentication]) willReturn:auth];
            [MKTGiven(auth.accessToken) willReturn:@"TOKEN"];
            [MKTGiven(auth.idToken) willReturn:@"JWT"];
            google.authenticating = YES;
            waitUntil(^(DoneCallback done) {
                [google authenticateWithScopes:nil callback:^(NSError *error, NSString *token) {
                    expect(token).toNot.beNil();
                    expect(error).to.beNil();
                    done();
                }];
                [google cancelAuthentication];
                [google signIn:authentication didSignInForUser:user withError:nil];
            });
        });

    });

    context(@"when signIn:didSigninForUser:withError called", ^{

        __block GIDGoogleUser *user;

        beforeEach(^{
            user = MKTMock(GIDGoogleUser.class);
            GIDAuthentication *auth = MKTMock(GIDAuthentication.class);
            [MKTGiven([user authentication]) willReturn:auth];
            [MKTGiven(auth.accessToken) willReturn:@"TOKEN"];
            [MKTGiven(auth.idToken) willReturn:@"JWT"];
        });

        it(@"should send token to callback", ^{
            waitUntil(^(DoneCallback done) {
                [google authenticateWithScopes:nil callback:^(NSError *error, NSString *token) {
                    expect(token).to.equal(@"TOKEN");
                    expect(error).to.beNil();
                    done();
                }];
                [google signIn:authentication didSignInForUser:user withError:nil];
            });
        });

        it(@"should send jwt to callback", ^{
            waitUntil(^(DoneCallback done) {
                google.serverClientId = @"SERVER CLIENTID";
                [google authenticateWithScopes:nil callback:^(NSError *error, NSString *token) {
                    expect(token).to.equal(@"JWT");
                    expect(error).to.beNil();
                    done();
                }];
                [google signIn:authentication didSignInForUser:user withError:nil];
            });
        });

        it(@"should send the error to callback", ^{
            NSError *error = MKTMock(NSError.class);
            waitUntil(^(DoneCallback done) {
                [google authenticateWithScopes:nil callback:^(NSError *error, NSString *token) {
                    expect(token).to.beNil();
                    expect(error).toNot.beNil();
                    done();
                }];
                [google signIn:authentication didSignInForUser:nil withError:error];
            });
        });

    });

});

describe(@"lifecycle callbacks", ^{

    it(@"should call handleURL:sourceApplication:", ^{
        NSURL *url = MKTMock(NSURL.class);
        [google handleURL:url sourceApplication:@"app"];
        [MKTVerify(authentication) handleURL:url sourceApplication:@"app" annotation:nil];
    });

    it(@"should signOut", ^{
        [google clearSession];
        [MKTVerify(authentication) signOut];
    });
});

SpecEnd
