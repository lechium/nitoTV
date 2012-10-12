//
//  ntvWeatherViewer.m
//  nitoTV
//
//  Created by nito on 2/29/08.
//  Copyright 2008 nito llc. All rights reserved.
//


#define TEXT_LEADING 5.0f
#define ICON_TOP_OFFSET 1.85f //higher numbers = lower
#define TEXT_TOP_OFFSET 1.55f
#define ICON_RIGHT_DIVIDEND 6.0f
#define SHARED_THEME [objc_getClass("BRThemeInfo") sharedTheme]

static char const * const kNitoWVHeaderKey = "nWVHeader";
static char const * const kNitoWVSourceTextKey = "nWVSourceText";
static char const * const kNitoWVWeatherArrayKey = "nWVWeatherArray";
static char const * const kNItoWVWeatherDictionaryKey = "nWVWeatherDictionary";


%subclass ntvWeatherViewer : BRController


%new -(id)header
{
	return [self associatedValueForKey:(void*)kNitoWVHeaderKey];
}

%new - (void)setHeader:(id)value
{
	[self associateValue:value withKey:(void*)kNitoWVHeaderKey];
}

%new - (id)sourceText
{
	return [self associatedValueForKey:(void*)kNitoWVSourceTextKey];
}

%new - (void)setSourceText:(id)value
{
	[self associateValue:value withKey:(void*)kNitoWVSourceTextKey];
}

%new - (NSArray *)weatherArray
{
	return [self associatedValueForKey:(void*)kNitoWVWeatherArrayKey];
}

%new - (void)setWeatherArray:(NSArray *)value
{
	[self associateValue:value withKey:(void*)kNitoWVWeatherArrayKey];
}

%new - (NSDictionary *)weatherDictionary
{
	return [self associatedValueForKey:(void*)kNItoWVWeatherDictionaryKey];
}

%new - (void)setWeatherDictionary:(NSDictionary *)value
{
	[self associateValue:value withKey:(void*)kNItoWVWeatherDictionaryKey];
}



%new - (id) initWithArray:(NSArray *)inputArray
{
    if ( [self init] == nil )
        return ( nil );
	
	[self setWeatherArray:inputArray];
		// weatherArray = inputArray;
	//NSLog(@"inputArray: %@", inputArray);
	//[weatherArray retain];
	
    return ( self );
}

%new - (id) initWithDictionary:(NSDictionary *)inputDict
{
    if ( [self init] == nil )
        return ( nil );
	
	[self setWeatherDictionary:inputDict];
		//weatherDictionary = inputDict;
	//NSLog(@"weatherDictionary: %@", weatherDictionary);
	//[weatherDictionary retain];
	
    return ( self );
}

%new - (id)altImageForCode:(int)theCode
{
	NSString *startingString = @"http://nitosoft.com/nito_tv/weather_alt/";
	
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
	
	//id myImage = [BRImage imageWithPath:pictureString];
	id myImage = [objc_getClass("BRImage") imageWithURL:[NSURL URLWithString:pictureString]];
	return myImage;
}

%new - (id)imageForCode:(int)theCode
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
	
	id myImage = [objc_getClass("BRImage") imageWithURL:[NSURL URLWithString:pictureString]];
	return myImage;
}




%new - (void)drawSelf
{
	id weatherDictionary = [self weatherDictionary];
	
	id firstTextControl = [[[objc_getClass("ntvTextControl") alloc] init] autorelease];
	id secondTextControl = [[[objc_getClass("ntvTextControl") alloc] init] autorelease];
	id thirdTextControl = [[[objc_getClass("ntvTextControl") alloc] init] autorelease];
	
	NSDictionary *weekOneDict = [[weatherDictionary objectForKey:@"forecast"] objectAtIndex:0];
	
	NSDictionary *weekTwoDict = [[weatherDictionary objectForKey:@"forecast"] objectAtIndex:1];
	
	int theCode = [[weatherDictionary objectForKey:@"code"] intValue];
	int codeTwo = [[weekOneDict objectForKey:@"code"] intValue];
	int codeThree = [[weekTwoDict objectForKey:@"code"] intValue];
	
	id weatherImage = [self altImageForCode:theCode];
	id weatherImageTwo = [self altImageForCode:codeTwo];
	id weatherImageThree = [self altImageForCode:codeThree];
	id yahooImage = [self imageForCode:420];
	
	id imageControl = [[[objc_getClass("ntvImageControl") alloc] init] autorelease];
	id imageControlTwo = [[[objc_getClass("ntvImageControl") alloc] init] autorelease];
	id imageControlThree = [[[objc_getClass("ntvImageControl") alloc] init] autorelease];
	id imageControlYahoo = [[[objc_getClass("ntvImageControl") alloc] init] autorelease];
	
	[imageControl setImage:weatherImage];
	[imageControlTwo setImage:weatherImageTwo];
	[imageControlThree setImage:weatherImageThree];
	[imageControlYahoo setImage:yahooImage];
	
	
	if ([self respondsToSelector:@selector(controls)])
	{
		
		[self addControl:firstTextControl];
		[self addControl:imageControl];
		[self addControl:imageControlTwo];
		[self addControl:imageControlThree];
		[self addControl:secondTextControl];
		[self addControl:thirdTextControl];
		[self addControl:imageControlYahoo];
		
	} else {
		
		[self addSubview:firstTextControl];
		[self addSubview:imageControl];
		[self addSubview:imageControlTwo];
		[self addSubview:imageControlThree];
		[self addSubview:secondTextControl];
		[self addSubview:thirdTextControl];
		[self addSubview:imageControlYahoo];
		
		
	}
	
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

	
	[firstTextControl setText: condition withAttributes:[SHARED_THEME menuItemTextAttributes]];
	
	[secondTextControl setText: firstDay withAttributes:[SHARED_THEME menuItemTextAttributes]];
	
	[thirdTextControl setText: secondDay withAttributes:[SHARED_THEME menuItemTextAttributes]];

	
    CGRect testFrame, imageFrame, imageFrameTwo, imageFrameThree, frameOne, frameTwo, yahooFrame;
	
	CGRect master  = [[self parent] frame];
	CGSize pb = [imageControl pixelBounds];
	imageFrame.size.width = pb.width;
	imageFrame.size.height = pb.height;
		//imageFrame.size = [imageControl pixelBounds];
	
		//NSLog(@"imageFrame.height: %i width: %i", imageFrame.size.height, imageFrame.size.width); 
	imageFrame.origin.y = master.origin.y + (master.size.height * (1.0f / ICON_TOP_OFFSET));
    imageFrame.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ ICON_RIGHT_DIVIDEND);
	
	[imageControl setFrame:imageFrame];
	
		//NSLog(@"imageFrameThree origin: %i", imageFrameThree.origin.y);
	
	CGSize testSize = [firstTextControl renderedSize];
	testFrame.size.width = testSize.width;
	testFrame.size.height = testSize.height;
	
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
	imageFrameTwo.origin.y = frameOne.origin.y - (imageFrame.size.height/2);
	imageFrameTwo.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ ICON_RIGHT_DIVIDEND);
	[imageControlTwo setFrame:imageFrameTwo];
	imageFrameThree.size = [imageControlTwo pixelBounds];

	
	imageFrameThree.origin.y = frameTwo.origin.y - (imageFrameTwo.size.height/2);
	imageFrameThree.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ ICON_RIGHT_DIVIDEND);
	[imageControlThree setFrame:imageFrameThree];
	
	

	yahooFrame.size = [imageControlYahoo pixelBounds];
	yahooFrame.origin.y = frameTwo.origin.y - (frameTwo.size.height * 2.5);
    yahooFrame.origin.x = master.origin.x + ((master.origin.x + master.size.width) * 1.0f/ 1.4f);
	[imageControlYahoo setFrame: yahooFrame];
	

	CGRect frame = master;
	frame.origin.y = frame.size.height * 0.60;
	id _header = [[objc_getClass("BRHeaderControl") alloc] init];
	[_header setTitle: theTitle withAttributes:[SHARED_THEME menuTitleTextAttributes]];
	// position it near the top of the screen (remember, origin is
    // lower-left)
    
	frame.origin.y = frame.size.height * 0.82f;
    frame.size.height = 85.0f; //[SHARED_THEME listIconHeight]
    [_header setFrame: frame];
	
	
    // add the header control to our master layer
	if ([self respondsToSelector:@selector(controls)])
		[self addControl:_header];
	else 
		[self addSubview:_header];
	
	[self setHeader:_header];
	
}

 

- (void)controlWasActivated
{
	[self drawSelf];
	
    %orig;
}



%end