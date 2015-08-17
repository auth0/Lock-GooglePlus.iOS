//
//  ViewController.m
//  LockGoogleApp
//
//  Created by Hernan Zalazar on 8/14/15.
//  Copyright (c) 2015 Auth0. All rights reserved.
//

#import "ViewController.h"
#import "LockGoogleProvider.h"
#import <Lock/A0AuthParameters.h>
#import <Lock/A0Token.h>
#import <Lock/A0UserProfile.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)login:(id)sender {
    A0GoogleAuthenticator *authenticator = [[LockGoogleProvider sharedInstance] authenticator];
    A0AuthParameters *parameters = [A0AuthParameters newDefaultParams];
    [authenticator authenticateWithParameters:parameters
                                      success:^(A0UserProfile *profile, A0Token *token){
                                          NSLog(@"Authenticated with Google user with email %@", profile.email);
                                      }
                                      failure:^(NSError *error) {
                                          NSLog(@"Failed to authenticate with error %@", error);
                                      }];
}
@end
