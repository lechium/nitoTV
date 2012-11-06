//
//  nitoInstalledPackageManager.m
//  nitoTV
//
//  Created by kevin bradley on 9/23/11.
//  Copyright 2011 nito LLC. All rights reserved.
//

/*
#import "nitoInstalledPackageManager.h"

#import "ntvMedia.h"
#import "ntvMediaPreview.h"
#import "PackageDataSource.h"
#import "nitoMoreMenu.h"
*/

#import "packageManagement.h"

static char const * const kNitoIPMInstalledListKey = "nIMPinstalledList";
static char const * const kNitoIPMSelectedObjectKey = "nIMPSelectedObject"; //doesnt appear to ever be used


%subclass nitoInstalledPackageManager : nitoMediaMenuController
	//@implementation nitoInstalledPackageManager

	//@synthesize installedList, selectedObject;

%new - (NSArray *)installedList
{
	return [self associatedValueForKey:(void*)kNitoIPMInstalledListKey];
}

%new - (void)setInstalledList:(NSArray *)theInstalledList
{
	[self associateValue:theInstalledList withKey:(void*)kNitoIPMInstalledListKey];
}

%new - (void)_populateData
{
	[[self list] removeDividers];
	[[self names] removeAllObjects];
	id _installedList = [packageManagement parsedPackageArray];
	[self setInstalledList:_installedList];
	for (NSDictionary *item in _installedList)
	{
		[[self names] addObject:[self getTitleFromPackage:item]];
	}
	[[self list] reload];
}

%new - (NSString *)getTitleFromPackage:(NSDictionary *)packageDict
{
	if ([[packageDict allKeys] containsObject:@"Name"])
		return [packageDict valueForKey:@"Name"];
	
	return [packageDict valueForKey:@"Package"];
}

-(id)initWithTitle:(NSString *)theTitle
{
	self = %orig;
	
	[self _populateData];
	return ( self );
}

- (id)previewControlForItem:(long)item
{
	
	id currentAsset = [[objc_getClass("ntvMedia") alloc] init];
	
	id installedList = [self installedList];
	
	id currentPackage = [installedList objectAtIndex:item];
	
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
	if ([[[installedList objectAtIndex:item] allKeys] containsObject:@"Description"])
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
	if ([[[installedList objectAtIndex:item] allKeys] containsObject:@"Section"])
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

- (void)itemSelected:(long)selected
{
	id installedList = [self installedList];
	NSString *selectedPackage = [[installedList objectAtIndex:selected] valueForKey:@"Package"];
	[self setSelectedObject:selectedPackage];
		//selectedObject = selectedPackage;
	id pds = [[objc_getClass("PackageDataSource") alloc] initWithPackageInfo:[installedList objectAtIndex:selected]];
	[pds setDatasource:pds];
	[pds setDelegate:self];
	[pds setCurrentPackageMode:kPKGInstalledListMode];
	[pds updateButtons];
	[ROOT_STACK pushController:pds];
	[pds release];
}

- (void)dealloc
{
		//[installedList release];
		//installedList = nil;
		//[selectedObject release];
		//selectedObject = nil;
	%orig;
}

#pragma delegate functions


%new -(void)controller:(id)c selectedControl:(BRControl *)ctrl
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
			//selectedObject = packageName;
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
					NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_selectedObject, @"Package", selectedButton, @"Sender", nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveDialog" object:nil userInfo:userInfo];
				} else {
						
					[self showProtectedAlert:_selectedObject];
					PLAY_FAIL_SOUND;
					return;
				}
				
			} else {
				PLAY_FAIL_SOUND;
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


%end
	//@end
