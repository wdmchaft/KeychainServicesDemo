//
//  RUBHomeViewController.h
//  RUBKeychainDemo
//
//  Created by Manuel Binna on 13.01.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUBLoginViewController.h"

@interface RUBHomeViewController : UIViewController <RUBLoginViewControllerDelegate>
{

}

- (IBAction)changeCredentialsButtonTouched:(id)sender;

@end
