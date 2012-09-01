#import "ntvSettingsArrayController.h"
#import "packageManagement.h"

@implementation ntvSettingsArrayController

- (id) init
{
	return ( [self initWithTitle:@"Title" withType:kNTVSectionArray] );
}

- (id)itemForRow:(long)row {
	
	BRMenuItem * result = [BRMenuItem ntvMenuItem];
	NSString *theTitle = [_names objectAtIndex:row];
	[result setText:theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	[result setRightJustifiedText:@"ON" withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
	return result;
}


- (id) initWithTitle:(NSString *)theTitle withType:(int)sType
{
	self = [super initWithTitle:theTitle];
	
	_currentType = sType;
	
	switch(sType)
	{
		case kNTVSectionArray:
			
			[_names addObjectsFromArray:[packageManagement fullSectionList]];
			break;
			
	}
	
	return ( self );
}

- (id) previewControlForItem: (long) item
{
	BRImageAndSyncingPreviewController *previewCon = [[BRImageAndSyncingPreviewController alloc] init];
	[previewCon setImage:[[NitoTheme sharedTheme] packageImage]];
	return [previewCon autorelease];
	
}


- (void) textDidChange: (id) sender
{
		// do nothing for now
}

- (void) textDidEndEditing: (id) sender
{
	switch (_kbType)
	{
		default:
			
				//nothing here for now, till we actually have arrays we want to add objects to
			break;
			
			
	}
	[[self stack] popController];
}	

- (void) itemSelected: (long) row
{
	
	/*
	 // may or may not end up using this, just commented out for now to reduce warnings
	 id controller = nil;
	 int currentCount = [self controlCount];
	 currentCount--;
	 //NSLog(@"row: %i currentCount: %i", row, currentCount);
	 */
	
	NSString *selectedName = [_names objectAtIndex:row];
	_currentRow = row;
	
	switch(_currentType)
	{
		case kNTVSectionArray:
			
			NSLog(@"enable/disable item: %@", selectedName);
			
			break;
	}
	
}


- (void) dealloc
{
	[super dealloc];
}



/*
 
 deprecated for now, from old nitotv, if you dont end up using, clean it out later
 
 - (void)editArgument:(NSString *)theSuffix forMode:(int)theMode atIndex:(int)theIndex
 {
 
 NSMutableArray *argArray = [[NSMutableArray alloc] init];
 
 NSArray *blacklistVolumes = nil;
 NSArray *mpArgs = nil;
 
 
 [_names replaceObjectAtIndex:theIndex withObject:theSuffix];
 
 switch (theMode)
 {
 case kntvBlacklistArray:
 
 [argArray addObjectsFromArray:blacklistVolumes];
 [argArray replaceObjectAtIndex:theIndex withObject:theSuffix];
 [nitoTVAppliance setArray:argArray forKey:@"blackList"];
 //[[RUIPreferenceManager sharedPreferences] setObject:argArray forKey:@"blackList" forDomain:@"com.apple.frontrow.appliance.nitoTV" sync:YES];
 [[self list] reload];
 //[[self scene] renderScene];
 break;
 
 case kntvMPArgumentsArray:
 
 [argArray addObjectsFromArray:mpArgs];
 [argArray replaceObjectAtIndex:theIndex withObject:theSuffix];
 [nitoTVAppliance setArray:argArray forKey:@"mpArgs"];
 //[[RUIPreferenceManager sharedPreferences] setObject:argArray forKey:@"mpArgs" forDomain:@"com.apple.frontrow.appliance.nitoTV" sync:YES];
 [[self list] reload];
 //[[self scene] renderScene];
 break;
 
 
 
 
 }
 [argArray release];
 }
 
 - (void)addArgument:(NSString *)theSuffix forMode:(int)theMode
 {
 //NSLog(@"%@ %s", self, _cmd);
 NSMutableArray *argArray = [[NSMutableArray alloc] init];
 
 NSArray *blacklistVolumes = [nitoTVAppliance arrayForKey:@"blackList"];
 
 NSArray *mpArgs = [nitoTVAppliance arrayForKey:@"mpArgs"];
 int theCount = [self controlCount];
 theCount = theCount--;
 [_names insertObject:theSuffix atIndex:theCount];
 [_names retain];
 [[self list] removeDividers];
 [[self list] addDividerAtIndex:[_names count]-1 withLabel:@""];
 
 switch (theMode)
 {
 case kntvBlacklistArray:
 
 [argArray addObjectsFromArray:blacklistVolumes];
 [argArray addObject:theSuffix];
 [nitoTVAppliance setArray:argArray forKey:@"blackList"];
 //[[RUIPreferenceManager sharedPreferences] setObject:argArray forKey:@"blackList" forDomain:@"com.apple.frontrow.appliance.nitoTV" sync:YES];
 
 [[self list] reload];
 //[[self scene] renderScene];
 //[argArray release];
 break;
 
 case kntvMPArgumentsArray:
 
 [argArray addObjectsFromArray:mpArgs];
 [argArray addObject:theSuffix];
 [nitoTVAppliance setArray:argArray forKey:@"mpArgs"];
 
 //[[RUIPreferenceManager sharedPreferences] setObject:argArray forKey:@"mpArgs" forDomain:@"com.apple.frontrow.appliance.nitoTV" sync:YES];
 [[self list] reload];
 //[argArray release];
 //[[self scene] renderScene];
 break;
 
 
 
 
 }
 
 }
 */


@end
