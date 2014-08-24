//
//  nitoSourceController.m
//  nitoTV
//
//  Created by Kevin Bradley on 9/20/11.
//  Copyright 2011 nito, LLC. All rights reserved.
//

#import "packageManagement.h"

/*
#import "nitoSourceController.h"
#import "ntvMedia.h"
#import "ntvMediaPreview.h"
#import "PackageDataSource.h"
#import "nitoMoreMenu.h"
*/

//crashing here
/*
 
 Aug 24 15:12:39 Apple-TV AppleTV[2387]: *** Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSCFString substringFromIndex:]: Index 7 out of bounds; string length 2'
 *** First throw call stack:
 */

enum  {
	
	kNTVConnectionPackagesCheck = 1,
	kNTVConnectionPackagesBZ2Check,
	kNTVSourcesListMode,
	kNTVSourceBrowseMode,
	kNTVSourceMissingDefaultsMode,
};



#define NITO_LIST @"/etc/apt/sources.list.d/nitotv.list"

/*

@interface nitoSourceController ()

	// Properties that don't need to be seen by the outside world.

@property (nonatomic, readonly) BOOL              isReceiving;
@property (nonatomic, retain)   NSURLConnection * connection;

@end
*/

/*
 
 NSArray						*sourceArray;
 NSString					*potentialSource;
 int							listMode;
 NSURLConnection *           _connection;
 int							_validSourceCheck;
 NSDictionary				*currentRepo;
 id							selectedObject;
 int							progressIndex;
 NSArray						*missingDomains;
 BOOL						missingDefaults;
 
 */

static BOOL missingDefaults;
static BOOL processing = FALSE;
static int connectionMode;
static int listMode;
static int _validSourceCheck;
static int progressIndex;


static char const * const kNitoSourceArrayKey = "nSourceArray";
static char const * const kNitoPotentialSourcesKey = "nPotentialSource";
static char const * const kNitoSourceConnectionKey = "nSourceConnection";
static char const * const kNitoSourceCurrentRepoKey = "nSourceCurrentRepo";
static char const * const kNitoSourceSelectedObjectKey = "nSourceSelectedObject";
static char const * const kNitoSourceMissingDomainsKey = "nSourceMissingDomains";

/*
@implementation nitoSourceController

@synthesize sourceArray, connectionMode, potentialSource, listMode, currentRepo, selectedObject, progressIndex, processing, missingDomains, missingDefaults;
@synthesize connection    = _connection;
*/

%subclass nitoSourceController : nitoMediaMenuController

%new - (NSArray *)sourceArray {
    return [self associatedValueForKey:(void*)kNitoSourceArrayKey];
}

%new - (void)setSourceArray:(NSArray *)value {

	[self associateValue:value withKey:(void*)kNitoSourceArrayKey];
}

%new - (NSString *)potentialSource {
    return [self associatedValueForKey:(void*)kNitoPotentialSourcesKey];
}

%new - (void)setPotentialSource:(NSString *)value {
    [self associateValue:value withKey:(void*)kNitoPotentialSourcesKey];
}


%new - (void)setListMode:(int)value {
    listMode = value;
}

%new - (NSURLConnection *)connection {
    return [self associatedValueForKey:(void*)kNitoSourceConnectionKey];
}

%new - (void)setConnection:(NSURLConnection *)value {
    [self associateValue:value withKey:(void*)kNitoSourceConnectionKey];
}

%new - (int)validSourceCheck {
    return _validSourceCheck;
}

%new - (void)setValidSourceCheck:(int)value {
    if (_validSourceCheck != value) {
        _validSourceCheck = value;
    }
}

%new - (NSDictionary *)currentRepo {
    return [self associatedValueForKey:(void*)kNitoSourceCurrentRepoKey];
}

%new - (void)setCurrentRepo:(NSDictionary *)value {
    [self associateValue:value withKey:(void*)kNitoSourceCurrentRepoKey];
}

%new - (id)selectedObject {
    return [self associatedValueForKey:(void*)kNitoSourceSelectedObjectKey];
}

%new - (void)setSelectedObject:(id)value {
	[self associateValue:value withKey:(void*)kNitoSourceSelectedObjectKey];
}

%new - (int)progressIndex {
    return progressIndex;
}

%new - (void)setProgressIndex:(int)value {
   
        progressIndex = value;
}

%new - (NSArray *)missingDomains {
    return [self associatedValueForKey:(void*)kNitoSourceMissingDomainsKey];
}

%new - (void)setMissingDomains:(NSArray *)value {
	[self associateValue:value withKey:(void*)kNitoSourceMissingDomainsKey];
}

%new - (BOOL)missingDefaults {
    return missingDefaults;
}

%new - (void)setMissingDefaults:(BOOL)value {
   
        missingDefaults = value;
}



%new - (void)_testSourceURL:(NSString *)baseUrlString
	// Starts a connection to download the current URL.
{
    NSURL *             url;
    NSMutableURLRequest *      request;

	NSString *fullURLString = nil;
	
	
	switch (connectionMode) {
			
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
		
	id _connection = [NSURLConnection connectionWithRequest:request delegate:self];
	[self setConnection:_connection];
		
	
}


%new - (id)initWithTitle:(NSString *)theTitle andSources:(NSArray *)sources
{
	return [self initWithTitle:theTitle andSources:sources inMode:kNTVSourcesListMode]; 
}

%new - (void)refreshMissingDomains
{
	
	[self setMissingDomains:[packageManagement missingDefaultDomains]];
	if ([[self missingDomains] count] > 0)
	{
		missingDefaults = TRUE;
	} else {
		missingDefaults = FALSE;
	}
}

%new - (id)initWithTitle:(NSString *)theTitle andSources:(NSArray *)sources inMode:(int)theListMode
{
	self = [self initWithTitle:theTitle];
	
	processing = FALSE;
	progressIndex = -1;
	

	[self setCurrentRepo:nil];
	connectionMode = 0;
	_validSourceCheck = 1;
		//sourceArray = sources;
	[self setSourceArray:sources];
	listMode = theListMode;
	missingDefaults = FALSE;
	
	
	
	switch (theListMode) {
			
		case kNTVSourcesListMode:
			
			[self setMissingDomains:[packageManagement missingDefaultDomains]];
			if ([[self missingDomains] count] > 0)
			{
				missingDefaults = TRUE;
			}
				[self _processSources];
			break;
			
		case kNTVSourceBrowseMode:
				[self _processList];
			break;
			
		case kNTVSourceMissingDefaultsMode:
			
			[self setMissingDomains:[packageManagement missingDefaultDomains]];
			[self setSourceArray:[self missingDomains]];
			
			[self _processDefaults];
			break;
	}

	
	return ( self );
}

%new - (void)_processDefaults
{
	[[self names] removeAllObjects];
	for(id currentObject in [self missingDomains])
	{
		
		if ([[currentObject allKeys] containsObject:@"SourceDomain"])
		{
			NSString *sd = [currentObject valueForKey:@"SourceDomain"];
			[[self names] addObject:sd];
		}
			

	}
}

%new - (void)_processList
{
	[[self names] removeAllObjects];
		//NSLog(@"array: %@", [self sourceArray]);
	for(id currentObject in [self sourceArray])
	{
		if ([[currentObject allKeys] containsObject:@"Name"])
			[[self names] addObject:[currentObject valueForKey:@"Name"]];
		else
			[[self names] addObject:[currentObject valueForKey:@"Package"]];
	}

}

%new - (void)_processSources
{
	[[self list] removeDividers];
	[[self names] removeAllObjects];
	int sourceCount = [[self sourceArray] count];
	for(id currentObject in [self sourceArray])
	{
		if ([[currentObject allKeys] containsObject:@"Origin"])
			[[self names] addObject:[currentObject valueForKey:@"Origin"]];
		else
			[[self names] addObject:[currentObject valueForKey:@"SourceDomain"]];
	}
	[[self names] addObject:BRLocalizedString(@"Add Source", @"Add source menu item")];
	
	[[self list] addDividerAtIndex:sourceCount withLabel:BRLocalizedString(@"Options", @"Options menu item divider in software section")];
}

%new - (BOOL)isReceiving
{
    return ([self connection] != nil);
}

%new - (void)_stopReceiveWithStatus:(int)status
	// Shuts down the connection and displays the result (statusString == nil) 
	// or the error status (otherwise).
{
    if ([self connection] != nil) {
        [[self connection] cancel];
        [self setConnection:nil];
		
    }
}

/*
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
*/

%new - (NSArray *)bzipMimeArray
{

	return [NSArray arrayWithObjects:@"application/x-bzip2", @"application/bzip2", @"application/x-bz2", @"application/x-bzip", @"application/x-compressed", nil];
}

%new - (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
	
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

%new - (id)previewControlForSourceRow:(long)item
{
	int adjustedCount = ([self itemCount]-1);
	if (adjustedCount == item)
	{
		Class briaspc = objc_getClass("BRImageAndSyncingPreviewController");
		if (briaspc != nil)
		{
			id controller = [[briaspc alloc] init];
			[controller setImage:[[NitoTheme sharedTheme] sharePointImage]];
			
			return [controller autorelease];
		}
		
		NSLog(@"is 6.0, no BRImageAndSyncingPreviewController!");
		return nil;
		
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
	
	NSDictionary *sourceItem = [[self sourceArray] objectAtIndex:item];
	
	NSString *sourceName = nil;
	
	if ([[sourceItem allKeys] containsObject:@"Origin"])
		sourceName = [sourceItem valueForKey:@"Origin"];
	else
		sourceName = [sourceItem valueForKey:@"SourceDomain"];
	
		//NSLog(@"sourceItem: %@", [[self sourceArray] objectAtIndex:item]);
	
	id currentAsset = [[objc_getClass("ntvMedia") alloc] init];
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
	
	
	id preview = [[objc_getClass("ntvMediaPreview") alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	return [preview autorelease];
	
	
	
}

%new + (NSArray *)untouchableSources
{
	return [NSArray arrayWithObjects:@"apt.awkwardtv.org", @"apt.saurik.com", @"nitosoft.com", @"mirrors.xbmc.org", nil];
}

%new - (BOOL)canRemoveSource:(NSString *)theSource
{
	if ([[%c(nitoSourceController) untouchableSources] containsObject:theSource])
		return ( FALSE );
	
	return ( TRUE );
}

%new - (void)removeDialog:(NSDictionary *)sourceToRemove
{
	id opDi = [[objc_getClass("BROptionDialog") alloc] init];
	NSString *objectName = [sourceToRemove valueForKey:@"SourceDomain"];
	[opDi setTitle:BRLocalizedString(@"Delete Source?", @"alert dialog for deleting source")];
	[opDi setPrimaryInfoText:[NSString stringWithFormat:BRLocalizedString(@"Any packages on this repo will no longer be available. Are you sure you want to delete the source '%@'?", @"alert dialog for deleting source"),objectName]];
	[opDi addOptionText:BRLocalizedString(@"Cancel Delete", @"cancel button") isDefault:YES];
	[opDi addOptionText:BRLocalizedString(@"Delete", @"cancel delete")];
	[opDi setActionSelector:@selector(deleteOptionSelected:) target:self];
	
	[ROOT_STACK pushController:opDi];
	[opDi autorelease];
	[self setCurrentRepo:sourceToRemove];
}

%new - (void)deleteOptionSelected:(id)option
{
	if([[[self stack] peekController] isKindOfClass: objc_getClass("BROptionDialog")])
	{
		[[self stack] popController];
	}
	
	switch ([option selectedIndex]) {
			
		case 1: //delete
			
			[self removeSource:[self currentRepo]];
			
			break;
	}
}

			 //removeSource? deprecated?
			 
%new - (void)removeSource:(NSDictionary *)theSource //
{
		//NSLog(@"should remove source: %@", theSource);
	NSString *tempFile = @"/private/var/mobile/Library/Preferences/duwmz";
	[theSource writeToFile:tempFile atomically:YES];
	id theWaitController = [[objc_getClass("BRTextWithSpinnerController") alloc] initWithTitle:@"Removing Source..." text:@"Removing Source, Please Wait..."];
	[ROOT_STACK pushController:theWaitController];
	[theWaitController release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:tempFile forKey:@"Source"];
	[NSTimer scheduledTimerWithTimeInterval:.1 target: self selector: @selector(finishRemovingSource:) userInfo: userInfo repeats: NO];
}


%new - (void)addDefaultSource:(NSDictionary *)theSource
{
	
	id theWaitController = [[objc_getClass("BRTextWithSpinnerController") alloc] initWithTitle:@"Restoring Default Source..." text:@"Restoring Default Source..."];
	[ROOT_STACK pushController:theWaitController];
	[theWaitController release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theSource forKey:@"Source"];
	[NSTimer scheduledTimerWithTimeInterval:.1 target: self selector: @selector(finishRestoringSource:) userInfo: userInfo repeats: NO];
}

%new - (void)finishRestoringSource:(id)timer
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


%new - (void)finishRemovingSource:(id)timer
{
	NSString *sourcePath = [[timer userInfo] valueForKey:@"Source"];
	NSString *commandString = [NSString stringWithFormat:@"/usr/bin/nitoHelper removeRepo %@ 2", sourcePath];
		//NSLog(@"commandString: %@", commandString);
	int sysReturn = system([commandString UTF8String]);
	NSLog(@"removed with status: %i", sysReturn);
	[self setSourceArray:[packageManagement repoReleaseDictionaries]];

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
	
	switch (listMode) {
			
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

%new - (id)previewControlForPackageRow:(long)item
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

	
	id currentAsset = [[objc_getClass("ntvMedia") alloc] init];
	
	id currentPackage = [[self sourceArray] objectAtIndex:item];
	
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
	if ([[[[self sourceArray] objectAtIndex:item] allKeys] containsObject:@"Description"])
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
	if ([[[[self sourceArray] objectAtIndex:item] allKeys] containsObject:@"Section"])
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
	
	
	id preview = [[objc_getClass("ntvMediaPreview") alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	return [preview autorelease];
	

}
- (id)previewControlForItem:(long)row
{
	id controller = nil;

	Class briaspc = objc_getClass("BRImageAndSyncingPreviewController");
	
	switch (listMode) {
			
		case kNTVSourcesListMode:
			
			return [self previewControlForSourceRow:row];
			
			break;
			
		case kNTVSourceBrowseMode:
			
			return [self previewControlForPackageRow:row];
			
			break;
			
			
		case kNTVSourceMissingDefaultsMode:
			
			if (briaspc != nil)
			{
				controller = [[briaspc alloc] init];
				[controller setImage:[[NitoTheme sharedTheme] sharePointImage]];
				
				return [controller autorelease];
			}
			
			return nil;
		
	}
	
	return nil;
}

%new -(void)controller:(id)c selectedControl:(id)ctrl
{

	if ([ctrl respondsToSelector:@selector(selectedControl)])
	{
		id data = [[c provider] data];
		
		id selectedControl = [ctrl selectedControl];
		int focusedIndex = [[ctrl focusedIndexPath] indexAtPosition:1];
		id myAsset = [data objectAtIndex:focusedIndex];
		
			//NSLog(@"selectedControl of type %@ selected", [selectedControl class]);
		
		NSString *packageName = [[selectedControl title] string];
		id theImage = [myAsset coverArt];
			//	NSLog(@"selectedControl: %@ packageName: %@ index: %i", selectedControl, packageName, focusedIndex);
		[self setSelectedObject:packageName];
	
		[c updatePackageData:packageName usingImage:theImage];
		
	}
	
	
}

%new -(void)controller:(id)c buttonSelectedAtIndex:(int)index
{
	
		//NSLog(@"%@ buttonSelectedAtIndex: %i", c, index);
	id selectedButton = [[c buttons] objectAtIndex:index];
	id _selectedObject = [self selectedObject];
	
	switch (index) {
			
		case 0: //install
			
			[c setListActionMode:kPackageInstallMode];
			[c newUberInstaller:_selectedObject withSender:selectedButton];
			break;

			
		case 1: //remove
				//NSLog(@"remove: %@", selectedObject);
			if ([PM packageInstalled:_selectedObject])
			{
				if ([PM canRemove:_selectedObject])
				{
					[c setListActionMode:KPackageRemoveMode];
						//[c removePackage:selectedObject];
						//[c removePackage:selectedObject withSender:selectedButton];
					NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_selectedObject, @"Package", selectedButton, @"Sender", nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveDialog" object:nil userInfo:userInfo];
				} else {
					[self showProtectedAlert:_selectedObject];
					[objc_getClass("BRSoundHandler") playSound:18];
					return;
				}
				
			} else {
				[objc_getClass("BRSoundHandler") playSound:18];
			}
			
			break;
			
		case 2: //more
			

			[c showPopupFrom:c withSender:selectedButton];
			break;
	}
	
}

%new - (void)showProtectedAlert:(NSString *)protectedPackage
{
	id result = [[objc_getClass("BRAlertController") alloc] initWithType:0 titled:BRLocalizedString(@"Required Package", @"alert when there is a required / unremovable package") primaryText:[NSString stringWithFormat:BRLocalizedString(@"The Package %@ is required for proper operation of your AppleTV and cannot be removed", @"primary text when there is a required / unremovable package"), protectedPackage] secondaryText:BRLocalizedString(@"Press menu to exit", @"seconday text when there is a required / unremovable package") ];
	[ROOT_STACK pushController:result];
	[result release];
}


%new - (void)showPopupFrom:(id)me withSender:(id)sender
{
	id c = [[objc_getClass("nitoMoreMenu") alloc] initWithSender:sender addedTo:me];
	[c addToController:me];
	[c release];
}

-(BOOL)rightAction:(long)theRow
{

	id row = [[self list] selectedObject];
	[self showPopupFrom:self withSender:row];
	return YES;
}

%new - (void)promptForSource
{
	if (missingDefaults == TRUE)
	{
		
		int alertResult = 0;
		Class broac = %c(BROptionAlertControl);
		
		if ([broac respondsToSelector:@selector(postAlertWithTitle:primaryText:secondaryText:firstButton:secondButton:thirdButton:defaultFocus:)])
		{
			alertResult = (int)[objc_getClass("BROptionAlertControl") postAlertWithTitle:BRLocalizedString(@"Choose source type", @"Choose source type") primaryText:BRLocalizedString(@"Default source(s) are missing, would you like to add a new one or restore a default?", @"Default source(s) are missing, would you like to add a new one or restore a default?") secondaryText:nil firstButton:BRLocalizedString(@"Restore Default", @"Restore Default") secondButton:BRLocalizedString(@"Add New", @"Add New") thirdButton:nil defaultFocus:0];
		
		} else {
			
			alertResult = (int)[objc_getClass("BROptionAlertControl") postAlertWithTitleAndCancel:BRLocalizedString(@"Choose source type", @"Choose source type") primaryText:BRLocalizedString(@"Default source(s) are missing, would you like to add a new one or restore a default?", @"Default source(s) are missing, would you like to add a new one or restore a default?") secondaryText:nil firstButton:BRLocalizedString(@"Restore Default", @"Restore Default") secondButton:BRLocalizedString(@"Add New", @"Add New") thirdButton:nil defaultFocus:0 identifier:@"" cancelIndex:0 allowAutoDismiss:NO autoDismissIndex:0];
		}
		id controller = nil;
		
		
			//NSLog(@"showUpdateDialog result: %i", alertResult);
		
		switch (alertResult) {
				
			case 0: //restore default
				
				controller = [[%c(nitoSourceController) alloc] initWithTitle:BRLocalizedString(@"Restore Default Source", @"Restore Default Source") andSources:nil inMode:kNTVSourceMissingDefaultsMode];
				[ROOT_STACK pushController:controller];
				[controller release];
				return;
				
			case 1: // add new, just continue

				break;
		}
	}
	
	
	
	id controller = [[objc_getClass("BRTextEntryController") alloc] init];
	[controller setTitle:BRLocalizedString(@"Enter Source URL", @"title of textentry controller for entering source url")];
	[controller setTextEntryTextFieldLabel:BRLocalizedString(@"URL:", @"the text to the left of the text field while entering a source url")];
	[controller setTextFieldDelegate:self];
	
	
	[controller setInitialTextEntryText:@"http://"];
	[ROOT_STACK pushController: controller];
	[controller release];
}



%new - (void) textDidChange: (id) sender
{
		// do nothing for now
}

%new - (void) textDidEndEditing: (id) sender
{
	connectionMode = kNTVConnectionPackagesBZ2Check;
	[[self stack] popController];
	[self setPotentialSource:[sender stringValue]];

	[self _testSourceURL:[sender stringValue]];
}

-(void)itemSelected:(long)selected
{
	if (listMode == kNTVSourceMissingDefaultsMode)
	{
		id currentObject = [[self missingDomains] objectAtIndex:selected];
		[self addDefaultSource:currentObject];
		return;
		
	}
	
	if (listMode == kNTVSourceBrowseMode) //browsing the source and not the repo list
	{
		
		NSString *selectedPackage = [[[self sourceArray] objectAtIndex:selected] valueForKey:@"Package"];
		[self setSelectedObject:selectedPackage];
		id pds = [[objc_getClass("PackageDataSource") alloc] initWithPackageInfo:[[self sourceArray] objectAtIndex:selected]];
		[pds setDatasource:pds];
		[pds setDelegate:self];
		[pds setCurrentPackageMode:kPKGRepoListMode];
		[ROOT_STACK pushController:pds];
		[pds release];
		return;
	}
	
		//repo list
	
	if (processing)
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
		
		processing = TRUE;
		progressIndex = selected;
		id theRepo = [[self sourceArray] objectAtIndex:selected];
		[self setCurrentRepo:theRepo];
		[[self list] reload];
			//[currentRepo retain]; // necessary? FIXME
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listFinished:) name:@"ListFinished" object:nil];
		[NSThread detachNewThreadSelector:@selector(processRepoThreaded:) toTarget:self withObject:theRepo];
		
			//FIXME: we need to reload the list and set some kind of "processing" item
	}
}

%new - (void)processRepoThreaded:(id)theRepo
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
	processing = FALSE;
	progressIndex = -1;
	%orig;
		//[super controlWasActivated];
	[[self list]reload];
}

- (id) itemForRow: (long) row 
{
	if ( row > [[self names] count] )
		return ( nil );
	
	id result = nil;
	NSString *theTitle = [[self names] objectAtIndex: row];
	
	result = [objc_getClass("nitoMenuItem") ntvFolderMenuItem];
	
	if (processing == TRUE)
	{
		if (row == progressIndex)
		{

			result = [objc_getClass("nitoMenuItem") ntvProgressMenuItem];
		}
	}
	
	[result setText:theTitle withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemTextAttributes]];			
	
	
	return ( result );
}

%new - (void)listFinished:(NSNotification *)n
{
	

	processing = FALSE;
	progressIndex = -1;
	id repo = [n userInfo];
	NSString *title = [repo valueForKey:@"Title"];
	NSArray *sources = [repo valueForKey:@"Sources"];
	
	id packageSourceListController = [[%c(nitoSourceController) alloc] initWithTitle:title andSources:sources inMode:kNTVSourceBrowseMode];
	[packageSourceListController setCurrentRepo:[self currentRepo]];
	[ROOT_STACK pushController:packageSourceListController];
	[packageSourceListController release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

%new - (NSString *)currentRepoString
{
	
	if ([[[self currentRepo] allKeys] containsObject:@"Origin"])
	{
		return [[self currentRepo] valueForKey:@"Origin"];
	} else {
		return [[self currentRepo] valueForKey:@"SourceDomain"];
	}
	
	return nil;
}

%new - (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data

{
	
}

%new - (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error

{
	
}

%new - (void)finishAddingSource:(id)timer
{
	NSString *theSource = [[timer userInfo] objectForKey:@"Source"];
	[packageManagement addSource:theSource];
	
	[self setSourceArray:[packageManagement repoReleaseDictionaries]];
	[self _processSources];
	[[self list] reload];
	[[self stack] popController];
	[self setPotentialSource:nil];
	_validSourceCheck = 1;
}

%new - (void)addSource:(NSString *)theSource
{
	id theWaitController = [[objc_getClass("BRTextWithSpinnerController") alloc] initWithTitle:@"Adding Source...." text:@"Adding Source, Please Wait..."];
	[ROOT_STACK pushController:theWaitController];
	[theWaitController release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theSource forKey:@"Source"];
	[NSTimer scheduledTimerWithTimeInterval:.1 target: self selector: @selector(finishAddingSource:) userInfo: userInfo repeats: NO];
	
}


%new - (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
	
{
    [self _stopReceiveWithStatus:0];
	
	switch (connectionMode) {
			
		case kNTVConnectionPackagesCheck:
			
			connectionMode = kNTVConnectionPackagesBZ2Check;
			[self _testSourceURL:[self potentialSource]];
			break;
			
		
		case kNTVConnectionPackagesBZ2Check:
			
			connectionMode = 0;
			
			if (_validSourceCheck == 0)
			{
				[self addSource:[self potentialSource]];
		
			} else {
				
				NSLog(@"invalid source!!, beep for now");
				PLAY_FAIL_SOUND;
				
			}

			
			break;
	}

}


%end
