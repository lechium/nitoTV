/*
 
 Defaults for iOS
 
 Written by Kevin Bradley on November, 10 2010
 
 Credits: 
 
 Dustin Howett (theos)
 
 https://github.com/DHowett/theos
 
 Mark Dalrymple (LogIt)
 
 http://borkware.com/quickies/one?topic=NSString 
 
 This is an attempt to re-write the defaults CLI for iOS, a combo of plutil, nano/vim just didn't 
 cut it!
 
 */


#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <unistd.h>

#define CURRENT_VERSION 0.1

enum  {
	
	kAWKDefaultBoolean = 0,
	kAWKDefaultString,
	kAWKDefaultFloat,
	kAWKDefaultInteger,
	
};

int varTypefromValue(id value)
{	

	
	if ([[value lowercaseString] isEqualToString:@"true"] || [[value lowercaseString] isEqualToString:@"false"])
		return kAWKDefaultBoolean;
	
	
	NSString *newString = nil;
	
	NSScanner *myScanner = [[NSScanner alloc] initWithString:value];
	[myScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&newString];
	[myScanner release];
	
	if (newString == nil) //no digits
		return kAWKDefaultString;
	
	
	NSRange range = [value rangeOfString: @"."];
	if ( range.location != NSNotFound ) //found
		return kAWKDefaultFloat;
	
	return kAWKDefaultFloat;
	
}

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	NSFileManager *man = [NSFileManager defaultManager];
	int i;
	//id thePrefs = [BRPreferences sharedFrontRowPreferences];
	//id object = [thePrefs objectForKey:@"RUISWUpdateLastCheckDate"];
	//NSLog(@"RUISWUpdateLastCheckDate: %@", object);

	
	
	if (argc < 3)
	{
		printf("defaults version: %.1f\n", CURRENT_VERSION);
		printf("Command line interface to a user's defaults.\n\n");
		printf("	Written by Kevin Bradley\n\n");
		printf("	This is an attempt to port the basic functionality of Apples 'defaults' CLI to iOS.\n\n");
		printf("Syntax:\n\n");
		printf("'defaults' followed by one of the following:\n\n");
		printf("	read <domain>                        shows defaults for given domain\n");	   
		printf("	read <domain> <key>                  shows defaults for given domain, key\n\n");
		printf("	write <domain> <key> <value>         writes key for domain\n\n");
		char ESC=27;
		printf("%c[1m",ESC);  /*- turn on bold */
		printf("NOTE: ");
		printf("%c[0m",ESC); /* turn off bold */
		printf("Currently we only read preferences from /var/mobile/Library/Preferences\n");
		printf("%c[1m",ESC);  /*- turn on bold */
		printf("NOTE: ");
		printf("%c[0m",ESC); /* turn off bold */
		printf("write only works with integers, floats, bools and strings, no dictionarys or arrays yet\n\n");
		
	}

	for (i = 1; i < (argc - 1); i+= 2){
		
		NSString *path = [NSString stringWithUTF8String:argv[0]];
		
		NSString *option = [NSString stringWithUTF8String:argv[i]];
		NSString *value = [NSString stringWithUTF8String:argv[i+1]];
		
		if ([option isEqualToString:@"read"])
		{
			NSString *prefPath = @"/var/mobile/Library/Preferences";
			value = [value stringByAppendingPathExtension:@"plist"];
			
			NSString *finishedString = [prefPath stringByAppendingPathComponent:value];
			if (![man fileExistsAtPath:finishedString])
			{
				LogIt(@"Domain %@ does not exist\n", [value stringByDeletingPathExtension]);
				[pool release];
				return -1;
			}
			
			NSDictionary *theDict = [NSDictionary dictionaryWithContentsOfFile:finishedString];
			if (argc >= 4) //there is a value for <key>
			{
				NSString *theKey = [NSString stringWithUTF8String:argv[3]];
				id keyValue = [theDict objectForKey:theKey];
				
				if (keyValue == nil)
				{
					LogIt(@"The domain/default pair of (%@, %@) does not exist",[value stringByDeletingPathExtension], theKey);
					[pool release];
					return -1;
				}
				LogIt(@"%@\n", keyValue);
				
			} else { //no value for <key> log entire dictionary
				
				LogIt(@"%@\n", theDict);
			
			}
			
			
		}
		
		if ([option isEqualToString:@"write"])
		{
			
			NSString *prefPath = @"/var/mobile/Library/Preferences";
			value = [value stringByAppendingPathExtension:@"plist"];
			
			NSString *finishedString = [prefPath stringByAppendingPathComponent:value];
			if (![man fileExistsAtPath:finishedString])
			{
				LogIt(@"Domain %@ does not exist\n", [value stringByDeletingPathExtension]);
				[pool release];
				return -1;
			}
			NSMutableDictionary *theDict = [[NSMutableDictionary alloc] initWithContentsOfFile:finishedString];
			if (argc >= 5) //there is a value for <key>
			{
				
				NSString *theKey = [NSString stringWithUTF8String:argv[3]];
				id newValue = [NSString stringWithUTF8String:argv[4]];
				//LogIt(@"valueType: %i\n", varTypefromValue(newValue));
				//LogIt(@"set value: %@ forKey: %@", newValue, theKey);
				int valueType = varTypefromValue(newValue);
				//NSLog(@"valueType: %i", valueType);
				BOOL boolz;
				float floats;
				int ints;
				switch (valueType) {
						
					case kAWKDefaultBoolean:
						
						boolz = [newValue boolValue];
						[theDict setObject:[NSNumber numberWithBool:boolz] forKey:theKey];
			
						break;
						 
					case kAWKDefaultString:
						 
						 [theDict setObject:newValue forKey:theKey];
						//[defaultHelper setString:newValue forKey:theKey forDomain:[value stringByDeletingPathExtension]];
						 break;
				
				
					case kAWKDefaultFloat:
						 
						 floats = [newValue floatValue];
						//LogIt(@"%f", floats);
						 [theDict setObject:[NSNumber numberWithFloat:floats] forKey:theKey];
						 break;   
				
					case kAWKDefaultInteger:
						
						
						 ints = [newValue intValue];
						//LogIt(@"%i", ints);
						[theDict setObject:[NSNumber numberWithBool:ints] forKey:theKey];
						break;
				}
				
				[theDict writeToFile:finishedString atomically:YES];
				CFPreferencesAppSynchronize((CFStringRef)[value stringByDeletingPathExtension]);
				[theDict release];
			}
			
		}
		
	}
	
	[pool release];
    return 0;
}



void LogIt (NSString *format, ...)
{
    va_list args;
	
    va_start (args, format);
	
    NSString *string;
	
    string = [[NSString alloc] initWithFormat: format  arguments: args];
	
    va_end (args);
	
    printf ("%s", [string cString]);
	
    [string release];
	
} // LogIt
