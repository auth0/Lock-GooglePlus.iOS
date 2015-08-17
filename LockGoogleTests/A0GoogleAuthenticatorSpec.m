// A0GoogleAuthenticatorSpec.m
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
#import <OCMockito/NSInvocation+OCMockito.h>
#import "A0GoogleAuthenticator.h"
#import "A0GoogleProvider.h"
#import <Lock/A0Strategy.h>
#import <Lock/A0APIClient.h>
#import <Lock/A0IdentityProviderCredentials.h>
#import <Lock/A0Errors.h>
#import <Lock/A0AuthParameters.h>
#import <Lock/A0APIClientProvider.h>
#import <Lock/A0IdentityProviderCredentials.h>
#import <Lock/A0Token.h>
#import <Lock/A0UserProfile.h>

#define kDefaultConnectionName @"google-oauth2"

@interface A0GoogleAuthenticator (Testing)
@property (strong, nonatomic) A0GoogleProvider *google;
- (instancetype)initWithConnectionName:(NSString *)connectionName andGoogleProvider:(A0GoogleProvider *)google;
- (void)handleDidBecomeActive:(NSNotification *)notification;
@end

SpecBegin(A0GoogleAuthenticator)

__block A0GoogleProvider *google;
__block id<A0APIClientProvider> clientProvider;
__block A0GoogleAuthenticator *authenticator;
__block A0APIClient *client;

beforeEach(^{
    google = MKTMock(A0GoogleProvider.class);
    clientProvider = MKTMockProtocol(@protocol(A0APIClientProvider));
    client = MKTMock(A0APIClient.class);
    [MKTGiven([clientProvider apiClient]) willReturn:client];
    authenticator = [[A0GoogleAuthenticator alloc] initWithConnectionName:kDefaultConnectionName andGoogleProvider:google];
    authenticator.clientProvider = clientProvider;
});

describe(@"authenticator identifier", ^{

    it(@"should have the default conneciton name", ^{
        expect(authenticator.identifier).to.equal(kDefaultConnectionName);
    });

    it(@"should allow custom connection name", ^{
        NSString *name = @"my-google-connection";
        authenticator = [[A0GoogleAuthenticator alloc] initWithConnectionName:name andGoogleProvider:google];
        expect(authenticator.identifier).to.equal(name);
    });
});

describe(@"authenticate", ^{

    __block NSString *googleToken;
    __block A0AuthParameters *parameters;

    beforeEach(^{
        googleToken = [[NSUUID UUID] UUIDString];
        parameters = [A0AuthParameters newDefaultParams];
    });

    it(@"should delegate to google provider", ^{
        [authenticator authenticateWithParameters:parameters
                                          success:^(A0UserProfile *profile, A0Token *token) {}
                                          failure:^(NSError *error){}];
        [MKTVerify(google) authenticateWithScopes:nil callback:HC_notNilValue()];
    });

    it(@"should send connection scopes in parameters", ^{
        [parameters setConnectionScopes:@{
                                          kDefaultConnectionName: @[@"scope1", @"scope2"]
                                          }];
        [authenticator authenticateWithParameters:parameters
                                          success:^(A0UserProfile *profile, A0Token *token) {}
                                          failure:^(NSError *error){}];
        MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
        [MKTVerify(google) authenticateWithScopes:[captor capture] callback:HC_notNilValue()];
        NSArray *scopes = [captor value];
        expect(scopes).to.contain(@"scope1");
        expect(scopes).to.contain(@"scope2");
    });

    it(@"should send unique connection scopes in parameters", ^{
        [parameters setConnectionScopes:@{
                                          kDefaultConnectionName: @[@"scope1", @"scope2", @"scope1"]
                                          }];
        [authenticator authenticateWithParameters:parameters
                                          success:^(A0UserProfile *profile, A0Token *token) {}
                                          failure:^(NSError *error){}];
        MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
        [MKTVerify(google) authenticateWithScopes:[captor capture] callback:HC_notNilValue()];
        NSArray *scopes = [captor value];
        expect(scopes).to.contain(@"scope1");
        expect(scopes).to.contain(@"scope2");
        expect(scopes.count).to.equal(2);
    });


    it(@"should broadcast error to failure block", ^{
        NSError *reason = MKTMock(NSError.class);
        waitUntilTimeout(1.0, ^(DoneCallback done) {
            [authenticator authenticateWithParameters:parameters
                                              success:^(A0UserProfile *profile, A0Token *token) {
                                                  failure(@"Should have failed to authenticate and called 'failure' block!");
                                              }
                                              failure:^(NSError *error){
                                                  expect(error).to.equal(reason);
                                                  done();
                                              }];
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [MKTVerify(google) authenticateWithScopes:nil callback:[captor capture]];
            A0GoogleAuthentication block = [captor value];
            block(reason, nil);
        });
    });

    it(@"should use google credentials", ^{
        [authenticator authenticateWithParameters:parameters
                                          success:^(A0UserProfile *profile, A0Token *token) {}
                                          failure:^(NSError *error){}];
        MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
        [MKTVerify(google) authenticateWithScopes:nil callback:[captor capture]];
        A0GoogleAuthentication block = [captor value];
        block(nil, googleToken);
        captor = [[MKTArgumentCaptor alloc] init];
        [MKTVerify(client) authenticateWithSocialConnectionName:kDefaultConnectionName
                                                    credentials:[captor capture]
                                                     parameters:parameters
                                                        success:HC_notNilValue()
                                                        failure:HC_notNilValue()];
        A0IdentityProviderCredentials *credentials = [captor value];
        expect(credentials.accessToken).to.equal(googleToken);
    });

    it(@"should pass along profile and token after authentication", ^{
        [MKTGiven([client authenticateWithSocialConnectionName:kDefaultConnectionName
                                                   credentials:HC_notNilValue()
                                                    parameters:parameters
                                                       success:HC_notNilValue()
                                                       failure:HC_notNilValue()])
         willDo:^id(NSInvocation *invocation) {
             NSArray *args = [invocation mkt_arguments];
             A0UserProfile *profile = MKTMock(A0UserProfile.class);
             A0Token *token = MKTMock(A0Token.class);
             A0APIClientAuthenticationSuccess success = args[3];
             success(profile, token);
             return nil;
        }];
        waitUntilTimeout(1.0, ^(DoneCallback done) {
            [authenticator authenticateWithParameters:parameters
                                              success:^(A0UserProfile *profile, A0Token *token) {
                                                  expect(profile).toNot.beNil();
                                                  expect(token).toNot.beNil();
                                                  done();
                                              }
                                              failure:^(NSError *error){
                                                  failure(@"Should not fail");
                                              }];
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [MKTVerify(google) authenticateWithScopes:nil callback:[captor capture]];
            A0GoogleAuthentication block = [captor value];
            block(nil, googleToken);
        });
    });
});

describe(@"lifecycle", ^{

    it(@"should clear google provider session", ^{
        [authenticator clearSessions];
        [MKTVerify(google) clearSession];
    });

    it(@"should handle URL", ^{
        NSURL *url = MKTMock(NSURL.class);
        [authenticator handleURL:url sourceApplication:@"App"];
        [MKTVerify(google) handleURL:url sourceApplication:@"App"];
    });

    it(@"should handle app become active notification", ^{
        NSNotification *notification = MKTMock(NSNotification.class);
        [authenticator handleDidBecomeActive:notification];
        [MKTVerify(google) cancelAuthentication];
    });
});
SpecEnd