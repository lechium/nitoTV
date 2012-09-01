/*
 nitoHelper.m
 nitoTV
 
 Written by Kevin Bradley

 
 */


#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <unistd.h>
#import "nitoHelperClass.h"


int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	setuid(0);
	int i;
	for (i = 1; i < (argc - 1); i+= 2){
		
		NSString *path = [NSString stringWithUTF8String:argv[0]];
		NSString *option = [NSString stringWithUTF8String:argv[i]];
		NSString *value = [NSString stringWithUTF8String:argv[i+1]];
		
	
		
		if ([option isEqualToString:@"reboot"])
		{
			[nitoHelperClass reboot];
			[pool release];
			return 0;
			
		} else if ([option isEqualToString:@"updateRepo"])
		{
			int termStatus = [nitoHelperClass updateRepo];
			[pool release];
			return termStatus;
			
		} else if ([option isEqualToString:@"install"])
		{
			nitoHelperClass *nhc = [[nitoHelperClass alloc] init];
			int termStatus = [nhc installPackage:value];
			[nhc release];
			[pool release];
			return termStatus;
			
		} else if ([option isEqualToString:@"remove"])
		{
			nitoHelperClass *nhc = [[nitoHelperClass alloc] init];
			int termStatus = [nhc removePackage:value];
			[nhc release];
			[pool release];
			return termStatus;
			
		} else if ([option isEqualToString:@"toggleBlock"])
		{
			int termStatus = [nitoHelperClass toggleUpdate];
			if (termStatus != 2)
				[pool release];
				//NSLog(@"termStatus: %i", termStatus);
			return termStatus;
		} else if ([option isEqualToString:@"dpkg"])
		{
			nitoHelperClass *nhc = [[nitoHelperClass alloc] init];
			int termStatus = [nhc dpkgPackage:value];
			[nhc release];
			[pool release];
			return termStatus;
			
		} else if ([option isEqualToString:@"configure"])
		{
			nitoHelperClass *nhc = [[nitoHelperClass alloc] init];
			int termStatus = [nhc configure];
			[nhc release];
			[pool release];
			return termStatus;
		} else if ([option isEqualToString:@"autoremove"])
		{
			nitoHelperClass *nhc = [[nitoHelperClass alloc] init];
			int termStatus = [nhc autoremove];
			[nhc release];
			[pool release];
			return termStatus;
		} else if ([option isEqualToString:@"queue"])
		{
			nitoHelperClass *nhc = [[nitoHelperClass alloc] init];
			int termStatus = [nhc installQueue:value];
			[nhc release];
			[pool release];
			return termStatus;
		}  else if ([option isEqualToString:@"upgrade"])
		{
			nitoHelperClass *nhc = [[nitoHelperClass alloc] init];
			int termStatus = [nhc updateAll];
			[nhc release];
			[pool release];
			return termStatus;
		} else if ([option isEqualToString:@"update"])
		{
			int termStatus = [nitoHelperClass aptUpdate];
			[pool release];
			return termStatus;	
		} else if ([option isEqualToString:@"fix43"])
		{
			int termStatus = [nitoHelperClass fix43:value];
			[pool release];
			return termStatus;	
		} else if ([option isEqualToString:@"50"])
		{
			int termStatus = [nitoHelperClass fix50];
			[pool release];
			return termStatus;	
		} else if ([option isEqualToString:@"su"])
		{
			int termStatus = [nitoHelperClass updateSelf];
			[pool release];
			return termStatus;	
		} else if ([option isEqualToString:@"addSource"])
		{
			int termStatus = [nitoHelperClass addNitoSource:value];
			[pool release];
			return termStatus;	
		} else if ([option isEqualToString:@"removeRepo"])
		{
			int termStatus = [nitoHelperClass removeRepo:value];
			[pool release];
			return termStatus;	
		} else if ([option isEqualToString:@"fixd"])
		{
			int termStatus = [nitoHelperClass fixDepends];
			[pool release];
			return termStatus;	
		} else if ([option isEqualToString:@"quiet_update"])
		{
			int termStatus = [nitoHelperClass aptUpdateQuiet];
			[pool release];
			return termStatus;	
		} else if ([option isEqualToString:@"restoreRepo"])
		{
			int termStatus = [nitoHelperClass addDefaultSource:[value intValue]];
			[pool release];
			return termStatus;
		} else if ([option isEqualToString:@"fixRepo"])
		{
			int termStatus = [nitoHelperClass fixRepo];
			[pool release];
			return termStatus;	
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
