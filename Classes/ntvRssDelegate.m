
#import "ntvRssDelegate.h"
#import "ntvRssBrowser.h"
#import <BackRow/BackRow.h>

@interface ntvRssDelegate (Private)

@end

@implementation ntvRssDelegate

- (id) initWithParentController: (id) theParent;
{
    if ( [super init] == nil )
        return ( nil );


	_itemArray = [[NSMutableArray alloc] init];
	_currentDict = nil;
	_currentString = [[NSMutableString alloc] init];
    _parentController = [theParent retain];

    return ( self );
}

- (void) dealloc
{

    [_filePath release];


    [super dealloc];
}

- (void) weakLinkToParser: (NSXMLParser *) parser
{
    _parser = parser;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{

	if ([_itemArray count] > 0)
	{
		//NSLog(@"maintitle: %@, item list: %@", _mainTitle, _itemArray);
		[(ntvRssBrowser*)_parentController finishRssWithArray:_itemArray withMainTitle:_mainTitle];
		//[_parent rssTest:[_itemArray objectAtIndex:0] withMainTitle:_mainTitle];
	}
	
	
}

- (void)parser:(id)fp8 foundCharacters:(id)fp12
{
	//NSLog(@"%@ %s", self, _cmd);
	NSString *newString = [fp12 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	
	if((![newString isEqualToString:@""]) && (![newString isEqualToString:@"\n"]) && (![newString isEqualToString:@" "]))
	{
		if ([_currentElement isEqualToString:@"feedburner:origLink"])
		{
			NSArray *sArray = [newString componentsSeparatedByString:@"#"];
			//NSLog(@"feedburner:origLink: %@", [sArray objectAtIndex:0]);
			[_currentDict setValue:[sArray objectAtIndex:0] forKey:@"mediaURL"];
		}
		if ([_currentElement isEqualToString:@"title"])
		{
			if (_currentDict == nil)
			{
				_mainTitle = newString;
			} else {
				[_currentString appendString:newString];
			}
			
		}
		
		if ([_currentElement isEqualToString:@"link"])
		{
			[_currentDict setValue:newString forKey:_currentElement];
		}
		
		if ([_currentElement isEqualToString:@"pubDate"])
		{
			[_currentDict setValue:newString forKey:@"pubDate"];
		}
		
		if ([_currentElement isEqualToString:@"description"])
		{
			
			//NSLog(@"theattrstring: %@", theAttrString);
			[_currentString appendString:newString];
		}
	
		//NSLog(newString);
		//NSLog(@"setObject: %@ forKey: %@", newString, _currentElement);
	}

	
}


- (void)parser:(id)fp8 didStartElement:(id)fp12 namespaceURI:(id)fp16 qualifiedName:(id)fp20 attributes:(id)fp24
{
	//NSLog(@"didstart: %@", fp12);
	NSString *theElement = fp12;
	
	if ([theElement isEqualToString:@"item"])
	{
		if (_currentDict == nil)
			_currentDict = [[NSMutableDictionary alloc] init];
	}
	
	if ([theElement isEqualToString:@"title"])
	{
		
		_currentString = nil;
		_currentString = [[NSMutableString alloc] init];
	}
	
	if ([theElement isEqualToString:@"description"])
	{
		_currentString = nil;
		_currentString = [[NSMutableString alloc] init];
	}
	

	
	//NSLog(@"_currentElement: %@", _currentElement);
	//if(_currentElement == nil)
	_currentElement = fp12;
	[_currentElement retain];
}

- (void)parser:(id)fp8 didEndElement:(id)fp12 namespaceURI:(id)fp16 qualifiedName:(id)fp20
{
	
	if ([fp12 isEqualToString:@"title"]){
		
		if (_currentDict != nil)
		{
			[_currentDict setValue:_currentString forKey:@"title"];
		} 
	}
	
	if ([fp12 isEqualToString:@"description"]){
		
		//NSAttributedString *theAttrString = [[NSAttributedString alloc] initWithHTML:[NSData dataWithBytes:[_currentString cString] length:[_currentString length]] documentAttributes:nil];
		//NSString *theString = [theAttrString string];
		//NSLog(@"string: %@", theString);
		[_currentDict setValue:_currentString forKey:@"description"];
	}
		if ([fp12 isEqualToString:@"item"]){
		
			if ([[_currentDict allKeys] count] > 0){
				NSDictionary *theDict = [NSDictionary dictionaryWithDictionary:_currentDict];
				[_itemArray addObject:theDict];
				//NSLog(@"adding: %@", _currentDict);
				[_currentDict removeAllObjects];

			}
}
			
	
	//NSLog(@"%@ %s", self, _cmd);
	_currentElement = nil;
	
}





@end

@implementation ntvRssDelegate (Private)


@end
