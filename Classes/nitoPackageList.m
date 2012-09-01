
#import "nitoPackageList.h"
#import "kbScrollingTextControl.h"

@implementation nitoPackageList

- (void)removeDialog:(NSString *)packageToRemove
{
	BROptionDialog *opDi = [[BROptionDialog alloc] init];
	[opDi setTitle:[NSString stringWithFormat:BRLocalizedString(@"Delete %@?", @"alert dialog for deleting playlist"),packageToRemove]];
	
	[opDi addOptionText:BRLocalizedString(@"Cancel Delete", @"cancel button") isDefault:YES];
	[opDi addOptionText:BRLocalizedString(@"Delete", @"cancel delete")];
	[opDi setActionSelector:@selector(deleteOptionSelected:) target:self];
	
	[[self stack] pushController:opDi];
	[opDi autorelease];
	greenMileFile = packageToRemove;
	[greenMileFile retain];
}
- (void)deleteOptionSelected:(id)option
{

	NSFileManager *man = [NSFileManager defaultManager];
	
	if([[[self stack] peekController] isKindOfClass: [BROptionDialog class]])
	{
		[[self stack] popController];
	}
	
	switch ([option selectedIndex]) {
			
		case 0: //cancel
			
			break;
			
		case 1: //delete
			
			[self customRemoveAction:greenMileFile];
			
			break;
	}
}

- (NSString *)aptStatus
{
	return [NSString stringWithContentsOfFile:@"/tmp/aptoutput"];
	
}

- (NSArray *)getPackageList
{
	
	NSString *command = @"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/dpkg_list.sh";
	int sysReturn = system([command UTF8String]);
	return [self parsedPackageList];
		//NSLog(@"packageInfo: %@", [self packageInfo]);
}

	///var/cache/apt/archives

- (NSArray *)parsedPackageList
{	
	
	NSString *packageFile = @"/tmp/installed_dpkg";
	NSString *packageString = [NSString stringWithContentsOfFile:packageFile encoding:NSUTF8StringEncoding error:nil];
	NSArray *lineArray = [packageString componentsSeparatedByString:@"\n"];
	NSMutableArray *packageList = [[NSMutableArray alloc] init];
	for (id lineItem in lineArray)
	{
		NSArray *itemArray = [lineItem componentsSeparatedByString:@" "];
		
		if ([itemArray count] >= 26)
		{
			NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] init];
			NSString *packageName = [itemArray objectAtIndex:2];
				//NSLog(@"itemArray: %@", itemArray);
			packageName = [packageName stringByReplacingOccurrencesOfString:@" " withString:@""];
			NSString *version = [itemArray objectAtIndex:8];
			int vIndex = 8;
			while ([version length] == 0)
			{
				if (vIndex >= [itemArray count])
					break;
				version = [itemArray objectAtIndex:vIndex];
				vIndex++;
			}
			version = [version stringByReplacingOccurrencesOfString:@" " withString:@""];
			NSArray *arrayRange = [itemArray subarrayWithRange:NSMakeRange(26, [itemArray count]-26)];
			NSString *descriptionString = [arrayRange componentsJoinedByString:@" "];
			descriptionString = [descriptionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[dictItem setObject:packageName forKey:@"name"];
			[dictItem setObject:version forKey:@"version"];
			[dictItem setObject:descriptionString forKey:@"description"];
			if ([packageName length] > 0)
			{
				[packageList addObject:dictItem];
			}
			
			[dictItem release];
		}
	}
	return [packageList autorelease];
}

- (BOOL)canRemove:(NSString *)theItem
{
	NSDictionary *packageDict = [self getPackageInfo:theItem];
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
		if ([[priority lowercaseString] isEqualToString:@"optional"])
			return YES;
	} else {
		NSLog(@"nito_install_idiot_proofing: cannot delete package: %@ with priority: %@", theItem, priority);
		return NO;
	}
	
	return NO;
}

- (BOOL)leftAction:(long)theRow
{
	return NO;
	NSString *item = [_names objectAtIndex:theRow];
	if ([self canRemove:item])
	{
		[self removeDialog:item];
			//[self customRemoveAction:item];
		return YES;
	} else {
		return NO;
		
	}
	return NO;	
}


- (void)customInstallAction:(NSString *)packageName
{
	id spinControl = [[BRTextWithSpinnerController alloc] initWithTitle:nil text:[NSString stringWithFormat:@"installing %@",packageName]];
		//NSLog(@"text string: %@", [text stringValue]);
	[[self stack] pushController:spinControl];
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:packageName forKey:@"text"];
	[NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(updateCustomFinal:) userInfo: userInfo repeats: NO];
	
}

- (void)updateCustomFinal:(id)timer
{
		//NSLog(@"userInfo: %@", [timer userInfo]);
	[self updateCustom:[[timer userInfo] objectForKey:@"text"]];
	
}

- (void)customRemoveAction:(id)theFile
{
	id spinControl = [[BRTextWithSpinnerController alloc] initWithTitle:nil text:[NSString stringWithFormat:BRLocalizedString(@"removing %@", @"Removing %@"),theFile]];
		//NSLog(@"text string: %@", [text stringValue]);
	[[self stack] pushController:spinControl];
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theFile forKey:@"text"];
	[NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(removeCustomFinal:) userInfo: userInfo repeats: NO];
	
}

- (void)removeCustomFinal:(id)timer
{
		//NSLog(@"userInfo: %@", [timer userInfo]);
	[self removeCustom:[[timer userInfo] objectForKey:@"text"]];
	
}

- (void)removeCustom:(NSString *)customFile
{
	NSString *command = [NSString stringWithFormat:@"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/uninstall_dpkg.sh %@", customFile];
	int sysReturn = system([command UTF8String]);
	NSLog(@"remove custom returned with status %i", sysReturn);
	id installStatus = [self removeFinishedWithStatus:sysReturn andFeedback:[self aptStatus]];
	
	[[self stack] swapController:installStatus];
}

- (void)updateCustom:(NSString *)customFile
{
	NSString *command = [NSString stringWithFormat:@"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/install_ntv.sh %@", customFile];
	int sysReturn = system([command UTF8String]);
	NSLog(@"update custom returned with status %i", sysReturn);
		//NSLog(@"aptoutput: %@", [self aptStatus]);
	id installStatus = [self installFinishedWithStatus:sysReturn andFeedback:[self aptStatus]];
	
	[[self stack] swapController:installStatus];
		//NSLog(@"update status: %i", sysReturn);
		//[[self stack] popController];
}

-(id)removeFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback
{
	NSString * path = @"/tmp/aptoutput";
	
	kbScrollingTextControl *textControls = [[kbScrollingTextControl alloc] init];
	
	[textControls setDocumentPath:path encoding:NSUTF8StringEncoding];
	
	NSString *myTitle = nil;
	if (termStatus == 0)
	{
		myTitle = BRLocalizedString(@"Package Removal Successful / Up to Date", @"Package Removal Successful / Up to Date");
		
	} else {
		
		myTitle = BRLocalizedString(@"Package Removal Failed!", @"Package Removal Failed!");
	}
	
	[textControls setTitle:myTitle];
	[textControls autorelease];
	return [BRController controllerWithContentControl:textControls];
	
}

-(id)installFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback
{
	NSString * path = @"/tmp/aptoutput";
	
	kbScrollingTextControl *textControls = [[kbScrollingTextControl alloc] init];
	
	[textControls setDocumentPath:path encoding:NSUTF8StringEncoding];
	
	NSString *myTitle = nil;
	if (termStatus == 0)
	{
		myTitle = BRLocalizedString(@"Installation Successful / Up to Date", @"Installation Successful / Up to Date");
		
	} else {
		
		myTitle = BRLocalizedString(@"Installation Failed!",@"Installation Failed!" );
	}
	
	[textControls setTitle:myTitle];
	[textControls autorelease];
	return [BRController controllerWithContentControl:textControls];
	
}


-(id)initWithData:(id)theData andTitle:(id)theTitle	
{
	self = [super initWithTitle:theTitle];
	
	if (self != nil)
	{
		_descriptions = [[NSMutableArray alloc] init];
		id headerImage = [[NitoTheme sharedTheme] searchImage];
		[self setListIcon:headerImage];
		for (id currentItem in theData)
		{
			[_names addObject:[currentItem objectForKey:@"name"]];
			[_descriptions addObject:[currentItem objectForKey:@"description"]];
			
		}
		
		return self;
	}
	
	return nil;
}

-(void)itemSelected:(long)selected
{
	NSString *item = [_names objectAtIndex:selected];
	
		//NSArray *getPackageList = [self getPackageList];
		//NSLog(@"packageList: %@", getPackageList);
		//NSString *outputFile = [NSBundle outputFileWithName:@"Packages.plist"];
		//[getPackageList writeToFile:outputFile atomically:YES];
	[self customInstallAction:item];
		//NSLog(@"info for package: %@", item);
	
}

- (NSDictionary *)getPackageInfo:(NSString *)thePackage
{
	
	NSString *command = [NSString stringWithFormat:@"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/package_info.sh %@", thePackage];
	int sysReturn = system([command UTF8String]);
	return [self packageInfo];
		//NSLog(@"packageInfo: %@", [self packageInfo]);
}

- (NSDictionary *)packageInfo
{
	NSString *searchPkg = [NSString stringWithContentsOfFile:@"/tmp/pkginfo"];
	NSArray *packageList = [searchPkg componentsSeparatedByString:@"\n"];
	NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
	for (id currentItem in packageList)
	{
		NSArray *itemArray = [currentItem componentsSeparatedByString:@": "];
		if ([itemArray count] >= 2)
		{
			
			[mutableDict setObject:[itemArray objectAtIndex:1] forKey:[itemArray objectAtIndex:0]];
		}
		
	}
	
	return [mutableDict autorelease];
}

- (void)dealloc
{
	[_descriptions release];
	[super dealloc];
}

-(id)previewControlForItem:(long)item
{
		//NSLog(@"description: %@", [_descriptions objectAtIndex:item]);
	ntvMedia *currentAsset = [[ntvMedia alloc] init];
	
	[currentAsset setTitle:[_names objectAtIndex:item]];
	[currentAsset setSummary:[_descriptions objectAtIndex:item]];
	[currentAsset setCoverArt:[[NitoTheme sharedTheme] packageImage]];
	
	ntvMediaPreview *preview = [[ntvMediaPreview alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	
	return [preview autorelease];
}

-(id)oldpreviewControlForItem:(long)item
{
	BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
	BRImage *previewImage = [[NitoTheme sharedTheme] packageImage];
	[obj setImage:previewImage];
	return [obj autorelease];
}

-(id)itemForRow:(long)row
{
	BRMenuItem *result = [BRMenuItem ntvDownloadMenuItem];
	[result setText:[_names objectAtIndex:row] withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	return	result;
}

@end