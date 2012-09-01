#import "ntvRssBrowser.h"
#import "NitoTheme.h"
#import "ntvRSSViewer.h"
#import "APDocument.h"
#import "APElement.h"
#import "CPlusFunctions.mm"

@implementation ntvRssBrowser

+ (NSString *) rootMenuLabel
{
	return ( @"nito.rss.root" );
}


- (BOOL)isPlaying {
    return [_parentController isPlaying];
}

- (nitoRss *)currentNitoRss {
    return [[currentNitoRss retain] autorelease];
}



- (void)setCurrentNitoRss:(nitoRss *)value {
    if (currentNitoRss != value) {
        [currentNitoRss release];
        currentNitoRss = [value copy];
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

- (BOOL)rightAction:(long)theRow
{
	NSString *currentKey = nil;
	NSDictionary *currentDict = nil;
	id rssController = nil;
	
	if (theRow+1 == (long)[_names count])
	{
		return NO;
	}
	
	currentKey = [_names objectAtIndex:theRow];
	
	
	if (!currentNitoRss)
		currentNitoRss = [[nitoRss alloc] init];
	currentDict = [_globalDict valueForKey:currentKey];
	[currentNitoRss setTheProps:currentDict];
	
	rssController = [[nitoRssController alloc] initWithRss:currentDict withMode:ntvEditRSSPoint];
	
	[rssController autorelease];
	[rssController setParentController:self];
	[rssController setRssKey:currentKey];
	[rssController setCurrentRow:theRow];
	[[self stack] pushController:rssController];
	return YES;
	
}

- (long) controlCount
{
	
	return ( [_names count] );
	
}

/*
- (BOOL)brEventAction:(id)fp8;

{
	int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	long currentRow;
	int theAction = [fp8 remoteAction];
	NSString *currentKey = nil;
	NSDictionary *currentDict = nil;
	id rssController = nil;
	switch (theAction)
	{
		case kBREventRemoteActionMenu: //Menu
			
			return NO;
			
		case kBREventRemoteActionRight: //right
			
			if (_listState == 1)
				return NO;
			
			currentRow = [self getSelection];
			
						return [self rightAction:currentRow];
			
			break;
			
		case kBREventRemoteActionUp: //up
			
			if([self getSelection] == 0 && (int)[fp8 value] == 1)
			{
				[self setSelection:itemCount-1];
				//[self updatePreviewController];
				return YES;
			}
			return [super brEventAction:fp8];
			
			
			break;
			
		case kBREventRemoteActionDown: //Down
			
			if([self getSelection] == itemCount-1 && (int)[fp8 value] == 1)
			{
				[self setSelection:0];
				//[self updatePreviewController];
				return YES;
			}
			return [super brEventAction:fp8];
			
			
			break;
			
			
			
		default:
			
			[super brEventAction:fp8];
			break;
	}
	return YES;
}
 
 */


- (id)parentController {
	
    return _parentController;
	
}

- (void)setParentController:(id)value {

        _parentController = value;
    
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

- (id) init
{
	
	return ( [self initWithArray:NULL state:0 andTitle:NULL] );
}



- (void)finishRssWithArray:(NSArray *)inputArray withMainTitle:(NSString *)theTitle
{
	id rssController = [[ntvRssBrowser alloc] initWithArray:inputArray state:1 andTitle:theTitle];
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



- (NSArray *) arrayFromRSSFeed : (NSString *)path

{
	//NSLog(@"%@ %s", self, _cmd);
	//NSError *error = nil;
	NSURL *metaURL = [NSURL URLWithString:path];
	//NSString *theString = [NSString stringWithContentsOfURL:metaURL];
	NSString *theString = [NSString stringWithContentsOfURL:metaURL encoding:NSUTF8StringEncoding error:nil];
	APDocument *doc = [APDocument documentWithXMLString:theString];
	//NSLog(@"doc: %@",[doc prettyXML]);
	APElement *rootElt = [[[doc rootElement] childElements] objectAtIndex:0];
	NSMutableArray *fullArray = [[NSMutableArray alloc] init];
		//APElement *val =[rootElt firstChildElementNamed:@"rss"];
	APElement *titleElement = [rootElt firstChildElementNamed:@"title"];
	_mainTitle = [titleElement value];
	NSArray *items = [rootElt childElements:@"item"];
	
//	return nil;

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

	return [fullArray autorelease];
}







- (void)showRssItem:(NSDictionary *)inputDict withMainTitle:(NSString *)mainTitle
{
	
	//NSLog(@"inputDict: %@ main title: %@", inputDict, mainTitle);
	id cons = [[ntvRSSViewer alloc] initWithDictionary:inputDict];
	
	[cons setLabelText:mainTitle];
	[[self stack] pushController:cons];
	[cons release];
	
	
}

- (BOOL)rowSelectable:(long)row
{
	return YES;
}

- (id)globalDict
{
	return _globalDict;
}


- (id) initWithArray: (NSArray *) inputArray state: (int) listState andTitle:(NSString *)theTitle
{
	if ( [super init] == nil )
		return ( nil );
	if ([self respondsToSelector:@selector(setUseCenteredLayout:)])
		[self setUseCenteredLayout:YES];
	
	[_parentController retain];
	[self setListTitle:theTitle];
	_mainTitle = theTitle;

	id sfi = [[NitoTheme sharedTheme] rssImage];
	[self setListIcon:sfi];
	[self setListIconHorizontalOffset:0.25f];
	[self setListIconKerningFactor:0.3f];
	
	
	_names = [[NSMutableArray alloc] init];
	_locations = [[NSMutableArray alloc] init];
	_locationDicts = [[NSMutableArray alloc] init];
		
	_listState = listState;

	NSString *theDest = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
	NSString *rssFile = [theDest stringByAppendingPathComponent:@"com.nito.nitoTV.rss.plist"];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:rssFile])
		rssFile = [[NSBundle bundleForClass:[ntvRssBrowser class]] pathForResource:@"rss" ofType:@"plist"];
	NSDictionary *fullDict = [NSDictionary dictionaryWithContentsOfFile:rssFile];
	_globalDict = [[NSMutableDictionary alloc] initWithDictionary:[fullDict valueForKey:@"Feeds"]];
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

	[[self list] setDatasource:self];
	if (listState == 0)
	{
		long theCount = [self controlCount];
		[[self list] addDividerAtIndex:theCount - 1 withLabel:@"Options"];
	}
	return ( self );
}

- (void) dealloc
{
	//NSLog(@"%@ %s", self, _cmd);

	//
	
	[_locationDicts release];
	
	//[_locations release];
	//[_names release];
	[super dealloc];
}


- (id) controlAtIndex: (long) row requestedBy:(id)fp12
{
	if ( row > (long)[_names count] )
		return ( nil );
	
	//NSLog(@"%@ %s", self, _cmd);
	
	BRMenuItem * result = nil;
	
		NSString *theTitle = [_names objectAtIndex: row];
		
		switch (row){
			
								
			default:
				
				result = [BRMenuItem ntvFolderMenuItem];
				break;
		}
		
				
				
			
	[result setText: theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
	
	return ( result );
}




- (void)reloadRSSFile
{
	NSString *rssFile = [NSBundle userRssFileLocation];
	if ([[NSFileManager defaultManager] fileExistsAtPath:rssFile])
	{
		NSDictionary *fullDict = [NSDictionary dictionaryWithContentsOfFile:rssFile];
		[_globalDict removeAllObjects];
		[_globalDict addEntriesFromDictionary:[fullDict objectForKey:@"Feeds"]];
	}
	
}

- (void)refresh
{
	[self reloadRSSFile];
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
	
	NSArray *sortedArray;
	NSSortDescriptor *nameDescriptor =
	
	[[[NSSortDescriptor alloc] initWithKey:@"name"
	  
								 ascending:YES
	  
								  selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	
	
	
	
	
	NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
	
	sortedArray = [_locationDicts sortedArrayUsingDescriptors:descriptors];
	
	
	
	//NSLog(@"sortedArray: %@", sortedArray);
	
	
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
	[_locations retain];

	
	[_names addObject:BRLocalizedString(@"Add RSS Location", @"Add RSS Location")];
	
	[_locations addObject:@"addnew"];
	
	long theCount = [self controlCount];
	[[self list] addDividerAtIndex:theCount - 1 withLabel:@"Options"];
	[[self list] reload];
	
	//[[self scene] renderScene]; 
}

- (CGRect)listRectWithSize:(CGRect)listFrame inMaster:(CGRect)master inListMode:(int)listState
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
	
	[super layoutSubcontrols];
	CGRect master = [self frame];
	BRListControl *listLayer = [self _getList];
	
	CGRect listFrame = [listLayer frame];
	listFrame = [self listRectWithSize:listFrame inMaster:master inListMode:_listState];
	[listLayer setFrame:listFrame];
	
}

- (void) itemSelected: (long) row
{

	id theLocation = [_locations objectAtIndex:row];
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
				
				
				rssController = [[nitoRssController alloc] initWithRss:tempObject withMode:ntvCreateRSSPoint];
				
				[rssController autorelease];
				[rssController setParentController:self];
				[[self stack] pushController:rssController];
				return;
			}
			
		
			tempObject = [self arrayFromRSSFeed:theLocation];
			
			
			if (tempObject == nil)
				return;
		
			rssController = [[ntvRssBrowser alloc] initWithArray:tempObject state:1 andTitle:_mainTitle];
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



- (BOOL)mediaPreviewShouldShowMetadata
{
	return FALSE;
}



@end
