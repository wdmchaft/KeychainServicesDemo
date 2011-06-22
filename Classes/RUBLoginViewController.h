//
//  RUBKeychainDemoViewController.h
//  RUBKeychainDemo
//
//  Created by Manuel Binna on 11.01.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUBKeychainServicesWrapper.h"

@class RUBLoginViewController;

@protocol RUBLoginViewControllerDelegate

- (void)loginViewControllerDidFinish:(RUBLoginViewController *)loginViewController;

@end

@interface RUBLoginViewController : UIViewController 
{
    @private
    
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    
    NSString *username;
    NSString *password;
    
    id<RUBLoginViewControllerDelegate> delegate;
    
    RUBKeychainServicesWrapper *keychainServicesWrapper;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

@property (nonatomic, assign) id<RUBLoginViewControllerDelegate> delegate;

- (IBAction)loginButtonTouched:(id)sender;
- (IBAction)resetCredentialsButtonTouched:(id)sender;
- (IBAction)dismissKeyboardButtonTouched:(id)sender;

@end
