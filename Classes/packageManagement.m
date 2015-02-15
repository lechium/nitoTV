	//
	//  packageManagement.m
	//  nitoTV
	//
	//  Created by Kevin Bradley on 10/29/10.
	//  Copyright 2010 nito, LLC. All rights reserved.
	//

#import "packageManagement.h"
#import "Reachability.h"

	//http://appldnld.apple.com/

#define STATUS_FILE		  @"/var/lib/dpkg/status"
#define LIST_LOCATION	  @"/var/lib/apt/lists/"
#define ARCHIVES_LOCATION @"/var/cache/apt/archives"

#define NOW_STRING		[df stringFromDate:[NSDate date]]
#define CHECK_FREQ		[[nitoDefaultManager preferences] integerForKey:UPDATE_CHECK_FREQUENCY]
#define TRUNCATE_COUNT  4000

enum {

	kNitoSaurikSource,
	kNitoZodttdSource,
	kNitoBigbossSource,
	kNitoModmyiSource,
	kNitoAwkSource,
};

@implementation packageManagement

+ (id)_imageWithURL:(NSURL *)urlPath
{
    Class imageClass = objc_getClass("BRImage");
    if (imageClass == nil) //5.4bx+
    {
        imageClass = objc_getClass("ATVImage");
    }
    
    if (imageClass == nil)
    {
        NSLog(@"the whole world is exploding, no BRImage OR ATVImage, how is this possible???");
        return nil;
    }
    return [imageClass imageWithURL:urlPath];
}

+ (id)_imageWithPath:(NSString *)imagePath
{
    Class imageClass = objc_getClass("BRImage");
    if (imageClass == nil) //5.4bx+
    {
        imageClass = objc_getClass("ATVImage");
    }
    
    if (imageClass == nil)
    {
        NSLog(@"the whole world is exploding, no BRImage OR ATVImage, how is this possible???");
        return nil;
    }
    return [imageClass imageWithPath:imagePath];
}

+ (NSString *)properVersion
{
	Class cls = NSClassFromString(@"ATVVersionInfo");
	if (cls != nil)
	{ return [cls currentOSVersion]; }
	
	return nil;	
}

+ (BOOL)ntvSevenPointOhPLus
{
	
	NSString *versionNumber = [packageManagement properVersion];
	NSString *baseline = @"7.0";
	NSComparisonResult theResult = [versionNumber compare:baseline options:NSNumericSearch];
    //NSLog(@"properVersion: %@", versionNumber);
    //NSLog(@"theversion: %@  installed version %@", theVersion, installedVersion);
	if ( theResult == NSOrderedDescending )
	{
        //	NSLog(@"%@ is greater than %@", versionNumber, baseline);
		
		return YES;
		
	} else if ( theResult == NSOrderedAscending ){
		
        //NSLog(@"%@ is greater than %@", baseline, versionNumber);
		return NO;
		
	} else if ( theResult == NSOrderedSame ) {
		
        //		NSLog(@"%@ is equal to %@", versionNumber, baseline);
		return YES;
	}
	
	return NO;
}

+ (BOOL)ntvSixPointOhPLus
{
	
	NSString *versionNumber = [packageManagement properVersion];
	NSString *baseline = @"6.0";
	NSComparisonResult theResult = [versionNumber compare:baseline options:NSNumericSearch];
		//NSLog(@"properVersion: %@", versionNumber);
		//NSLog(@"theversion: %@  installed version %@", theVersion, installedVersion);
	if ( theResult == NSOrderedDescending )
	{
			//	NSLog(@"%@ is greater than %@", versionNumber, baseline);
		
		return YES;
		
	} else if ( theResult == NSOrderedAscending ){
		
			//NSLog(@"%@ is greater than %@", baseline, versionNumber);
		return NO;
		
	} else if ( theResult == NSOrderedSame ) {
		
			//		NSLog(@"%@ is equal to %@", versionNumber, baseline);
		return YES;
	}
	
	return NO;
}

+ (BOOL)ntvFivePointOnePlus
{
	
	NSString *versionNumber = [packageManagement properVersion];
	NSString *baseline = @"5.1";
	NSComparisonResult theResult = [versionNumber compare:baseline options:NSNumericSearch];
	//NSLog(@"properVersion: %@", versionNumber);
	//NSLog(@"theversion: %@  installed version %@", theVersion, installedVersion);
	if ( theResult == NSOrderedDescending )
	{
		//	NSLog(@"%@ is greater than %@", versionNumber, baseline);
		
		return YES;
		
	} else if ( theResult == NSOrderedAscending ){
		
		//NSLog(@"%@ is greater than %@", baseline, versionNumber);
		return NO;
		
	} else if ( theResult == NSOrderedSame ) {
		
		//		NSLog(@"%@ is equal to %@", versionNumber, baseline);
		return YES;
	}
	
	return NO;
}

+ (BOOL)ntvFivePointZeroPlus
{
	
	NSString *versionNumber = [packageManagement properVersion];
	NSString *baseline = @"5.0";
	NSComparisonResult theResult = [versionNumber compare:baseline options:NSNumericSearch];
	//NSLog(@"properVersion: %@", versionNumber);
	//NSLog(@"theversion: %@  installed version %@", theVersion, installedVersion);
	if ( theResult == NSOrderedDescending )
	{
		//	NSLog(@"%@ is greater than %@", versionNumber, baseline);
		
		return YES;
		
	} else if ( theResult == NSOrderedAscending ){
		
		//NSLog(@"%@ is greater than %@", baseline, versionNumber);
		return NO;
		
	} else if ( theResult == NSOrderedSame ) {
		
		//		NSLog(@"%@ is equal to %@", versionNumber, baseline);
		return YES;
	}
	
	return NO;
}

+ (void)PMRunConfigure
{
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper configure 1 2"];
	int configReturn = system([command UTF8String]);
	NSLog(@"configure returned with status %i", configReturn);
}

+ (void)PMRunAutoremove
{
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper autoremove 1 2"];
	int configReturn = system([command UTF8String]);
	NSLog(@"autoremove returned with status %i", configReturn);
		//id installStatus = [self installFinishedWithStatus:configReturn andFeedback:[self aptStatus]];
	
		//[[self stack] swapController:installStatus];
}

+ (id)sharedManager
{
	static packageManagement *shared = nil;
	if(shared == nil)
		shared = [[packageManagement alloc] init];
	
	return shared;
}

//+ (packageManagement *)sharedInstance
//{
//    return [[self alloc] init];
//}


	//filter through the basic array and change it from an array to \n delimited mutable string 

+ (NSString *)essentialDisplayStringFromArray:(NSArray *)essentialArray
{
	NSMutableString *essentialString = [[NSMutableString alloc] init];
	NSEnumerator *essentialEnum = [essentialArray objectEnumerator];
	id currentObject = nil;
	while((currentObject = [essentialEnum nextObject]))
	{
			//id objectName = [currentObject valueForKey:@"Package"];
		[essentialString appendFormat:@"%@\n ", currentObject];
	}
	
	return [essentialString autorelease];
}


+ (BOOL)essentialUpdatesExist
{
	NSArray *essentialArray = [packageManagement essentialUpdatesAvailable];
	if ([essentialArray count] > 0)
		return YES;
	
	return NO;
	
}

+ (NSArray *)basicAppleTVUpdatesAvailable
{
	NSMutableArray *atvArray = [[NSMutableArray alloc] init]; //final array
	
		//find the location of each raw list file for sauriks repo, awk repo and nito repo
	
	NSString *saurikPath = [packageManagement sauriksListLocation];
	
	NSString *nitoPath = [packageManagement nitoListLocation];
	NSString *awkPath = [packageManagement awkListLocation];
	NSString *xbmcPath = [packageManagement XBMCLocation];
	
		//make the initial array from sauriks path, and then add both nito and awk arrays
	
	NSMutableArray *saurikList = [[NSMutableArray alloc] initWithArray:[packageManagement parsedPackageArrayForRepo:saurikPath]]; //full list
	
	[saurikList addObjectsFromArray:[packageManagement parsedPackageArrayForRepo:nitoPath]]; //add nito packages
	[saurikList addObjectsFromArray:[packageManagement parsedPackageArrayForRepo:awkPath]]; //add awk packages
	[saurikList addObjectsFromArray:[packageManagement parsedPackageArrayForRepo:xbmcPath]]; //add xbmc packages

		//NSLog(@"saurikList: %@", saurikList);
	NSEnumerator *sEnum = [saurikList objectEnumerator];

	id theObject = nil;
	while((theObject = [sEnum nextObject]))
	{
		id objectName = [theObject valueForKey:@"Package"];
		id onlineVersion = [theObject valueForKey:@"Version"];
		id installedVersion = [[packageManagement sharedManager] packageVersion:objectName];
		if (installedVersion != nil)
		{
				//NSLog(@"package: '%@' online version: '%@' installed version: '%@'", objectName, onlineVersion, installedVersion);
			NSComparisonResult theResult = [installedVersion compare:onlineVersion options:NSNumericSearch];
			
			if ( theResult == NSOrderedAscending )
			{
				NSLog(@"%@: online version %@ is greater than installedVersion: %@", objectName, onlineVersion, installedVersion);
				[atvArray addObject:objectName];
					//[essentialArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:objectName, @"Package", installedVersion, @"InstalledVersion", onlineVersion, @"OnlineVersion", nil]];
				
			}
		}
		
	}
	[saurikList release];
	saurikList = nil;
	return [atvArray autorelease];
	
}

+ (NSArray *)basicEssentialUpdatesAvailable
{
	[packageManagement aptUpdateQuiet];
	NSMutableArray *essentialArray = [[NSMutableArray alloc] init]; //final array
	
		//find the location of each raw list file for sauriks repo, awk repo and nito repo
	
	NSString *saurikPath = [packageManagement sauriksListLocation];
	NSString *nitoPath = [packageManagement nitoListLocation];
	NSString *awkPath = [packageManagement awkListLocation];
	
		//make the initial array from sauriks path, and then add both nito and awk arrays
	
	NSMutableArray *saurikList = [[NSMutableArray alloc] initWithArray:[packageManagement parsedPackageArrayForRepo:saurikPath]]; //full list
	[saurikList addObjectsFromArray:[packageManagement parsedPackageArrayForRepo:nitoPath]]; //add nito packages
	[saurikList addObjectsFromArray:[packageManagement parsedPackageArrayForRepo:awkPath]]; //add awk packages
	
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:ESSENTIAL_PREDICATE]; //extensions.h
	NSArray *filteredArray = [saurikList filteredArrayUsingPredicate:filterPredicate];
	NSEnumerator *filteredEnum = [filteredArray objectEnumerator];
	
		//array is now filtered, now we cycle through to see which ones are actually installed AND have updates available
	
	id theObject = nil;
	while((theObject = [filteredEnum nextObject]))
	{
		id objectName = [theObject valueForKey:@"Package"];
		id onlineVersion = [theObject valueForKey:@"Version"];
		id installedVersion = [[packageManagement sharedManager] packageVersion:objectName];
		if (installedVersion != nil)
		{
				//NSLog(@"package: '%@' online version: '%@' installed version: '%@'", objectName, onlineVersion, installedVersion);
			NSComparisonResult theResult = [installedVersion compare:onlineVersion options:NSNumericSearch];
			
			if ( theResult == NSOrderedAscending )
			{
				NSLog(@"%@: online version %@ is greater than installedVersion: %@", objectName, onlineVersion, installedVersion);
				[essentialArray addObject:objectName];
					//[essentialArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:objectName, @"Package", installedVersion, @"InstalledVersion", onlineVersion, @"OnlineVersion", nil]];
				
			}
		}
		
	}
	[saurikList release];
	saurikList = nil;
	return [essentialArray autorelease];
	
}

	//right now this one isnt used, but it may be used in the future if i decide to display more in-depth info about what updates are available

+ (NSArray *)essentialUpdatesAvailable
{
	NSMutableArray *essentialArray = [[NSMutableArray alloc] init]; //final array
	
		//find the location of each raw list file for sauriks repo, awk repo and nito repo
	
	NSString *saurikPath = [packageManagement sauriksListLocation];
	NSString *nitoPath = [packageManagement nitoListLocation];
	NSString *awkPath = [packageManagement awkListLocation];
	
		//make the initial array from sauriks path, and then add both nito and awk arrays
	
	NSMutableArray *saurikList = [[NSMutableArray alloc] initWithArray:[packageManagement parsedPackageArrayForRepo:saurikPath]]; //full list
	[saurikList addObjectsFromArray:[packageManagement parsedPackageArrayForRepo:nitoPath]]; //add nito packages
	[saurikList addObjectsFromArray:[packageManagement parsedPackageArrayForRepo:awkPath]]; //add awk packages
	
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:ESSENTIAL_PREDICATE]; //extensions.h
	NSArray *filteredArray = [saurikList filteredArrayUsingPredicate:filterPredicate];
	NSEnumerator *filteredEnum = [filteredArray objectEnumerator];
	
		//array is now filtered, now we cycle through to see which ones are actually installed AND have updates available
	
	id theObject = nil;
	while((theObject = [filteredEnum nextObject]))
	{
		id objectName = [theObject valueForKey:@"Package"];
		id onlineVersion = [theObject valueForKey:@"Version"];
		id installedVersion = [[packageManagement sharedManager] packageVersion:objectName];
		if (installedVersion != nil)
		{
				//NSLog(@"package: '%@' online version: '%@' installed version: '%@'", objectName, onlineVersion, installedVersion);
			NSComparisonResult theResult = [installedVersion compare:onlineVersion options:NSNumericSearch];
			
			if ( theResult == NSOrderedAscending )
			{
				NSLog(@"%@: online version %@ is greater than installedVersion: %@", objectName, onlineVersion, installedVersion);
				[essentialArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:objectName, @"Package", installedVersion, @"InstalledVersion", onlineVersion, @"OnlineVersion", nil]];
				
			}
		}
		
	}
	[saurikList release];
	saurikList = nil;
	return [essentialArray autorelease];
	
}

- (void)_updateDateCheck
{
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"MMddyy_HHmmss"];
		NSString *newDate = [df stringFromDate:[NSDate date]];
		[[nitoDefaultManager preferences] setObject:newDate forKey:LAST_UPDATE_CHECK];
		//[FR_PREF setObject:newDate forKey:LAST_UPDATE_CHECK];

			//NSLog(@"update date with value: %@", newDate);
		[df release];	
}

- (NSString *)_lastCheckDate
{
		//LogSelf;
		//return [FR_PREF stringForKey:LAST_UPDATE_CHECK];
		return [[nitoDefaultManager preferences] objectForKey:LAST_UPDATE_CHECK];
}

-(BOOL)_shouldCheckUpdate
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"MMddyy_HHmmss"];
	NSDate *myDate = [df dateFromString: [self _lastCheckDate]];
	NSDate *now = [df dateFromString:NOW_STRING];
	[df release];
	double timeSinceDate = [now timeIntervalSinceDate:myDate];
	
	double minutes = (timeSinceDate / 60);
	
		//	NSLog(@"minutes: %g",minutes ); //minutes since check
	
	if (minutes > CHECK_FREQ) //FIXME change to higher value!!!
	{
		[self _updateDateCheck];
		return YES;
		
	}
	
	return NO;
}

	//us.scw.afctwoadd

+ (BOOL)internetAvailable
{
	NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
	switch (netStatus) {
			
		case NotReachable:
			//NSLog(@"NotReachable");
			return NO;
			break;
			
		case ReachableViaWiFi:
			//NSLog(@"ReachableViaWiFi");
			return YES;
			break;
			
			
		case ReachableViaWWAN:
			//NSLog(@"ReachableViaWWAN");
			return YES;
			break;
	}
	return NO;
}
//+ (BOOL)internetAvailable
//{
//	return [objc_getClass("BRIPConfiguration") internetAvailable];
//}

- (void)checkForUpdate //change update check to look for a typedef int rather than bool, then we can say 0 == update nitotv 1 = update essential 2 = both -1 = none?
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if ([self _shouldCheckUpdate] == FALSE)
	{
		NSLog(@"checked within the last %i minutes!!!", CHECK_FREQ);
			//return nil;
		[pool release];
		return;
	}
	
    BOOL internetAvailable = [packageManagement internetAvailable];
	//BOOL internetAvailable = [objc_getClass("BRIPConfiguration") internetAvailable];
	if (internetAvailable == TRUE)
	{
		NSArray *updateArray = [packageManagement basicEssentialUpdatesAvailable];
		if ([updateArray count] > 0)
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:@"CheckForUpdate" object:updateArray userInfo:nil];
				//return updateArray;
		}
	}
	[pool release];
		//return nil;
	
}

/*

- (BOOL)oldcheckForUpdate //change update check to look for a typedef int rather than bool, then we can say 0 == update nitotv 1 = update essential 2 = both -1 = none?
{
		//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		//LogSelf;
	if ([self _shouldCheckUpdate] == FALSE)
	{
		NSLog(@"checked within the last %i minutes!!!", CHECK_FREQ);
		return FALSE;
	}
	
	BOOL internetAvailable = [BRIPConfiguration internetAvailable];
	if (internetAvailable == TRUE)
	{
		NSString *localVersion = [[packageManagement sharedManager] packageVersion:@"com.nito.nitotv"];
		NSDictionary *vDict = [[NSDictionary alloc] initWithContentsOfURL:[[[NSURL alloc] initWithString:@"http://nitosoft.com/version.plist"] autorelease]];
			//NSLog(@"vDict: %@", vDict);
		NSString *onlineVersion = [vDict objectForKey:@"versionThree"];
			//NSLog(@"onlineVersion: %@ localVersion: %@", onlineVersion, localVersion);
		NSComparisonResult theResult = [localVersion compare:onlineVersion options:NSNumericSearch];
		
		if ( theResult == NSOrderedDescending )
		{
				//NSLog(@"local version %@ is greater than online version: %@", localVersion, onlineVersion);
				//[pool release];
			return FALSE;
		} else if ( theResult == NSOrderedAscending ){
			
				//NSLog(@"local version %@ is less than online version: %@", localVersion, onlineVersion);
			NSLog(@"update available!!");
				//[[NSNotificationCenter defaultCenter] postNotificationName:@"CheckForUpdate" object:nil];
				//[pool release];
			
			return TRUE;
		} else if ( theResult == NSOrderedSame ) {
			
				//NSLog(@"local version %@ is equal to online version: %@", localVersion, onlineVersion);
			
				//[pool release];
			return FALSE;
		} else {
			
			NSLog(@"what a world what a world!!!!, explosions imminent, women and children first!!");
				//[pool release];
			return FALSE;
		}
		
		
	}
		//[pool release];
		//[pool drain];
	return FALSE;
	
}

*/

+ (NSArray *)depedenciesForPackage:(NSString *)currentPackage
{
	NSDictionary *packageList = [packageManagement easyLazyIHateYouParsedPackageList];
		//id currentDict = [packageList objectForKey:currentPackage];
	if ([packageList objectForKey:currentPackage] != nil)
	{
		id currentDict = [packageList objectForKey:currentPackage];
		if ([[currentDict allKeys] containsObject:@"Depends"])
		{
			NSMutableArray *cleanArray = [[NSMutableArray alloc] init];
			NSString *depends = [currentDict valueForKey:@"Depends"];
			NSArray *dependsArray = [depends componentsSeparatedByString:@","];
			for (id depend in dependsArray)
			{
				NSArray *spaceDelimitedArray = [depend componentsSeparatedByString:@" "];
				NSString *isolatedDependency = [[spaceDelimitedArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				if ([isolatedDependency length] == 0)
					isolatedDependency = [[spaceDelimitedArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				[cleanArray addObject:isolatedDependency];
			}
			
			return [cleanArray autorelease];
		}
		
	}
	
	return nil;
}

- (NSArray *)depedenciesForPackage:(NSString *)currentPackage
{
	NSDictionary *packageList = [self parsedPackageList];
		//id currentDict = [packageList objectForKey:currentPackage];
	if ([packageList objectForKey:currentPackage] != nil)
	{
		id currentDict = [packageList objectForKey:currentPackage];
		if ([[currentDict allKeys] containsObject:@"Depends"])
			return [currentDict objectForKey:@"Depends"];
		else
			return nil;
		
	}
	
	return nil;
}

- (NSString *)packageVersion:(NSString *)currentPackage
{
	NSDictionary *packageList = [self parsedPackageList];
		//id currentDict = [packageList objectForKey:currentPackage];
	if ([packageList objectForKey:currentPackage] != nil)
	{
		id currentDict = [packageList objectForKey:currentPackage];
		if ([[currentDict allKeys] containsObject:@"Version"])
			return [currentDict objectForKey:@"Version"];
		else
			return nil;
		
	}
	
	return nil;
}

- (BOOL)packageInstalled:(NSString *)currentPackage
{
	NSDictionary *packageList = [self parsedPackageList];
	if ([packageList objectForKey:currentPackage] != nil)
	{
		id currentDict = [packageList objectForKey:currentPackage];
		if ([[currentDict allKeys] containsObject:@"Version"])
			return YES;
		else
			return NO;
		
	}
	
	return NO;
}

+ (NSDictionary *)easyLazyIHateYouParsedPackageList
{
	NSString *endFile = [packageManagement installedLocation];
	NSDictionary *parsedDict = [NSDictionary dictionaryWithContentsOfFile:endFile];
	return parsedDict;
}

- (NSDictionary *)parsedPackageList
{
		//NSString *endFile = @"/Installed.plist";
	NSString *endFile = [packageManagement installedLocation];
	NSDictionary *parsedDict = [NSDictionary dictionaryWithContentsOfFile:endFile];
	return parsedDict;
}

- (NSArray *)untouchables
{
	return [NSArray arrayWithObjects:@"openssh", @"openssl", @"cydia", @"apt7", @"apt7-key", @"apt7-lib", @"apt7-ssl", @"berkeleydb", @"com.nito.nitotv", @"beigelist", @"mobilesubstrate", @"com.nito", @"org.awkwardtv",@"bash", @"bzip2", @"coreutils-bin", @"diffutils", @"findutils", @"gzip", @"lzma", @"ncurses", @"tar", @"firmware-sbin", @"dpkg", @"gnupg", @"gzip", @"lzma", @"curl", @"coreutils", @"cy+cpu.arm", @"cy+kernel.darwin", @"cy+model.appletv", @"cy+os.ios", @"org.tomcool.smframework",nil];
}

- (BOOL)canRemove:(NSString *)theItem
{
	if ([[self untouchables] containsObject:theItem])
	{
		return NO;
	}
	NSDictionary *packageList = [self parsedPackageList];
	NSDictionary *packageDict = [packageList valueForKey:theItem];	
	NSString *essential = [packageDict objectForKey:@"Essential"];
	NSString *priority = [packageDict objectForKey:@"Priority"];
	if ([essential length] > 1)
	{
		if ([[essential lowercaseString] isEqualToString:@"yes"])
		{
			NSLog(@"nito_install_idiot_proofing: cannot delete essential package: %@ with priority: %@", theItem, priority);
			return NO;
		}
	}
	NSLog(@"priority: %@", priority);
	if ([priority length] == 0)
		return YES;
	
	if ([priority length] > 1)
	{
		if ([[priority lowercaseString] isEqualToString:@"required"])
		{
			NSLog(@"nito_install_idiot_proofing: cannot delete package: %@ with priority: %@", theItem, priority);
			return NO;
			
		} else {
			return YES;
		} 
	}
	return NO;
}

+ (int)addSource:(NSString *)theSource
{
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper addSource %@ 2", theSource];
	int sysReturn = system([command UTF8String]);
	NSLog(@"addSource ended with: %i", sysReturn);
	return sysReturn;
}

+ (BOOL)addLine:(NSString *)theLine toFile:(NSString *)theFile
{
	NSString *fileContents = nil;
	NSMutableArray *lineArray = nil;
	
	if ([FM fileExistsAtPath:theFile])
	{
		fileContents = [NSString stringWithContentsOfFile:theFile encoding:NSUTF8StringEncoding error:nil];
		lineArray = [[NSMutableArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
	
	} else { //no file yet!
		
		lineArray = [[NSMutableArray alloc] init];
	}
	
	[lineArray addObject:theLine];
	
	NSMutableString *outputFile = [[NSMutableString alloc] initWithString:[lineArray componentsJoinedByString:@"\n"]];
	if([outputFile writeToFile:theFile atomically:YES encoding:NSUTF8StringEncoding error:nil] == TRUE)
	{
		[lineArray release];
		lineArray = nil;
		[outputFile release];
		outputFile = nil;
		return TRUE;
	}
	
	[lineArray release];
	lineArray = nil;
	[outputFile release];
	outputFile = nil;
	return FALSE;
}


+ (NSArray *)kosherSections
{
	return [NSArray arrayWithObjects:@"Data Storage", @"Development",  @"Fonts", @"Networking", @"Packaging", @"Repositories", @"System", @"Tweaks", @"Utilities", 
			@"utils", @"Multimedia", @"ATV_Settings", @"Main_Menu_Extensions", @"Music", @"Localization", @"Networking",@"Productivity", nil];
}

+ (NSArray *)fullSectionList
{
	return [NSArray arrayWithObjects:@"Addons", @"Administration", @"Archiving", @"Books", @"Carrier Bundles", @"Data Storage", @"Development", 
			@"Dictionaries", @"Education", @"Entertainment", @"Fonts", @"Games", @"Java", @"Keyboards", @"Localization", @"Messaging", @"Multimedia", 
			@"Navigation", @"Networking", @"Packaging", @"Productivity", @"Repositories", @"Ringtones", @"Scripting", 
			@"Site-Specific Apps", @"Social", @"Soundboards", @"System", @"Terminal Support", @"Text Editors", @"Themes", @"Toys", @"Tweaks", @"Utilities", 
			@"Wallpaper", @"Widgets", @"X Window", nil];
	
}

+ (int)aptUpdateQuiet
{
	NSString *command = @"/usr/bin/nitoHelper quiet_update 1 2";
	int sysReturn = system([command UTF8String]);
	return sysReturn;
}

+ (int)aptUpdate
{
	NSString *command = @"/usr/bin/nitoHelper update 1 2";
	int sysReturn = system([command UTF8String]);
	return sysReturn;
}


+ (void)convertPlistToBinary:(NSString *)plistPath
{
	NSFileManager *man = [NSFileManager defaultManager];
	
	NSString *tempPath = @"/private/var/tmp/tmp.plist";
	NSData *plistData;
	NSString *error;
	NSPropertyListFormat format;
	id plist;
	id binaryPlistData;
	plistData = [NSData dataWithContentsOfFile:plistPath];
	
	plist = [NSPropertyListSerialization propertyListFromData:plistData
											 mutabilityOption:NSPropertyListImmutable
													   format:&format
											 errorDescription:&error];
	
	if(plist == nil) { // unable to parse plist
		NSLog(@"error occured: %@", error);
		
	} else {
		binaryPlistData = [NSPropertyListSerialization dataFromPropertyList:plist
																	 format:NSPropertyListBinaryFormat_v1_0
														   errorDescription:&error];
		if(binaryPlistData == nil) {//unable to create serialized plist
									// deal with failure -- error gives description of the error
			NSLog(@"error occured: %@", error);
		}
		
		if(![binaryPlistData writeToFile:tempPath atomically:YES]) {
			NSLog(@"file failed to write!!!");
		} else {
			
			NSLog(@"file didnt fail!, replace the old one!");
			[man removeItemAtPath:plistPath error:nil];
			[man moveItemAtPath:tempPath toPath:plistPath error:nil];
			
		}
	}
}



+ (void)updatePackageList
{
	NSString *endFile = [packageManagement installedLocation];
	NSDictionary *packageList = [packageManagement parsedPackageList];
	[packageList writeToFile:endFile atomically:YES];
}

+ (NSString *)installedLocation
{
	NSString *theDest = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
	NSString *installedFile = [theDest stringByAppendingPathComponent:@"Installed.plist"];
	return installedFile;
}



	// /var/lib/apt/lists/


+ (NSString *)sauriksListLocation
{
	return [packageManagement listLocationFromString:SAURIK_DOMAIN];
}

+ (NSString *)awkListLocation
{
	return [packageManagement listLocationFromString:AWK_DOMAIN];
}

+ (NSString *)nitoListLocation
{
	return [packageManagement listLocationFromString:NITO_SOURCE_DOMAIN];
}

+ (NSString *)XBMCLocation
{
	return [packageManagement listLocationFromString:XBMC_DOMAIN];
}
//+ (NSString *)sauriksListLocation
//{
//	NSArray *fla = [packageManagement filteredListArray];
//	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] 'apt.saurik.com'"];
//	NSArray *newArray = [fla filteredArrayUsingPredicate:filterPredicate];
//	if ([newArray count] > 0)
//		return [newArray objectAtIndex:0];
//	else 
//		return nil;
//}

+ (NSString *)domainFromRepoObject:(NSString *)repoObject
{
		//LogSelf;
    if ([repoObject length] == 0)return nil;
	NSArray *sourceObjectArray = [repoObject componentsSeparatedByString:@" "];
	NSString *url = [sourceObjectArray objectAtIndex:1];
    if ([url length] > 7)
    {
        NSString *urlClean = [url substringFromIndex:7];
        NSArray *secondArray = [urlClean componentsSeparatedByString:@"/"];
        return [secondArray objectAtIndex:0];
    }
    return nil;
}

+ (NSArray *)sourcesFromFile:(NSString *)theSourceFile
{
	NSMutableArray *finalArray = [[NSMutableArray alloc] init];
	NSString *sourceString = [[NSString stringWithContentsOfFile:theSourceFile encoding:NSASCIIStringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSArray *sourceFullArray =  [sourceString componentsSeparatedByString:@"\n"];
	NSEnumerator *sourceEnum = [sourceFullArray objectEnumerator];
	id currentSource = nil;
	while (currentSource = [sourceEnum nextObject])
	{
        NSString *theObject = [packageManagement domainFromRepoObject:currentSource];
        if (theObject != nil)
        {
            if (![finalArray containsObject:theObject])
                [finalArray addObject:theObject];
        }
    }
	
	return [finalArray autorelease];
}

+(void)restoreDefaultRepo:(int)defaultRepo
{
	
}

/*
 
 cydia.list
 
 deb http://apt.saurik.com/ ios/675.00 main
 deb http://cydia.zodttd.com/repo/cydia/ stable main
 deb http://apt.thebigboss.org/repofiles/cydia/ stable main
 deb http://apt.modmyi.com/ stable main
 
 
 awkwardtv.list
 
 deb http://apt.awkwardtv.org/ stable main
 
 
 cy# [packageManagement detailedRepoDomainList]
 [{lineIndex:"0",SourceDomain:"apt.awkwardtv.org",SourceFile:"/etc/apt/sources.list.d/awkwardtv.list"},{lineIndex:"0",SourceDomain:"apt.saurik.com",SourceFile:"/etc/apt/sources.list.d/cydia.list"},{lineIndex:"1",SourceDomain:"cydia.zodttd.com",SourceFile:"/etc/apt/sources.list.d/cydia.list"},{lineIndex:"2",SourceDomain:"apt.thebigboss.org",SourceFile:"/etc/apt/sources.list.d/cydia.list"},{lineIndex:"3",SourceDomain:"apt.modmyi.com",SourceFile:"/etc/apt/sources.list.d/cydia.list"},{lineIndex:"0",SourceDomain:"dl.firecore.com",SourceFile:"/etc/apt/sources.list.d/firecore.list"},{lineIndex:"0",SourceDomain:"nitosoft.com",SourceFile:"/etc/apt/sources.list.d/nito.list"},{lineIndex:"0",SourceDomain:"mirrors.xbmc.org",SourceFile:"/etc/apt/sources.list.d/xbmc.list"}]

 
 */

+ (NSArray *)detailedRepoDomainList
{
	NSMutableArray *finalListArray = [[NSMutableArray alloc] init];
	NSArray *skipItems = [NSArray arrayWithObjects:@"saurik.list", @".DS_Store", nil];
	NSString *sourcesFolder = @"/etc/apt/sources.list.d";
	NSDirectoryEnumerator *theEnum = [[NSFileManager defaultManager] enumeratorAtPath:sourcesFolder];
	id theObject = nil;
	while(theObject = [theEnum nextObject])
	{
		if (![skipItems containsObject:theObject])
		{
			if ([[[theObject pathExtension] lowercaseString] isEqualToString:@"list"])
			{
				NSString *fullPath = [sourcesFolder stringByAppendingPathComponent:theObject];
				NSArray *sourceArray = [packageManagement sourcesFromFile:fullPath];
				int index = 0;
				for (id currentSource in sourceArray)
				{
					NSDictionary *objectDict = [NSDictionary dictionaryWithObjectsAndKeys:fullPath, @"SourceFile", currentSource, @"SourceDomain", [NSString stringWithFormat:@"%i", index], @"lineIndex", nil];
					[finalListArray addObject:objectDict];
					index++;
					
				}
			}
			
		}
	}
	return [finalListArray autorelease];
}

	//["apt.awkwardtv.org","apt.saurik.com","cydia.zodttd.com","apt.thebigboss.org","apt.modmyi.com","nitosoft.com","mirrors.xbmc.org"]

+ (NSArray *)defaultDomains
{
	return [NSArray arrayWithObjects:@"apt.awkwardtv.org",@"apt.saurik.com",@"cydia.zodttd.com",@"apt.thebigboss.org",@"apt.modmyi.com",@"nitosoft.com", nil];
}

+ (int)sourceIntegerForRepo:(NSString *)theRepo
{
		//	LogSelf;
		//NSLog(@"repo: %@", theRepo);
	
	if ([theRepo isEqualToString:AWK_DOMAIN])
		return kNitoAwkSource;
	if ([theRepo isEqualToString:SAURIK_DOMAIN])
		return kNitoSaurikSource;
	if ([theRepo isEqualToString:ZODTTD_DOMAIN])
		return kNitoZodttdSource;
	if ([theRepo isEqualToString:BIGBOSS_DOMAIN])
		return kNitoBigbossSource;
	if ([theRepo isEqualToString:MODMYI_DOMAIN])
		return kNitoModmyiSource;
	
	return -1;

}

+ (NSArray *)missingDefaultDomains
{
	NSMutableArray *finalListArray = [[NSMutableArray alloc] init];
	NSArray *defaultDomains = [packageManagement defaultDomains];
	NSArray *rdl = [packageManagement repoDomainList];
	NSEnumerator *repoEnum = [defaultDomains objectEnumerator];
	id currentDomain = nil;
	while (currentDomain = [repoEnum nextObject])
	{
		if (![rdl containsObject:currentDomain])
		{
				//NSLog(@"domain missing: %@ add it!", currentDomain);
			NSString *sourceIntStr = [NSString stringWithFormat:@"%i", [packageManagement sourceIntegerForRepo:currentDomain]];
			
			[finalListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:currentDomain, @"SourceDomain", sourceIntStr, @"SourceInteger", nil]];
		}
	}
	
	return [finalListArray autorelease];
}

+ (NSArray *)repoDomainList
{
	NSMutableArray *finalListArray = [[NSMutableArray alloc] init];
	NSArray *skipItems = [NSArray arrayWithObjects:@"saurik.list", @".DS_Store", nil];
	NSString *sourcesFolder = @"/etc/apt/sources.list.d";
	NSDirectoryEnumerator *theEnum = [[NSFileManager defaultManager] enumeratorAtPath:sourcesFolder];
	id theObject = nil;
	while(theObject = [theEnum nextObject])
	{
		if (![skipItems containsObject:theObject])
		{
			if ([[[theObject pathExtension] lowercaseString] isEqualToString:@"list"])
			{
				NSString *fullPath = [sourcesFolder stringByAppendingPathComponent:theObject];
				[finalListArray addObjectsFromArray:[packageManagement sourcesFromFile:fullPath]];
			}
			
		}
	}
	return [finalListArray autorelease];
}

+ (NSString *)displayDependentsForPackage:(NSString *)thePackage
{
	NSArray *dependants = [packageManagement dependentsForPackage:thePackage];
	NSMutableArray *nameArray = [[NSMutableArray alloc] init];
	for(id currentDependant in dependants)
	{
		[nameArray addObject:[currentDependant valueForKey:@"Package"]];
	}
	return [packageManagement essentialDisplayStringFromArray:[nameArray autorelease]];
}

+ (NSArray *)dependentsForPackage:(NSString *)thePackage
{
	NSArray *packageList = [packageManagement parsedPackageArray];
		//NSLog(@"packageList: %@", packageList);
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"%@ IN Depends", thePackage];
	NSArray *newArray = [packageList filteredArrayUsingPredicate:filterPredicate];
	if ([newArray count] > 0)
		return newArray;
	else 
		return nil;
}

+ (void)writeSectionsInArray:(NSArray *)theArray
{
	NSMutableArray *sections = [[NSMutableArray alloc] init];
	for(id currentItem in theArray)
	{
		NSString *section = [currentItem valueForKey:@"Section"];
			//NSLog(@"section: %@", [currentItem valueForKey:@"Section"]);
		if (![sections containsObject:section])
		{
			[sections addObject:section];
		}
			 
		
		
	}
	NSString *outFile = @"/var/mobile/Library/Preferences/zod_leftover_sections.plist";
	[sections writeToFile:outFile atomically:YES];
	
	[sections release];
	sections = nil;
}

+ (void)writeOutRepo:(NSString *)theRepo
{
	LogSelf;
	NSString *myLocation = [packageManagement listLocationFromString:theRepo];
	NSArray *fullArray = [packageManagement parsedPackageArrayForRepo:myLocation];
	NSString *outputFile = [[@"/var/mobile/Library/Preferences" stringByAppendingPathComponent:theRepo] stringByAppendingPathExtension:@"plist"];
	[fullArray writeToFile:outputFile atomically:YES];
}


+ (NSArray *)simpleDependantsForPackage:(NSString *)thePackage
{
	NSArray *packageList = [packageManagement parsedPackageArray];
		//NSLog(@"packageList: %@", packageList);
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"%@ IN Depends", thePackage];
	NSArray *newArray = [packageList filteredArrayUsingPredicate:filterPredicate];
	NSMutableArray *finalArray = [[NSMutableArray alloc] init];
	
	for (id packageInfo in newArray)
	{
		[finalArray addObject:[packageInfo valueForKey:@"Package"]];
	}
	
	if ([finalArray count] > 0)
	{
		return [finalArray autorelease];
	}
	
	[finalArray release];
	finalArray = nil;
	return nil;
}



+ (NSString *)listLocationFromString:(NSString *)predicateString
{
	NSArray *fla = [packageManagement filteredListArray];
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", predicateString];
	NSArray *newArray = [fla filteredArrayUsingPredicate:filterPredicate];
	if ([newArray count] > 0)
		return [newArray objectAtIndex:0];
	else 
		return nil;
}

+ (NSString *)releaseLocationFromString:(NSString *)predicateString
{
	NSArray *fla = [packageManagement filteredReleaseArray];
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", predicateString];
	NSArray *newArray = [fla filteredArrayUsingPredicate:filterPredicate];
	if ([newArray count] > 0)
		return [newArray objectAtIndex:0];
	else 
		return nil;
}

+ (NSArray *)filteredReleaseArray
{
	NSArray *listArray = [FM contentsOfDirectoryAtPath:LIST_LOCATION error:nil];
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(SELF CONTAINS[c] '_Release') AND SELF endswith[c] 'e'"];
	NSArray *filteredArray = [listArray filteredArrayUsingPredicate:filterPredicate];
	
		//NSLog(@"filteredArray: %@", filteredArray);
	return filteredArray;
}

+ (NSArray *)filteredListArray
{
	NSArray *listArray = [FM contentsOfDirectoryAtPath:LIST_LOCATION error:nil];
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(SELF CONTAINS[c] '_Packages') AND SELF endswith[c] 's'"];
	NSArray *filteredArray = [listArray filteredArrayUsingPredicate:filterPredicate];
	
		//NSLog(@"filteredArray: %@", filteredArray);
	return filteredArray;
	
}

+ (NSArray *)dependencyArrayFromString:(NSString *)depends
{
	NSMutableArray *cleanArray = [[NSMutableArray alloc] init];
	NSArray *dependsArray = [depends componentsSeparatedByString:@","];
	for (id depend in dependsArray)
	{
		NSArray *spaceDelimitedArray = [depend componentsSeparatedByString:@" "];
		NSString *isolatedDependency = [[spaceDelimitedArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([isolatedDependency length] == 0)
			isolatedDependency = [[spaceDelimitedArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		[cleanArray addObject:isolatedDependency];
	}
	
	return [cleanArray autorelease];
}

+ (NSArray *)oldDependencyArrayFromString:(NSString *)dependString
{
	if ([dependString length] > 0)
		return [dependString componentsSeparatedByString:@", "];
	
	return nil;
}

+ (NSArray *)parsedPackageArray
{
	NSString *packageString = [NSString stringWithContentsOfFile:STATUS_FILE encoding:NSUTF8StringEncoding error:nil];
	NSArray *lineArray = [packageString componentsSeparatedByString:@"\n\n"];
		//NSLog(@"lineArray: %@", lineArray);
	NSMutableArray *mutableList = [[NSMutableArray alloc] init];
		//NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
	for (id currentItem in lineArray)
	{ 
		NSArray *packageArray = [currentItem componentsSeparatedByString:@"\n"];
			//	NSLog(@"packageArray: %@", packageArray);
		NSMutableDictionary *currentPackage = [[NSMutableDictionary alloc] init];
		for (id currentLine in packageArray)
		{
			NSArray *itemArray = [currentLine componentsSeparatedByString:@": "];
			if ([itemArray count] >= 2)
			{
				NSString *key = [itemArray objectAtIndex:0];
				NSString *object = [itemArray objectAtIndex:1];
				
				if ([key isEqualToString:@"Depends"]) //process the array
				{
					NSArray *dependsObject = [packageManagement dependencyArrayFromString:object];
					
					[currentPackage setObject:dependsObject forKey:key];
					
				} else { //every other key, even if it has an array is treated as a string
					
					[currentPackage setObject:object forKey:key];
				}
				
				
			}
		}
		
			//NSLog(@"currentPackage: %@\n\n", currentPackage);
		if ([[currentPackage allKeys] count] > 4)
		{
				//[mutableDict setObject:currentPackage forKey:[currentPackage objectForKey:@"Package"]];
			[mutableList addObject:currentPackage];
		}
		
		[currentPackage release];
		currentPackage = nil;
		
	}
	
	NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES
																	 selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSSortDescriptor *packageDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Package" ascending:YES
																		selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, packageDescriptor, nil];
	NSArray *sortedArray = [mutableList sortedArrayUsingDescriptors:descriptors];
	
	[mutableList release];
	mutableList = nil;
	
	return sortedArray;
}

+ (NSArray *)parsedPackageArrayForRepo:(NSString *)theRepo
{
	
	NSString *listLocation = LIST_LOCATION;
	NSString *packageString = [NSString stringWithContentsOfFile:[listLocation stringByAppendingPathComponent:theRepo] encoding:NSASCIIStringEncoding error:nil];
		//NSLog(@"stringFile: %@", [listLocation stringByAppendingPathComponent:theRepo]);
	NSArray *lineArray = [packageString componentsSeparatedByString:@"\n\n"];
		//NSLog(@"lineArray: %@", lineArray);
		NSMutableArray *mutableList = [[NSMutableArray alloc] init];
		//NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
	for (id currentItem in lineArray)
	{ 
		NSArray *packageArray = [currentItem componentsSeparatedByString:@"\n"];
			//	NSLog(@"packageArray: %@", packageArray);
		NSMutableDictionary *currentPackage = [[NSMutableDictionary alloc] init];
		for (id currentLine in packageArray)
		{
			NSArray *itemArray = [currentLine componentsSeparatedByString:@": "];
			if ([itemArray count] >= 2)
			{
				
				[currentPackage setObject:[itemArray objectAtIndex:1] forKey:[itemArray objectAtIndex:0]];
			}
		}
		
			//NSLog(@"currentPackage: %@\n\n", currentPackage);
		if ([[currentPackage allKeys] count] > 4)
		{
				//[mutableDict setObject:currentPackage forKey:[currentPackage objectForKey:@"Package"]];
				[mutableList addObject:currentPackage];
		}
		
		[currentPackage release];
		currentPackage = nil;
		
	}
	
	NSString *endFile = @"/var/mobile/Library/Preferences/test.plist";
	[mutableList writeToFile:endFile atomically:YES];
	
	return [mutableList autorelease];
}


+ (NSDictionary *)parsedReleaseForRepo:(NSString *)theRepo withInfo:(NSDictionary *)info
{
	
	NSString *listLocation = LIST_LOCATION;
	NSString *packageString = [NSString stringWithContentsOfFile:[listLocation stringByAppendingPathComponent:theRepo] encoding:NSUTF8StringEncoding error:nil];
	NSArray *lineArray = [packageString componentsSeparatedByString:@"\n"];
	NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:info];
	for (id currentLine in lineArray)
	{
		NSArray *itemArray = [currentLine componentsSeparatedByString:@": "];
		if ([itemArray count] >= 2)
		{
			[mutableDict setObject:[itemArray objectAtIndex:1] forKey:[itemArray objectAtIndex:0]];
		}
	}
	
	return [mutableDict autorelease];
}

+ (NSDictionary *)parsedReleaseForRepo:(NSString *)theRepo
{
	
	NSString *listLocation = LIST_LOCATION;
	NSString *packageString = [NSString stringWithContentsOfFile:[listLocation stringByAppendingPathComponent:theRepo] encoding:NSUTF8StringEncoding error:nil];
	NSArray *lineArray = [packageString componentsSeparatedByString:@"\n"];
	NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
	for (id currentLine in lineArray)
	{
		NSArray *itemArray = [currentLine componentsSeparatedByString:@": "];
		if ([itemArray count] >= 2)
		{
			[mutableDict setObject:[itemArray objectAtIndex:1] forKey:[itemArray objectAtIndex:0]];
		}
	}
	
	return [mutableDict autorelease];
}

+ (NSArray *)repoReleaseDictionaries
{
	NSMutableArray *finalArray = [[NSMutableArray alloc] init];
	NSArray *repoArray = [packageManagement detailedRepoDomainList];
	for(id currentRepo in repoArray)
	{
		NSString *releaseLocation = [packageManagement releaseLocationFromString:[currentRepo valueForKey:@"SourceDomain"]];
		NSDictionary *releaseDict = [packageManagement parsedReleaseForRepo:releaseLocation withInfo:currentRepo];
		[finalArray addObject:releaseDict];
	}
	
	return [finalArray autorelease];
}

+ (void)testPrintList
{
	NSLog(@"releaseDict: %@", [packageManagement repoReleaseDictionaries]);
}


+ (NSArray *)newParsedPackageArrayForRepo:(NSString *)theRepo
{
	NSDictionary *dictionaryList = [packageManagement truncatedParsedPackageListForRepo:theRepo];
	NSMutableArray *convertArray = [[NSMutableArray alloc] init];
	NSEnumerator *dictEnum = [dictionaryList keyEnumerator];
	id nextObject = nil;
	while (nextObject = [dictEnum nextObject]) {
		
		[convertArray addObject:[dictionaryList valueForKey:nextObject]];
		
	}
		//NSArray *newArray = [NSArray arrayWithArray:[[convertArray copy] autorelease]];
		
	NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES
																	 selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSSortDescriptor *packageDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Package" ascending:YES
																		selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, packageDescriptor, nil];
	NSArray *sortedArray = [convertArray sortedArrayUsingDescriptors:descriptors];
	[convertArray release];
	convertArray = nil;

	return sortedArray;
}

+ (NSArray *)sectionArray
{
	return [[nitoDefaultManager preferences] objectForKey:SECTION_LIST];
}

+ (NSDictionary *)truncatedParsedPackageListForRepo:(NSString *)theRepo //trim to 1000
{
	
	NSString *listLocation = LIST_LOCATION;
		//NSStringEncoding encoding;
		//NSError* error = nil;
		//NSString* packageString = [NSString stringWithContentsOfFile:[listLocation stringByAppendingPathComponent:theRepo] usedEncoding:&encoding error:&error];
	NSString *packageString = [NSString stringWithContentsOfFile:[listLocation stringByAppendingPathComponent:theRepo]];
		//NSString *packageString = [NSString stringWithContentsOfFile:[listLocation stringByAppendingPathComponent:theRepo] encoding:NSUTF8StringEncoding error:nil];
	NSArray *lineArray = [packageString componentsSeparatedByString:@"\n\n"];
		//NSLog(@"lineArray count: %i", [lineArray count]);
		//NSLog(@"lineArray: %@", lineArray);
		//NSMutableArray *mutableList = [[NSMutableArray alloc] init];
	NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc ]init];
	for (id currentItem in lineArray)
	{ 
		NSArray *packageArray = [currentItem componentsSeparatedByString:@"\n"];
			//	NSLog(@"packageArray: %@", packageArray);
		NSMutableDictionary *currentPackage = [[NSMutableDictionary alloc] init];
		for (id currentLine in packageArray)
		{
			NSArray *itemArray = [currentLine componentsSeparatedByString:@": "];
			if ([itemArray count] >= 2)
			{
				
				[currentPackage setObject:[itemArray objectAtIndex:1] forKey:[itemArray objectAtIndex:0]];
			}
		}
		
		
		
			//NSLog(@"currentPackage: %@\n\n", currentPackage);
		if ([[currentPackage allKeys] count] > 4)
		{
			NSString *packageKey = [currentPackage objectForKey:@"Package"];
			
				//if (![[mutableDict allKeys] containsObject:packageKey])
			
				NSString *section = [currentPackage objectForKey:@"Section"];
			
				if ([[packageManagement sectionArray] containsObject:section])
				{
						//NSLog(@"adding package: %@ for section: %@", packageKey, section);
					if(currentPackage != nil && packageKey != nil)
						[mutableDict setObject:currentPackage forKey:packageKey];
				}
			
				//else
				//NSLog(@"already contains: %@", currentPackage);
				//[mutableList addObject:currentPackage];
		}
		
		[currentPackage release];
		currentPackage = nil;
		
		if ([[mutableDict allKeys] count] > TRUNCATE_COUNT)
		{
			NSLog(@"truncate at %i!!", TRUNCATE_COUNT);
			return [mutableDict autorelease];
			
		}
		
		
	}
	
		//NSString *endFile = @"/var/mobile/Library/Preferences/test.plist";
		//[mutableDict writeToFile:endFile atomically:YES];
	
	return [mutableDict autorelease];
}

+ (NSDictionary *)parsedPackageListForRepo:(NSString *)theRepo
{
	
	NSString *listLocation = LIST_LOCATION;
		//NSStringEncoding encoding;
		//NSError* error = nil;
		//NSString* packageString = [NSString stringWithContentsOfFile:[listLocation stringByAppendingPathComponent:theRepo] usedEncoding:&encoding error:&error];
		NSString *packageString = [NSString stringWithContentsOfFile:[listLocation stringByAppendingPathComponent:theRepo]];
		//NSString *packageString = [NSString stringWithContentsOfFile:[listLocation stringByAppendingPathComponent:theRepo] encoding:NSUTF8StringEncoding error:nil];
	NSArray *lineArray = [packageString componentsSeparatedByString:@"\n\n"];
		//NSLog(@"lineArray: %@", lineArray);
		//NSMutableArray *mutableList = [[NSMutableArray alloc] init];
	NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc ]init];
	for (id currentItem in lineArray)
	{ 
		NSArray *packageArray = [currentItem componentsSeparatedByString:@"\n"];
			//	NSLog(@"packageArray: %@", packageArray);
		NSMutableDictionary *currentPackage = [[NSMutableDictionary alloc] init];
		for (id currentLine in packageArray)
		{
			NSArray *itemArray = [currentLine componentsSeparatedByString:@": "];
			if ([itemArray count] >= 2)
			{
				
				[currentPackage setObject:[itemArray objectAtIndex:1] forKey:[itemArray objectAtIndex:0]];
			}
		}
		
			//NSLog(@"currentPackage: %@\n\n", currentPackage);
		if ([[currentPackage allKeys] count] > 4)
		{
			NSString *packageKey = [currentPackage objectForKey:@"Package"];
			NSString *section = [currentPackage objectForKey:@"Section"];
				//	if ([[packageManagement kosherSections] containsObject:section])
				[mutableDict setObject:currentPackage forKey:packageKey];
				
		}
		
		[currentPackage release];
		currentPackage = nil;
		
	}
	
		//NSString *endFile = @"/var/mobile/Library/Preferences/test.plist";
		//[mutableDict writeToFile:endFile atomically:YES];
	
	return [mutableDict autorelease];
}



+ (NSDictionary *)parsedPackageList
{
	
	NSString *packageFile = STATUS_FILE;
	NSString *packageString = [NSString stringWithContentsOfFile:packageFile encoding:NSUTF8StringEncoding error:nil];
	NSArray *lineArray = [packageString componentsSeparatedByString:@"\n\n"];
		//NSLog(@"lineArray: %@", lineArray);
		//NSMutableArray *mutableList = [[NSMutableArray alloc] init];
	NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
	for (id currentItem in lineArray)
	{ 
		NSArray *packageArray = [currentItem componentsSeparatedByString:@"\n"];
			//NSLog(@"packageArray: %@", packageArray);
		NSMutableDictionary *currentPackage = [[NSMutableDictionary alloc] init];
		for (id currentLine in packageArray)
		{
			NSArray *itemArray = [currentLine componentsSeparatedByString:@": "];
			if ([itemArray count] >= 2)
			{
				
				[currentPackage setObject:[itemArray objectAtIndex:1] forKey:[itemArray objectAtIndex:0]];
			}
		}
		
			//NSLog(@"currentPackage: %@\n\n", currentPackage);
		if ([[currentPackage allKeys] count] > 4)
		{
			[mutableDict setObject:currentPackage forKey:[currentPackage objectForKey:@"Package"]];
				//[mutableList addObject:currentPackage];
		}
		
		[currentPackage release];
		currentPackage = nil;
		
	}
	
		//NSString *endFile = @"/test.plist";
		//[mutableList writeToFile:endFile atomically:YES];
	
	return [mutableDict autorelease];
}


@end
