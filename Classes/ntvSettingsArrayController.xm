	//#import "ntvSettingsArrayController.h"
#import "packageManagement.h"


static int _currentType;
static int _kbType;
static int _currentRow;

%subclass ntvSettingsArrayController : nitoMediaMenuController

	//@implementation ntvSettingsArrayController

- (id) init
{
	return ( [self initWithTitle:@"Title" withType:kNTVSectionArray] );
}

%new - (id)itemForRow:(long)row {
	
	id result = [%c(nitoMenuItem) ntvMenuItem];
	NSString *theTitle = [[self names] objectAtIndex:row];
	[result setText:theTitle withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemTextAttributes]];
	[result setRightJustifiedText:@"ON" withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemSmallTextAttributes]];
	return result;
}


%new - (id) initWithTitle:(NSString *)theTitle withType:(int)sType
{
	self = %orig;
	
	_currentType = sType;
	
	switch(sType)
	{
		case kNTVSectionArray:
			
			[[self names] addObjectsFromArray:[packageManagement fullSectionList]];
			break;
			
	}
	
	return ( self );
}

- (id) previewControlForItem: (long) item
{
	return nil;
	id previewCon = [[%c(BRImageAndSyncingPreviewController) alloc] init];
	[previewCon setImage:[[NitoTheme sharedTheme] packageImage]];
	return [previewCon autorelease];
	
}


%new - (void) textDidChange: (id) sender
{
		// do nothing for now
}

%new - (void) textDidEndEditing: (id) sender
{
	switch (_kbType)
	{
		default:
			
				//nothing here for now, till we actually have arrays we want to add objects to
			break;
			
			
	}
	[[self stack] popController];
}	

%new - (void) itemSelected: (long) row
{
	
	/*
	 // may or may not end up using this, just commented out for now to reduce warnings
	 id controller = nil;
	 int currentCount = [self controlCount];
	 currentCount--;
	 //NSLog(@"row: %i currentCount: %i", row, currentCount);
	 */
	
	NSString *selectedName = [[self names] objectAtIndex:row];
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
	%orig;
}




%end
	//@end
