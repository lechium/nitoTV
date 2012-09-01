//
//  defaultHelper.m
//  nitoTV
//
//  Created by blunt on 11/10/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

#import "nitoHelperClass.h"


/*

 updaterepo.sh
 
 echo "deb http://apt.awkwardtv.org/ stable main" > /etc/apt/sources.list.d/awkwardtv.list
 wget -O- http://apt.awkwardtv.org/awkwardtv.pub | apt-key add -
 
 */

static NSString *aptGet = @"/usr/bin/apt-get";
static NSString *aptCache = @"/usr/bin/apt-cache";

@implementation nitoHelperClass

+ (int)addDefaultSource:(int)sourceInteger
{
	NSString *sourceLine = nil;
	NSString *sourceFile = CYDIA_LIST;
	
	switch (sourceInteger) {
			
			
		case kNitoSaurikSource:
			
			sourceLine = SAURIK_SOURCE;
			break;
		
		case kNitoZodttdSource:
			
			sourceLine = ZODTTD_SOURCE;
			break;
			
		case kNitoBigbossSource:
			
			sourceLine = BIGBOSS_SOURCE;
			break;
			
		case kNitoModmyiSource:
			
			
			sourceLine = MODMYI_SOURCE;
			break;
			
		case kNitoAwkSource:
			
			sourceLine = AWK_SOURCE;
			sourceFile = AWK_LIST;
			break;
			
	}
	
	if (sourceLine != nil) //we have SOMETHING
	{
		int returnStatus = [nitoHelperClass addLine:sourceLine toFile:sourceFile];
		[self aptUpdateQuiet];
		return returnStatus;
	}
	
	NSLog(@"re-add source failure: %i", sourceInteger);
	return -1;
}

+ (int)fix50
{
	NSString *btServerPath = @"/System/Library/LaunchDaemons/com.apple.BTServer.plist";
	NSMutableDictionary *btServer = [[NSMutableDictionary alloc] initWithContentsOfFile:btServerPath];
	if ([[btServer allKeys] containsObject:@"EnvironmentVariables"])
	{
		[btServer removeObjectForKey:@"EnvironmentVariables"];
		if ([btServer writeToFile:btServerPath atomically:YES] == TRUE)
		{
			NSLog(@"rewrote BTServer daemon properly, restart lowtide!");
			int unloadStatus = system("/bin/launchctl unload /System/Library/LaunchDaemons/com.apple.BTServer.plist");
			NSLog(@"unload btserver returned with status %i", unloadStatus);
			return 0;
		}
	}
	return -1;
}


+ (int)fix43:(NSString *)inputFile
{
	NSString *configLine = [NSString stringWithFormat:@"%@ configure", inputFile];
	NSLog(@"%@", configLine);
	int sysReturn = system([configLine UTF8String]);
	[nitoHelperClass aptUpdate];
	return sysReturn;
}

- (NSFileHandle *)logHandle
{
	logHandle = [[NSFileHandle fileHandleForWritingAtPath:[self logPath]] retain];
	return logHandle;
}

- (NSString *)logPath
{
	NSString * logPath = @"/tmp/aptoutput";
	[[NSFileManager defaultManager] createFileAtPath: logPath contents:nil attributes:nil];
	return logPath;
}

- (int)installQueue:(NSString *)theFile
{
		//NSLog(@"installQueue: %@", theFile);
	NSArray *queueArray = [NSArray arrayWithContentsOfFile:theFile];
		//NSLog(@"queueArray: %@", queueArray);
	NSEnumerator *installEnum = [queueArray objectEnumerator];
	id currentItem = nil;
	int sysReturn = 0;
	while (currentItem = [installEnum nextObject])
	{
		NSString *installString = [NSString stringWithFormat:@"/usr/bin/apt-get install -y --force-yes %@ 2>&1", currentItem];
		sysReturn = system([installString UTF8String]);
		NSLog(@"install %@ returned with %i", currentItem, sysReturn);
	}
	return sysReturn;
}

+ (int)fixDepends
{
	int sysReturn = system("/usr/bin/apt-get -f install -y --force-yes 1>/tmp/aptoutput 2>/tmp/aptoutput");
	return sysReturn;
}

- (int)autoremove
{
	
	int sysReturn = system("/usr/bin/apt-get autoremove -y --force-yes 1>/tmp/aptoutput 2>/tmp/aptoutput");
	return sysReturn;
	
}

- (int)updateAll
{

	[nitoHelperClass aptUpdate];
	int sysReturn = system("/usr/bin/apt-get -y -u dist-upgrade --force-yes 2>&1");
	return sysReturn;
}

- (int)configure
{
	
	int sysReturn = system("/usr/bin/dpkg --configure -a 1>/tmp/dpkgout 2>/tmp/dpkgout");
	return sysReturn;
}

+(int)aptUpdateQuiet
{
	int sysReturn = system("/usr/bin/apt-get update &> /dev/null");
	return sysReturn;
}

+(int)aptUpdate
{
	int sysReturn = system("/usr/bin/apt-get update");
	return sysReturn;
}

- (int)dpkgPackage:(NSString *)packagePath
{
	NSString *installString = [NSString stringWithFormat:@"/usr/bin/dpkg -i 2>&1", packagePath];
	int sysReturn = system([installString UTF8String]);

	
}

+ (int)updateSelf
{
	[nitoHelperClass aptUpdate];
	NSString *installString = @"/usr/bin/apt-get install -y --force-yes com.nito.nitotv 2>&1";
	int sysReturn = system([installString UTF8String]);
		//NSLog(@"updateSelf %@ returned with %i", installString, sysReturn);
	
	return sysReturn;
}

- (int)installPackage:(NSString *)packageId
{
	[nitoHelperClass aptUpdate];
	NSString *installString = [NSString stringWithFormat:@"/usr/bin/apt-get install -y --force-yes %@ 2>&1", packageId];
	int sysReturn = system([installString UTF8String]);
		//NSLog(@"install %@ returned with %i", installString, sysReturn);
	
	return sysReturn;
}

- (int)removePackage:(NSString *)packageId
{
	
	NSString *removeString = [NSString stringWithFormat:@"/usr/bin/apt-get -y --force-yes remove %@ 2>&1", packageId];
	int sysReturn = system([removeString UTF8String]);
		//NSLog(@"remove %@ returned with %i", installString, sysReturn);
	return sysReturn;
	
}

+(void)reboot
{
	int sysReturn = system("/usr/bin/reboot");
}

+(int)fixRepo
{
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *awkwardRepo = @"/etc/apt/sources.list.d/awkward.list";
	NSString *awkwardRepoExtra = @"/etc/apt/sources.list.d/awkwardtv.list";
	if ([FM fileExistsAtPath:awkwardRepoExtra])
	{
		if ([FM fileExistsAtPath:awkwardRepo])
		{
			if ([FM fileExistsAtPath:awkwardRepoExtra])
				[FM removeItemAtPath:awkwardRepoExtra error:nil];
		
		} else {
			
			if ([FM fileExistsAtPath:awkwardRepoExtra])
				[FM moveItemAtPath:awkwardRepoExtra toPath:awkwardRepo error:nil];
		}
		
	}
	return 0;
}

+(int)installKey
{
	Class ntask = NSClassFromString(@"NSTask");
	id wgetTask = [ntask launchedTaskWithLaunchPath:@"/usr/bin/wget" arguments:[NSArray arrayWithObjects:@"-O", @"/awkwardtv.pub", @"http://apt.awkwardtv.org/awkwardtv.pub", nil]];
	 waitpid([wgetTask processIdentifier], NULL, 0);
	int termStatus = [wgetTask terminationStatus];
	if (termStatus == 0)
	{
		id aptKey = [ntask launchedTaskWithLaunchPath:@"/usr/bin/apt-key" arguments:[NSArray arrayWithObjects:@"add", @"/awkwardtv.pub", nil]];
		waitpid([aptKey processIdentifier], NULL, 0);
		termStatus = [aptKey terminationStatus];
		return termStatus;
	}
	return -1;
}



+(int)updateRepo
{
	NSString *awkwardRepo = @"/etc/apt/sources.list.d/awkwardtv.list";
	NSMutableString *awkFile = [[NSMutableString alloc] initWithContentsOfFile:awkwardRepo encoding:NSUTF8StringEncoding error:nil];
	NSString *sm = @"stable main";
	NSRange range = [awkFile rangeOfString: sm];
	if ( range.location == NSNotFound )
	{
		[awkFile replaceOccurrencesOfString:@"./" withString:sm options:nil range:NSMakeRange(0, [awkFile length])];
		//[[NSFileManager defaultManager] removeItemAtPath:awkwardRepo error:nil];
		BOOL writeFile = [awkFile writeToFile:awkwardRepo atomically:YES];
		NSLog(@"writing file: %@ success: %@", awkFile, [NSNumber numberWithBool:writeFile]);
		[awkFile release];
		if (writeFile == YES)
		{
			int termStatus = [nitoHelperClass installKey];
			return termStatus;
		} else {
			return -1;
		}

	}
	
	return 0;
}
+ (void)fixHosts
{
	NSMutableString *hosts2 = [[NSMutableString alloc] initWithContentsOfFile:@"/etc/hosts"];
	[hosts2 replaceOccurrencesOfString:@"127.0.0.1\tappldnld.apple.com.edgesuite.net" withString:@"" options:nil range:NSMakeRange(0, [hosts2 length])];
	[hosts2 replaceOccurrencesOfString:@"127.0.0.1\tappldnld.apple.com" withString:@"" options:nil range:NSMakeRange(0, [hosts2 length])];
	[hosts2 replaceOccurrencesOfString:@"127.0.0.1\tmesu.apple.com" withString:@"" options:nil range:NSMakeRange(0, [hosts2 length])];
	[hosts2 writeToFile:@"/etc/hosts" atomically:YES];
	[hosts2 release];
	return;
}

+ (void)fixHostsold
{
		//NSLog(@"toggleUpdate");
	NSMutableString *hosts2 = [[NSMutableString alloc] initWithContentsOfFile:@"/etc/hosts"];
	NSRange range = [hosts2 rangeOfString: @"127.0.0.1      mesu.apple.com"];
	
	if ( range.location != NSNotFound )
	{
			//[hosts replaceOccurrencesOfString:@"127.0.0.1      mesu.apple.com" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [hosts length])]
			//NSLog(@"mesu exists!");
		hosts2 = [hosts2 stringByReplacingCharactersInRange:range withString:@""];
	}
	
	range = [hosts2 rangeOfString:@"127.0.0.1      appldnld.apple.com"];
	if (range.location != NSNotFound)
	{
			//NSLog(@"appldnld.apple.com exists!");
		hosts2 = [hosts2 stringByReplacingCharactersInRange:range withString:@""];
	}
	
	range = [hosts2 rangeOfString:@"127.0.0.1		 appldnld.apple.com.edgesuite.net"];
	if (range.location != NSNotFound)
	{
			//NSLog(@"appldnld.apple.com.edgesuite.net exists!");
		hosts2 = [hosts2 stringByReplacingCharactersInRange:range withString:@""];
	}
	
	[hosts2 writeToFile:@"/etc/hosts" atomically:YES];
	[hosts2 release];
	return;
	
	/*
	 NSMutableArray *hostArray = [[NSMutableArray alloc] initWithArray:[hosts componentsSeparatedByString:@"\n"]];
	 int i;
	 for (i = 0; i < [hostArray count]; i++)
	 {
	 NSString *currentItem = [hostArray objectAtIndex:i];
	 currentItem = [currentItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	 //NSLog(@"currentItem: %@", currentItem);
	 NSArray *items = [currentItem componentsSeparatedByString:@" "];
	 //NSLog(@"items: %@ index: %i", items, i);
	 if ([items containsObject:@"mesu.apple.com"])
	 {
	 
	 //NSLog(@"item %i: %@ item to remove", i, currentItem);
	 [hostArray removeObjectAtIndex:i];
	 }
	 
	 if ([items containsObject:@"appldnld.apple.com"])
	 {
	 
	 //NSLog(@"item %i: %@ item to remove", i, currentItem);
	 [hostArray removeObjectAtIndex:i];
	 }
	 
	 if ([items containsObject:@"appldnld.apple.com.edgesuite.net"])
	 {
	 
	 //NSLog(@"item %i: %@ item to remove", i, currentItem);
	 [hostArray removeObjectAtIndex:i];
	 }
	 }
	 
	 NSMutableString *thePl = [[NSMutableString alloc] initWithString:[hostArray componentsJoinedByString:@"\n"]];
	 [thePl writeToFile:@"/etc/hosts" atomically:YES];
	 [hostArray release];
	 [hosts release];
	 [thePl release];
	 */
}


/*
 
 Architectures = "darwin-arm iphoneos-arm";
 Codename = ios;
 Components = main;
 Description = "Distribution of Unix Software for iPhoneOS 3";
 Label = "Cydia/Telesphoreo";
 Origin = "Telesphoreo Tangelo";
 SourceDomain = "apt.saurik.com";
 SourceFile = "/etc/apt/sources.list.d/cydia.list";
 Suite = stable;
 Support = "http://cydia.saurik.com/support/*";
 Version = "1.0r282";
 lineIndex = 0;
 
 
 */

+ (int)removeRepo:(NSString *)thePath //output a plist file that we read from.
{
	NSDictionary *repoDict = [NSDictionary dictionaryWithContentsOfFile:thePath];
	NSString *repoFile = [repoDict valueForKey:@"SourceFile"];
	int lineIndex = [[repoDict valueForKey:@"lineIndex"] intValue];
	
	NSString *fileContents = [NSString stringWithContentsOfFile:repoFile]; //deprecated i know, but theres no telling what format these files are in.
	NSMutableArray *lineArray = [[NSMutableArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
	int lineCount = [lineArray count];

		//if there are 2 lines or less this should be a solo file. FIXME: once i figure this out, make sure to either delete the file outright, OR just delete the line.
	if (lineCount > 2)
	{
		[lineArray removeObjectAtIndex:lineIndex];
		NSMutableString *outputFile = [[NSMutableString alloc] initWithString:[lineArray componentsJoinedByString:@"\n"]];
		if([outputFile writeToFile:repoFile atomically:YES] == TRUE)
		{
			[lineArray release];
			lineArray = nil;
			[outputFile release];
			outputFile = nil;
			[self aptUpdateQuiet];
			return 0; //good return
		}
		
		[lineArray release];
		lineArray = nil;
		[outputFile release];
		outputFile = nil;
		return -1;
	} //lineArray count > 2 if
	
		//if we get this far we SHOULD be safe to kill the whole file
	NSLog(@"removing file!!, %@", repoFile);
	if([[NSFileManager defaultManager] removeItemAtPath:repoFile error:nil])
	{
		NSLog(@"removed successfully!");
		[self aptUpdate];
		return 0;
	} else {
		NSLog(@"removal failure!!!");
		return -1;
	}
	
	NSLog(@"how the hell did we get here?!?!?");
	
	return -1;
}

+ (int)addNitoSource:(NSString *)theURL
{
	NSString *newFullFormat = [NSString stringWithFormat:@"deb %@ ./\n", theURL];
	int returnStatus = [nitoHelperClass addLine:newFullFormat toFile:NITO_LIST];
	[self aptUpdate];
	return returnStatus;
}

+ (int)addLine:(NSString *)theLine toFile:(NSString *)theFile
{
	NSString *fileContents = nil;
	NSMutableArray *lineArray = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:theFile])
	{
		fileContents = [NSString stringWithContentsOfFile:theFile encoding:NSUTF8StringEncoding error:nil];
		lineArray = [[NSMutableArray alloc] initWithArray:[fileContents componentsSeparatedByString:@"\n"]];
		
	} else { //no file yet!
		
		lineArray = [[NSMutableArray alloc] init];
	}
	[lineArray removeObject:@""];
	[lineArray addObject:theLine];
	[lineArray removeObject:@""];
	
	NSMutableString *outputFile = [[NSMutableString alloc] initWithString:[lineArray componentsJoinedByString:@"\n"]];
	if([outputFile writeToFile:theFile atomically:YES encoding:NSUTF8StringEncoding error:nil] == TRUE)
	{
		[lineArray release];
		lineArray = nil;
		[outputFile release];
		outputFile = nil;
		return 0; //good return
	}
	
	[lineArray release];
	lineArray = nil;
	[outputFile release];
	outputFile = nil;
	return -1;
}

+ (int)toggleUpdate
{
	BOOL addHost = YES;
	int returnValue = 0;
	NSMutableString *hosts = [[NSMutableString alloc] initWithContentsOfFile:@"/etc/hosts"];
	NSMutableArray *hostArray = [[NSMutableArray alloc] initWithArray:[hosts componentsSeparatedByString:@"\n"]];
	int i;
		//NSLog(@"hostARray: %@", hostArray);
	if ([hostArray containsObject:@"127.0.0.1\tappldnld.apple.com.edgesuite.net"])
	{
			//NSLog(@"fix hosts!");
		[nitoHelperClass fixHosts];
		[hostArray release];
		[hosts release];
			//NSLog(@"here?");
		return 2;
	}
	if ([hostArray containsObject:@"127.0.0.1\tmesu.apple.com"])
	{
		addHost = NO;
		returnValue = 1;
		[hostArray removeObject:@"127.0.0.1\tmesu.apple.com"];
		
	}
	
	if ([hostArray containsObject:@"127.0.0.1\tappldnld.apple.com"])
	{
		addHost = NO;
		returnValue = 1;
		[hostArray removeObject:@"127.0.0.1\tappldnld.apple.com"];
		
	}
	
	if ([hostArray containsObject:@"127.0.0.1\tappldnld.apple.com.edgesuite.net"])
	{
		addHost = NO;
		returnValue = 1;
		[hostArray removeObject:@"127.0.0.1\tappldnld.apple.com.edgesuite.net"];
	}
	/*
	 for (i = 0; i < [hostArray count]; i++)
	 {
	 NSString *currentItem = [hostArray objectAtIndex:i];
	 currentItem = [currentItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	 //NSLog(@"currentItem: %@", currentItem);
	 NSArray *items = [currentItem componentsSeparatedByString:@" "];
	 //NSLog(@"items: %@", items);
	 if ([items containsObject:@"127.0.0.1\tmesu.apple.com"])
	 {
	 addHost = NO;
	 returnValue = 1;
	 //NSLog(@"item %i: %@ item to remove", i, currentItem);
	 //[hostArray removeObjectAtIndex:i];
	 [hostArray removeObject:@"127.0.0.1\tmesu.apple.com"];
	 } else if ([items containsObject:@"127.0.0.1\tappldnld.apple.com"])
	 {
	 NSLog(@"containsObject: appldnld.apple.com remove: %@", [hostArray objectAtIndex:i]);
	 addHost = NO;
	 returnValue = 1;
	 //NSLog(@"item %i: %@ item to remove", i, currentItem);
	 //[hostArray removeObjectAtIndex:i];
	 [hostArray removeObject:@"127.0.0.1\tappldnld.apple.com"];
	 } else if ([items containsObject:@"127.0.0.1\tappldnld.apple.com.edgesuite.net"])
	 {
	 addHost = NO;
	 returnValue = 1;
	 //NSLog(@"item %i: %@ item to remove", i, currentItem);
	 //[hostArray removeObjectAtIndex:i];
	 [hostArray removeObject:@"127.0.0.1\tappldnld.apple.com.edgesuite.net"];
	 }
	 
	 }
	 */
	if (addHost == YES)
	{
		[hostArray addObject:@"127.0.0.1\tmesu.apple.com"];
			//[hostArray addObject:@"127.0.0.1\tappldnld.apple.com"];
			//[hostArray addObject:@"127.0.0.1\tappldnld.apple.com.edgesuite.net"];
	}
	NSMutableString *thePl = [[NSMutableString alloc] initWithString:[hostArray componentsJoinedByString:@"\n"]];
	[thePl writeToFile:@"/etc/hosts" atomically:YES];
	[hostArray release];
	[hosts release];
	[thePl release];
	return returnValue;
}




@end
