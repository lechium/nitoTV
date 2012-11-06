enum 
{
	ntvCreateWeatherPoint = 0,
	ntvEditWeatherPoint = 1,
	
};
typedef int ntvWeatherMode;
	
	//#import "nitoWeatherController.h"
#import "NitoTheme.h"
	//#import "ntvWeatherManager.h"

/*
 
 NSMutableDictionary	*weatherDictionary;
 id						_parentController;
 NSMutableArray			*_things; //menu items in the main menu
 NSString				*weatherKey;
 
 */

static int		weatherMode;
static long		_currentRow;
static int      _kbType;

static char const * const kNitoWCDictionaryKey = "nWCDictionary";
static char const * const kNitoWCParentControllerKey = "nWCParentController";
static char const * const kNitoWCThingsKey = "nWCThings";
static char const * const kNitoWCWeatherKeyKey = "nWCWeatherKey";


%subclass nitoWeatherController : BRMediaMenuController
	//@implementation nitoWeatherController

	//ivars - > associated objects start

%new - (NSMutableDictionary *)weatherDictionary
{
	return [self associatedValueForKey:(void*)kNitoWCDictionaryKey];
}

%new - (void)setWeatherDictionary:(NSMutableDictionary *)value
{
	[self associateValue:value withKey:(void*)kNitoWCDictionaryKey];
}

%new - (id)parentController
{
	return [self associatedValueForKey:(void*)kNitoWCParentControllerKey];
}

%new - (void)setParentController:(id)value
{
	[self associateValue:value withKey:(void*)kNitoWCParentControllerKey];
}

%new - (NSMutableArray *)things
{
	return [self associatedValueForKey:(void*)kNitoWCThingsKey];
}

%new - (void)setThings:(NSMutableArray *)value
{
	[self associateValue:value withKey:(void*)kNitoWCThingsKey];
}

%new - (NSString *)weatherKey
{
	return [self associatedValueForKey:(void*)kNitoWCWeatherKeyKey];
}

%new - (void)setWeatherKey:(NSString *)value
{
	[self associateValue:value withKey:(void*)kNitoWCWeatherKeyKey];
}

	//ivar - > associated objects end

+ (NSString *) rootMenuLabel
{
	return ( @"nito.weather.root" );
}


- (id) previewControlForItem: (long) row
{
	return nil;
	
}



%new - (BOOL)rowSelectable:(long)row
{
	return YES;
}

%new - (id)initWithWeather:(NSDictionary *)weatherPoint withMode:(int)theMode
{
		self = [self init];
	
	NSLog(@"initWithWeather");
	
	//if ( (%orig == nil) )
//		return ( nil );
	
	weatherMode = theMode;
	//NSLog(@"weather point: %@", weatherPoint);
	id _weatherDictionary = [[NSMutableDictionary alloc] initWithDictionary:weatherPoint];
	
	[self setListTitle: BRLocalizedString(@"Weather Location", @"title of menu for editing/saving weather location points")];
	
	id sp = [[NitoTheme sharedTheme] weatherImage];
	[self setListIcon:sp horizontalOffset:0.25 kerningFactor:0.1];

	id _things = [[NSMutableArray alloc] init];
	[_things addObject: BRLocalizedString(@"Weather Name", @"the name of the weather location point as its displayed in the weather menu")];
	[_things addObject: BRLocalizedString(@"Weather Location", @"the zip code/location id of the weather location point")];
	[_things addObject: BRLocalizedString(@"Units", @"celcius / fahrenheit of weather point")];
	
	
	
	
	switch(weatherMode){
		
		case ntvEditWeatherPoint:
			
			[_things addObject: BRLocalizedString(@"View Weather", @"the menu item responsible for viewing weather location")];
			[_things addObject: BRLocalizedString(@"Save Changes", @"the menu item to save changes to a weather location")];
			[_things addObject: BRLocalizedString(@"Remove Weather Location", @"the menu item to remove the current weather location")];
			break;
		
		case ntvCreateWeatherPoint:
			
			[_things addObject: BRLocalizedString(@"View Weather", @"the menu item responsible for viewing weather location")];
			[_things addObject: BRLocalizedString(@"Save Weather Location", @"the menu item to save a new weather location to the weather.plist file")];
			//[_things addObject:@"Discard Changes"];
			break;
	}
	

	
	[[self list] setDatasource:self];
	//[[self list] setProvider: self];
	[[self list] addDividerAtIndex:3 withLabel:@"Options"];
	[self setThings:_things];
	[self setWeatherDictionary:_weatherDictionary];
	NSLog(@"down here somewhereS?");
	return ( self );
}

- (void)editTitle
{
	//NSLog(@"dostuff");
}

/*
- (void) dealloc
{
	
	[_things release];

	[super dealloc];
}
 
 */

%new - (NSString *)titleForRow:(long)row {
	if(row < [[self things] count]) {
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
	if ( row > [[self things] count] )
		return ( nil );
	
	Class brti = objc_getClass("BRThemeInfo");
	
	id result = [%c(nitoMenuItem) ntvMenuItem];
	
	NSDictionary *theDict = [self weatherDictionary];
	NSString *theTitle = [[self things] objectAtIndex: row];
	NSString *theString;

		switch (row){
			
			case 0: //location name
				
			
				[result setRightJustifiedText:[theDict objectForKey:@"name"] withAttributes:[[brti sharedTheme] menuItemSmallTextAttributes]]; 
				break;
				
			case 1: //location id/zip
				
				
				[result setRightJustifiedText:[theDict objectForKey:@"location"] withAttributes:[[brti sharedTheme] menuItemSmallTextAttributes]];
					
				break;
				
			case 2: //location units
				
				theString = [theDict objectForKey:@"units"];
				//result = [BRTextMenuItemLayer menuItem];
				if ([[theString lowercaseString] isEqualToString:@"c"])
					[result setRightJustifiedText:@"Celcius" withAttributes:[[brti sharedTheme] menuItemSmallTextAttributes]];
				else if ([[theString lowercaseString] isEqualToString:@"f"])
					[result setRightJustifiedText:@"Fahrenheit" withAttributes:[[brti sharedTheme] menuItemSmallTextAttributes]];
				
				
				break;
			
			
		
		
				
			default:
				
				//result = [BRTextMenuItemLayer menuItem];
				break;
		}

				
	[result setText:theTitle withAttributes:[[brti sharedTheme] menuItemTextAttributes]];			
			
	//[result setTitle: theTitle];
	
	
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
		
		case ntvWeatherNameKBType:
			
					
					[[self weatherDictionary] setValue:[sender stringValue] forKey:@"name"];
					[[self list] reload];
					break;
					
				case ntvChainMode:
					
					
					break;
					
			
			
			break;
			
		case ntvWeatherLocationKBType:
			
			
					[[self weatherDictionary] setValue:[sender stringValue] forKey:@"location"];
				
					[[self list] reload];
			
			break;
	}

}



%new - (int)getSelection
{
	id list = [self list];
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


%new - (void)setSelection:(int)sel
{
	id list = [self list];
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


- (void) itemSelected: (long) row
{
	NSFileManager *man = [NSFileManager defaultManager];
	NSDictionary *theDict = [self weatherDictionary];
	
	id theItem = [self controlAtIndex:row requestedBy:nil];
	
	NSString *rightString;

	NSString *localWeather = [NSBundle userWeatherFileLocation];

	NSString *weatherPath = [NSBundle weatherFileLocation];
	
	if (![man fileExistsAtPath:localWeather])
		[man copyItemAtPath:weatherPath toPath:localWeather error:nil];
		
			
	NSMutableDictionary *fileDict = [NSMutableDictionary dictionaryWithContentsOfFile:localWeather];
	long cRow = (long)[self currentRow];
	//id currentObject = [fileDict objectForKey:theName];

	
	id controller = nil;

	switch (row) {
		
	case 0: //item weather name
		
		//NSLog(@"int value: %i", rightValue);
		rightString = [theItem rightJustifiedText];
		
		_kbType = ntvWeatherNameKBType;
		
		controller = [[%c(BRTextEntryController) alloc] init];
		[controller setTitle:BRLocalizedString(@"Enter weather location name", @"title of textentry controller for entering weather location name")];
		[controller setTextEntryTextFieldLabel:BRLocalizedString(@"Name:", @"the text to the left of the text field while entering a weather location name")];
	
			[controller setTextFieldDelegate:self];
	
		[controller setInitialTextEntryText:rightString];
		[ROOT_STACK pushController: controller];
		
		
		
		break;
		
	
	case 1: //weather zip code / location id
		
	
		rightString = [theItem rightJustifiedText];

		
		_kbType = ntvWeatherLocationKBType;
	
		controller = [[%c(BRTextEntryController) alloc] init];
		[controller setTitle:BRLocalizedString(@"Enter zip code or location ID", @"title of textentry controller for entering weather zip code or location id")];
		[controller setTextEntryTextFieldLabel:BRLocalizedString(@"ID:", @"the text to the left of the text field while entering a weather location name")];
			
				[controller setTextFieldDelegate:self];
			
		[controller setInitialTextEntryText:rightString];
		[ROOT_STACK pushController: controller];
		
		
		break;
		
	case 2: //weather units
		
		rightString = [theItem rightJustifiedText];
			if ([[rightString lowercaseString] isEqualToString:@"celcius"])
		{
			[theDict setValue:@"f" forKey:@"units"];
		} else if ([[rightString lowercaseString] isEqualToString:@"fahrenheit"])
		{
			[theDict setValue:@"c" forKey:@"units"];
			
		}
			
			[[self list] reload];
		//[[self scene] renderScene];
		break;
	
	case 3: //view weather
		
		[[self stack] popToController:[self parentController]];
		[[self parentController] itemSelected:cRow];
		
		break;
		
  case 4: //Save weather location
		
		switch (weatherMode) {
			
		case ntvCreateWeatherPoint:
			
			
				
			[fileDict setValue:theDict forKey:[theDict objectForKey:@"name"]];
			[fileDict writeToFile:localWeather atomically:YES];
			//[gDict setValue:[self weatherDictionary] forKey:[NSString stringWithFormat:@"%i", dictCount]];
			[[self parentController] refresh];
			[[self stack] popToController:[self parentController]];
			
			break;
			
		case ntvEditWeatherPoint:
			
				
				if (![[theDict objectForKey:@"name"] isEqualToString:[self weatherKey]])
				{
					NSLog(@"remove: %@", [self weatherKey]);
					[fileDict removeObjectForKey:[self weatherKey]];
				}
			[fileDict setValue:theDict forKey:[theDict objectForKey:@"name"]];
			[fileDict writeToFile:localWeather atomically:YES];
			//[gDict setValue:[self weatherDictionary] forKey:[NSString stringWithFormat:@"%i", weatherKey]];
			[[self parentController] refresh];
			[[self stack] popToController:[self parentController]];
			break;
			
		default:
			break;
		}
		
		
	
		
		break;
		
	case 5: //delete volume
		
		switch (weatherMode) {
			
			case ntvCreateWeatherPoint:
				
			
				break;
				
			case ntvEditWeatherPoint:
				
				[fileDict removeObjectForKey:[theDict valueForKey:@"name"]];
				//[fileDict setValue:[self weatherDictionary] forKey:[NSString stringWithFormat:@"%i", weatherKey]];
				[fileDict writeToFile:localWeather atomically:YES];
				//[gDict removeObjectForKey:[NSString stringWithFormat:@"%i", weatherKey]];
				[[self parentController] refresh];
				[[self stack] popToController:[self parentController]];
				break;
				
			default:
				break;
		}
		
				
		break;
		
	default:
		break;
	}
	
}


%end

	//@end
