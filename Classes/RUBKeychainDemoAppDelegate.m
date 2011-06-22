//
//  RUBKeychainDemoAppDelegate.m
//  RUBKeychainDemo
//
//  Created by Manuel Binna on 11.01.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import "RUBKeychainDemoAppDelegate.h"
#import "RUBLoginViewController.h"
#import "RUBHomeViewController.h"

@implementation RUBKeychainDemoAppDelegate

#pragma mark Properties

@synthesize window;
@synthesize loginViewController;
@synthesize homeViewController;

#pragma mark NSObject

- (void)dealloc 
{
    [loginViewController release];
    [homeViewController release];
    [window release];
    
    [super dealloc];
}

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    [[self loginViewController] setDelegate:[self homeViewController]];
    [[self window] addSubview:[[self homeViewController] view]];
    
    [[self homeViewController] presentModalViewController:[self loginViewController] animated:NO];
    
    [[self window] makeKeyAndVisible];

    return YES;
}

@end
