#import "nitoWeatherController.h"
#import "NitoTheme.h"
#import "ntvWeatherManager.h"

@implementation nitoWeatherController

+ (NSString *) rootMenuLabel
{
	return ( @"nito.weather.root" );
}


- (ntvWeatherMode)weatherMode {
    return weatherMode;
}

- (void)setWeatherMode:(ntvWeatherMode)value {
 
        weatherMode = value;
    
}

- (NSString *)weatherKey {
    return weatherKey;
}

- (void)setWeatherKey:(NSString *)value {

        weatherKey = value;
    
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
	return ( [self initWithWeather:NULL withMode:0] );
}


- (BOOL)rowSelectable:(long)row
{
	return YES;
}

- (id) initWithWeather:(NSDictionary *)weatherPoint withMode:(ntvWeatherMode)theMode {
	
	if ( [super init] == nil )
		return ( nil );
	[_parentController retain];
	weatherMode = theMode;
	//NSLog(@"weather point: %@", weatherPoint);
	weatherDictionary = [[NSMutableDictionary alloc] initWithDictionary:weatherPoint];

	[self setListTitle: BRLocalizedString(@"Weather Location", @"title of menu for editing/saving weather location points")];
	
	id sp = [[NitoTheme sharedTheme] weatherImage];
	[self setListIcon:sp horizontalOffset:0.25 kerningFactor:0.1];

	_things = [[NSMutableArray alloc] init];
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
	if(row < [_things count]) {
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
	if ( row > [_things count] )
		return ( nil );
	
	
	BRMenuItem *result = [BRMenuItem ntvMenuItem];
	
	NSDictionary *theDict = weatherDictionary;
	NSString *theTitle = [_things objectAtIndex: row];
	NSString *theString;

		switch (row){
			
			case 0: //location name
				
			
				[result setRightJustifiedText:[theDict objectForKey:@"name"] withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]]; 
				break;
				
			case 1: //location id/zip
				
				
				[result setRightJustifiedText:[theDict objectForKey:@"location"] withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
					
				break;
				
			case 2: //location units
				
				theString = [theDict objectForKey:@"units"];
				//result = [BRTextMenuItemLayer menuItem];
				if ([[theString lowercaseString] isEqualToString:@"c"])
					[result setRightJustifiedText:@"Celcius" withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
				else if ([[theString lowercaseString] isEqualToString:@"f"])
					[result setRightJustifiedText:@"Fahrenheit" withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
				
				
				break;
			
			
		
		
				
			default:
				
				//result = [BRTextMenuItemLayer menuItem];
				break;
		}

				
	[result setText:theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];			
			
	//[result setTitle: theTitle];
	
	
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
		
		case ntvWeatherNameKBType:
			
					
					[[self weatherDictionary] setValue:[sender stringValue] forKey:@"name"];
					
					//[[self stack] popToController:_parentController];
					[[self list] reload];
					
					//[[_parentController scene] renderScene]; 
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


- (void) itemSelected: (long) row
{
	NSFileManager *man = [NSFileManager defaultManager];
	NSDictionary *theDict = weatherDictionary;
	//NSString *theName = [weatherDictionary objectForKey:@"name"];
	//NSString *currentUnit = [theDict valueForKey:@"units"];
	//id gDict = [_parentController globalDict];
	id theItem = [self controlAtIndex:row requestedBy:nil];
	
	NSString *rightString;

	NSString *localWeather = [NSBundle userWeatherFileLocation];

	NSString *weatherPath = [NSBundle weatherFileLocation];
	
	if (![man fileExistsAtPath:localWeather])
		[man copyItemAtPath:weatherPath toPath:localWeather error:nil];
		
			
	NSMutableDictionary *fileDict = [NSMutableDictionary dictionaryWithContentsOfFile:localWeather];
	int cRow = [self currentRow];
	//id currentObject = [fileDict objectForKey:theName];

	
	BRTextEntryController *controller = nil;

	switch (row) {
		
	case 0: //item weather name
		
		//NSLog(@"int value: %i", rightValue);
		rightString = [theItem rightJustifiedText];
		
		_kbType = ntvWeatherNameKBType;
		
		controller = [[BRTextEntryController alloc] init];
		[controller setTitle:BRLocalizedString(@"Enter weather location name", @"title of textentry controller for entering weather location name")];
		[controller setTextEntryTextFieldLabel:BRLocalizedString(@"Name:", @"the text to the left of the text field while entering a weather location name")];
	
			[controller setTextFieldDelegate:self];
	
		[controller setInitialTextEntryText:rightString];
		[[self stack] pushController: controller];
		
		
		
		break;
		
	
	case 1: //weather zip code / location id
		
	
		rightString = [theItem rightJustifiedText];

		
		_kbType = ntvWeatherLocationKBType;
	
		controller = [[BRTextEntryController alloc] init];
		[controller setTitle:BRLocalizedString(@"Enter zip code or location ID", @"title of textentry controller for entering weather zip code or location id")];
		[controller setTextEntryTextFieldLabel:BRLocalizedString(@"ID:", @"the text to the left of the text field while entering a weather location name")];
			
				[controller setTextFieldDelegate:self];
			
		[controller setInitialTextEntryText:rightString];
		[[self stack] pushController: controller];
		
		
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
		
		[[self stack] popToController:_parentController];
		[_parentController itemSelected:cRow];
		
		break;
		
  case 4: //Save weather location
		
		switch (weatherMode) {
			
		case ntvCreateWeatherPoint:
			
			
				
			[fileDict setValue:[self weatherDictionary] forKey:[weatherDictionary objectForKey:@"name"]];
			[fileDict writeToFile:localWeather atomically:YES];
			//[gDict setValue:[self weatherDictionary] forKey:[NSString stringWithFormat:@"%i", dictCount]];
			[(ntvWeatherManager *)_parentController refresh];
			[[self stack] popToController:_parentController];
			
			break;
			
		case ntvEditWeatherPoint:
			
				
				if (![[weatherDictionary objectForKey:@"name"] isEqualToString:weatherKey])
				{
					NSLog(@"remove: %@", weatherKey);
					[fileDict removeObjectForKey:weatherKey];
				}
			[fileDict setValue:[self weatherDictionary] forKey:[weatherDictionary objectForKey:@"name"]];
			[fileDict writeToFile:localWeather atomically:YES];
			//[gDict setValue:[self weatherDictionary] forKey:[NSString stringWithFormat:@"%i", weatherKey]];
			[_parentController refresh];
			[[self stack] popToController:_parentController];
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
				
				[fileDict removeObjectForKey:[weatherDictionary valueForKey:@"name"]];
				//[fileDict setValue:[self weatherDictionary] forKey:[NSString stringWithFormat:@"%i", weatherKey]];
				[fileDict writeToFile:localWeather atomically:YES];
				//[gDict removeObjectForKey:[NSString stringWithFormat:@"%i", weatherKey]];
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
	
}

- (NSMutableDictionary *)weatherDictionary {
    return [[weatherDictionary retain] autorelease];
}




@end
