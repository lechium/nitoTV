	//#import "nitoRssController.h"
#import "NitoTheme.h"
	//#import "CPlusFunctions.mm"


typedef int ntvRssMode;

#define SHARED_THEME [%c(BRThemeInfo) sharedTheme]

/*
 
 NSMutableDictionary	*rssDictionary;
 id						_parentController;
 NSMutableArray			*_things; //menu items in the main menu
 NSString				*rssKey;
 
 */

static int rssMode;
static int _kbType;
static long _currentRow;

static char const * const kNitoRCRssKey = "nRCRSSKey";
static char const * const kNitoRCRssDictionaryKey = "nRCRSSDictionary";
static char const * const kNitoRCThingsKey = "nRCRSSThings";
static char const * const kNitoRCParentControllerKey = "nRCParentController";


%subclass nitoRssController : BRMediaMenuController

	//@implementation nitoRssController

%new - (NSMutableDictionary *)rssDictionary
{
	return [self associatedValueForKey:(void *)kNitoRCRssDictionaryKey];
}

%new - (void)setRssDictionary:(NSMutableDictionary *)value
{
	[self associateValue:value withKey:(void *)kNitoRCRssDictionaryKey];
}

%new + (NSString *) rootMenuLabel
{
	return ( @"nito.rss.root" );
}


%new - (int)rssMode {
    return rssMode;
}

%new - (void)setRssMode:(int)value {
 
        rssMode = value;
    
}

%new - (NSString *)rssKey {
    return [self associatedValueForKey:(void*)kNitoRCRssKey];
}

%new - (void)setRssKey:(NSString *)value {

	[self associateValue:value withKey:(void*)kNitoRCRssKey];
    
}


%new - (id)parentController {
	
    return [self associatedValueForKey:(void*)kNitoRCParentControllerKey];
	
}

%new - (void)setParentController:(id)value {

	[self associateValue:value withKey:(void*)kNitoRCParentControllerKey];
    
}

%new - (NSMutableArray *)things
{
	return [self associatedValueForKey:(void*)kNitoRCThingsKey];
}

%new - (void)setThings:(NSMutableArray *)value
{
	[self associateValue:value withKey:(void*)kNitoRCThingsKey];
}

- (id) previewControlForItem: (long) row
{
	return nil;
	
}


%new -(void) keyboardActivated:(NSNotification*) notification
{
	NSDictionary* keyboardProps = (NSDictionary*)[notification object];
	NSLog(@"keyboardProps: %@", keyboardProps);
	//	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kRemoteKeyboardEvent object:nil userInfo:keyboardProps deliverImmediately:YES];
}

%new - (BOOL)rowSelectable:(long)row
{
	return YES;
}

%new - (id) initWithRss:(NSDictionary *)rssPoint withMode:(int)theMode {
	
	if ( [self init] == nil )
		return ( nil );
	
	if ([self respondsToSelector:@selector(setUseCenteredLayout:)])
		[self setUseCenteredLayout:YES];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardActivated:) name:@"BRRemotePromptUpdateNotification" object:nil];
	
	rssMode = theMode;
	
	id _rssDictionary = [[NSMutableDictionary alloc] initWithDictionary:rssPoint];

	
	[self setListTitle: BRLocalizedString(@"RSS Location", @"title of menu for editing/saving rss location points")];
	
	id sp = [[NitoTheme sharedTheme] rssImage];
	[self setListIcon:sp horizontalOffset:0.25 kerningFactor:0.1];

	id _things = [[NSMutableArray alloc] init];
	[_things addObject: BRLocalizedString(@"RSS Name", @"the name of the rss location point as its displayed in the weather menu")];
	[_things addObject: BRLocalizedString(@"RSS Location", @"the url of the rss location point")];
	
	
	
	
	switch(rssMode){
		
		case ntvEditRSSPoint:
			
			[_things addObject: BRLocalizedString(@"View Feed", @"the menu item responsible for viewing rss location")];
			[_things addObject: BRLocalizedString(@"Save Changes", @"the menu item to save changes to a rss location")];
			[_things addObject: BRLocalizedString(@"Remove RSS Location", @"the menu item to remove the current rss location")];
			break;
		
		case ntvCreateRSSPoint:
			
			[_things addObject: BRLocalizedString(@"View Feed", @"the menu item responsible for viewing rss location")];
			[_things addObject: BRLocalizedString(@"Save RSS Location", @"the menu item to save a new rss location to the rss.plist file")];
			//[_things addObject:@"Discard Changes"];
			break;
	}
	

	[self setThings:_things];
	[self setRssDictionary:_rssDictionary];
	
	[[self list] setDatasource:self];

	[[self list] addDividerAtIndex:2 withLabel:BRLocalizedString(@"Options",@"options in menu divider")];
	
	return ( self );
}

%new - (void)editTitle
{
	//NSLog(@"dostuff");
}

//- (void) dealloc
//{
//	
//	[_things release];
//
//	[super dealloc];
//}

%new - (NSString *)titleForRow:(long)row {
	if(row < (long)[[self things] count]) {
		return [[self things] objectAtIndex:row];
	} else {
		return nil;
	}
}

%new -(float)heightForRow:(long)row {
	return 0.0f;
}

%new -(id)itemForRow:(long)row {
	return [self controlAtIndex:row requestedBy:nil];
}

- (long)itemCount {
	return [[self things] count];
}


%new - (long) controlCount
{

		return ( [[self things] count] );
	
}

%new - (id) controlAtIndex: (long) row requestedBy:(id)fp12
{
	if ( row > (long)[[self things] count] )
		return ( nil );
	
	//NSLog(@"%@ %s", self, _cmd);
	id  result = nil;

	NSDictionary *theDict = [self rssDictionary];
	NSString *theTitle = [[self things] objectAtIndex: row];

		switch (row){
			
			case 0: //location name
				
				result = [%c(nitoMenuItem) ntvMenuItem];
				[result setRightJustifiedText:[theDict objectForKey:@"name"] withAttributes:[SHARED_THEME menuItemSmallTextAttributes]];
				break;
				
			case 1: //location url
				
				result = [%c(nitoMenuItem)  ntvMenuItem];
				[result setRightJustifiedText:[theDict objectForKey:@"location"] withAttributes:[SHARED_THEME menuItemSmallTextAttributes]];
					
				break;

			
			
		
		
				
			default:
				
				result = [%c(nitoMenuItem)  ntvMenuItem];
				break;
		}

				
				
			
	[result setText:theTitle withAttributes:[SHARED_THEME menuItemTextAttributes]];
	
	
	return ( result );
}

%new - (long)currentRow {
    return _currentRow;
}

%new - (void)setCurrentRow:(long)value {
 
	_currentRow = value;
}


%new - (void) textDidChange: (id) sender
{
    // do nothing for now
}

%new - (void) textDidEndEditing: (id) sender
{
	[[self stack] popController];
	
	switch (_kbType) {
		
		case ntvRssNameKBType:
			
					
					[[self rssDictionary] setValue:[sender stringValue] forKey:@"name"];
					[[self list] reload];
					break;
					
				case ntvChainMode:
					
					
					break;
					
			
			
			break;
			
		case ntvRssLocationKBType:
			
			
					[[self rssDictionary] setValue:[sender stringValue] forKey:@"location"];
				
					[[self list] reload];
					
				
					
			
			
			break;
	}
}



- (BOOL)brEventAction:(id)fp8

{

	int theAction = (int)[fp8 remoteAction];

	switch (theAction)
	{
		case kBREventRemoteActionMenu: //Menu
			
			return NO;
			
		default:
			%orig;
			
			break;
	}
	return YES;
}


//%new - (CGRect)listRectWithSize:(CGRect)listFrame inMaster:(CGRect)master
//{
//	listFrame.size.height -= 2.5f*listFrame.origin.y;
//	listFrame.size.width*=1.5f;
//	listFrame.origin.x = (master.size.width - listFrame.size.width) * 0.5f;
//	listFrame.origin.y *= 2.0f;
//	return listFrame;
//}
//
//%new - (id)_getList
//{
//	return MSHookIvar<id>(self, "_list");
//}
//
//- (void)layoutSubcontrols
//{
//	//Shrink the list frame to make room for displaying the filename
//	%orig;
//	CGRect master = [self frame];
//	id listLayer = [self list];
//	
//	CGRect listFrame = [listLayer frame];
//	listFrame = [self listRectWithSize:listFrame inMaster:master];
//	[listLayer setFrame:listFrame];
//	//[self doMyLayout];
//}

- (void) itemSelected: (long) row
{
	NSFileManager *man = [NSFileManager defaultManager];
	id _parentController = [self parentController];
	id gDict = [_parentController globalDict];
	id theItem = [self controlAtIndex:row requestedBy:nil];
	id _rssDictionary = [self rssDictionary];
	NSString *rightString;
	NSString *localRss = [NSBundle userRssFileLocation];
	NSString *rssPath = [NSBundle rssFileLocation];
	
	if (![man fileExistsAtPath:localRss])
		[man copyItemAtPath:rssPath toPath:localRss error:nil];
	NSDictionary *fileDict = [NSDictionary dictionaryWithContentsOfFile:localRss];
	NSMutableDictionary *feedDict = [[NSMutableDictionary alloc] initWithDictionary:[fileDict valueForKey:@"Feeds"]];

	long cRow = (long)[self currentRow];
	NSDictionary *saveDict = nil;
	id controller = nil;
	switch (row) {
		
	case 0: //item rss name
		
		//NSLog(@"int value: %i", rightValue);
		rightString = [theItem rightJustifiedText];
		
		_kbType = ntvRssNameKBType;
		
		controller = [[%c(BRTextEntryController) alloc] init];
		[controller setTitle:BRLocalizedString(@"Enter RSS location name", @"title of textentry controller for entering rss location name")];
		[controller setTextEntryTextFieldLabel:BRLocalizedString(@"Name:", @"the text to the left of the text field while entering a rss location name")];
		[controller setTextFieldDelegate:self];
		[controller setInitialTextEntryText:rightString];
		[[self stack] pushController: controller];
		break;
		
	
	case 1: //url
		
		rightString = [theItem rightJustifiedText];
	
		
		_kbType = ntvRssLocationKBType;
		controller = [[%c(BRTextEntryController) alloc] init];
		[controller setTitle:BRLocalizedString(@"Enter RSS feed URL", @"title of textentry controller for entering RSS url")];
		[controller setTextEntryTextFieldLabel:BRLocalizedString(@"URL:", @"the text to the left of the text field while entering a RSS url")];
		[controller setTextFieldDelegate:self];
		[controller setInitialTextEntryText:rightString];
		[[self stack] pushController: controller];
		break;
		
		
	case 2: //view rss
		
		[[self stack] popToController:_parentController];
		[_parentController itemSelected:cRow];
		
		
		break;
		
  case 3: //Save rss location
		
		switch (rssMode) {
			
		case ntvCreateRSSPoint:
				
			[feedDict setValue:_rssDictionary forKey:[_rssDictionary objectForKey:@"name"]];
		    saveDict = [NSDictionary dictionaryWithObjectsAndKeys:feedDict, @"Feeds", nil];
			[saveDict writeToFile:localRss atomically:YES];
			[_parentController refresh];
			[[self stack] popToController:_parentController];
			
			break;
			
		case ntvEditRSSPoint:
			
				if (![[_rssDictionary objectForKey:@"name"] isEqualToString:[self rssKey]])
				{
					NSLog(@"remove: %@", [self rssKey]);
					[feedDict removeObjectForKey:[self rssKey]];
				}
			[feedDict setValue:_rssDictionary forKey:[_rssDictionary objectForKey:@"name"]];
			saveDict = [NSDictionary dictionaryWithObjectsAndKeys:feedDict, @"Feeds", nil];
			[saveDict writeToFile:localRss atomically:YES];
			[_parentController refresh];
			[[self stack] popToController:_parentController];
			break;
			
		default:
			break;
		}
		
		
	
		
		break;
		
	case 4: //delete volume
		
		switch (rssMode) {
			
			case ntvCreateRSSPoint:
				
				break;
				
			case ntvEditRSSPoint:
				
				//[feedDict removeObjectForKey:[NSString stringWithFormat:@"%i", [self rssKey]]];
				[feedDict removeObjectForKey:[_rssDictionary valueForKey:@"name"]];
				saveDict = [NSDictionary dictionaryWithObjectsAndKeys:feedDict, @"Feeds", nil];
				[saveDict writeToFile:localRss atomically:YES];
				[gDict removeObjectForKey:[NSString stringWithFormat:@"%i", [self rssKey]]];
				[_parentController refresh];
				[[self stack] popToController:_parentController];
				break;
				
			default:
				break;
		}
		
		
		break;
		
	default:
		break;
	}
	[feedDict release];
}



%end
	//@end
