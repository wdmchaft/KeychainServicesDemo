//
//  RUBKeychainServicesWrapper.m
//  RUBKeychainDemo
//
//  Created by Manuel Binna on 13.01.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import "RUBKeychainServicesWrapper.h"
#import <Security/Security.h>

#define kPersistentKeychainReferenceKey @"RUBKeychainServicesWrapperPersistentKeychainReferenceKey"

#define kKeychainItemIdentifier @"de.rub.emma.KeychainDemo"
#define kKeychainItemServer @"www.example.com"
#define kKeychainItemInitialAccount @""
#define kKeychainItemInitialPassword @""
#define kKeychainItemDescription @"KeychainDemo sample application"

@interface RUBKeychainServicesWrapper ()

@property (nonatomic, retain) NSData *persistentKeychainRef;

- (void)initializeKeychainItem;
- (void)savePersistentKeychainRefInUserDefaults:(NSData *)thePersistentKeychainRef;

@end

#pragma mark -

@implementation RUBKeychainServicesWrapper

#pragma mark Properties

@synthesize persistentKeychainRef;

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        persistentKeychainRef = [[[NSUserDefaults standardUserDefaults] 
                                  dataForKey:kPersistentKeychainReferenceKey] retain];
        if (persistentKeychainRef == nil)
        {
            // No item in the Keychain yet. Initialize it and obtain a persistent reference to it.
            [self initializeKeychainItem];
        }
    }
    return self;
}

- (void)dealloc
{
    [persistentKeychainRef release];
    
    [super dealloc];
}

#pragma mark RUBKeychainServicesWrapper

- (NSDictionary *)keychainItem
{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           [self persistentKeychainRef], kSecValuePersistentRef,
                           kCFBooleanTrue, kSecReturnAttributes, 
                           kCFBooleanTrue, kSecReturnData,
                           nil];
    NSDictionary *item = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef) query, 
                                          (CFTypeRef *) &item);
    
    if (status == noErr) 
    {
        return item;
    }
    else if (status == errSecItemNotFound)
    {
        return nil;
    }
    else
    {
        // Any other error is unexpected here
        
        // When signing with a self-signed certificate 'errSecInteractionNotAllowed' is returned
        NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                                                NSUserDomainMask, 
                                                                                YES) objectAtIndex:0];
        NSString *path = [documentsDirectoryPath stringByAppendingPathComponent:@"crash.log"];
        NSString *msg = [NSString stringWithFormat:@"Programm will crash. Error code: %ld\n", (long) status];
        [msg writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSAssert(NO, @"Serious error.");
        return nil;
    }
}

- (BOOL)updateKeychainItemWithUsername:(NSString *)username password:(NSString *)password
{
    NSDictionary *query = [NSDictionary dictionaryWithObject:[self persistentKeychainRef] 
                                                      forKey:kSecValuePersistentRef];
    NSDictionary *attributesToUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                        username, kSecAttrAccount,
                                        [password dataUsingEncoding:NSUTF8StringEncoding], kSecValueData, 
                                        nil];
    OSStatus status = SecItemUpdate((CFDictionaryRef) query, 
                                    (CFDictionaryRef) attributesToUpdate);
    
    return (status == noErr);
}

- (BOOL)resetKeychainItem
{
    return [self updateKeychainItemWithUsername:@"" password:@""];
}

#pragma mark RUBKeychainServicesWrapper ()

- (void)initializeKeychainItem
{
    NSData *encodedIdentifier = [kKeychainItemIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       kSecClassGenericPassword, kSecClass,
                                       encodedIdentifier, kSecAttrGeneric,
                                       encodedIdentifier, kSecAttrService,
                                       nil];

#if TARGET_IPHONE_SIMULATOR
    // Ignore the access group if running on the iPhone simulator.
    // 
    // Apps that are built for the simulator aren't signed, so there's no keychain access group
    // for the simulator to check. This means that all apps can see all keychain items when run
    // on the simulator.
    //
    // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
    // simulator will return -25243 (errSecNoAccessForItem).
    //
    // http://developer.apple.com/library/ios/#samplecode/GenericKeychain/Listings/Classes_KeychainItemWrapper_m.html
#else           
    [attributes setObject:@"A2935A6MY3.de.rub.emma.KeychainDemoSuite" forKey:(id)kSecAttrAccessGroup];
#endif
    
    OSStatus searchResult = SecItemCopyMatching((CFDictionaryRef) attributes, 
                                                NULL);
    if (searchResult == noErr)  // Keychain item already exists. Obtain the Persistent Keychain Reference.
    {
        // This situation occurs when the app is re-installed and the Persistent Keychain Reference is not 
        // longer stored in the NSUserDefaults.
        [attributes setObject:(id)kCFBooleanTrue 
                       forKey:kSecReturnPersistentRef];
        NSData *persistentRef = nil;
        OSStatus persistentRefSearchResult = SecItemCopyMatching((CFDictionaryRef) attributes, 
                                                                 (CFTypeRef *) &persistentRef);
        if (persistentRefSearchResult == noErr)
        {
            NSLog(@"Obtained existing Persistent Keychain Reference");
            [self savePersistentKeychainRefInUserDefaults:persistentRef];
        }
        else if (persistentRefSearchResult == errSecItemNotFound)
        {
            NSLog(@"Item not found");
        }
        else
        {
            NSLog(@"Other error");
        }
    }
    else if (searchResult == errSecItemNotFound) // Keychain item does not exist yet. Create it.
    {
        [attributes setObject:kKeychainItemInitialAccount 
                       forKey:kSecAttrAccount];
        [attributes setObject:[kKeychainItemInitialPassword dataUsingEncoding:NSUTF8StringEncoding] 
                       forKey:kSecValueData];
        [attributes setObject:(id)kCFBooleanTrue 
                       forKey:kSecReturnPersistentRef];
        NSData *persistentRef = nil;
        OSStatus storeResult = SecItemAdd((CFDictionaryRef) attributes, 
                                          (CFTypeRef *) &persistentRef);
        if (storeResult == noErr)
        {
            [self savePersistentKeychainRefInUserDefaults:persistentRef];
        }
        
        [persistentRef release];
    }
}

- (void)savePersistentKeychainRefInUserDefaults:(NSData *)thePersistentKeychainRef
{
    NSLog(@"A new item was added to the Keychain");
    [self setPersistentKeychainRef:thePersistentKeychainRef];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self persistentKeychainRef] 
                     forKey:kPersistentKeychainReferenceKey];
    [userDefaults synchronize];
}

@end
