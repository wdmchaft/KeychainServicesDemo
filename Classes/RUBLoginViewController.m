//
//  RUBKeychainDemoViewController.m
//  RUBKeychainDemo
//
//  Created by Manuel Binna on 11.01.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import "RUBLoginViewController.h"
#import <Security/Security.h>

@interface RUBLoginViewController ()

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, retain) RUBKeychainServicesWrapper *keychainServicesWrapper;

- (void)storeCredentialsInKeychain;
- (void)reloadData;

@end

#pragma mark -

@implementation RUBLoginViewController

#pragma mark Properties

@synthesize usernameTextField;
@synthesize passwordTextField;

@synthesize username;
@synthesize password;

@synthesize delegate;

@synthesize keychainServicesWrapper;

#pragma mark NSObject

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        keychainServicesWrapper = [[RUBKeychainServicesWrapper alloc] init];
    }
    return self;
}

- (void)dealloc 
{
    [usernameTextField release];
    [passwordTextField release];
    
    [username release];
    [password release];
    
    [keychainServicesWrapper release];
    
    [super dealloc];
}

#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        keychainServicesWrapper = [[RUBKeychainServicesWrapper alloc] init];
    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
    
    [[self usernameTextField] becomeFirstResponder];
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	[self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
}

#pragma mark RUBKeychainDemoViewController

- (IBAction)loginButtonTouched:(id)sender
{
    NSLog(@"Logging in");
    
    [self setUsername:[[self usernameTextField] text]];
    [self setPassword:[[self passwordTextField] text]];
    
    [self storeCredentialsInKeychain];
    
    [[self delegate] loginViewControllerDidFinish:self];
}

- (IBAction)resetCredentialsButtonTouched:(id)sender
{
    NSLog(@"Resetting credentials");
    
    [[self keychainServicesWrapper] resetKeychainItem];
    [self reloadData];
}

- (IBAction)dismissKeyboardButtonTouched:(id)sender
{
    [[self usernameTextField] resignFirstResponder];
    [[self passwordTextField] resignFirstResponder];
}

#pragma mark RUBKeychainDemoViewController ()

- (void)reloadData 
{
    NSDictionary *keychainItem = [[self keychainServicesWrapper] keychainItem];
    NSString *theUsername = [keychainItem objectForKey:kSecAttrAccount];
    [self setUsername:theUsername];
    NSString *thePassword = [[NSString alloc] initWithData:[keychainItem objectForKey:kSecValueData] 
                                                  encoding:NSUTF8StringEncoding];
    [self setPassword:thePassword];
    [thePassword release];
    
    [[self usernameTextField] setText:[self username]];
    [[self passwordTextField] setText:[self password]];
}

- (void)storeCredentialsInKeychain
{
    [[self keychainServicesWrapper] updateKeychainItemWithUsername:[self username] password:[self password]];
}

@end
