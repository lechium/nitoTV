//
//  defaultHelper.m
//  nitoTV
//
//  Created by blunt on 11/10/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

#import "defaultHelper.h"


@implementation defaultHelper

+ (void)setInteger:(int)theInt forKey:(NSString *)theKey inDomain:(NSString *)theDomain
{
	CFPreferencesSetValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithInt:theInt],(CFStringRef)theDomain, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
	CFPreferencesAppSynchronize((CFStringRef)theDomain);
}

+ (void)setArray:(NSArray *)inputArray forKey:(NSString *)theKey forDomain:(NSString *)theDomain
{
	CFPreferencesSetValue((CFStringRef)theKey, (CFArrayRef)inputArray,(CFStringRef)theDomain, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
	CFPreferencesAppSynchronize((CFStringRef)theDomain);
	CFRelease(inputArray);
}

+ (void)setFloat:(float)theFloat forKey:(NSString *)theKey forDomain:(NSString *)theDomain
{
	CFPreferencesSetValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithFloat:theFloat],(CFStringRef)theDomain, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
	CFPreferencesAppSynchronize((CFStringRef)theDomain);
}

+ (void)setString:(NSString *)inputString forKey:(NSString *)theKey forDomain:(NSString *)theDomain
{
	NSLog(@"setString: %@ forKey: %@ forDomain: %@", inputString, theKey, theDomain);
	CFPreferencesSetValue((CFStringRef)theKey, (CFStringRef)inputString,(CFStringRef)theDomain, CFSTR("mobile"), CFSTR("mobile"));
	CFPreferencesAppSynchronize((CFStringRef)theDomain);
	CFRelease(inputString);
}

@end
