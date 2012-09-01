//
//  PackageDataSource.m
//  nitoTV
//
//  Created by Tom Cool & Kevin Bradley on 2/26/11.
//  Copyright 2011 nito. All rights reserved.
//

#import "queryMenu.h"
#import "PackageDataSource.h"
#import "nitoInstallManager.h"
#import "nitoSourceController.h"
#import "nitoMoreMenu.h"
#import <SMFramework/SMFComplexProcessDropShadowControl.h>
#import <SMFramework/SMFramework.h>

@implementation PackageDataSource

@class queryMenu;
@synthesize packageData, imageURL, rawCoverArt, provider, installed, currentMode, listActionMode;


/*
 
 Package: com.nito.nitotv
 Status: install ok installed
 Section: Utilities
 Installed-Size: 1380
 Maintainer: nito
 Architecture: iphoneos-arm
 Version: 0.6.4-91
 Depends: beigelist, mobilesubstrate, com.nito.gs
 Description: Release six, weather, RSS, basic deb installer, featured packages, revamped search, package deletion (featured packages only).
 Name: nitoTV
 Website: nitosoft.com
 Author: nito
 
 
 */

- (BOOL)rowSelectable:(long)row	
{
	return YES;
}


- (NSDictionary *)parsedPackageList
{
		//NSString *endFile = @"/Installed.plist";
	NSString *endFile = [packageManagement installedLocation];
	NSDictionary *parsedDict = [NSDictionary dictionaryWithContentsOfFile:endFile];
	return parsedDict;
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


-(void)process:(SMFComplexProcessDropShadowControl *)p ended:(NSString *)s
{
	id installCon = [[[self stack] controllersOfClass:[nitoInstallManager class]] objectAtIndex:0];
	[packageManagement updatePackageList];
	[[installCon list] reload];
		//NSLog(@"process: %@ ended: %@ returnStatus: %i", p, s, [p returnCode]); 
	switch ([self listActionMode]) {

		case kPackageInstallMode:
				//	NSLog(@"kPackageInstallMode");
			if ([p returnCode] == 0)
			{
				[p setTitle:@"Installation/Upgrade successful"];
				[p setSubtitle:@"Press Menu to exit"];
			} else {
				[p setTitle:@"Installation failed"];
				[p setSubtitle:@"Press Menu to exit"];
			}
			break;
	
		case KPackageRemoveMode:
			
			if ([p returnCode] == 0)
			{
				[p setTitle:@"Removal success"];
				[p setSubtitle:@"Press Menu to exit"];
			} else {
				[p setTitle:@"Removal failed"];
				[p setSubtitle:@"Press Menu to exit"];
			}
			
			break;
	}
	
}

- (void)installQueue:(NSString *)queueFile withSender:(id)sender
{
	
	id consoleController = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper queue %@", queueFile];
	[consoleController setAp:command];
	[consoleController setTitle:@"Installing Queue..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController setIsAnimated:TRUE];
	[consoleController setSender:sender];
	[consoleController addToController:self];

	[consoleController release];
	
}

- (void)installQueue:(NSString *)queueFile
{
	id consoleController = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper queue %@", queueFile];
	[consoleController setAp:command];
	[consoleController setTitle:@"Installing Queue..."];
	[consoleController setShowsProgressBar:FALSE];
		[consoleController setIsAnimated:TRUE];
	[consoleController addToController:self];
	[consoleController release];
}

- (void)showRemoveDialogNotification:(NSNotification *)n
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self performSelectorOnMainThread:@selector(showRemoveDialog:) withObject:[n userInfo] waitUntilDone:NO];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showRemoveDialog:(NSDictionary *)removeDict
{
	
	NSString *packageToRemove = [removeDict valueForKey:@"Package"];
	NSString *theTitle = BRLocalizedString(@"Delete Package?", @"alert dialog for deleting playlist");
	NSString *secondaryString = [packageManagement displayDependentsForPackage:packageToRemove];
	NSString *primaryInfo = nil;
	if ([secondaryString length] > 0)
	{
		primaryInfo = [NSString stringWithFormat:BRLocalizedString(@"The following packages depend upon %@, do you wish to delete all of them?",@"primary text for the alert on removing packages"), packageToRemove];
		
	}
	int alertResult = [BROptionAlertControl postAlertWithTitle:theTitle primaryText:primaryInfo secondaryText:secondaryString firstButton:BRLocalizedString(@"Cancel", @"Cancel") secondButton:BRLocalizedString(@"Delete", @"Delete") thirdButton:nil defaultFocus:0];
	
	
	
		//NSLog(@"showUpdateDialog result: %i", alertResult);
	
	switch (alertResult) {
			
		case 1: //remove
			[self performSelector:@selector(finalizeRemove:) withObject:removeDict afterDelay:1];
				//[self finalizeRemove:packageToRemove];
			break;
	}	

}

- (void)finalizeRemove:(NSDictionary *)removeDict
{
	NSString *customFile = [removeDict valueForKey:@"Package"];
	id sender = [removeDict valueForKey:@"Sender"];
	id consoleController  = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper remove %@", customFile];
	[consoleController setAp:command];
	[consoleController setIsAnimated:TRUE];
	[consoleController setSender:sender];
	[consoleController setTitle:[NSString stringWithFormat:@"Removing %@...", customFile]];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	[consoleController release];
}

/*
 
 //deprecated
 
- (void)deleteOptionSelected:(id)option
{
		//NSFileManager *man = [NSFileManager defaultManager];
	
	if([[[self stack] peekController] isKindOfClass: [BROptionDialog class]])
	{
		[[self stack] popController];
	}
	
	switch ([option selectedIndex]) {
			
		case 0: //cancel
			
			break;
			
		case 1: //delete
			
			[self finalizeRemove:greenMileFile];
			
			break;
	}
}
*/

/*

- (void)removeDialog:(NSString *)packageToRemove
{
	
	BROptionDialog *opDi = [[BROptionDialog alloc] init];
	NSString *secondaryString = [packageManagement displayDependentsForPackage:packageToRemove];
	[opDi setTitle:[NSString stringWithFormat:BRLocalizedString(@"Delete %@?", @"alert dialog for deleting playlist"),packageToRemove]];
	
	if ([secondaryString length] > 0)
	{
		NSString *primaryInfo = [NSString stringWithFormat:BRLocalizedString(@"The following packages depend upon %@, do you wish to delete all of them?",@"primary text for the alert on removing packages"), packageToRemove];
		[opDi setPrimaryInfoText:primaryInfo];
		[opDi setSecondaryInfoText:secondaryString];
	}
	
	[opDi addOptionText:BRLocalizedString(@"Cancel Delete", @"cancel button") isDefault:YES];
	[opDi addOptionText:BRLocalizedString(@"Delete", @"cancel delete")];
	[opDi setActionSelector:@selector(deleteOptionSelected:) target:self];
	[[self stack] pushController:opDi];
	[opDi release];
	greenMileFile = packageToRemove;
	[greenMileFile retain];
}
 
 */



- (void)removePackage:(NSString *)customFile withSender:(id)sender
{
	
	[self performSelector:@selector(removeDialog:) withObject:customFile afterDelay:4];
		//[self performSelectorOnMainThread:@selector(removeDialog:) withObject:customFile waitUntilDone:NO];
		//[self removeDialog:customFile];
}

- (void)removePackage:(NSString *)customFile
{
	id consoleController  = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper remove %@", customFile];
	[consoleController setAp:command];
	[consoleController setIsAnimated:TRUE];
	[consoleController setTitle:[NSString stringWithFormat:@"Removing %@...", customFile]];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	[consoleController release];
}

- (void)newUberInstaller:(NSString *)customFile
{	
	
	id consoleController  = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper install %@ 2", customFile];
	[consoleController setAp:command];
	[consoleController setIsAnimated:TRUE];
		//[consoleController setShadowStyle:0];
	[consoleController setTitle:[NSString stringWithFormat:@"Installing %@...", customFile]];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	
}

- (void)newUberInstaller:(NSString *)customFile withSender:(id)sender
{	
	
	id consoleController  = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper install %@ 2", customFile];
	[consoleController setAp:command];
	[consoleController setIsAnimated:TRUE];
	if (sender != nil)
	{
		[consoleController setSender:sender];
	}
		//[consoleController setShadowStyle:0];
	[consoleController setTitle:[NSString stringWithFormat:@"Installing %@...", customFile]];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	
}

- (void)showPopupFrom:(id)me withSender:(id)sender
{
	nitoMoreMenu *c = [[nitoMoreMenu alloc] initWithSender:sender addedTo:me];
	[c addToController:me];
	[c release];
}

//- (void)showPopupFrom:(id)me withSender:(id)sender
//{
//	SMFListDropShadowControl *c = [[SMFListDropShadowControl alloc]init];
//	[c setCDelegate:me];
//	[c setSender:sender];
//	[c setIsAnimated:TRUE];
//	[c setCDatasource:me];
//	[c addToController:me];
//}

- (void)showPopupFrom:(id)me
{
	SMFListDropShadowControl *c = [[SMFListDropShadowControl alloc]init];
	[c setCDelegate:me];
	[c setIsAnimated:TRUE];
	[c setCDatasource:me];
	[c addToController:me];
		//[c release];
}

- (NSArray *)parsedPackageArray
{
	
	NSString *packageFile = @"/tmp/pkginfo";
	NSString *packageString = [NSString stringWithContentsOfFile:packageFile encoding:NSUTF8StringEncoding error:nil];
	NSArray *packageArray = [packageString componentsSeparatedByString:@"\n\n"];
	NSString *mainLine = [packageArray objectAtIndex:0];
	NSArray *lineArray = [mainLine componentsSeparatedByString:@"\n"];
	return (lineArray);
	
}
- (NSDictionary *)packageInfoFromArray:(NSArray *)packageList
{
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
	
	[packageData release];
	[imageURL release];
	[provider release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)controlWasDeactivated
{
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super controlWasDeactivated];
}

- (void)controlWasActivated
{
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRemoveDialogNotification:) name:@"RemoveDialog" object:nil];
	[super controlWasActivated];
}

- (id)initWithPackageInfo:(NSDictionary *)packageInfo
{
	
	self = [super init];

	NSString *packageId = [packageInfo valueForKey:@"Package"];
	installed = [self packageInstalled:packageId];
	packageData = packageInfo;
	
	return ( self );
}

- (id)initWithPackage:(NSString *)packageId usingImage:(id)theImage
{
	self = [super init];
	[[NSFileManager defaultManager] removeItemAtPath:@"/tmp/pkginfo" error:nil];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/apt-cache show %@ 1>/tmp/pkginfo", packageId];
	//NSArray *packageArray = [[SMFCommonTools sharedInstance] returnForProcess:command];
	system([command UTF8String]);
	NSArray *packageArray = [self parsedPackageArray];

	if (theImage != nil)
	{
		if ([theImage respondsToSelector:@selector(isPowerOfTwo)])
		{
			rawCoverArt = theImage;
		} else {
			imageURL = theImage;
		}
	}
		
	installed = [self packageInstalled:packageId];
	currentMode = kPKGFavoritesListMode;
	packageData = [self packageInfoFromArray:packageArray];

	return (self);
	
}

- (void)updatePackageData:(NSString *)packageId usingImage:(id)theImage
{
	[[NSFileManager defaultManager] removeItemAtPath:@"/tmp/pkginfo" error:nil];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/apt-cache show %@ 1>/tmp/pkginfo", packageId];

		//NSArray *packageArray = [[SMFCommonTools sharedInstance] returnForProcess:command];
	system([command UTF8String]);
	NSArray *packageArray = [self parsedPackageArray];
	
	if (theImage != nil)
	{
		if ([theImage respondsToSelector:@selector(isPowerOfTwo)])
		{
			rawCoverArt = theImage;
		} else {
			imageURL = theImage;
		}
	}
	
	installed = [self packageInstalled:packageId];
	packageData = [self packageInfoFromArray:packageArray];
	[self reload];
	[self setFocusedControl:[self._buttons objectAtIndex:0]];
}


-(NSString *)shelfTitle
{
	switch (currentMode) {
					
		case kPKGFavoritesListMode:
			return @"Featured";
		
		case kPKGSearchListMode:
			return @"Search Results";
		
		case kPKGRepoListMode:
			return [(nitoSourceController*) delegate currentRepoString];
			
		case kPKGInstalledListMode:
			return @"Installed";

	}
	return @"Featured";
}

-(NSString *)title
{
    return [packageData valueForKey:@"Name"];
}
-(NSString *)subtitle
{
    return [packageData valueForKey:@"Package"];
}
-(NSString *)summary
{
    return [packageData valueForKey:@"Description"];
}

- (NSArray *)headers
{
	return [NSArray arrayWithObjects:@"Author",@"Version",@"Section",@"Dependencies",nil];
}

-(NSArray *)dependencies
{

	id dependString =[packageData valueForKey:@"Depends"];
	
	if ([dependString respondsToSelector:@selector(length)])
	{
		if ([dependString length] > 0)
			return [dependString componentsSeparatedByString:@", "];
	} else if ([dependString respondsToSelector:@selector(count)]) {
		
		return dependString;
	}

	return nil;
}

-(NSArray *)columns
{
    NSArray *author = [NSArray arrayWithObjects:[packageData valueForKey:@"Author"],nil];
    NSArray *section = [NSArray arrayWithObjects:[packageData valueForKey:@"Section"],nil];
    NSArray *depends = [self dependencies];
    NSArray *version = [NSArray arrayWithObjects:[packageData valueForKey:@"Version"], nil];
    NSArray *objects = [NSArray arrayWithObjects:author,version,section,depends,nil];
    return objects;
}
-(NSString *)rating
{

	NSString *package = [self subtitle];
	NSArray *packageItems = [package componentsSeparatedByString:@"."];
	if ([packageItems count] > 1)
	{
		NSString *middle = [packageItems objectAtIndex:1];
		if ([middle isEqualToString:@"tomcool"])
		{
			return @"TV-COOL";
		}
	}


	return @"TV-NITO";
}
-(BRImage *)coverArt
{
	if (rawCoverArt != nil)
	{
		return rawCoverArt;
	}
	if (imageURL != nil)
	{
		return [BRImage imageWithURL:[NSURL URLWithString:imageURL]];
	}

    return [[NitoTheme sharedTheme] packageImage];
}
	//@"com.nito.query"

- (NSArray *)searchDataStore
{
	queryMenu *queryObject = [[[self stack] controllersOfClass:[queryMenu class]] lastObject];
	
	NSArray *names = [(queryMenu *)queryObject names];
	NSMutableArray *assetArray = [[NSMutableArray alloc] init];
	NSEnumerator *assetEnum = [names objectEnumerator];
	id theObject = nil;
	while ((theObject = [assetEnum nextObject]))
	{
		
		NSString *imagePath = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"package" ofType:@"png" inDirectory:@"Images"];
		
		SMFPhotoMediaAsset * asset = [[SMFPhotoMediaAsset alloc] init];
        [asset setFullURL:imagePath];
        [asset setThumbURL:imagePath];
        [asset setCoverArtURL:imagePath];
        [asset setIsLocal:YES];
		[asset setTitle:theObject];
		[assetArray addObject:asset];
		[asset release];
	}
	
	
	return [assetArray autorelease];
}

- (NSArray *)repoDataStore
{
	
	NSArray *ogArray = [(nitoSourceController *)delegate sourceArray];
	NSArray *repoItems = nil;
	
	if ([ogArray count] > 1000)
	{
		NSLog(@"really big source! count: %i, slimmed to 1K", [ogArray count]);
		repoItems = [ogArray subarrayWithRange:NSMakeRange(0, 1000)];

	} else {
		
		NSLog(@"much more manageable: %i", [ogArray count]);
		
		repoItems = ogArray;

	}

		//NSLog(@"repoItems: %@", repoItems);
	NSMutableArray *assetArray = [[NSMutableArray alloc] init];
	NSEnumerator *assetEnum = [repoItems objectEnumerator];
	id theObject = nil;
	while ((theObject = [assetEnum nextObject]))
	{
		BOOL isLocal = NO;
		NSString *packageID = [theObject valueForKey:@"Package"];
		NSString *imagePath = [theObject valueForKey:@"imageUrl"];
		if (imagePath == nil)
		{
			isLocal = YES;
			imagePath = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"package" ofType:@"png" inDirectory:@"Images"];
		}
		
		SMFPhotoMediaAsset * asset = [[SMFPhotoMediaAsset alloc] init];
        [asset setFullURL:imagePath];
        [asset setThumbURL:imagePath];
        [asset setCoverArtURL:imagePath];
        [asset setIsLocal:isLocal];
		[asset setTitle:packageID];
		[assetArray addObject:asset];
		[asset release];
	}
	
	
	return [assetArray autorelease];
}

- (NSArray *)installedDataStore
{
	NSArray *installedArray = [packageManagement parsedPackageArray];
	NSMutableArray *assetArray = [[NSMutableArray alloc] init];
	NSEnumerator *assetEnum = [installedArray objectEnumerator];
	id theObject = nil;
	while ((theObject = [assetEnum nextObject]))
	{
		BOOL isLocal = NO;
		NSString *packageID = [theObject valueForKey:@"Package"];
		NSString *imagePath = [theObject valueForKey:@"imageUrl"];
		if (imagePath == nil)
		{
			isLocal = YES;
			imagePath = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"package" ofType:@"png" inDirectory:@"Images"];
		}
		
		SMFPhotoMediaAsset * asset = [[SMFPhotoMediaAsset alloc] init];
        [asset setFullURL:imagePath];
        [asset setThumbURL:imagePath];
        [asset setCoverArtURL:imagePath];
        [asset setIsLocal:isLocal];
		[asset setTitle:packageID];
		[assetArray addObject:asset];
		[asset release];
	}
	
	
	return [assetArray autorelease];
}

- (NSArray *)favoriteDataStore
{
	NSArray *favorites = [nitoInstallManager nitoPackageArray];
		//NSLog(@"favorites: %@", favorites);
	NSMutableArray *assetArray = [[NSMutableArray alloc] init];
	NSEnumerator *assetEnum = [favorites objectEnumerator];
	id theObject = nil;
	while ((theObject = [assetEnum nextObject]))
	{
		BOOL isLocal = NO;
		NSString *packageID = [theObject valueForKey:@"url"];
		NSString *imagePath = [theObject valueForKey:@"imageUrl"];
		if (imagePath == nil)
		{
			isLocal = YES;
			imagePath = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"package" ofType:@"png" inDirectory:@"Images"];
		}
			
		SMFPhotoMediaAsset * asset = [[SMFPhotoMediaAsset alloc] init];
        [asset setFullURL:imagePath];
        [asset setThumbURL:imagePath];
        [asset setCoverArtURL:imagePath];
        [asset setIsLocal:isLocal];
		[asset setTitle:packageID];
		[assetArray addObject:asset];
			[asset release];
	}
	

	return [assetArray autorelease];
}

- (void)queuePopupWithPackage:(NSString *)thePackage
{
	BRImage *image = [[NitoTheme sharedTheme] packageImage];
	NSString *installMessage = [NSString stringWithFormat:@"%@ added to queue", thePackage];
	NSArray *a = [NSArray arrayWithObjects:installMessage,@"Continuing queuing or press 'Install' to execute queue",nil];
	id popup=[SMFCommonTools popupControlWithLines:a andImage:image];
	[SMFCommonTools showPopup:popup];
}

- (void)removeQueuePopupWithPackage:(NSString *)thePackage
{
	BRImage *image = [[NitoTheme sharedTheme] packageImage];
	NSString *installMessage = [NSString stringWithFormat:@"%@ un-queued", thePackage];
	NSArray *a = [NSArray arrayWithObjects:installMessage,@"Continuing queuing or press 'Install' to execute queue",nil];
	id popup=[SMFCommonTools popupControlWithLines:a andImage:image];
	[SMFCommonTools showPopup:popup];
}

-(BRPhotoDataStoreProvider *)providerForShelf
{
    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"Hello" predicate:_pred mediaTypes:_set];
	NSArray *assets = nil;
	switch (currentMode) {
	
		case kPKGFavoritesListMode:
			
			assets = [self favoriteDataStore];
			
			break;
	
		case kPKGRepoListMode:
			
			assets = [self repoDataStore];
			
			break;
			
		case kPKGSearchListMode:
			
			assets = [self searchDataStore];
			
			break;
			
		case kPKGInstalledListMode:
			
			assets = [self installedDataStore];
			
			break;
		
		default:
			assets = nil;
				//assets = [SMFPhotoMethods mediaAssetsForPath:[[NSBundle bundleForClass:[self class]]pathForResource:@"Posters" ofType:@""]];
			break;
	
	}
	
	
 
    for (id a in assets) {
        [store addObject:a];
    }
    
    
    id tcControlFactory = [BRPosterControlFactory factory];
    provider    = [BRPhotoDataStoreProvider providerWithDataStore:store controlFactory:tcControlFactory];
    [store release];
    return provider; 
}
-(NSArray *)buttons
{
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    BRButtonControl* b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]previewActionImage] 
													   subtitle:@"Install" 
														  badge:nil];
    [buttons addObject:b];
    
    
   
	if (currentMode == kPKGFavoritesListMode)
	{
		b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]queueActionImage] 
										  subtitle:@"Queue" 
											 badge:nil];
		[buttons addObject:b];
	}
	
    
    b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]deleteActionImage] 
									  subtitle:@"Remove" 
										 badge:nil];
	if (installed == FALSE)
	{
		[b setButtonEnabled:FALSE];
	}
    [buttons addObject:b];

	
	b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme] moreActionImage] 
									  subtitle:@"More" 
										 badge:nil];
	
    [buttons addObject:b];
    return [buttons autorelease];
    
}

-(void)controller:(SMFMoviePreviewController *)c selectedControl:(BRControl *)ctrl
{
		//	NSLog(@"here: %@", ctrl);
	if ([ctrl respondsToSelector:@selector(subtitle)])
	{
			//NSLog(@"button subtitle: %@", [[ctrl subtitle]string]);
	}	
		if ([ctrl respondsToSelector:@selector(selectedControl)])
		{
				//NSLog(@"selectedControl: %@", [[[ctrl selectedControl]title]string ]);
		}
	
	 
}

@end
