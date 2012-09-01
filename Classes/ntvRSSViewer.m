//
//  ntvRSSViewer.m
//  maintenance
//
//  Created by Kevin Bradley on 7/11/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//
#define ITEM_BUFFER 20.0f
#define ICON_TOP_OFFSET 1.75f //higher numbers = lower
#define TEXT_TOP_OFFSET 1.403f
#define PRIMARY_LEFT_OFFSET .3648 //lower = more to the left

#import "ntvRSSViewer.h"
#import "APDocument.h"

@implementation ntvRSSViewer

- (id) initWithDictionary:(NSDictionary *)inputDict
{
    if ( [super init] == nil )
        return ( nil );
	
    rssDict = inputDict;
	
	[rssDict retain];
	
    return ( self );
}

- (NSString *)labelText {
    return [[_labelText retain] autorelease];
}

- (void)setLabelText:(NSString *)value {
    if (_labelText != value) {
        [_labelText release];
        _labelText = [value copy];
    }
}






- (BOOL)brEventAction:(BREvent *)fp8;

{
	//ushort theUsage = [fp8 usage];
	int theAction = [fp8 remoteAction];
	//NSLog(@"theUsage: %i", theUsage);
	switch (theAction)
	{
		case kBREventRemoteActionMenu: //Menu
			
			return NO;
			
		case kBREventRemoteActionRight: //right
			
			if ([[self pageTwo] length] > 0)
			{
				[_secondInfoText setText:[self pageTwo] withAttributes:[[BRThemeInfo sharedTheme] promptTextAttributes]];
				[_nextPageImage setValue:[NSNumber numberWithFloat:0] forKeyPath:@"opacity"];
				[_previousPageImage setValue:[NSNumber numberWithFloat:1] forKeyPath:@"opacity"];
				[_labelTextControl setValue:[NSNumber numberWithFloat:1] forKeyPath:@"opacity"];
			}
			
			break;
			
		case kBREventRemoteActionLeft: //left
			
			if ([[self pageOne] length] > 0)
			{
				[_secondInfoText setText:[self pageOne] withAttributes:[[BRThemeInfo sharedTheme] promptTextAttributes]];
				[_nextPageImage setValue:[NSNumber numberWithFloat:1] forKeyPath:@"opacity"];
				[_previousPageImage setValue:[NSNumber numberWithFloat:0] forKeyPath:@"opacity"];
				[_labelTextControl setValue:[NSNumber numberWithFloat:0] forKeyPath:@"opacity"];
			}
				
			
			break;
			
		default:
			[super brEventAction:fp8];
			
			break;
	}
	return YES;
}

- (void)dealloc
{
	[_secondInfoText release];
	[_previousPageImage release];
	[_nextPageImage release];
	[_labelTextControl release];
	[super dealloc];
}

- (NSString *)pageOne {
    return [[pageOne retain] autorelease];
}

- (void)setPageOne:(NSString *)value {
    if (pageOne != value) {
        [pageOne release];
        pageOne = [value copy];
    }
}

- (NSString *)pageTwo {
    return [[pageTwo retain] autorelease];
}

- (void)setPageTwo:(NSString *)value {
    if (pageTwo != value) {
        [pageTwo release];
        pageTwo = [value copy];
    }
}



- (void)drawSelf
{
	
	

	float previousPageAlpha = 0;
	float nextPageAlpha = 0;
	float labelTextAlpha = 1;
	CGRect master = [self frame];
	_theTitle = [rssDict valueForKey:@"title"];
	
	id finalTitle = _theTitle;
	
	int titleLength = [_theTitle length];
	
	if (titleLength > 60)
		finalTitle = [NSString stringWithFormat:@"%@...", [_theTitle substringToIndex:60]];
	
	NSString *theString = [rssDict valueForKey:@"description"];
	
	//APDocument *doc = [[APDocument alloc] initWithString:description];
	
	//NSXMLDocument *doc = [[NSXMLDocument alloc] initWithData:[NSData dataWithBytes:[description cString] length:[description length]] options:NSXMLDocumentTidyHTML error:nil];
	
		//	NSString *theString = description;
	//NSString *theString = [doc stringValue];
	//[doc release];
	

	float maxHeight = master.size.height;
	float stfHeight = maxHeight * .15;
	
	int descriptionLength = [theString length];
	
	
	
		//[theString retain];
	
	if (descriptionLength > 300)
	{
		
		stfHeight = maxHeight * .35;
		
	}
	
	if (descriptionLength > 500)
	{
		
		stfHeight = maxHeight * .45;

	}
	
	if (descriptionLength > 800)
	{
		
		stfHeight = maxHeight * .50;
		
	}
			
	if (descriptionLength > 1000)
	{
		
		stfHeight = maxHeight * .55;
	}
	
	if (descriptionLength > 1200)
	{	
		
		stfHeight = maxHeight * .60;
	
	}
	
	if (descriptionLength > 1300)
	{	

		stfHeight = maxHeight * .70;
		
	}
	
	if (descriptionLength > 1400)
	{	
		
		stfHeight = maxHeight * .80;
		[self setPageOne:[theString substringToIndex:1400]];
		[self setPageTwo:[theString substringFromIndex:1400]];
		nextPageAlpha = 1;
		labelTextAlpha = 0;
	}
	
	
	if ([self pageOne] != nil)
	{
		
		theString = [self pageOne];
		
	}
	
	NSString *pubDate = [rssDict valueForKey:@"pubDate"];

	_secondInfoText = [[BRTextControl alloc] init];
	_primaryInfoText = [[[BRTextControl alloc] init] autorelease];
	_labelTextControl = [[BRTextControl alloc] init];
	_nextPageImage = [[BRImageControl alloc] init];
	_previousPageImage = [[BRImageControl alloc] init];
	
	[self addControl:_nextPageImage];
	[self addControl:_previousPageImage];
	[self addControl:_primaryInfoText];
	[self addControl:_secondInfoText];
	[self addControl:_labelTextControl];
	
	BRImage *nextPageIcon = [BRImage imageWithPath:[[NSBundle bundleForClass:[ntvRSSViewer class]] pathForResource:@"NextPage" ofType:@"png"]];
	BRImage *previousPageIcon = [BRImage imageWithPath:[[NSBundle bundleForClass:[ntvRSSViewer class]] pathForResource:@"PreviousPage" ofType:@"png"]];
	
	[_nextPageImage setImage:nextPageIcon];
	[_previousPageImage setImage:previousPageIcon];
	
	[_primaryInfoText setText:pubDate withAttributes:[[BRThemeInfo sharedTheme] promptTextAttributes]];
	//NSString *docString = [NSString stringWithContentsOfFile:docPath];
	[_secondInfoText setText:theString withAttributes:[[BRThemeInfo sharedTheme] promptTextAttributes]];
	
	[_labelTextControl setText:_labelText withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
		//[theString release];

	
    CGRect primaryTextFrame, secondaryTextFrame, labelTextFrame, nextPageFrame, previousPageFrame;

	primaryTextFrame.size = [_primaryInfoText renderedSize];
	
	float ptfOriginX = (master.size.width - primaryTextFrame.size.width)/2;
	
    primaryTextFrame.origin.y =  master.size.height * 0.78f;
	primaryTextFrame.origin.x = ptfOriginX;
	[_primaryInfoText setFrame: primaryTextFrame];
	
	
	secondaryTextFrame.size = [_secondInfoText renderedSize];
	
	float stfWidth = master.size.width * .70;
	float stfOriginX = (master.size.width - stfWidth)/2;
	
	
	secondaryTextFrame.size.width = stfWidth;
	secondaryTextFrame.size.height = stfHeight;
	secondaryTextFrame.origin.y = primaryTextFrame.origin.y - (primaryTextFrame.size.height +secondaryTextFrame.size.height);
	secondaryTextFrame.origin.x = stfOriginX;
	

	[_secondInfoText setFrame: secondaryTextFrame];
	
	//NSLog(@"secondaryTextFrame: %@", NSStringFromRect(secondaryTextFrame));
	labelTextFrame.size = [_labelTextControl renderedSize];
	
	labelTextFrame.origin.y = secondaryTextFrame.origin.y - (primaryTextFrame.size.height + ITEM_BUFFER);
	if (labelTextFrame.origin.y < 0)
		labelTextFrame.origin.y = 30;
	
	
	
    labelTextFrame.origin.x = (master.origin.x) + ((master.origin.x + master.size.width) * .10);
	[_labelTextControl setFrame: labelTextFrame];
	
	//NSLog(@"labelTextFrame: %@", NSStringFromRect(labelTextFrame));
	
	float nextPageArrowOriginX = stfWidth + stfOriginX + 40;
	float previousPageArrowOriginX = stfOriginX - 70;
	
	nextPageFrame.size = [_nextPageImage pixelBounds];
	float nextPageArrowOriginY = (master.size.height - nextPageFrame.size.height)/2;
	nextPageFrame.origin.x = nextPageArrowOriginX;
	nextPageFrame.origin.y = nextPageArrowOriginY;
	[_nextPageImage setFrame:nextPageFrame];
	[_nextPageImage  setValue:[NSNumber numberWithFloat:nextPageAlpha] forKeyPath:@"opacity"];
	
	previousPageFrame.size = [_previousPageImage pixelBounds];
	previousPageFrame.origin.x = previousPageArrowOriginX;
	previousPageFrame.origin.y = nextPageArrowOriginY;
	[_previousPageImage setFrame:previousPageFrame];
	[_previousPageImage setValue:[NSNumber numberWithFloat:previousPageAlpha] forKeyPath:@"opacity"];
	
	[_labelTextControl setValue:[NSNumber numberWithFloat:labelTextAlpha] forKeyPath:@"opacity"];	
	CGRect frame = master;

	
	_header = [[BRHeaderControl alloc] init];
	
    [_header setTitle: (BRTextControl *) finalTitle]; //not really, just trying to keep the compiler for complaining
	// position it near the top of the screen (remember, origin is
    // lower-left)
    frame.origin.y = frame.size.height * 0.82f;
    frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
    [_header setFrame: frame];

    [self addControl: _header];
	
}


- (void)controlWasActivated;
{
	[self drawSelf];
	
    [super controlWasActivated];
}

- (void)controlWasDeactivated;
{
	
    [super controlWasDeactivated];
}

- (BOOL) isNetworkDependent
{
    return ( YES );
}

//- (BOOL)is1080i
//{
//	NSString *displayUIString = [BRDisplayManager currentDisplayModeUIString];
//	//NSLog(@"displayUIString: %@", displayUIString);
//	NSArray *displayCom = [displayUIString componentsSeparatedByString:@" "];
//	NSString *shortString = [displayCom objectAtIndex:0];
//	if ([shortString isEqualToString:@"1080i"])
//		return YES;
//	else
//		return NO;
//}
//
//- (CGSize)sizeFor1080i
//{
//	
//	CGSize currentSize;
//	currentSize.width = 1280.0f;
//	currentSize.height = 720.0f;
//	
//	
//	return currentSize;
//}

@end
