//
//  nitoInstalledPackageManager.m
//  nitoTV
//
//  Created by kevin bradley on 9/23/11.
//  Copyright 2011 nito LLC. All rights reserved.
//

#import "nitoInstalledPackageManager.h"
#import "packageManagement.h"
#import "ntvMedia.h"
#import "ntvMediaPreview.h"
#import "PackageDataSource.h"
#import "nitoMoreMenu.h"

@implementation nitoInstalledPackageManager

@synthesize installedList, selectedObject;

- (void)_populateData
{
	[[self list] removeDividers];
	[_names removeAllObjects];
	self.installedList = [packageManagement parsedPackageArray];
	for (NSDictionary *item in self.installedList)
	{
		[_names addObject:[self getTitleFromPackage:item]];
	}
	[[self list] reload];
}

- (NSString *)getTitleFromPackage:(NSDictionary *)packageDict
{
	if ([[packageDict allKeys] containsObject:@"Name"])
		return [packageDict valueForKey:@"Name"];
	
	return [packageDict valueForKey:@"Package"];
}

-(id)initWithTitle:(NSString *)theTitle
{
	self = [super initWithTitle:theTitle];
	
	[self _populateData];
	return ( self );
}

- (id)previewControlForItem:(long)item
{
	
	ntvMedia *currentAsset = [[ntvMedia alloc] init];
	
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
	
	
	ntvMediaPreview *preview = [[ntvMediaPreview alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	return [preview autorelease];
	
	
}

- (void)itemSelected:(long)selected
{
	NSString *selectedPackage = [[installedList objectAtIndex:selected] valueForKey:@"Package"];
	selectedObject = selectedPackage;
	PackageDataSource *pds = [[PackageDataSource alloc] initWithPackageInfo:[installedList objectAtIndex:selected]];
	[pds setDatasource:pds];
	[pds setDelegate:self];
	[pds setCurrentMode:kPKGInstalledListMode];
	[[self stack] pushController:pds];
	[pds release];
}

- (void)dealloc
{
	[installedList release];
	installedList = nil;
	[selectedObject release];
	selectedObject = nil;
	[super dealloc];
}

#pragma delegate functions


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
					NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:selectedObject, @"Package", selectedButton, @"Sender", nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveDialog" object:nil userInfo:userInfo];
				} else {
						
					[self showProtectedAlert:selectedObject];
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


@end
