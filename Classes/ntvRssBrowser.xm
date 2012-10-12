
#import "NitoTheme.h"
#import "APDocument.h"
#import "APElement.h"
#import "nitoRss.h"

static int _listState;

static char const * const kNitoRBParentControllerKey = "nRBParentController";
static char const * const kNitoRBLocationsKey = "nRBLocations";
static char const * const kNitoRBLocationDictsKey = "nRBLocationDicts";
static char const * const kNitoRBGlobalDictKey = "nRBGlobalDict";
static char const * const kNitoRBMaintTitleKey = "nRBMaintTitle";
static char const * const kNitoRBCurrentNitoRssKey = "nRBCurrentNitoRss";

@interface ntvRssBrowser : NSObject

- (CGRect)listRectWithSize:(CGRect)listFrame inMaster:(CGRect)master inListMode:(int)listState;
- (CGRect)frame;
@end


%subclass ntvRssBrowser : nitoMediaMenuController

%new - (id)parentController
{
	return [self associatedValueForKey:(void*)kNitoRBParentControllerKey];
}

%new - (void)setParentController:(id)value
{
	[self associateValue:value withKey:(void*)kNitoRBParentControllerKey];
}

%new - (NSMutableArray *)locations
{
	return [self associatedValueForKey:(void*)kNitoRBLocationsKey];
}

%new - (void)setLocations:(NSMutableArray *)value
{
	[self associateValue:value withKey:(void*)kNitoRBLocationsKey];
}

%new - (NSMutableArray *)locationDicts
{
	return [self associatedValueForKey:(void*)kNitoRBLocationDictsKey];
}

%new -(void)setLocationDicts:(NSMutableArray *)value
{
	[self associateValue:value withKey:(void*)kNitoRBLocationDictsKey];
}

%new - (NSMutableDictionary *)globalDict
{
	return [self associatedValueForKey:(void*)kNitoRBGlobalDictKey];
}

%new - (void)setGlobalDict:(NSMutableDictionary *)value
{
	[self associateValue:value withKey:(void*)kNitoRBGlobalDictKey];
}


/*
 

 id	_parentController;
 NSMutableArray	    	*_locations;
 NSMutableArray         *_locationDicts;
 NSMutableDictionary	*_globalDict;
 int					_listState;
 NSString				*_mainTitle;
 nitoRss			    *currentNitoRss;
 
 */


%new + (NSString *) rootMenuLabel
{
	return ( @"nito.rss.root" );
}

%new - (NSString *)mainTitle
{
	return [ self associatedValueForKey:(void*)kNitoRBMaintTitleKey];
}

%new - (void)setMainTitle:(NSString *)value
{
	[self associateValue:value withKey:(void*)kNitoRBMaintTitleKey];
}

%new - (nitoRss *)currentNitoRss {
    return [self associatedValueForKey:(void*)kNitoRBCurrentNitoRssKey];
}



%new - (void)setCurrentNitoRss:(nitoRss *)value {
    [self associateValue:value withKey:(void*)kNitoRBCurrentNitoRssKey];
}


- (BOOL)rightAction:(long)theRow
{
	NSString *currentKey = nil;
	NSDictionary *currentDict = nil;
	id rssController = nil;
	
	if (theRow+1 == (long)[[self names] count])
	{
		return NO;
	}
	
	currentKey = [[self names] objectAtIndex:theRow];
	
	
	id _currentNitoRss = [self currentNitoRss];
	if (!_currentNitoRss)
	{
		_currentNitoRss = [[nitoRss alloc] init];
	}

	currentDict = [[self globalDict] valueForKey:currentKey];
	[_currentNitoRss setTheProps:currentDict];
	
	rssController = [[%c(nitoRssController) alloc] initWithRss:currentDict withMode:1];
	
	[rssController autorelease];
	[rssController setParentController:self];
	[rssController setRssKey:currentKey];
	[rssController setCurrentRow:theRow];
	[[self stack] pushController:rssController];
	return YES;
	
}

%new - (long) controlCount
{
	
	return ( [[self names] count] );
	
}



- (id) previewControlForItem: (long) item
{

		return nil;
	//if (_listState == 0)
//		return nil;
//	id currentLocation = [_locations objectAtIndex:item];
//	NSString *description = [currentLocation valueForKey:@"description"];
//	if (description == nil)
//		return nil;
//	NSAttributedString *theAttrString = [[NSAttributedString alloc] initWithHTML:[NSData dataWithBytes:[description UTF8String] length:[description length]] documentAttributes:nil];
//	//NSLog(@"beforeWrapper: %@", theAttrString);
//	id theWrapper = [[[theAttrString allAttachments] objectAtIndex:0] fileWrapper];
//	//NSLog(@"after wrapper");
//	BRImage  * myImage = [BRImage imageWithData:[theWrapper regularFileContents]];
//
//	BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
//	
//					  
//	[obj setImage:myImage];
//	return obj;
}

//- (id) init
//{
//	
//	return ( [self initWithArray:NULL state:0 andTitle:NULL] );
//}



%new - (void)finishRssWithArray:(NSArray *)inputArray withMainTitle:(NSString *)theTitle
{
	id rssController = [[%c(ntvRssBrowser) alloc] initWithArray:inputArray state:1 andTitle:theTitle];
	//NSLog(@"inputArray: %@", inputArray);
	[[self stack] pushController:rssController];
	[rssController autorelease];
}

//
//- (NSString *)flattenHTML:(NSString *)html {
//	
//    NSScanner *theScanner;
//    NSString *text = nil;
//	
//    theScanner = [NSScanner scannerWithString:html];
//	
//    while ([theScanner isAtEnd] == NO) {
//		
//        // find start of tag
//        [theScanner scanUpToString:@"<" intoString:NULL] ; 
//		
//        // find end of tag
//        [theScanner scanUpToString:@">" intoString:&text] ;
//		
//        // replace the found tag with a space
//        //(you can filter multi-spaces out later if you wish)
//        html = [html stringByReplacingOccurrencesOfString:[ NSString stringWithFormat:@"%@>", text] withString:@" "];
//		
//    } // while //
//    
//    return html;
//	
//}



%new - (NSArray *) arrayFromRSSFeed : (NSString *)path

{
		//NSLog(@"path: %@", path);
	//NSLog(@"%@ %s", self, _cmd);
	//NSError *error = nil;
	NSURL *metaURL = [NSURL URLWithString:path];
	
		//NSString *theString = [NSString stringWithContentsOfURL:metaURL encoding:NSUTF8StringEncoding error:nil];
	NSString *theString = [[NSString alloc ] initWithContentsOfURL:metaURL encoding:NSUTF8StringEncoding error:nil];
		//NSLog(@"theString: %@", theString);
	APDocument *doc = [APDocument documentWithXMLString:theString];
		//NSLog(@"doc: %@",[doc prettyXML]);
	APElement *rootElt = [[[doc rootElement] childElements] objectAtIndex:0];
	NSMutableArray *fullArray = [[NSMutableArray alloc] init];
		//APElement *val =[rootElt firstChildElementNamed:@"rss"];
	APElement *titleElement = [rootElt firstChildElementNamed:@"title"];
	[self setMainTitle:[titleElement value]];
		// = [titleElement value];
	NSArray *items = [rootElt childElements:@"item"];
	

	if([items count] > 0) {
			int i;
			for (i = 0; i < (int)[items count]; i++)
			{
				NSMutableDictionary *feedDict = [[NSMutableDictionary alloc] init];
				
				
				
				APElement *feed = [items objectAtIndex:i];
			
				
				//title;
				
				
				APElement *titleElement = [feed firstChildElementNamed:@"title"];
				NSString *cleanString = [[titleElement value] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				NSMutableString *newString = [[NSMutableString alloc] initWithString:cleanString];
				[newString replaceOccurrencesOfString:@"amp;" withString:@"" options:nil range:NSMakeRange(0, [newString length])];
				//newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				[feedDict setObject:newString forKey:@"title"];
				[newString release];
				
				
				//description
				
				APElement *descElement = [feed firstChildElementNamed:@"description"];
				
				NSString *descString = [descElement value];
				
				descString = [descString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				NSString *theString = [NSString	flattenHTML:descString];
			
				[feedDict setObject:theString forKey:@"description"];
				
				
				//pubDate
				
				APElement *dateElement = [feed firstChildElementNamed:@"pubDate"];
				
				if (dateElement != nil)
				{
					NSString *dateString = [dateElement value];
					
					dateString = [dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					
					[feedDict setObject:dateString forKey:@"pubDate"];
				}
				
				
				
	
				//link
				
				APElement *linkElement = [feed firstChildElementNamed:@"link"];
				
				NSString *linkString = [linkElement value];
				
				linkString = [linkString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				[feedDict setObject:linkString forKey:@"link"];
				
//				
//				//origLink
//				
//				APElement *origLink = [feed firstChildElementNamed:"feedburner:origLink"];
//				
//				NSString *origString = [origLink value];
//				
//				origString = [origString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//				
//				[feedDict setObject:origString forKey:@"mediaURL"];
//							
				
				[fullArray addObject:feedDict];
				[feedDict release];
				feedDict = nil;
			}
		//NSLog(@"fullArray: %@", fullArray);
		
	} else {
		//NSLog(@"Media node not found, invalid XML file.");
	}

	[theString release];
	return [fullArray autorelease];
}







%new - (void)showRssItem:(NSDictionary *)inputDict withMainTitle:(NSString *)mainTitle
{
	
	//NSLog(@"inputDict: %@ main title: %@", inputDict, mainTitle);
	id cons = [[objc_getClass("ntvRSSViewer") alloc] initWithDictionary:inputDict];
		//NSLog(@"cons: %@", cons);
	[cons setLabelText:mainTitle];
	[[self stack] pushController:cons];
	[cons release];
	
	
}

%new - (BOOL)rowSelectable:(long)row
{
	return YES;
}



%new - (id) initWithArray: (NSArray *) inputArray state: (int) listState andTitle:(NSString *)theTitle
{
	if ( [self init] == nil )
		return ( nil );
	if ([self respondsToSelector:@selector(setUseCenteredLayout:)])
		[self setUseCenteredLayout:YES];
	
	
	[self setListTitle:theTitle];
	[self setMainTitle:theTitle];
	
	id sfi = [[NitoTheme sharedTheme] rssImage];
	[self setListIcon:sfi];
	[self setListIconHorizontalOffset:0.25f];
	[self setListIconKerningFactor:0.3f];
	
	
	id _names = [[NSMutableArray alloc] init];
	id _locations = [[NSMutableArray alloc] init];
	id _locationDicts = [[NSMutableArray alloc] init];
		
	_listState = listState;

	NSString *theDest = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
	NSString *rssFile = [theDest stringByAppendingPathComponent:@"com.nito.nitoTV.rss.plist"];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:rssFile])
		rssFile = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"rss" ofType:@"plist"];
	NSDictionary *fullDict = [NSDictionary dictionaryWithContentsOfFile:rssFile];
	id _globalDict = [[NSMutableDictionary alloc] initWithDictionary:[fullDict valueForKey:@"Feeds"]];
	int feedCount = [[_globalDict allKeys] count];
	int i;
	NSString *currentName = nil;
	id currentItem = nil;
	NSString *currentKey = nil;
	NSString *currentLocale = nil;
	NSArray *sortedArray;
	NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES
	selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
	
	//NSLog(@"sortedArray: %@", sortedArray);
	
	
	int k;
	
	
	switch (listState)
	{
		case 0: // initial list
			
			for (i = 0; i < feedCount; i++)
			{
				NSDictionary *dict;
				
				currentKey = [[_globalDict allKeys] objectAtIndex:i];
				currentItem = [_globalDict valueForKey:currentKey];
				//NSLog(@"currentItem: %@", currentItem);
				currentName = [currentItem valueForKey:@"name"];
				currentLocale = [currentItem valueForKey:@"location"];
				dict = [NSDictionary dictionaryWithObjectsAndKeys:currentName, @"name", currentLocale, @"location", currentKey, @"key", nil];
				[_locationDicts addObject:dict];
				
			}
			
			sortedArray = [_locationDicts sortedArrayUsingDescriptors:descriptors];
			for (k = 0; k < (int)[sortedArray count]; k++)
			{
				currentItem = [sortedArray objectAtIndex:k];
				//NSLog(@"currentItem: %@", currentItem);
				
				currentName = [currentItem valueForKey:@"name"];
				currentLocale = [currentItem valueForKey:@"location"];
				currentKey = [currentItem valueForKey:@"key"];
				[_names addObject:currentName];
				[_locations addObject:currentLocale];
				
			}
			[_names addObject:BRLocalizedString(@"Add RSS Location", @"Add RSS Location")];
			
			[_locations addObject:@"addnew"];
			break;
			
		case 1: //list from array
			
			for (i = 0; i < (int)[inputArray count]; i++)
			{
				currentItem = [inputArray objectAtIndex:i];
				currentName = [currentItem valueForKey:@"title"];
				[_names addObject:currentName];
				[_locations addObject:currentItem];
			}
			break;
	}

	[self setNames:_names];
	[self setLocations:_locations];
	[self setLocationDicts:_locationDicts];
	[self setGlobalDict:_globalDict];
	[[self list] setDatasource:self];
	if (listState == 0)
	{
		long theCount = (long)[self controlCount];
		[[self list] addDividerAtIndex:theCount - 1 withLabel:@"Options"];
	}
	return ( self );
}

//- (void) dealloc
//{
//	//NSLog(@"%@ %s", self, _cmd);
//
//	//
//	
//	[_locationDicts release];
//	
//	//[_locations release];
//	//[_names release];
//	[super dealloc];
//}


%new - (id) controlAtIndex: (long) row requestedBy:(id)fp12
{
	if ( row > (long)[[self names] count] )
		return ( nil );
	
	//NSLog(@"%@ %s", self, _cmd);
	
	id result = nil;
	
		NSString *theTitle = [[self names] objectAtIndex: row];
		
		switch (row){
			
								
			default:
				
				result = [%c(nitoMenuItem) ntvFolderMenuItem];
				break;
		}
		
				
				
			
	[result setText: theTitle withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemTextAttributes]];
	
	
	return ( result );
}




%new - (void)reloadRSSFile
{
	NSString *rssFile = [NSBundle userRssFileLocation];
	if ([[NSFileManager defaultManager] fileExistsAtPath:rssFile])
	{
		NSDictionary *fullDict = [NSDictionary dictionaryWithContentsOfFile:rssFile];
		[[self globalDict] removeAllObjects];
		[[self globalDict] addEntriesFromDictionary:[fullDict objectForKey:@"Feeds"]];
	}
	
}

%new - (void)refresh
{
	[self reloadRSSFile];
	
	id _names = [self names];
	id _locations = [self locations];
	id _locationDicts = [self locationDicts];
	id _globalDict = [self globalDict];
	
	[_names removeAllObjects];
	[_locations removeAllObjects];
	[_locationDicts removeAllObjects];
	[[self list] removeDividers];
	
	
	
	int feedCount = [[_globalDict allKeys] count];
	int i;
	NSString *currentName = nil;
	id currentItem = nil;
	NSString *currentKey = nil;
	NSString *currentLocale = nil;
	
	
	for (i = 0; i < feedCount; i++)
	{
		NSDictionary *dict;
		currentKey = [[_globalDict allKeys] objectAtIndex:i];
		currentItem = [_globalDict valueForKey:currentKey];
		//NSLog(@"currentItem: %@", currentItem);
		currentName = [currentItem valueForKey:@"name"];
		currentLocale = [currentItem valueForKey:@"location"];
		dict = [NSDictionary dictionaryWithObjectsAndKeys:currentName, @"name", currentLocale, @"location", currentKey, @"key", nil];
	
		[_locationDicts addObject:dict];
	}
	
	NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" 
																	ascending:YES 
																	 selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	
	NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];

	NSArray *sortedArray = [_locationDicts sortedArrayUsingDescriptors:descriptors];
	
	int k;
	
	for (k = 0; k < (int)[sortedArray count]; k++)
	{
		currentItem = [sortedArray objectAtIndex:k];
		//NSLog(@"currentItem: %@", currentItem);
		currentName = [currentItem valueForKey:@"name"];
		currentLocale = [currentItem valueForKey:@"location"];
		currentKey = [currentItem valueForKey:@"key"];
		[_names addObject:currentName];
		[_locations addObject:currentLocale];
		
	}
	
	[_names addObject:BRLocalizedString(@"Add RSS Location", @"Add RSS Location")];
	
	[_locations addObject:@"addnew"];
	
	long theCount = (long)[self controlCount];
	[[self list] addDividerAtIndex:theCount - 1 withLabel:@"Options"];
	[[self list] reload];
	
}

%new - (CGRect)listRectWithSize:(CGRect)listFrame inMaster:(CGRect)master inListMode:(int)listState
{
	listFrame.size.height -= 2.5f*listFrame.origin.y;
	if (listState == 0)
		listFrame.size.width*=1.5f;
	else
		listFrame.size.width*=2.0f;
	
	listFrame.origin.x = (master.size.width - listFrame.size.width) * 0.5f;
	listFrame.origin.y *= 2.0f;
	//NSLog(@"listFrame: %@", NSStringFromRect(listFrame));
	return listFrame;
}

- (void)layoutSubcontrols
{
	
	%orig;
	CGRect master = [self frame];
	id listLayer = [self list];
	
	CGRect listFrame = [listLayer frame];
	listFrame = [self listRectWithSize:listFrame inMaster:master inListMode:_listState];
	[listLayer setFrame:listFrame];
	
}

- (void) itemSelected: (long) row
{

	id theLocation = [[self locations] objectAtIndex:row];
	id tempObject = nil;
	id rssController = nil;
	//NSLog(@"location: %@", theLocation);
	switch (_listState)
	{
		case 0: //init
			if ([theLocation isEqualToString:@"addnew"])
			{
				// do stuff
				tempObject = [NSDictionary dictionaryWithObjectsAndKeys:@"New Location", @"name", @"http://", @"location", nil];
				
				
				rssController = [[%c(nitoRssController) alloc] initWithRss:tempObject withMode:ntvCreateRSSPoint];
				
				[rssController autorelease];
				[rssController setParentController:self];
				[[self stack] pushController:rssController];
				return;
			}
			
		
			tempObject = [self arrayFromRSSFeed:theLocation];
			
				//NSLog(@"tempObject: %@", tempObject);
			
			
			if (tempObject == nil)
				return;
		
			rssController = [[%c(ntvRssBrowser) alloc] initWithArray:tempObject state:1 andTitle:[self mainTitle]];
			NSLog(@"rssController: %@", rssController);
			//NSLog(@"inputArray: %@", inputArray);
			[[self stack] pushController:rssController];
			[rssController release];
			//NSLog(@"connecting to feed: %@", theLocation);
			break;
			
		case 1: // show rss feed
			//NSLog(@"before show rss item: %@", _mainTitle);
			[self showRssItem:theLocation withMainTitle:[self listTitle]];
			break;
	}

	
}



%new - (BOOL)mediaPreviewShouldShowMetadata
{
	return FALSE;
}


%end