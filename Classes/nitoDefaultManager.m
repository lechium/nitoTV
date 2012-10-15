//
//  nitoDefaultManager.m
//  nitoTV
//
//  Created by Kevin Bradley on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "nitoDefaultManager.h"

#define myDomain			(CFStringRef)@"com.nito.nitoTV"
#define NITO_DOMAIN			@"com.nito.nitoTV"

@implementation nitoDefaultManager

+(NSMFPreferences *)preferences {
    static NSMFPreferences *_preferences = nil;
    
    if(!_preferences)
        _preferences = [[NSMFPreferences alloc] initWithPersistentDomainName:NITO_DOMAIN];
    
    return _preferences;
}

/*

 deprecated
 
+ (int)integerForKey:(NSString *)theKey
{
	Boolean temp;
	
	int outInt = CFPreferencesGetAppIntegerValue((CFStringRef)theKey, myDomain, &temp);
	return outInt;
	
}

+ (NSNumber *)numberForKey:(NSString *)theKey
{
	CFNumberRef myNumber = [(CFNumberRef)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSNumber *)myNumber;
}


+ (NSString *)stringForKey:(NSString *)theKey
{
	CFStringRef myString = [(CFStringRef)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSString *)myString;
}

+ (NSArray *)arrayForKey:(NSString *)theKey
{
	CFArrayRef myArray = [(CFArrayRef)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSArray *)myArray;
}

+ (void)setArray:(NSArray *)inputArray forKey:(NSString *)theKey forDomain:(NSString *)theDomain
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFArrayRef)inputArray, (CFStringRef)theDomain);
	CFPreferencesAppSynchronize((CFStringRef)theDomain);
	CFRelease(inputArray);
}

+ (void)setArray:(NSArray *)inputArray forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFArrayRef)inputArray, myDomain);
	CFPreferencesAppSynchronize(myDomain);
	CFRelease(inputArray);
}

+ (void)setString:(NSString *)inputString forKey:(NSString *)theKey
{
	
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFStringRef)inputString, myDomain);
	CFPreferencesAppSynchronize(myDomain);
	CFRelease(inputString);
}



+ (void)setInteger:(int)theInt forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithInt:theInt], myDomain);
	CFPreferencesAppSynchronize(myDomain);
}

+ (void)setInteger:(int)theInt forKey:(NSString *)theKey forDomain:(NSString *)theDomain
{
	
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithInt:theInt], (CFStringRef)theDomain);
	CFPreferencesAppSynchronize((CFStringRef)theDomain);
}
 
 */

@end
