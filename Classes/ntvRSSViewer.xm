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

	//#import "ntvRSSViewer.h"
#import "APDocument.h"
#import "packageManagement.h"

/*
 
 BRHeaderControl *       _header;
 NSString		*		_theTitle;
 objc_getClass("BRTextControl") *		_primaryInfoText;
 objc_getClass("BRTextControl") *		_secondInfoText;
 objc_getClass("BRTextControl") *		_labelTextControl;
 BRImageControl*		_previousPageImage;
 BRImageControl*		_nextPageImage;
 NSString				*_labelText;
 NSDictionary			*rssDict;
 NSString				*pageOne;
 NSString				*pageTwo;
 
 */

static char const * const kNitoRVHeaderKey = "nRVHeader";
static char const * const kNitoRVTheTitleKey = "nRVTitleKey";
static char const * const kNitoRVPrimaryInfoKey = "nRVPrimaryInfoText";
static char const * const kNitoRVSecondaryInfoKey = "nRVSecondaryInfoText";
static char const * const kNitoRVLabelTextKey = "nRVLabelTextControl";
static char const * const kNitoRVPreviousPageImageKey = "nRVPreviewPageImage";
static char const * const kNitoRVNextPageImageKey = "nRVNextPageImage";
static char const * const kNitoRVLabelTextStringKey = "nRVLabelTextString";
static char const * const kNitoRVRssDictKey = "nRVRssDict";
static char const * const kNitoRVPageOneStringKey = "nRVPageOneString";
static char const * const kNitoRVPageTwoStringKey = "nRVPageTwoString";

%subclass ntvRSSViewer : BRController

%new - (id) initWithDictionary:(NSDictionary *)inputDict
{
    if ( [self init] == nil )
        return ( nil );
	
    [self setRssDict:inputDict];
    return ( self );
}

%new - (id)header
{
	return [self associatedValueForKey:(void*)kNitoRVHeaderKey];
}

%new - (void)setHeader:(id)value
{
	[self associateValue:value withKey:(void*)kNitoRVHeaderKey];
}

%new - (id)theTitle
{
	return [self associatedValueForKey:(void*)kNitoRVTheTitleKey];
}

%new - (void)setTheTitle:(NSString* )value
{
	[self associateValue:value withKey:(void*)kNitoRVTheTitleKey];
}

%new - (id)primaryInfoText
{
	return [self associatedValueForKey:(void*)kNitoRVPrimaryInfoKey];
}

%new - (void)setPrimaryInfoText:(id)value
{
	[self associateValue:value withKey:(void*)kNitoRVPrimaryInfoKey];
}

%new - (id)secondInfoText
{
	return [self associatedValueForKey:(void*)kNitoRVSecondaryInfoKey];
}

%new - (void)setSecondInfoText:(id)value
{
	[self associateValue:value withKey:(void*)kNitoRVSecondaryInfoKey];
}

%new -(id)labelTextControl
{
	return [self associatedValueForKey:(void*)kNitoRVLabelTextKey];
}

%new -(void)setLabelTextControl:(id)value
{
	[self associateValue:value withKey:(void*)kNitoRVLabelTextKey];
}

%new - (NSString *)labelText {
    return [self associatedValueForKey:(void*)kNitoRVLabelTextStringKey];
}

%new - (void)setLabelText:(NSString *)value {
    [self associateValue:value withKey:(void*)kNitoRVLabelTextStringKey];
}

%new - (id)previousPageImage
{
	  return [self associatedValueForKey:(void*)kNitoRVPreviousPageImageKey];
}

%new - (void)setPreviousPageImage:(id)value
{
	[self associateValue:value withKey:(void*)kNitoRVPreviousPageImageKey];
}

%new - (id)nextPageImage
{
	return [self associatedValueForKey:(void*)kNitoRVNextPageImageKey];
}

%new - (void)setNextPageImage:(id)value
{
	[self associateValue:value withKey:(void*)kNitoRVNextPageImageKey];
}


%new - (NSString *)pageOne {
    return [self associatedValueForKey:(void*)kNitoRVPageOneStringKey];
}

%new - (void)setPageOne:(NSString *)value {
    
	[self associateValue:value withKey:(void*)kNitoRVPageOneStringKey];
}

%new - (NSString *)pageTwo {
    return [self associatedValueForKey:(void*)kNitoRVPageTwoStringKey];
}

%new - (void)setPageTwo:(NSString *)value {
	[self associateValue:value withKey:(void*)kNitoRVPageTwoStringKey];
}

%new -(NSDictionary *)rssDict
{
	return [self associatedValueForKey:(void*)kNitoRVRssDictKey];
}

%new -(void)setRssDict:(NSDictionary *)rssDict
{
	[self associateValue:rssDict withKey:(void*)kNitoRVRssDictKey];
}

- (void)layoutSubcontrols
{
	%orig;
	[self drawSelf];
}

%new - (void)drawSelf
{

		//	NSLog(@"rssDict: %@", [self rssDict]);
	float previousPageAlpha = 0;
	float nextPageAlpha = 0;
	float labelTextAlpha = 1;
	CGRect master = [self frame];
	id _theTitle = [[self rssDict] valueForKey:@"title"];
	
	id finalTitle = _theTitle;
	
	int titleLength = [_theTitle length];
	
	if (titleLength > 60)
		finalTitle = [NSString stringWithFormat:@"%@...", [_theTitle substringToIndex:60]];
	
	NSString *theString = [[self rssDict] valueForKey:@"description"];
	
	//APDocument *doc = [[APDocument alloc] initWithString:description];
	
	//NSXMLDocument *doc = [[NSXMLDocument alloc] initWithData:[NSData dataWithBytes:[description cString] length:[description length]] options:NSXMLDocumentTidyHTML error:nil];
	
		//	NSString *theString = description;
	//NSString *theString = [doc stringValue];
	//[doc release];
	

	float maxHeight = master.size.height;
	float stfHeight = maxHeight * .15;
	
	int descriptionLength = [theString length];
	
		
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
	
	NSString *pubDate = [[self rssDict] valueForKey:@"pubDate"];

	id _secondInfoText = [[objc_getClass("BRTextControl") alloc] init];
		//	NSLog(@"_secondInfoText: %@", _secondInfoText);
	id _primaryInfoText = [[[objc_getClass("BRTextControl") alloc] init] autorelease];
	id _labelTextControl = [[objc_getClass("BRTextControl") alloc] init];
	id _nextPageImage = [[%c(BRImageControl) alloc] init];
	id _previousPageImage = [[%c(BRImageControl) alloc] init];
	
	
    id nextPageIcon = [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"NextPage" ofType:@"png"]];
    
	//id nextPageIcon = [%c(BRImage) imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"NextPage" ofType:@"png"]];
	//id previousPageIcon = [%c(BRImage) imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"PreviousPage" ofType:@"png"]];
	
    id previousPageIcon = [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"PreviousPage" ofType:@"png"]];
	
	if ([self respondsToSelector:@selector(controls)])
	{
		
		[self addControl:_nextPageImage];
		[self addControl:_previousPageImage];
		[self addControl:_primaryInfoText];
		[self addControl:_secondInfoText];
		[self addControl:_labelTextControl];
		
	} else {
		
		
		[self addSubview:_nextPageImage];
		[self addSubview:_previousPageImage];
		[self addSubview:_primaryInfoText];
		[self addSubview:_secondInfoText];
		[self addSubview:_labelTextControl];
		
		
	}
	
	[_nextPageImage setImage:nextPageIcon];
	[_previousPageImage setImage:previousPageIcon];
	
	[_primaryInfoText setText:pubDate withAttributes:[[%c(BRThemeInfo) sharedTheme] promptTextAttributes]];
	
	[_secondInfoText setText:theString withAttributes:[[%c(BRThemeInfo) sharedTheme] promptTextAttributes]];
	
	[_labelTextControl setText:[self labelText] withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemTextAttributes]];
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

	
	id _header = [[%c(BRHeaderControl) alloc] init];
	
    [_header setTitle:  finalTitle]; //not really, just trying to keep the compiler for complaining
	// position it near the top of the screen (remember, origin is
    // lower-left)
    frame.origin.y = frame.size.height * 0.82f;
    frame.size.height = 85.0f; //[[%c(BRThemeInfo) sharedTheme] listIconHeight];
    [_header setFrame: frame];

	if ([self respondsToSelector:@selector(controls)])
	{
		[self addControl: _header];
	} else {
		[self addSubview: _header];
	}
	
	
	
	[self setHeader:_header];
	[self setSecondInfoText:_secondInfoText];
	[self setPrimaryInfoText:_primaryInfoText];
	[self setLabelTextControl:_labelTextControl];
	[self setNextPageImage:_nextPageImage];
	[self setPreviousPageImage:_previousPageImage];
	
}


- (void)controlWasActivated
{
		//[self drawSelf];
	
    %orig;
}

- (BOOL)brEventAction:(id)fp8

{
		//ushort theUsage = [fp8 usage];
	int theAction = (int)[fp8 remoteAction];
		//NSLog(@"theUsage: %i", theUsage);
	switch (theAction)
	{
		case kBREventRemoteActionMenu: //Menu
			
			return NO;
			
		case kBREventRemoteActionRight: //right
			
			if ([[self pageTwo] length] > 0)
			{
				[[self secondInfoText] setText:[self pageTwo] withAttributes:[[%c(BRThemeInfo) sharedTheme] promptTextAttributes]];
				[[self nextPageImage] setValue:[NSNumber numberWithFloat:0] forKeyPath:@"opacity"];
				[[self previousPageImage] setValue:[NSNumber numberWithFloat:1] forKeyPath:@"opacity"];
				[[self labelTextControl] setValue:[NSNumber numberWithFloat:1] forKeyPath:@"opacity"];
			}
			
			break;
			
		case kBREventRemoteActionLeft: //left
			
			if ([[self pageOne] length] > 0)
			{
				[[self secondInfoText] setText:[self pageOne] withAttributes:[[%c(BRThemeInfo) sharedTheme] promptTextAttributes]];
				[[self nextPageImage] setValue:[NSNumber numberWithFloat:1] forKeyPath:@"opacity"];
				[[self previousPageImage] setValue:[NSNumber numberWithFloat:0] forKeyPath:@"opacity"];
				[[self labelTextControl] setValue:[NSNumber numberWithFloat:0] forKeyPath:@"opacity"];
			}
			
			
			break;
			
		default:
			%orig;
			
			break;
	}
	return YES;
}

%end
