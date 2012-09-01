#import "nitoRssController.h"
#import "NitoTheme.h"
#import "CPlusFunctions.mm"

@implementation nitoRssController

+ (NSString *) rootMenuLabel
{
	return ( @"nito.rss.root" );
}

- (BOOL)isPlaying {
    return [_parentController isPlaying];
}


- (ntvRssMode)rssMode {
    return rssMode;
}

- (void)setRssMode:(ntvRssMode)value {
 
        rssMode = value;
    
}

- (NSString *)rssKey {
    return rssKey;
}

- (void)setRssKey:(NSString *)value {

	rssKey = value;
    
}





- (id)parentController {
	
    return _parentController;
	
}

- (void)setParentController:(id)value {

        _parentController = value;
    
}

- (id) previewControlForItem: (long) row;
{
	return nil;
	
}

- (id) init
{
	return ( [self initWithRss:NULL withMode:0] );
}

-(void) keyboardActivated:(NSNotification*) notification
{
	NSDictionary* keyboardProps = (NSDictionary*)[notification object];
	NSLog(@"keyboardProps: %@", keyboardProps);
	//	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kRemoteKeyboardEvent object:nil userInfo:keyboardProps deliverImmediately:YES];
}

- (BOOL)rowSelectable:(long)row
{
	return YES;
}

- (id) initWithRss:(NSDictionary *)rssPoint withMode:(ntvRssMode)theMode {
	
	if ( [super init] == nil )
		return ( nil );
	
	if ([self respondsToSelector:@selector(setUseCenteredLayout:)])
		[self setUseCenteredLayout:YES];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardActivated:) name:@"BRRemotePromptUpdateNotification" object:nil];
	[_parentController retain];
	rssMode = theMode;
	
	rssDictionary = [[NSMutableDictionary alloc] initWithDictionary:rssPoint];
	//NSLog(@"%@ %s", self, _cmd);
	
	//_stackPosition = position;
	[self setListTitle: BRLocalizedString(@"RSS Location", @"title of menu for editing/saving rss location points")];
	
	id sp = [[NitoTheme sharedTheme] rssImage];
	[self setListIcon:sp horizontalOffset:0.25 kerningFactor:0.1];

	_things = [[NSMutableArray alloc] init];
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
	

	
	[[self list] setDatasource:self];
	//[[self list] setProvider: self];
[[self list] addDividerAtIndex:2 withLabel:BRLocalizedString(@"Options",@"options in menu divider")];
	
	return ( self );
}

- (void)editTitle
{
	//NSLog(@"dostuff");
}

- (void) dealloc
{
	
	[_things release];

	[super dealloc];
}

- (NSString *)titleForRow:(long)row {
	if(row < (long)[_things count]) {
		return [_things objectAtIndex:row];
	} else {
		return nil;
	}
}

-(float)heightForRow:(long)row {
	return 0.0f;
}

-(id)itemForRow:(long)row {
	return [self controlAtIndex:row requestedBy:nil];
}

- (long)itemCount {
	return [_things count];
}


- (long) controlCount
{

		return ( [_things count] );
	
}

- (id) controlAtIndex: (long) row requestedBy:(id)fp12
{
	if ( row > (long)[_things count] )
		return ( nil );
	
	//NSLog(@"%@ %s", self, _cmd);
	BRMenuItem * result = nil;

	NSDictionary *theDict = rssDictionary;
	NSString *theTitle = [_things objectAtIndex: row];
	//NSString *theString;
	//int auths;
	//NSLog(@"title: %@ row: %f", theTitle, row);
		
		switch (row){
			
			case 0: //location name
				
				result = [BRMenuItem ntvMenuItem];
				[result setRightJustifiedText:[theDict objectForKey:@"name"] withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
				break;
				
			case 1: //location url
				
				result = [BRMenuItem ntvMenuItem];
				[result setRightJustifiedText:[theDict objectForKey:@"location"] withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
					
				break;

			
			
		
		
				
			default:
				
				result = [BRMenuItem ntvMenuItem];
				break;
		}

				
				
			
	[result setText:theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
	
	return ( result );
}

- (long)currentRow {
    return _currentRow;
}

- (void)setCurrentRow:(long)value {
    if (_currentRow != value) {
        _currentRow = value;
    }
}


- (void) textDidChange: (id) sender
{
    // do nothing for now
}

- (void) textDidEndEditing: (id) sender
{
	[[self stack] popController];
	
	switch (_kbType) {
		
		case ntvRssNameKBType:
			
					
					[[self rssDictionary] setValue:[sender stringValue] forKey:@"name"];
					
					//[[self stack] popToController:_parentController];
					[[self list] reload];
					
					//[[_parentController scene] renderScene]; 
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



- (BOOL)brEventAction:(id)fp8;

{
		//int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	//NSLog(@"%@ %s", self, _cmd);
	
	//int theValue = [fp8 value];
	
	//unsigned short theUsage = [fp8 usage];
	
	
	int theAction = [fp8 remoteAction];
	//NSLog(@"action: %@", fp8);
	//(uint32_t)([fp8 page] << 16 | [fp8 usage])
	switch (theAction)
	{
		case kBREventRemoteActionMenu: //Menu
			
			return NO;
			
			
			
			break;
			
		case kBREventRemoteActionUp: //up
			
			//if([self getSelection] == 0 && [fp8 value] == 1)
			//{
			//	[self setSelection:itemCount-1];
				//[self updatePreviewController];
			//	return YES;
			//}
			[super brEventAction:fp8];
			
			
			break;
			
		case kBREventRemoteActionDown: //Down
			
			//if([self getSelection] == itemCount-1 && [fp8 value] == 1)
			//{
			//	[self setSelection:0];
				//[self updatePreviewController];
			//	return YES;
		//	}
			[super brEventAction:fp8];
			
			
			break;
			
		default:
			[super brEventAction:fp8];
			
			break;
	}
	return YES;
}


- (int)getSelection
{
	BRListControl *list = [self list];
	int row;
	NSMethodSignature *signature = [list methodSignatureForSelector:@selector(selection)];
	NSInvocation *selInv = [NSInvocation invocationWithMethodSignature:signature];
	[selInv setSelector:@selector(selection)];
	[selInv invokeWithTarget:list];
	if([signature methodReturnLength] == 8)
	{
		double retDoub = 0;
		[selInv getReturnValue:&retDoub];
		row = retDoub;
	}
	else
		[selInv getReturnValue:&row];
	return row;
}

- (void)setSelection:(int)sel
{
	BRListControl *list = [self list];
	NSMethodSignature *signature = [list methodSignatureForSelector:@selector(setSelection:)];
	NSInvocation *selInv = [NSInvocation invocationWithMethodSignature:signature];
	[selInv setSelector:@selector(setSelection:)];
	if(strcmp([signature getArgumentTypeAtIndex:2], "l"))
	{
		double dvalue = sel;
		[selInv setArgument:&dvalue atIndex:2];
	}
	else
	{
		long lvalue = sel;
		[selInv setArgument:&lvalue atIndex:2];
	}
	[selInv invokeWithTarget:list];
}

- (CGRect)listRectWithSize:(CGRect)listFrame inMaster:(CGRect)master
{
	listFrame.size.height -= 2.5f*listFrame.origin.y;
	listFrame.size.width*=1.5f;
	listFrame.origin.x = (master.size.width - listFrame.size.width) * 0.5f;
	listFrame.origin.y *= 2.0f;
	return listFrame;
}

- (void)layoutSubcontrols
{
	//Shrink the list frame to make room for displaying the filename
	[super layoutSubcontrols];
	CGRect master = [self frame];
	BRListControl *listLayer = [self _getList];
	
	CGRect listFrame = [listLayer frame];
	listFrame = [self listRectWithSize:listFrame inMaster:master];
	[listLayer setFrame:listFrame];
	//[self doMyLayout];
}

- (void) itemSelected: (long) row
{
	NSFileManager *man = [NSFileManager defaultManager];
	//NSDictionary *theDict = rssDictionary;
	id gDict = [(ntvRssBrowser *)_parentController globalDict];
	id theItem = [self controlAtIndex:row requestedBy:nil];
	//int rightValue;
	NSString *rightString;
	NSString *localRss = [NSBundle userRssFileLocation];
	
	
	NSString *rssPath = [NSBundle rssFileLocation];
	
	if (![man fileExistsAtPath:localRss])
		[man copyItemAtPath:rssPath toPath:localRss error:nil];
	NSDictionary *fileDict = [NSDictionary dictionaryWithContentsOfFile:localRss];
	NSMutableDictionary *feedDict = [[NSMutableDictionary alloc] initWithDictionary:[fileDict valueForKey:@"Feeds"]];

	int cRow = [self currentRow];
	NSDictionary *saveDict = nil;
		//int i;
	
	
	BRTextEntryController *controller = nil;
	switch (row) {
		
	case 0: //item rss name
		
		//NSLog(@"int value: %i", rightValue);
		rightString = [theItem rightJustifiedText];
		
		_kbType = ntvRssNameKBType;
		
		controller = [[BRTextEntryController alloc] init];
		[controller setTitle:BRLocalizedString(@"Enter RSS location name", @"title of textentry controller for entering rss location name")];
		[controller setTextEntryTextFieldLabel:BRLocalizedString(@"Name:", @"the text to the left of the text field while entering a rss location name")];
		
		
				[controller setTextFieldDelegate:self];
			
			
		[controller setInitialTextEntryText:rightString];
		[[self stack] pushController: controller];
		
		
	
		
		break;
		
	
	case 1: //url
		
		rightString = [theItem rightJustifiedText];
	
		
		_kbType = ntvRssLocationKBType;
		
		
		
		controller = [[BRTextEntryController alloc] init];
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
				
			[feedDict setValue:[self rssDictionary] forKey:[rssDictionary objectForKey:@"name"]];
		    saveDict = [NSDictionary dictionaryWithObjectsAndKeys:feedDict, @"Feeds", nil];
			[saveDict writeToFile:localRss atomically:YES];
			//[gDict setValue:[self rssDictionary] forKey:[NSString stringWithFormat:@"%i", dictCount]];
			[(ntvRssBrowser *)_parentController refresh];
			[[self stack] popToController:_parentController];
			
			break;
			
		case ntvEditRSSPoint:
			
				if (![[rssDictionary objectForKey:@"name"] isEqualToString:rssKey])
				{
					NSLog(@"remove: %@", rssKey);
					[feedDict removeObjectForKey:rssKey];
				}
				[feedDict setValue:[self rssDictionary] forKey:[rssDictionary objectForKey:@"name"]];
			//[feedDict setValue:[self rssDictionary] forKey:[NSString stringWithFormat:@"%i", rssKey]];
				saveDict = [NSDictionary dictionaryWithObjectsAndKeys:feedDict, @"Feeds", nil];
			[saveDict writeToFile:localRss atomically:YES];
			//[gDict setValue:[self rssDictionary] forKey:[NSString stringWithFormat:@"%i", rssKey]];
			[(ntvRssBrowser *)_parentController refresh];
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
				
				//[feedDict removeObjectForKey:[NSString stringWithFormat:@"%i", rssKey]];
				[feedDict removeObjectForKey:[rssDictionary valueForKey:@"name"]];
				saveDict = [NSDictionary dictionaryWithObjectsAndKeys:feedDict, @"Feeds", nil];
				[saveDict writeToFile:localRss atomically:YES];
				[gDict removeObjectForKey:[NSString stringWithFormat:@"%i", rssKey]];
				[(ntvRssBrowser *)_parentController refresh];
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

- (NSMutableDictionary *)rssDictionary {
    return [[rssDictionary retain] autorelease];
}




@end
