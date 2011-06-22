//
//  RUBKeychainServicesWrapper.h
//  RUBKeychainDemo
//
//  Based on the chapter 'Keychain Services Tasks for iPhone OS' in the
//  'Keychain Services Programming Guide'
//
//  Created by Manuel Binna on 13.01.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUBKeychainServicesWrapper : NSObject 
{
    @private
    
    NSData *persistentKeychainRef;
}

@property (nonatomic, readonly) NSDictionary *keychainItem;

- (BOOL)updateKeychainItemWithUsername:(NSString *)username password:(NSString *)password;
- (BOOL)resetKeychainItem;

@end
