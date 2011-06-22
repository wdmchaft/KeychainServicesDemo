//
//  RUBKeychainDemoAppDelegate.h
//  RUBKeychainDemo
//
//  Created by Manuel Binna on 11.01.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RUBLoginViewController;
@class RUBHomeViewController;

@interface RUBKeychainDemoAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    RUBLoginViewController *viewController;
    RUBHomeViewController *homeViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RUBLoginViewController *loginViewController;
@property (nonatomic, retain) IBOutlet RUBHomeViewController *homeViewController;

@end
