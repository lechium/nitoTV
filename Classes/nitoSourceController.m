//
//  nitoSourceController.m
//  nitoTV
//
//  Created by Kevin Bradley on 9/20/11.
//  Copyright 2011 nito, LLC. All rights reserved.
//

#import "nitoSourceController.h"
#import "packageManagement.h"
#import "ntvMedia.h"
#import "ntvMediaPreview.h"
#import "PackageDataSource.h"
#import "nitoMoreMenu.h"

#define NITO_LIST @"/etc/apt/sources.list.d/nitotv.list"

@interface nitoSourceController ()

	// Properties that don't need to be seen by the outside world.

@property (nonatomic, readonly) BOOL              isReceiving;
@property (nonatomic, retain)   NSURLConnection * connection;

@end

@implementation nitoSourceController

@synthesize sourceArray, connectionMode, potentialSource, listMode, currentRepo, selectedObject, progressIndex, processing, missingDomains, missingDefaults;
@synthesize connection    = _connection;

- (void)_testSourceURL:(NSString *)baseUrlString
	// Starts a connection to download the current URL.
{
    NSURL *             url;
    NSMutableURLRequest *      request;

	NSString *fullURLString = nil;
	
	
	switch (self.connectionMode) {
			
		case kNTVConnectionPackagesCheck:
			
			fullURLString = [baseUrlString stringByAppendingPathComponent:@"Packages"];
			break;
			
		case kNTVConnectionPackagesBZ2Check:
			
			fullURLString = [baseUrlString stringByAppendingPathComponent:@"Packages.bz2"];
			break;
	
	}
	
	url = [NSURL URLWithString:fullURLString];
	request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"GET"];
		
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
}


- (id)initWithTitle:(NSString *)theTitle andSources:(NSArray *)sources
{
	return [self initWithTitle:theTitle andSources:sources inMode:kNTVSourcesListMode]; 
}

- (void)refreshMissingDomains
{
	self.missingDomains = [packageManagement missingDefaultDomains];
	if ([missingDomains count] > 0)
	{
		self.missingDefaults = TRUE;
	} else {
		self.missingDefaults = FALSE;
	}
}

- (id)initWithTitle:(NSString *)theTitle andSources:(NSArray *)sources inMode:(int)theListMode
{
	self = [super initWithTitle:theTitle];
	
	self.processing = FALSE;
	self.progressIndex = -1;
	self.currentRepo = nil;
	self.connectionMode = 0;
	_validSourceCheck = 1;
	self.sourceArray = sources;
	self.listMode = theListMode;
	self.missingDefaults = FALSE;
	
		//[self setListIcon:[[NitoTheme sharedTheme] fileServerImage] horizontalOffset:0.0 kerningFactor:0.15];
	
	switch (theListMode) {
			
		case kNTVSourcesListMode:
			
			self.missingDomains = [packageManagement missingDefaultDomains];
			if ([missingDomains count] > 0)
			{
				self.missingDefaults = TRUE;
			}
				[self _processSources];
			break;
			
		case kNTVSourceBrowseMode:
				[self _processList];
			break;
			
		case kNTVSourceMissingDefaultsMode:
			
			self.missingDomains = [packageManagement missingDefaultDomains];
			self.sourceArray = self.missingDomains;
			[self _processDefaults];
			break;
	}

	
	return ( self );
}

- (void)_processDefaults
{
	[_names removeAllObjects];
	for(id currentObject in self.missingDomains)
	{
		
		if ([[currentObject allKeys] containsObject:@"SourceDomain"])
		{
			NSString *sd = [currentObject valueForKey:@"SourceDomain"];
			[_names addObject:sd];
		}
			

	}
}

- (void)_processList
{
	[_names removeAllObjects];
		//NSLog(@"array: %@", self.sourceArray);
	for(id currentObject in self.sourceArray)
	{
		if ([[currentObject allKeys] containsObject:@"Name"])
			[_names addObject:[currentObject valueForKey:@"Name"]];
		else
			[_names addObject:[currentObject valueForKey:@"Package"]];
	}

}

- (void)_processSources
{
	[[self list] removeDividers];
	[_names removeAllObjects];
	int sourceCount = [[self sourceArray] count];
	for(id currentObject in self.sourceArray)
	{
		if ([[currentObject allKeys] containsObject:@"Origin"])
			[_names addObject:[currentObject valueForKey:@"Origin"]];
		else
			[_names addObject:[currentObject valueForKey:@"SourceDomain"]];
	}
	[_names addObject:BRLocalizedString(@"Add Source", @"Add source menu item")];
	
	[[self list] addDividerAtIndex:sourceCount withLabel:BRLocalizedString(@"Options", @"Options menu item divider in software section")];
}

- (BOOL)isReceiving
{
    return (self.connection != nil);
}

- (void)_stopReceiveWithStatus:(int)status
	// Shuts down the connection and displays the result (statusString == nil) 
	// or the error status (otherwise).
{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
		
    }
}

- (void)dealloc
{
	[selectedObject release];
	selectedObject = nil;
	[potentialSource release];
	potentialSource = nil;
	[sourceArray release];
	sourceArray = nil;
	[currentRepo release];
	currentRepo = nil;
	[missingDomains release];
	missingDomains = nil;
	[super dealloc];
}

- (NSArray *)bzipMimeArray
{

	return [NSArray arrayWithObjects:@"application/x-bzip2", @"application/bzip2", @"application/x-bz2", @"application/x-bzip", @"application/x-compressed", nil];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
	
{
	
	
    NSString *          contentTypeHeader;
    
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    
    if ((httpResponse.statusCode / 100) != 2) {
        [self _stopReceiveWithStatus:[httpResponse statusCode]];
    } else {
        contentTypeHeader = [httpResponse.allHeaderFields objectForKey:@"Content-Type"];
        if (contentTypeHeader == nil) {
            [self _stopReceiveWithStatus:[httpResponse statusCode]];
			NSLog(@"no content type! invalid");
			return;
        } else {
			NSLog(@"contentType: %@", contentTypeHeader);
			if ([[self bzipMimeArray] containsObject:contentTypeHeader])
			{
				NSLog(@"valid!");
				_validSourceCheck--;
			}

        }
	}

}

- (id)previewControlForSourceRow:(long)item
{
	int adjustedCount = ([self itemCount]-1);
	if (adjustedCount == item)
	{
		BRImageAndSyncingPreviewController *controller = [[BRImageAndSyncingPreviewController alloc] init];
		[controller setImage:[[NitoTheme sharedTheme] sharePointImage]];
		
		return [controller autorelease];
	}
	
	/*
	 
	 example source
	 
	 Date:"Sun, 18 Sep 2011 09:22:01 UTC",
	 Label:"AwkwardTV",
	 Suite:"stable",
	 Components:"main",
	 Origin:"AwkwardTV",
	 lineIndex:"0",
	 SourceDomain:"apt.awkwardtv.org",
	 SourceFile:"/etc/apt/sources.list.d/awkward.list",
	 Description:"AwkwardTV AppleTV 2 Software",
	 Architectures:"iphoneos-arm",
	 Codename:"awkwardtv"
	 
	 
	 Origin, Description, Date, SourceDomain
	 
	 
	 */
	
	NSDictionary *sourceItem = [sourceArray objectAtIndex:item];
	
	NSString *sourceName = nil;
	
	if ([[sourceItem allKeys] containsObject:@"Origin"])
		sourceName = [sourceItem valueForKey:@"Origin"];
	else
		sourceName = [sourceItem valueForKey:@"SourceDomain"];
	
		//NSLog(@"sourceItem: %@", [sourceArray objectAtIndex:item]);
	
	ntvMedia *currentAsset = [[ntvMedia alloc] init];
	[currentAsset setTitle:sourceName];
	NSString *description = nil;
	NSString *date = nil;
	NSString *suite = nil;
	if ([[sourceItem allKeys] containsObject:@"Description"])
		description = [sourceItem valueForKey:@"Description"];
	else
		description = @"Release file missing from repo.";

		[currentAsset setCoverArt:[[NitoTheme sharedTheme] sharePointImage]];

	
	NSMutableArray *customKeys = [[NSMutableArray alloc] init];
	NSMutableArray *customObjects = [[NSMutableArray alloc] init];
	
	if(description != nil)
	{
		[currentAsset setSummary:description];
	}
	
	if ([[sourceItem allKeys] containsObject:@"Date"])
		date = [sourceItem valueForKey:@"Date"];
	if ([[sourceItem allKeys] containsObject:@"Suite"])
		suite = [sourceItem valueForKey:@"Suite"];
	if (date != nil)
	{
		[customKeys addObject:BRLocalizedString(@"Date", @"Date")];
		[customObjects addObject:date];
	}
	
	if (suite != nil)
	{
		[customKeys addObject:BRLocalizedString(@"Suite", @"Suite")];
		[customObjects addObject:suite];
	}
	
	
	[currentAsset setCustomKeys:[customKeys autorelease] 
					 forObjects:[customObjects autorelease]];
	
	
	ntvMediaPreview *preview = [[ntvMediaPreview alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	return [preview autorelease];
	
	
	
}

+ (NSArray *)untouchableSources
{
	return [NSArray arrayWithObjects:@"apt.awkwardtv.org", @"apt.saurik.com", @"nitosoft.com", @"mirrors.xbmc.org", nil];
}

- (BOOL)canRemoveSource:(NSString *)theSource
{
	if ([[nitoSourceController untouchableSources] containsObject:theSource])
		return ( FALSE );
	
	return ( TRUE );
}

- (void)removeDialog:(NSDictionary *)sourceToRemove
{
	BROptionDialog *opDi = [[BROptionDialog alloc] init];
	NSString *objectName = [sourceToRemove valueForKey:@"SourceDomain"];
	[opDi setTitle:BRLocalizedString(@"Delete Source?", @"alert dialog for deleting source")];
	[opDi setPrimaryInfoText:[NSString stringWithFormat:BRLocalizedString(@"Any packages on this repo will no longer be available. Are you sure you want to delete the source '%@'?", @"alert dialog for deleting source"),objectName]];
	[opDi addOptionText:BRLocalizedString(@"Cancel Delete", @"cancel button") isDefault:YES];
	[opDi addOptionText:BRLocalizedString(@"Delete", @"cancel delete")];
	[opDi setActionSelector:@selector(deleteOptionSelected:) target:self];
	
	[[self stack] pushController:opDi];
	[opDi autorelease];
	[self setCurrentRepo:sourceToRemove];
}

- (void)deleteOptionSelected:(id)option
{
	if([[[self stack] peekController] isKindOfClass: [BROptionDialog class]])
	{
		[[self stack] popController];
	}
	
	switch ([option selectedIndex]) {
			
		case 1: //delete
			
			[self removeSource:self.currentRepo];
			
			break;
	}
}

- (void)removeSource:(NSDictionary *)theSource
{
		//NSLog(@"should remove source: %@", theSource);
	NSString *tempFile = @"/private/var/mobile/Library/Preferences/duwmz";
	[theSource writeToFile:tempFile atomically:YES];
	BRTextWithSpinnerController *theWaitController = [[BRTextWithSpinnerController alloc] initWithTitle:@"Removing Source..." text:@"Removing Source, Please Wait..."];
	[[self stack] pushController:theWaitController];
	[theWaitController release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:tempFile forKey:@"Source"];
	[NSTimer scheduledTimerWithTimeInterval:.1 target: self selector: @selector(finishRemovingSource:) userInfo: userInfo repeats: NO];
}


- (void)addDefaultSource:(NSDictionary *)theSource
{
	
	BRTextWithSpinnerController *theWaitController = [[BRTextWithSpinnerController alloc] initWithTitle:@"Restoring Default Source..." text:@"Restoring Default Source..."];
	[[self stack] pushController:theWaitController];
	[theWaitController release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theSource forKey:@"Source"];
	[NSTimer scheduledTimerWithTimeInterval:.1 target: self selector: @selector(finishRestoringSource:) userInfo: userInfo repeats: NO];
}

- (void)finishRestoringSource:(id)timer
{
	int sourceInt = [[[[timer userInfo] valueForKey:@"Source"] valueForKey:@"SourceInteger"] intValue];
	NSString *commandString = [NSString stringWithFormat:@"/usr/bin/nitoHelper restoreRepo %i 2", sourceInt];
		//NSLog(@"commandString: %@", commandString);
	int sysReturn = system([commandString UTF8String]);
	NSLog(@"restore with status: %i", sysReturn);
	
	[[self stack] popController];
	
	
		
	NSArray *controllers = [[self stack] controllers];
	int adjustedCount = [controllers count]-2;
	id controller = [controllers objectAtIndex:adjustedCount];
		//NSLog(@"controller: %@", controller);
		//	NSLog(@"self stack: %@", [self stack]);
		//NSLog(@"stack controllers: %@", [[self stack] controllers]);
	
	[controller setSourceArray:[packageManagement repoReleaseDictionaries]];

	
	[[self stack] popController];
	[controller _processSources];
	[[controller list] reload];
	[controller refreshMissingDomains];
}


- (void)finishRemovingSource:(id)timer
{
	NSString *sourcePath = [[timer userInfo] valueForKey:@"Source"];
	NSString *commandString = [NSString stringWithFormat:@"/usr/bin/nitoHelper removeRepo %@ 2", sourcePath];
		//NSLog(@"commandString: %@", commandString);
	int sysReturn = system([commandString UTF8String]);
	NSLog(@"removed with status: %i", sysReturn);
	self.sourceArray = [packageManagement repoReleaseDictionaries];
	[self _processSources];
	[[self list] reload];
	[[self stack] popController];
	
	[self refreshMissingDomains];
	
	
}

- (BOOL)leftAction:(long)theRow
{
	
	id currentItem = [[self sourceArray] objectAtIndex:theRow];
		//NSLog(@"remove row: %i currentItem: %@", theRow, currentItem);
	id objectName = nil;
	
	switch (self.listMode) {
			
		case kNTVSourcesListMode:
			
			objectName = [currentItem valueForKey:@"SourceDomain"];
			
			if ([self canRemoveSource:objectName])
			{

				[self removeDialog:currentItem];
				return TRUE;
			} else {
				
				PLAY_FAIL_SOUND;
				NSLog(@"untouchable!!");
				
			}
			
			break;
			
		case kNTVSourceBrowseMode:
			
			
			return FALSE;
			
		default:
			
			return FALSE;
			
			
	}
	

	return TRUE;
}

- (id)previewControlForPackageRow:(long)item
{
	
	/*

	 example package
	 
	 Depends:"mobilesubstrate",
	 MD5sum:"eaf507fa3a1d45419034e0f42333e722",
	 Package:"remotehd-atv2",
	 SHA1:"b1def6d67c39cc8d6d0a1a1f7d4deea3e5747e76",
	 Description:"Remote HD plugin for AppleTV enables Remote HD iOS application to provide remote control for your AppleTV.",
	 Size:"246100",
	 Filename:"pool/main/remotehd-atv2_4.3.6_iphoneos-arm.deb",
	 Version:"4.3.6",
	 Architecture:"iphoneos-arm",
	 "Installed-Size":"240",
	 Priority:"optional",
	 Section:"utils",
	 Maintainer:"Pratik Kumar<pratik@appdynamic.com>",
	 SHA256:"51c385467359effdaf0b2f01c27e497d9056b576202a03e41bdaaaecb295e085"
	 
	 
	 Package, Description, Version, Section
	 
	 
	 */

	
	ntvMedia *currentAsset = [[ntvMedia alloc] init];
	
	id currentPackage = [sourceArray objectAtIndex:item];
	
	NSString *packageName = nil;
	
	if ([[currentPackage allKeys] containsObject:@"Name"])
		packageName = [currentPackage valueForKey:@"Name"];
	else
		packageName = [currentPackage valueForKey:@"Package"];
	
	[currentAsset setTitle:packageName];
	
	NSString *currentVersion = [currentPackage valueForKey:@"Version"];
	NSString *description = nil;
	NSString *author = nil;
	NSString *section = nil;
	if ([[[sourceArray objectAtIndex:item] allKeys] containsObject:@"Description"])
		description = [currentPackage valueForKey:@"Description"];

	[currentAsset setCoverArt:[[NitoTheme sharedTheme] packageImage]];

	
	NSMutableArray *customKeys = [[NSMutableArray alloc] init];
	NSMutableArray *customObjects = [[NSMutableArray alloc] init];
	
	[customKeys addObject:@"Version"];
	[customObjects addObject:currentVersion];
	if(description != nil)
	{
		[currentAsset setSummary:description];
	}
	
	if ([[currentPackage allKeys] containsObject:@"Author"])
		author = [currentPackage valueForKey:@"Author"];
	if ([[[sourceArray objectAtIndex:item] allKeys] containsObject:@"Section"])
		section = [currentPackage valueForKey:@"Section"];
	if (author != nil)
	{
		[customKeys addObject:BRLocalizedString(@"Author", @"Author")];
		[customObjects addObject:author];
	}
	
	if (section != nil)
	{
		[customKeys addObject:BRLocalizedString(@"Section", @"Section")];
		[customObjects addObject:section];
	}
	
	
	[currentAsset setCustomKeys:[customKeys autorelease] 
					 forObjects:[customObjects autorelease]];
	
	
	ntvMediaPreview *preview = [[ntvMediaPreview alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	return [preview autorelease];
	

}
- (id)previewControlForItem:(long)row
{
	id controller = nil;

	switch (self.listMode) {
			
		case kNTVSourcesListMode:
			
			return [self previewControlForSourceRow:row];
			
			break;
			
		case kNTVSourceBrowseMode:
			
			return [self previewControlForPackageRow:row];
			
			break;
			
			
		case kNTVSourceMissingDefaultsMode:
			
			controller = [[BRImageAndSyncingPreviewController alloc] init];
			[controller setImage:[[NitoTheme sharedTheme] sharePointImage]];
			
			return [controller autorelease];
			
		
	}
	
	return nil;
}

-(void)controller:(PackageDataSource *)c selectedControl:(BRControl *)ctrl
{

	if ([ctrl respondsToSelector:@selector(selectedControl)])
	{
		id data = [[c provider] data];
		
		BRPosterControl *selectedControl = [(BRMediaShelfView *)ctrl selectedControl];
		int focusedIndex = [(BRMediaShelfView *)ctrl focusedIndex];
		id myAsset = [data objectAtIndex:focusedIndex];
		
			//NSLog(@"selectedControl of type %@ selected", [selectedControl class]);
		
		NSString *packageName = [[selectedControl title] string];
		BRImage *theImage = [myAsset coverArt];
			//	NSLog(@"selectedControl: %@ packageName: %@ index: %i", selectedControl, packageName, focusedIndex);
		selectedObject = packageName;
	
		[c updatePackageData:packageName usingImage:theImage];
		
	}
	
	
}

-(void)controller:(PackageDataSource *)c buttonSelectedAtIndex:(int)index
{
	
		//NSLog(@"%@ buttonSelectedAtIndex: %i", c, index);
	id selectedButton = [[c _buttons] objectAtIndex:index];
	
	switch (index) {
			
		case 0: //install
			
			[c setListActionMode:kPackageInstallMode];
			[c newUberInstaller:selectedObject withSender:selectedButton];
			break;

			
		case 1: //remove
				//NSLog(@"remove: %@", selectedObject);
			if ([PM packageInstalled:selectedObject])
			{
				if ([PM canRemove:selectedObject])
				{
					[c setListActionMode:KPackageRemoveMode];
						//[c removePackage:selectedObject];
						//[c removePackage:selectedObject withSender:selectedButton];
					NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:selectedObject, @"Package", selectedButton, @"Sender", nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveDialog" object:nil userInfo:userInfo];
				} else {
					[self showProtectedAlert:selectedObject];
					[BRSoundHandler playSound:18];
					return;
				}
				
			} else {
				[BRSoundHandler playSound:18];
			}
			
			break;
			
		case 2: //more
			

			[c showPopupFrom:c withSender:selectedButton];
			break;
	}
	
}

- (void)showProtectedAlert:(NSString *)protectedPackage
{
	BRAlertController *result = [[BRAlertController alloc] initWithType:0 titled:BRLocalizedString(@"Required Package", @"alert when there is a required / unremovable package") primaryText:[NSString stringWithFormat:BRLocalizedString(@"The Package %@ is required for proper operation of your AppleTV and cannot be removed", @"primary text when there is a required / unremovable package"), protectedPackage] secondaryText:BRLocalizedString(@"Press menu to exit", @"seconday text when there is a required / unremovable package") ];
	[[self stack] pushController:result];
	[result release];
}


- (void)showPopupFrom:(id)me withSender:(id)sender
{
	nitoMoreMenu *c = [[nitoMoreMenu alloc] initWithSender:sender addedTo:me];
	[c addToController:me];
	[c release];
}

-(BOOL)rightAction:(long)theRow
{

	id row = [[self list] selectedObject];
	[self showPopupFrom:self withSender:row];
	return YES;
}

- (void)promptForSource
{
	if (self.missingDefaults == TRUE)
	{
		int alertResult = [BROptionAlertControl postAlertWithTitle:BRLocalizedString(@"Choose source type", @"Choose source type") primaryText:BRLocalizedString(@"Default source(s) are missing, would you like to add a new one or restore a default?", @"Default source(s) are missing, would you like to add a new one or restore a default?") secondaryText:nil firstButton:BRLocalizedString(@"Restore Default", @"Restore Default") secondButton:BRLocalizedString(@"Add New", @"Add New") thirdButton:nil defaultFocus:0];
		
		id controller = nil;
		
		
			//NSLog(@"showUpdateDialog result: %i", alertResult);
		
		switch (alertResult) {
				
			case 0: //restore default
				
				controller = [[nitoSourceController alloc] initWithTitle:BRLocalizedString(@"Restore Default Source", @"Restore Default Source") andSources:nil inMode:kNTVSourceMissingDefaultsMode];
				[[self stack] pushController:controller];
				[controller release];
				return;
				
			case 1: // add new, just continue

				break;
		}
	}
	
	
	
	id controller = [[BRTextEntryController alloc] init];
	[controller setTitle:BRLocalizedString(@"Enter Source URL", @"title of textentry controller for entering source url")];
	[controller setTextEntryTextFieldLabel:BRLocalizedString(@"URL:", @"the text to the left of the text field while entering a source url")];
	[controller setTextFieldDelegate:self];
	
	
	[controller setInitialTextEntryText:@"http://"];
	[[self stack] pushController: controller];
	[controller release];
}



- (void) textDidChange: (id) sender
{
		// do nothing for now
}

- (void) textDidEndEditing: (id) sender
{
	self.connectionMode = kNTVConnectionPackagesBZ2Check;
	[[self stack] popController];
	self.potentialSource = [sender stringValue];
	[self _testSourceURL:[sender stringValue]];
}

-(void)itemSelected:(long)selected
{
	if (self.listMode == kNTVSourceMissingDefaultsMode)
	{
		id currentObject = [self.missingDomains objectAtIndex:selected];
		[self addDefaultSource:currentObject];
		return;
		
	}
	
	if (self.listMode == kNTVSourceBrowseMode) //browsing the source and not the repo list
	{
		
		NSString *selectedPackage = [[sourceArray objectAtIndex:selected] valueForKey:@"Package"];
		selectedObject = selectedPackage;
		PackageDataSource *pds = [[PackageDataSource alloc] initWithPackageInfo:[sourceArray objectAtIndex:selected]];
		[pds setDatasource:pds];
		[pds setDelegate:self];
		[pds setCurrentMode:kPKGRepoListMode];
		[[self stack] pushController:pds];
		[pds release];
		return;
	}
	
		//repo list
	
	if (self.processing)
	{
		NSLog(@"processing, dont interrupt!!");
		PLAY_FAIL_SOUND;
		return;
	}
	
	int adjustedCount = ([self itemCount]-1);
	if (adjustedCount == selected)
	{
		[self promptForSource]; //add rep
		
	} else { //repo list
		
		self.processing = TRUE;
		self.progressIndex = selected;
		id theRepo = [self.sourceArray objectAtIndex:selected];
		[self setCurrentRepo:theRepo];
		[[self list] reload];
		[currentRepo retain]; // necessary? FIXME
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listFinished:) name:@"ListFinished" object:nil];
		[NSThread detachNewThreadSelector:@selector(processRepoThreaded:) toTarget:self withObject:theRepo];
		
			//FIXME: we need to reload the list and set some kind of "processing" item
	}
}

- (void)processRepoThreaded:(id)theRepo
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *title = nil;
	
	if ([[theRepo allKeys] containsObject:@"Origin"])
			title = [theRepo valueForKey:@"Origin"];
		else
			title = [theRepo valueForKey:@"SourceDomain"];
	
		//	NSLog(@"title: %@", title);
	
	NSString *domain = [theRepo valueForKey:@"SourceDomain"];
	NSString *repoListLocation = [packageManagement listLocationFromString:domain];
	NSArray *sources = [packageManagement newParsedPackageArrayForRepo:repoListLocation];
		//NSString *filteredFile = [@"/var/mobile/Library/Preferences/" stringByAppendingFormat:@"%@.plist", title];
		//NSLog(@"filteredFile: %@ sources count: %i", filteredFile, [sources count]);
		//[sources writeToFile:filteredFile atomically:TRUE];
	
	NSDictionary *sourceDict = [NSDictionary dictionaryWithObjectsAndKeys:title, @"Title", sources, @"Sources", nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ListFinished" object:nil userInfo:sourceDict];

	
	[pool release];
	
}

- (void)controlWasActivated
{
	self.processing = FALSE;
	self.progressIndex = -1;
	[super controlWasActivated];
	[[self list]reload];
}

- (id) itemForRow: (long) row 
{
	if ( row > [_names count] )
		return ( nil );
	
	BRMenuItem *result = nil;
	NSString *theTitle = [_names objectAtIndex: row];
	
	result = [BRMenuItem ntvFolderMenuItem];
	
	if (self.processing == TRUE)
	{
		if (row == self.progressIndex)
		{

			result = [BRMenuItem ntvProgressMenuItem];
		}
	}
	
	[result setText:theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];			
	
	
	return ( result );
}

- (void)listFinished:(NSNotification *)n
{
	

	self.processing = FALSE;
	self.progressIndex = -1;
	id repo = [n userInfo];
	NSString *title = [repo valueForKey:@"Title"];
	NSArray *sources = [repo valueForKey:@"Sources"];
	
	nitoSourceController *packageSourceListController = [[nitoSourceController alloc] initWithTitle:title andSources:sources inMode:kNTVSourceBrowseMode];
	[packageSourceListController setCurrentRepo:self.currentRepo];
	[[self stack] pushController:packageSourceListController];
	[packageSourceListController release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)currentRepoString
{
		//NSLog(@"self.currentRepo: %@", self.currentRepo);
	if ([[self.currentRepo allKeys] containsObject:@"Origin"])
	{
		return [[self currentRepo] valueForKey:@"Origin"];
	} else {
		return [[self currentRepo] valueForKey:@"SourceDomain"];
	}
	
	return nil;
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data

{
	
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error

{
	
}

- (void)finishAddingSource:(id)timer
{
	NSString *theSource = [[timer userInfo] objectForKey:@"Source"];
	[packageManagement addSource:theSource];
	self.sourceArray = [packageManagement repoReleaseDictionaries];
	[self _processSources];
	[[self list] reload];
	[[self stack] popController];
	self.potentialSource = nil;
	_validSourceCheck = 1;
}

- (void)addSource:(NSString *)theSource
{
	BRTextWithSpinnerController *theWaitController = [[BRTextWithSpinnerController alloc] initWithTitle:@"Adding Source...." text:@"Adding Source, Please Wait..."];
	[[self stack] pushController:theWaitController];
	[theWaitController release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theSource forKey:@"Source"];
	[NSTimer scheduledTimerWithTimeInterval:.1 target: self selector: @selector(finishAddingSource:) userInfo: userInfo repeats: NO];
	
}


- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
	
{
    [self _stopReceiveWithStatus:0];
	
	switch (self.connectionMode) {
			
		case kNTVConnectionPackagesCheck:
			
			self.connectionMode = kNTVConnectionPackagesBZ2Check;
			[self _testSourceURL:self.potentialSource];
			break;
			
		
		case kNTVConnectionPackagesBZ2Check:
			
			self.connectionMode = 0;
			
			if (_validSourceCheck == 0)
			{
				[self addSource:self.potentialSource];
		
			} else {
				
				NSLog(@"invalid source!!, beep for now");
				PLAY_FAIL_SOUND;
				
			}

			
			break;
	}

}


@end
