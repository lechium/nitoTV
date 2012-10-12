
#import "NitoTheme.h"
#import <math.h>
#import "nitoWeather.h"
#import "APXML.h"

#define DEGREE_UNICODE @"\u00B0"

/*
 

 id						_parentController;
 NSMutableArray	    	*_locations;
 NSMutableArray		    *_units;
 NSMutableArray         *_locationDicts;
 NSMutableDictionary	*_globalDict;
 NSString				*_mainTitle;
 NSArray				*tempWeatherArray;
 nitoWeather			*currentNitoWeather;
 
 int					_listState;
 int					progressRow;
 
 */


static int      _listState;
static int		progressRow = -1;

static char const * const kNitoWMParentControllerKey = "nWMParentController";
static char const * const kNitoWMLocationsKey = "nWMLocations";
static char const * const kNitoWMUnitsKey = "nWMUnits";
static char const * const kNitoWMLocationDictsKey = "nWMLocationsDict";
static char const * const kNitoWMGlobalDictKey = "nWMGlobalDict";
static char const * const kNitoWMMainTitleKey = "nWMMainTitle";
static char const * const kNitoWMTempWeatherArrayKey = "nWMTempWeatherArray";
static char const * const kNitoWMCurrentNitoWeatherKey = "nWMCurrentNitoWeather";



%subclass ntvWeatherManager : nitoMediaMenuController


%new - (id)parentController
{
	return [self associatedValueForKey:(void*)kNitoWMParentControllerKey];
}

%new - (void)setParentController:(id)value
{
	[self associateValue:value withKey:(void*)kNitoWMParentControllerKey];
}

%new - (NSMutableArray *)locations
{
	return [self associatedValueForKey:(void*)kNitoWMLocationsKey];
}

%new - (void)setLocations:(NSMutableArray *)value
{
	[self associateValue:value withKey:(void*)kNitoWMLocationsKey];
}

%new - (NSMutableArray *)units
{
	return [self associatedValueForKey:(void *)kNitoWMUnitsKey];
}

%new - (void)setUnits:(NSMutableArray *)value
{
	[self associateValue:value withKey:(void *)kNitoWMUnitsKey];
}

%new - (NSMutableArray *)locationDicts
{
	return [self associatedValueForKey:(void *)kNitoWMLocationDictsKey];
}

%new - (void)setLocationDicts:(NSMutableArray *)value
{
	[self associateValue:value withKey:(void *)kNitoWMLocationDictsKey];
}

%new - (NSMutableDictionary *)globalDict 
{
	return [self associatedValueForKey:(void *)kNitoWMGlobalDictKey];
}

%new - (void)setGlobalDict:(NSMutableDictionary *)value
{
	[self associateValue:value withKey:(void *)kNitoWMGlobalDictKey];
}

%new - (NSString *)mainTitle
{
	return [self associatedValueForKey:(void *)kNitoWMMainTitleKey];
}

%new - (void)setMainTitle:(NSString *)value
{
	[self associateValue:value withKey:(void *)kNitoWMMainTitleKey];
}

%new - (NSArray *)tempWeatherArray
{
	return [self associatedValueForKey:(void *)kNitoWMTempWeatherArrayKey];
}

%new - (void)setTempWeatherArray:(NSArray *)value
{
	[self associateValue:value withKey:(void *)kNitoWMTempWeatherArrayKey];
}

%new - (nitoWeather *)currentNitoWeather
{
	return [self associatedValueForKey:(void *)kNitoWMCurrentNitoWeatherKey];
}

%new - (void)setCurrentNitoWeather:(nitoWeather *)value
{
	[self associateValue:value withKey:(void *)kNitoWMCurrentNitoWeatherKey];
}


- (BOOL)rightAction:(long)theRow
{
	//NSLog(@"currentRow: %d, %i", currentRow, [[self names] count]);
	if (theRow+1 == [[self names] count])
	{
		return NO;
	}
	
	NSString *currentKey = [[self names] objectAtIndex:theRow];
	
	id _currentNitoWeather = [self currentNitoWeather];
	if (!_currentNitoWeather)
	{
		_currentNitoWeather = [[nitoWeather alloc] init];
	}
	NSDictionary *currentDict = [[self globalDict] valueForKey:currentKey];
	[_currentNitoWeather setTheProps:currentDict];
	
	[self setCurrentNitoWeather:_currentNitoWeather];
	
	id weatherController = [[%c(nitoWeatherController) alloc] initWithWeather:currentDict withMode:1];
	
	[weatherController autorelease];
	[weatherController setParentController:self];
	[weatherController setWeatherKey:currentKey];
	[weatherController setCurrentRow:theRow];
	[[self stack] pushController:weatherController];
	
	return YES;
}


%new + (NSString *) rootMenuLabel
{
	return ( @"nito.weather.root" );
}


%new + (NSString *)windDirectionFromInt:(int)directionInt
{
	if (directionInt > 360)
		directionInt = directionInt - 360;
	
	NSString *direction = nil;
	if (directionInt == 0)
		direction = @"N";
	else if ((directionInt > 0) && (directionInt < 45))
		direction = @"NNE";
	else if (directionInt == 45)
		direction = @"NE";
	else if ((directionInt > 45) && (directionInt < 90))
		direction = @"ENE";
	else if (directionInt == 90)
		direction = @"E";
	else if ((directionInt > 90) && (directionInt < 135))
		direction = @"ESE";
	else if (directionInt == 135)
		direction = @"SE";
	else if ((directionInt > 135) && (directionInt < 180))
		direction = @"SSE";
	else if (directionInt == 180)
		direction = @"S";
	else if ((directionInt > 180) && (directionInt < 225))
		direction = @"SSW";
	else if (directionInt == 225)
		direction = @"SW";
	else if ((directionInt > 225) &&  (directionInt < 270))
		direction = @"WSW";
	else if (directionInt == 270)
		direction = @"W";
	else if ((directionInt > 270) && (directionInt < 315))
		direction = @"WNW";
	else if (directionInt == 315)
		direction = @"NW";
	else if ((directionInt > 315) &&  (directionInt < 360))
		direction = @"NNW";
	else if (directionInt == 360)
		direction = @"N";
	
	return direction;
	
}

%new - (id)altImageForCode:(int)theCode
{
	NSString *startingString = @"http://nitosoft.com/nito_tv/weather_alt_hr/";
	
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
	id myImage = [%c(BRImage) imageWithURL:[NSURL URLWithString:pictureString]];
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
	
	id myImage = [%c(BRImage) imageWithURL:[NSURL URLWithString:pictureString]];
	return myImage;
}

%new - (NSString *)complicatedDewPointFromDict:(NSDictionary *)weatherInfo
{
	
	
	float T = [[weatherInfo valueForKey:@"temp"] floatValue];
	NSString *units = [weatherInfo valueForKey:@"temperature"];
	int RH = [[weatherInfo valueForKey:@"humidity"]intValue];
	
	if([units isEqualToString:@"f"]){
		T = T - 52;
	}
	
	double H	= (log10(RH)-2)/0.4343 + (17.62*T)/(243.12+T);
	double Dp	= 243.12*H/(17.62-H);
	
		//return [NSString stringWithFormat:@"%.2f¡%@", Dp, units];
	return [NSString stringWithFormat:@"%.2f%@%@",Dp, units, DEGREE_UNICODE];
}

%new - (NSString *)dewPointFromDict:(NSDictionary *)weatherInfo
{
	float weatherTemp = [[weatherInfo valueForKey:@"temp"] floatValue];
	NSString *units = [weatherInfo valueForKey:@"temperature"];
	int humidity = [[weatherInfo valueForKey:@"humidity"]intValue];
	float conversionDivisor = 5;
	
	if (humidity < 50)
		return @"N/A";
	
	if ([units isEqualToString:@"c"])
		conversionDivisor = 5;
	else if([units isEqualToString:@"f"])
		conversionDivisor = 2.778;
	
	float dewPoint = weatherTemp - ((100 - humidity) / conversionDivisor);
	
	return [NSString stringWithFormat:@"%.2f%@%@", dewPoint, DEGREE_UNICODE, units];
}

//dew point = 100 - humidity / 2.778 for fahrenheit
- (id) previewControlForItem: (long)row
{
	
	id theLocation = [[self locations] objectAtIndex:row];
	//NSLog(@"theLocation: %@", theLocation);
	if ([theLocation isEqualToString:@"addnew"])
		return [self ogpreviewControlForItem:row];
	
	id currentAsset = [[objc_getClass("ntvMedia") alloc] init];
		id currentUnit = [[self units] objectAtIndex:row];
	
	NSURL *theUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?p=%@&u=%@", theLocation,currentUnit]];
	
	NSString *theString = [NSString stringWithContentsOfURL:theUrl encoding:NSUTF8StringEncoding error:nil];
	
	
	
	APDocument *xmlDoc = [APDocument documentWithXMLString:theString];

	NSDictionary *weatherInfo = [%c(ntvWeatherManager) parseYahooRSS:xmlDoc];
	//NSLog(@"weatherInfo: %@", weatherInfo);
	
	if (weatherInfo == nil)
	{
		[currentAsset release];
		return [self ogpreviewControlForItem:row];
	}
	
	[currentAsset setTitle:BRLocalizedString(@"Current Conditions",@"Current Conditions" )];
	int code = [[weatherInfo valueForKey:@"code"] intValue];
	NSString *weatherTemp = [weatherInfo valueForKey:@"temp"];
	NSString *units = [weatherInfo valueForKey:@"temperature"];
	NSString *text = [weatherInfo valueForKey:@"text"];
	int windDegree = [[weatherInfo valueForKey:@"direction"] intValue];
	NSString *region = [weatherInfo valueForKey:@"region"];
	NSString *city = [weatherInfo valueForKey:@"city"];
	NSString *date = [weatherInfo valueForKey:@"date"];
	NSString *dewPoint = [self complicatedDewPointFromDict:weatherInfo];
	if ([region length] == 0)
		region = [weatherInfo valueForKey:@"country"];
		
	NSString *direction = [%c(ntvWeatherManager) windDirectionFromInt:windDegree];
	//NSLog(@"windDegree: %i", windDegree);
	NSString *summary = [NSString stringWithFormat:@"%@%@%@ - %@", weatherTemp, DEGREE_UNICODE,units, text];
	[currentAsset setSummary:summary];
	id sp = [self altImageForCode:code];
	[currentAsset setCoverArt:sp];
	NSString *speedU = [weatherInfo valueForKey:@"speedU"];
	NSString *speed = [weatherInfo valueForKey:@"speed"];
	NSString *humidity = [NSString stringWithFormat:@"%@%%", [weatherInfo valueForKey:@"humidity"]];
	NSString *wind = [NSString stringWithFormat:@"from %@ at %@ %@", direction, speed, speedU]; 
	NSMutableArray *customKeys = [[NSMutableArray alloc] init];
	NSMutableArray *customObjects = [[NSMutableArray alloc] init];
	
	[customKeys addObject:BRLocalizedString(@"Dew Point", @"Dew Point")];
	[customObjects addObject:dewPoint];
	
	[customKeys addObject:BRLocalizedString(@"Humidity", @"Humidity")];
	[customObjects addObject:humidity];
	
	[customKeys addObject:BRLocalizedString(@"Wind",@"Wind")];
	[customObjects addObject:wind];
	
	[customKeys addObject:BRLocalizedString(@"Location", @"Location")];
	[customObjects addObject:[NSString stringWithFormat:@"%@, %@", city, region]];
	
	[customKeys addObject:BRLocalizedString(@"Date", @"Date")];
	[customObjects addObject:date];
	
	[currentAsset setCustomKeys:[customKeys autorelease] 
					 forObjects:[customObjects autorelease]];
	
	
	id preview = [[objc_getClass("ntvMediaPreview") alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	
	return [preview autorelease];
}

%new - (id) ogpreviewControlForItem: (long) item

{
	
	Class briaspc = objc_getClass("BRImageAndSyncingPreviewController");
	
	if (briaspc == nil)
		return nil;
	
	id sp = [[NitoTheme sharedTheme] weatherImage];
	id obj = [[briaspc alloc] init];
	
	[obj setImage:sp];
	
	return ([obj autorelease]);
	
}




%new - (void)reloadWeatherFile
{
	NSString *weatherFile = [NSBundle userWeatherFileLocation];
	if ([[NSFileManager defaultManager] fileExistsAtPath:weatherFile])
	{
		[[self globalDict] removeAllObjects];
		[[self globalDict] addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:weatherFile]];
	}
	
}


%new - (id) initWithArray: (NSArray *) inputArray state: (int) listState andTitle:(NSString *)theTitle
{

	progressRow = -1;
	if ( [self init] == nil )
		return ( nil );
	

	
	id sp = [[NitoTheme sharedTheme] weatherImage];
	[self setListTitle:theTitle];
	[self setListIcon:sp horizontalOffset:0.25 kerningFactor:0.1];
	
		//_mainTitle = theTitle;

	[self setMainTitle:theTitle];
	NSMutableArray *_names = [[NSMutableArray alloc] init];
	NSMutableArray *_locations = [[NSMutableArray alloc] init];
	NSMutableArray *_units = [[NSMutableArray alloc] init];
	NSMutableArray *_locationDicts = [[NSMutableArray alloc] init];
	_listState = listState;
	
	NSString *theDest = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
	NSString *weatherFile = [theDest stringByAppendingPathComponent:@"com.nito.nitoTV.weather.plist"];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:weatherFile])
		weatherFile = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"weather" ofType:@"plist"];
	
	NSMutableDictionary *_globalDict = [[NSMutableDictionary alloc] initWithContentsOfFile:weatherFile];

		int feedCount = [[_globalDict allKeys] count];
	int i;
	NSString *currentName = nil;
	id currentItem = nil;
	NSString *currentKey = nil;
	NSString *currentLocale = nil;
	NSString *currentUnit = nil;
	
	
			for (i = 0; i < feedCount; i++)
			{
				NSDictionary *dict;
				currentKey = [[_globalDict allKeys] objectAtIndex:i];
				currentItem = [_globalDict valueForKey:currentKey];
				//NSLog(@"currentItem: %@", currentItem);
				currentName = [currentItem valueForKey:@"name"];
				currentLocale = [currentItem valueForKey:@"location"];
				currentUnit = [currentItem valueForKey:@"units"];
				dict = [NSDictionary dictionaryWithObjectsAndKeys:currentName, @"name", currentLocale, @"location", currentUnit, @"units", currentName, @"key", nil];
			
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
	
	for (k = 0; k < [sortedArray count]; k++)
	{
		currentItem = [sortedArray objectAtIndex:k];
		//NSLog(@"currentItem: %@", currentItem);
		currentName = [currentItem valueForKey:@"name"];
		currentLocale = [currentItem valueForKey:@"location"];
		currentUnit = [currentItem valueForKey:@"units"];
		[_names addObject:currentName];
		[_locations addObject:currentLocale];
		[_units addObject:currentUnit];
	}
	
	
	[_names addObject:BRLocalizedString(@"Add Weather Location", @"Add Weather Location")];
	
	[_locations addObject:@"addnew"];
	
	
	[self setLocations:_locations];
	[self setUnits:_units];
	[self setNames:_names];
	[self setLocationDicts:_locationDicts];
	[self setGlobalDict:_globalDict];
	
	[[self list] setDatasource:self];
	long theCount = (long)[self controlCount];
	[[self list] addDividerAtIndex:theCount - 1 withLabel:@"Options"];	
	
	return ( self );
}


%new - (void)refresh
{
	id _globalDict = [self globalDict];
	[self reloadWeatherFile];
	[[self names] removeAllObjects];
	[[self locations] removeAllObjects];
	[[self units] removeAllObjects];
	[[self locationDicts] removeAllObjects];
	[[self list] removeDividers];


	int feedCount = [[_globalDict allKeys] count];
	int i;
	NSString *currentName = nil;
	id currentItem = nil;
	NSString *currentKey = nil;
	NSString *currentLocale = nil;
	NSString *currentUnit = nil;
	
	
	for (i = 0; i < feedCount; i++)
	{
		NSDictionary *dict;
		currentKey = [[_globalDict allKeys] objectAtIndex:i];
		currentItem = [_globalDict valueForKey:currentKey];
		//NSLog(@"currentItem: %@", currentItem);
		currentName = [currentItem valueForKey:@"name"];
		currentLocale = [currentItem valueForKey:@"location"];
		currentUnit = [currentItem valueForKey:@"units"];
		dict = [NSDictionary dictionaryWithObjectsAndKeys:currentName, @"name", currentLocale, @"location", currentUnit, @"units", currentName, @"key", nil];
		
		[[self locationDicts] addObject:dict];
	}
	
	NSArray *sortedArray;
	NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES
									selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	
	
	NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
	
	sortedArray = [[self locationDicts] sortedArrayUsingDescriptors:descriptors];
	
	//NSLog(@"sortedArray: %@", sortedArray);
	
	
	int k;
	
	for (k = 0; k < [sortedArray count]; k++)
	{
		currentItem = [sortedArray objectAtIndex:k];
		//NSLog(@"currentItem: %@", currentItem);
		currentName = [currentItem valueForKey:@"name"];
		currentLocale = [currentItem valueForKey:@"location"];
		currentUnit = [currentItem valueForKey:@"units"];
		[[self names] addObject:currentName];
		[[self locations] addObject:currentLocale];
		[[self units] addObject:currentUnit];
	}

	
	[[self names] addObject:BRLocalizedString(@"Add Weather Location", @"Add Weather Location")];
	
	[[self locations] addObject:@"addnew"];
	
	long theCount = (long)[self controlCount];
	[[self list] addDividerAtIndex:theCount - 1 withLabel:@"Options"];
	[[self list] reload];
	
}



%new - (BOOL)rowSelectable:(long)row
{
	return YES;
}


- (BOOL)brEventAction:(id)fp8
{
	long itemCount = (long)[[[self list] datasource] itemCount];
	//NSLog(@"%@ %s", self, _cmd);
	
	
	//return %orig;
	
	long currentRow;
	int theAction = (int)[fp8 remoteAction];
	
	//ushort theUsage = [fp8 usage];
	int theValue = (int)[fp8 value];	
	//NSLog(@"action: %@", fp8);
	
	switch (theAction)
	{
		case kBREventRemoteActionMenu:
			
			return NO;
			
		case kBREventRemoteActionRight:
			
			currentRow = (long)[self getSelection];
	
			
			return (BOOL)(long)(void *)[self rightAction:currentRow];
			
			
			break;
			
		case kBREventRemoteActionUp:
			
			if((int)[self getSelection] == 0 && theValue == 1)
			{
				[self setSelection:itemCount-1];
				//[self updatePreviewController];
				return YES;
			}
			%orig;
			
			
			break;
			
		case kBREventRemoteActionDown: 
			
			if((int)[self getSelection] == itemCount-1 && theValue == 1)
			{
				[self setSelection:0];
				//[self updatePreviewController];
				return YES;
			}
			%orig;
			
			
			break;
			
		default:
			
			%orig;
			break;
	}
	return YES;
}

	

/*
- (void) dealloc
{
	
	//[_names release];
	[_locations release];
	[_locationDicts release];
	[_units release];
	
	[super dealloc];
}
*/
%new - (NSString *)titleForRow:(long)row {
	if(row < [[self names] count]) {
		return [[self names] objectAtIndex:row];
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
	return [[self names] count];
}



%new - (long) controlCount
{

		return ( [[self names] count] );
	
}

%new - (id) controlAtIndex: (long) row requestedBy:(id)fp12
{
	if ( row > [[self names] count] )
		return ( nil );
	
	//NSLog(@"%@ %s", self, _cmd);
	
	
	id result = nil;
	NSString *theTitle = [[self names] objectAtIndex: row];
	
	if (row == progressRow) {
		result = [objc_getClass("nitoMenuItem") ntvProgressMenuItem];
	} else {
		result = [objc_getClass("nitoMenuItem") ntvFolderMenuItem];
	}
	
	[result setText:theTitle withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemTextAttributes]];			
	//[result addAccessoryOfType:1];
	
	
	return ( result );
}

- (void)controlWasActivated
{
	progressRow = -1;
	[[self list] reload];
	%orig;
}


/*
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

*/

#define XMLATSTR(dict,element,key)    [(dict) setObject:[(element) valueForAttributeNamed:(key)]forKey:(key)]
#define XMLATSTRK(dict,element,key,keyt)    [(dict) setObject:[(element) valueForAttributeNamed:(key)] forKey:(keyt)]



%new +(NSDictionary *)parseYahooRSS:(APDocument*)apDoc
{
	id rootElt = [[[apDoc rootElement] childElements] objectAtIndex:0];
	

	NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    id val =[rootElt firstChildElementNamed:@"yweather:location"];

	if (val != nil)
	{
		XMLATSTR(dict,val,@"city");
        XMLATSTR(dict,val,@"region");
        XMLATSTR(dict,val,@"country");
	}
	
	val = [rootElt firstChildElementNamed:@"yweather:units"];
	
	if (val != nil)
    {
        XMLATSTR(dict,val,@"temperature");
        XMLATSTR(dict,val,@"distance");
        XMLATSTRK(dict,val,@"pressure",@"pressureU");
        XMLATSTRK(dict,val,@"speed",@"speedU");
    }
	
	val = [rootElt firstChildElementNamed:@"yweather:wind"];
  
	if (val != nil)
    {
     
        XMLATSTR(dict,val,@"chill");
        XMLATSTR(dict,val,@"direction");
        XMLATSTR(dict,val,@"speed");
    }
	
	val = [rootElt firstChildElementNamed:@"yweather:atmosphere"];
    if (val != nil)
    {
 
        XMLATSTR(dict,val,@"humidity");
        XMLATSTR(dict,val,@"visibility");
        XMLATSTR(dict,val,@"pressure");
        XMLATSTR(dict,val,@"rising");
    }
    val = [rootElt firstChildElementNamed:@"yweather:astronomy"];
	if (val != nil)
    {
      
        XMLATSTR(dict,val,@"sunrise");
        XMLATSTR(dict,val,@"sunset");
    }
	
	val=[rootElt firstChildElementNamed:@"item"];
    //NSLog(@"val: %@",val);
    if (val != nil) {
        APElement *elt = val;
        val=[elt firstChildElementNamed:@"yweather:condition"];
        if (val!=nil) {
       
            XMLATSTR(dict,val,@"text");
            XMLATSTR(dict,val,@"code");
            XMLATSTR(dict,val,@"temp");
            XMLATSTR(dict,val,@"date");
        }
		
		val=[elt firstChildElementNamed:@"title"];
		
		if(val!=nil)
        {
			NSString *title=[val value];
			[dict setObject:title forKey:@"title"];
			//NSLog(@"elt2: %@", elt2);
		}
		
		
		val=[elt childElements:@"yweather:forecast"];
		//NSLog(@"yweather:forecast childElements: %@", val);
        if ([val count] > 0)
        {
            NSMutableArray *forecasts=[[NSMutableArray alloc]init];
            int i;
            for(i=0;i<[val count];i++)
            {
                NSMutableDictionary *tempDict=[[NSMutableDictionary alloc]init];
                APElement *elt2=[val objectAtIndex:i];
                XMLATSTR(tempDict,elt2,@"day");
                XMLATSTR(tempDict,elt2,@"date");
                XMLATSTR(tempDict,elt2,@"low");
                XMLATSTR(tempDict,elt2,@"high");
                XMLATSTR(tempDict,elt2,@"text");
                XMLATSTR(tempDict,elt2,@"code");
                [forecasts addObject:tempDict];
				[tempDict release];
            }
            [dict setObject:forecasts forKey:@"forecast"];
			[forecasts release];
        }
	}
	//NSLog(@"dict; %@", dict);
	
	return [dict autorelease];
}


%new - (void)bunkZip
{
	id alertCon = [%c(BRAlertController) alertOfType:0 titled:BRLocalizedString(@"Weather Retrieval Failed", @"alert for when weather retrieve failed") primaryText:BRLocalizedString(@"Weather retrieval failed, possibly a bad or incomplete zip code.", @"primary text for bad zip") secondaryText:BRLocalizedString(@"Popping in 3 Seconds", @"secondary text for bad zip alert")];
	[alertCon retain];
	[[self stack] pushController:alertCon];
	[self performSelector:@selector(popAlert:) withObject:alertCon afterDelay:3.0];
}

- (void) itemSelected: (long) row
{
	progressRow = row;
	[[self list] reload];
	id theLocation = [[self locations] objectAtIndex:row];
	
	if ([theLocation isEqualToString:@"addnew"])
	{
		// do stuff
		NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:@"New Location", @"name", @"94089", @"location", @"f", @"units", nil];


		id weatherController = [[%c(nitoWeatherController) alloc] initWithWeather:tempDict withMode:0];
		
		[weatherController autorelease];
		[weatherController setParentController:self];
		[[self stack] pushController:weatherController];
		return;
	}
	id currentUnit = [[self units] objectAtIndex:row];
	
	
	NSURL *theUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?p=%@&u=%@", theLocation,currentUnit]];
	
		//NSString *theString = [NSString stringWithContentsOfURL:theUrl];
	
	NSString *theString = [NSString stringWithContentsOfURL:theUrl encoding:NSUTF8StringEncoding error:nil];
	
	APDocument *xmlDoc = [APDocument documentWithXMLString:theString];
	
	
	NSDictionary *weatherInfo = [%c(ntvWeatherManager) parseYahooRSS:xmlDoc];
	
	id viewController = [[objc_getClass("ntvWeatherViewer") alloc] initWithDictionary:weatherInfo];
	
	NSLog(@"viewController: %@", viewController);
	
	[[self stack] pushController:viewController];
	[viewController release];
	
	
	
}



%new - (BOOL)mediaPreviewShouldShowMetadata
{
	return FALSE;
}


%end
