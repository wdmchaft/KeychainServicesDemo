//
//  RUBHomeViewController.m
//  RUBKeychainDemo
//
//  Created by Manuel Binna on 13.01.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import "RUBHomeViewController.h"


@implementation RUBHomeViewController

#pragma mark Properties



#pragma mark NSObject

- (void)dealloc 
{
    [super dealloc];
}

#pragma mark UIViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

#pragma mark RUBHomeViewController

- (IBAction)changeCredentialsButtonTouched:(id)sender
{
    RUBLoginViewController *loginVC = [[RUBLoginViewController alloc] initWithNibName:@"RUBLoginViewController" bundle:nil];
    [loginVC setDelegate:self];
    [self presentModalViewController:loginVC animated:YES];
    [loginVC release];
}

#pragma mark RUBLoginViewControllerDelegate

- (void)loginViewControllerDidFinish:(RUBLoginViewController *)loginViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
