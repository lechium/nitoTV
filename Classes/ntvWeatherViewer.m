//
//  ntvWeatherViewer.m
//  nitoTV
//
//  Created by nito on 2/29/08.
//  Copyright 2008 nito llc. All rights reserved.
//



#import "ntvWeatherViewer.h"

#define TEXT_LEADING 5.0f
#define ICON_TOP_OFFSET 1.85f //higher numbers = lower
#define TEXT_TOP_OFFSET 1.55f
#define ICON_RIGHT_DIVIDEND 6.0f

@implementation ntvWeatherViewer

- (id) initWithArray:(NSArray *)inputArray
{
    if ( [super init] == nil )
        return ( nil );
	
    weatherArray = inputArray;
	//NSLog(@"inputArray: %@", inputArray);
	[weatherArray retain];
	
    return ( self );
}

- (id) initWithDictionary:(NSDictionary *)inputDict
{
    if ( [super init] == nil )
        return ( nil );
	
    weatherDictionary = inputDict;
	//NSLog(@"weatherDictionary: %@", weatherDictionary);
	[weatherDictionary retain];
	
    return ( self );
}

- (BRImage *)altImageForCode:(int)theCode
{
	NSString *startingString = @"http://nitosoft.com/nito_tv/weather_alt/";
	//NSString *startingString = [[NSBundle bundleForClass:[MWeatherViewer class]] pathForResource:@"Images" ofType:@""];
	//NSLog(@"StartingString: %@", startingString);
	NSString *pictureString = nil;
	
	switch (theCode)
	{
		case 0: //tornado
			
			pictureString = [startingString stringByAppendingString:@"tornado.png"];
			break;
			
		case 3: //severe thunderstorms
		case 4: //thunderstorms
			
			pictureString = [startingString stringByAppendingString:@"thunders.png"];
			
			break;
			
			
		case 9://light drizzle
		case 11://showers
		case 12:
			
			pictureString = [startingString stringByAppendingString:@"showers.png"];
			break;
			
		case 13: //snow flurries
		case 14: //light snow showers
		case 15: //blowing snow
			
			pictureString = [startingString stringByAppendingString:@"snow.png"];
			
			break;
			
		case 16: //snow
			
			pictureString = [startingString stringByAppendingString:@"snowing.png"];
			
			break;
			
		case 17: //hail
			
			pictureString = [startingString stringByAppendingString:@"hail.png"];
			break;
			
		case 18: //sleet
			
			pictureString = [startingString stringByAppendingString:@"sleet.png"];
			break;	
		case 19: //dust
		case 20: //foggy
		case 21: //haze
		case 22: //smoky
			
			pictureString = [startingString stringByAppendingString:@"haze.png"];
			break;
			
		case 24:	//windy
			
			pictureString = [startingString stringByAppendingString:@"wind.png"];
			break;
			
	    case 26: //cloudy
			
			pictureString = [startingString stringByAppendingString:@"clouds.png"];
			break;
			
		case 27: //mostly cloudy (night)
			pictureString = [startingString stringByAppendingString:@"mostly_cloudy_night.png"];
			break;
			
		case 29: //partly cloudy (night)	
			pictureString = [startingString stringByAppendingString:@"cloudy_night.png"];
			break;
			
			
		case 28: //mostly cloudy (day)
			
			pictureString = [startingString stringByAppendingString:@"mostly_cloudy_day.png"];
			break;
		case 30: //partly cloudy (day)
			
			pictureString = [startingString stringByAppendingString:@"cloudy_day.png"];
			break;
			
			
		case 31: //clear (night)
		case 33: //fair (night)
			
			pictureString = [startingString stringByAppendingString:@"clear.png"];
			break;
			
			
			
		case 32: //sunny
			
			pictureString = [startingString stringByAppendingString:@"sunny.png"];
			break;
			
		case 34: //fair (day)
			
			pictureString = [startingString stringByAppendingString:@"mostly_clear.png"];
			break;
			
		case 39: //pm thunderstorms
			
			pictureString = [startingString stringByAppendingString:@"thunders_night.png"];
			break;
			
		case 37: //iso thunderstorms
		case 38: //scattered thunderstorms
		case 45: //thundershowers
			
			pictureString = [startingString stringByAppendingString:@"thunders.png"];
			break;
			
		case 41: //heavy snow
			
			pictureString = [startingString stringByAppendingString:@"heavy_snow.png"];			
			break;
			
			
			
		case 46: //snow showers
			
			pictureString = [startingString stringByAppendingString:@"snowing.png"];
			break;
			
			
		case 3200: //not available
			
			pictureString = [startingString stringByAppendingString:@"na.png"];
			break;
			
		case 420: //yahoo image
			
			pictureString = [startingString stringByAppendingString:@"main_142b.gif"];
			break;
			
		default:
			pictureString = [startingString stringByAppendingString:@"na.png"];
			
			
			break;
	}
	
	//NSLog(@"pictureString: %@", pictureString);
	
	//BRImage *myImage = [BRImage imageWithPath:pictureString];
	BRImage *myImage = [BRImage imageWithURL:[NSURL URLWithString:pictureString]];
	return myImage;
}

- (BRImage *)imageForCode:(int)theCode
{
	NSString *startingString = @"http://nitosoft.com/nito_tv/weather/";
	NSString *pictureString = nil;
	
	switch (theCode)
	{
			
		case 3: //severe thunderstorms
		case 4: //thunderstorms
			
			pictureString = [startingString stringByAppendingString:@"thunders.png"];
			
			break;
						
		case 5: //mixed rain and snow
		case 6: //mixed rain and sleet
		case 7: //mixed snow and sleet
			
			pictureString = [startingString stringByAppendingString:@"snow_and_rain.png"];
			break;
			
			
		case 9://light drizzle
		case 11://showers
		case 12:
			
			pictureString = [startingString stringByAppendingString:@"showers.png"];
			break;
			
		case 13: //snow flurries
		case 14: //light snow showers
		case 15: //blowing snow
			
			pictureString = [startingString stringByAppendingString:@"snow.png"];
			
			break;
			
		case 16: //snow
			
			pictureString = [startingString stringByAppendingString:@"snowing.png"];
			
			break;
			
		case 17: //hail
			
			pictureString = [startingString stringByAppendingString:@"hail.png"];
			break;
			
					
		case 19: //dust
		case 20: //foggy
		case 21: //haze
		case 22: //smoky
			
			pictureString = [startingString stringByAppendingString:@"haze.png"];
			break;
			
		case 24:	//windy
			
			pictureString = [startingString stringByAppendingString:@"wind.png"];
			break;
		
	    case 26: //cloudy
			
			pictureString = [startingString stringByAppendingString:@"clouds.png"];
			break;
			
		case 27: //mostly cloudy (night)
		case 29: //partly cloudy (night)	
			pictureString = [startingString stringByAppendingString:@"cloudy_night.png"];
			break;
			
			
		case 28: //mostly cloudy (day)
		case 30: //partly cloudy (day)
			
			pictureString = [startingString stringByAppendingString:@"cloudy_day.png"];
			break;
		
			
		case 31: //clear (night)
		case 33: //fair (night)
			
			pictureString = [startingString stringByAppendingString:@"clear.png"];
			break;
			
			 
			
		case 32: //sunny
			
			pictureString = [startingString stringByAppendingString:@"sunny.png"];
			break;
			
		case 34: //fair (day)
			
			pictureString = [startingString stringByAppendingString:@"mostly_clear.png"];
			break;
			
		case 39: //pm thunderstorms
			
			pictureString = [startingString stringByAppendingString:@"thunders_night.png"];
			break;
			
		case 37: //iso thunderstorms
		case 38: //scattered thunderstorms
		case 45: //thundershowers
			
			pictureString = [startingString stringByAppendingString:@"thunders.png"];
			break;
			
			
		case 46: //snow showers
			
			pictureString = [startingString stringByAppendingString:@"snowing.png"];
			break;
			
			
		case 3200: //not available
			
			pictureString = [startingString stringByAppendingString:@"na.png"];
			break;
			
		case 420: //yahoo image
			
			pictureString = [startingString stringByAppendingString:@"main_142b.gif"];
			break;
			
		default:
			pictureString = [startingString stringByAppendingString:@"na.png"];
			
			
			break;
	}
	
	//NSLog(@"pictureString: %@", pictureString);
	
	BRImage *myImage = [BRImage imageWithURL:[NSURL URLWithString:pictureString]];
	return myImage;
}

- (BOOL)over480
{
	id displayMode = [[BRDisplayManager sharedInstance] currentMode];
	
	//NSLog(@"displayMOde: %@", displayMode);
	int heights = [[displayMode valueForKey:@"Height"] intValue];

	//NSLog(@"height: %i mode: %i", heights,mode);
	if (heights > 480)
	{
		return YES;
	}
	return NO;
}



- (void)drawSelf
{
	//BOOL overSize = [self over480];
	BRTextControl *firstTextControl = [[[BRTextControl alloc] init] autorelease];
	BRTextControl *secondTextControl = [[[BRTextControl alloc] init] autorelease];
	BRTextControl *thirdTextControl = [[[BRTextControl alloc] init] autorelease];
	//BRTextControl *yahooTextControl = [[[BRTextControl alloc] init] autorelease];
	
	
	NSDictionary *weekOneDict = [[weatherDictionary objectForKey:@"forecast"] objectAtIndex:0];
	
	NSDictionary *weekTwoDict = [[weatherDictionary objectForKey:@"forecast"] objectAtIndex:1];
	
	int theCode = [[weatherDictionary objectForKey:@"code"] intValue];
	int codeTwo = [[weekOneDict objectForKey:@"code"] intValue];
	int codeThree = [[weekTwoDict objectForKey:@"code"] intValue];
	
	BRImage *weatherImage = [self altImageForCode:theCode];
	BRImage *weatherImageTwo = [self altImageForCode:codeTwo];
	BRImage *weatherImageThree = [self altImageForCode:codeThree];
	BRImage *yahooImage = [self imageForCode:420];
	
	BRImageControl *imageControl = [[[BRImageControl alloc] init] autorelease];
	BRImageControl *imageControlTwo = [[[BRImageControl alloc] init] autorelease];
	BRImageControl *imageControlThree = [[[BRImageControl alloc] init] autorelease];
	BRImageControl *imageControlYahoo = [[[BRImageControl alloc] init] autorelease];
	
	[imageControl setImage:weatherImage];
	[imageControlTwo setImage:weatherImageTwo];
	[imageControlThree setImage:weatherImageThree];
	[imageControlYahoo setImage:yahooImage];
	
	[self addControl:firstTextControl];
	[self addControl:imageControl];
	[self addControl:imageControlTwo];
	[self addControl:imageControlThree];
	[self addControl:secondTextControl];
	[self addControl:thirdTextControl];
	//[self addControl:yahooTextControl];
	[self addControl:imageControlYahoo];
	
	NSString *theTitle = [weatherDictionary objectForKey:@"title"];
	NSString *description = [weatherDictionary objectForKey:@"text"];
	NSString *temp = [weatherDictionary objectForKey:@"temp"];
	NSString *tempFormat = [weatherDictionary objectForKey:@"temperature"];
		
	
	NSString *weekDayOne = [weekOneDict objectForKey:@"day"];
	NSString *descOne = [weekOneDict objectForKey:@"text"];
	NSString *highOne = [weekOneDict objectForKey:@"high"];
	NSString *lowOne = [weekOneDict objectForKey:@"low"];
	
	NSString *weekDayTwo = [weekTwoDict objectForKey:@"day"];
	NSString *descTwo = [weekTwoDict objectForKey:@"text"];
	NSString *highTwo = [weekTwoDict objectForKey:@"high"];
	NSString *lowTwo = [weekTwoDict objectForKey:@"low"];
	NSString *condition = [NSString stringWithFormat:BRLocalizedString(@"Current Conditions: %@, %@°%@", @"current conditions of the current day for weather"), description, temp,tempFormat];
	
	NSString *firstDay = [NSString stringWithFormat:BRLocalizedString(@"%@ - %@, High: %@°%@, Low: %@°%@", @"second day forecast"), weekDayOne, descOne, highOne,tempFormat, lowOne,tempFormat];
	
	
	NSString *secondDay = [NSString stringWithFormat:BRLocalizedString(@"%@ - %@, High: %@°%@, Low: %@°%@", @"third day forecast"), weekDayTwo, descTwo, highTwo,tempFormat, lowTwo,tempFormat];
	
	//NSString *yahooInfo = @"Yahoo! Weather.";
	
	
	[firstTextControl setText: condition withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
	[secondTextControl setText: firstDay withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
	[thirdTextControl setText: secondDay withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
	//[yahooTextControl setText: yahooInfo withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
	
    CGRect testFrame, imageFrame, imageFrameTwo, imageFrameThree, frameOne, frameTwo, yahooFrame;
	//NSString *atvVersion = [nitoTVAppliance appleTVVersion];
	CGRect master  = [[self parent] frame];

    
		imageFrame.size = [imageControl pixelBounds];
	
		//NSLog(@"imageFrame.height: %i width: %i", imageFrame.size.height, imageFrame.size.width); 
	imageFrame.origin.y = master.origin.y + (master.size.height * (1.0f / ICON_TOP_OFFSET));
    imageFrame.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ ICON_RIGHT_DIVIDEND);
	
	[imageControl setFrame:imageFrame];
	
		//NSLog(@"imageFrameThree origin: %i", imageFrameThree.origin.y);
	
	testFrame.size = [firstTextControl renderedSize];
    testFrame.origin.y = master.origin.y + (master.size.height * (1.0f / TEXT_TOP_OFFSET));
    testFrame.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ 2.8f);
	[firstTextControl setFrame: testFrame];
	
	frameOne.size = [secondTextControl renderedSize];
    frameOne.origin.y = testFrame.origin.y - (testFrame.size.height * TEXT_LEADING);
    frameOne.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ 2.8f);
	[secondTextControl setFrame: frameOne];
	
	frameTwo.size = [thirdTextControl renderedSize];
    frameTwo.origin.y = frameOne.origin.y - (frameOne.size.height * TEXT_LEADING);
    frameTwo.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ 2.8f);
	[thirdTextControl setFrame: frameTwo];
	

		imageFrameTwo.size = [imageControlTwo pixelBounds];
	
	//if (overSize == YES)
		imageFrameTwo.origin.y = frameOne.origin.y - (imageFrame.size.height/2);
	//else
		imageFrameTwo.origin.y = frameOne.origin.y - (imageFrame.size.height/2);
		//imageFrameTwo.origin.y = imageFrame.origin.y - imageFrame.size.height;
	
	imageFrameTwo.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ ICON_RIGHT_DIVIDEND);
	
	[imageControlTwo setFrame:imageFrameTwo];
	

		 imageFrameThree.size = [imageControlTwo pixelBounds];

	
	//if (overSize == YES)
		imageFrameThree.origin.y = frameTwo.origin.y - (imageFrameTwo.size.height/2);
	//else
	//	imageFrameThree.origin.y = imageFrameTwo.origin.y - imageFrameTwo.size.height;
    
	imageFrameThree.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ ICON_RIGHT_DIVIDEND);
	[imageControlThree setFrame:imageFrameThree];
	
	

		yahooFrame.size = [imageControlYahoo pixelBounds];

	
	yahooFrame.origin.y = frameTwo.origin.y - (frameTwo.size.height * 2.5);
    yahooFrame.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ 1.4f);
	[imageControlYahoo setFrame: yahooFrame];
	

	
	
	CGRect frame = master;
	
	frame.origin.y = frame.size.height * 0.60;
	
	
	//NSString *headerTitle = nil;
	//NSString *buttonTitle = nil;
	
	
	_header = [[BRHeaderControl alloc] init];
	
    [_header setTitle: theTitle withAttributes:[[BRThemeInfo sharedTheme]menuTitleTextAttributes]];
	// position it near the top of the screen (remember, origin is
    // lower-left)
    frame.origin.y = frame.size.height * 0.82f;
    frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
    [_header setFrame: frame];
	//	[_header setIcon:tex horizontalOffset:0.0 kerningFactor:0.15];
	
    // add the header control to our master layer
	[self addControl:_header];
	
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


@end
