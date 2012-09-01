//
//  nitoManageMenu.m
//  nitoTV
//
//  Created by kevin bradley on 9/23/11.
//  Copyright 2011 nito, LLC. All rights reserved.
//

#import "nitoManageMenu.h"
#import "nitoInstalledPackageManager.h"
#import "nitoSourceController.h"
#import "packageManagement.h"
#import "ntvMedia.h"
#import "ntvMediaPreview.h"
#import "ntvSettingsArrayController.h"
#import "nitoMoreMenu.h"

@implementation nitoManageMenu

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

- (void)_populateData
{
	[_names addObject:BRLocalizedString(@"Packages", @"Packages")];
	[_names addObject:BRLocalizedString(@"Sources", @"Sources")];
		//[_names addObject:BRLocalizedString(@"Sections", @"Sections")];
	
		//View or remove packages you previously installed.
		//List current sources and add custom ones you may know.
}

- (id)initWithTitle:(NSString *)theTitle
{
	self = [super initWithTitle:theTitle];
	
	[self _populateData];
	
	return ( self );
}

-(void)itemSelected:(long)selected
{
	id controller = nil;
	id data = nil;
	
	switch (selected) {
			
		case 0: //Packages
			
				controller = [[nitoInstalledPackageManager alloc] initWithTitle:BRLocalizedString(@"Installed", @"Title of the menu where you browse all of your installed packages")];
			
			
			break;
			
		case 1: //Sources
			
			data = [packageManagement repoReleaseDictionaries];
			
			controller = [[nitoSourceController alloc] initWithTitle:BRLocalizedString(@"Manage Sources", @"Manage Sources") andSources:data];
			
			break;
			
		case 2: //Sections
			
			controller = [[ntvSettingsArrayController alloc] initWithTitle:BRLocalizedString(@"Sections", @"Sections title") withType:kNTVSectionArray];
			
			break;
	}
	
	[[self stack] pushController:controller];
	[controller release];
}




- (id)previewControlForItem:(long)item
{
	
	NSString *description = nil;
	id image = nil;
	ntvMedia *currentAsset = [[ntvMedia alloc] init];
	[currentAsset setTitle:[_names objectAtIndex:item]];
	
	switch (item) {
			
		case 0:
			
			description = BRLocalizedString(@"View or remove packages you previously installed.", @"View or remove packages you previously installed.");
			image = [[NitoTheme sharedTheme] packageImage];
			
			break;
			
		case 1:
			
			description = BRLocalizedString(@"List current sources and add custom ones you may know.", @"List current sources and add custom ones you may know.");
			image = [[NitoTheme sharedTheme] sharePointImage];
			
			break;
			
			
		case 2:
			
			description = BRLocalizedString(@"Manage the sections that are listed when browsing sources.", @"Manage the sections that are listed when browsing sources.");
			image = [[NitoTheme sharedTheme] packageImage];
			
			break;
	
	}

	[currentAsset setCoverArt:image];

	
	NSMutableArray *customKeys = [[NSMutableArray alloc] init];
	NSMutableArray *customObjects = [[NSMutableArray alloc] init];

	if(description != nil)
	{
		[currentAsset setSummary:description];
	}

	
	[currentAsset setCustomKeys:[customKeys autorelease] 
					 forObjects:[customObjects autorelease]];
	
	
	ntvMediaPreview *preview = [[ntvMediaPreview alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	return [preview autorelease];
}

@end
