
	//#import "nitoFilesController.h"
#import "CPlusFunctions.mm"
#import "ntvWeatherManager.h"
#import "ntvRssBrowser.h"
#import "nitoSettingsController.h"
#import "nitoInstallManager.h"
#import "queryMenu.h"
#import "packageManagement.h"
#import "nitoManageMenu.h"


#define FILES_ID @"ntvFileIdentifier"
#define STREAMS_ID @"ntvStreamsIdentifier"
#define RECENT_ID @"ntvRecentFileIdentifier"
#define PLAYLIST_ID @"ntvPlaylistIdentifier"
#define NETWORK_ID @"ntvNetworkIdentifier"
#define SETTINGS_ID @"ntvSettingsIdentifier"
#define RSS_ID @"ntvRSSIdentifier"
#define WEATHER_ID @"ntvWeatherIdentifier"
#define ABOUT_ID @"ntvAboutIdentifier"
#define SOFTWARE_ID @"ntvSoftwareIdentifier"
#define SOURCES_ID @"ntvSourceIdentifier"

#define SOFTWARE_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Install Software", @"Install Software") identifier:SOFTWARE_ID preferredOrder:0]
#define SOURCES_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Manage", @"Manage") identifier:SOURCES_ID preferredOrder:7]
#define FILES_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Files", @"Files") identifier:FILES_ID preferredOrder:0]
#define STREAMS_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Streams", @"Streams") identifier:STREAMS_ID preferredOrder:1]
#define RECENT_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Recent Files", @"Recent Files") identifier:RECENT_ID preferredOrder:2]
#define PLAYLIST_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Playlists", @"Playlists") identifier:PLAYLIST_ID preferredOrder:3]
#define NETWORK_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Network", @"Network") identifier:NETWORK_ID preferredOrder:4]
#define WEATHER_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Weather",@"Weather" ) identifier:WEATHER_ID preferredOrder:5]
#define RSS_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"RSS Feeds", @"RSS Feeds") identifier:RSS_ID preferredOrder:6]
#define SETTINGS_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"Settings", @"Settings") identifier:SETTINGS_ID preferredOrder:8]
#define ABOUT_CAT [BRApplianceCategory categoryWithName:BRLocalizedString(@"About", @"About") identifier:ABOUT_ID preferredOrder:9]

	//plutil -setvalue 1 -key notificationHooker /var/mobile/Library/Preferences/com.nito.nitoTV.plist


//plutil -setvalue 0 -key notificationHooker /var/mobile/Library/Preferences/com.nito.nitoTV.plist

@interface NTVApplianceInfo : BRApplianceInfo
@end

@implementation NTVApplianceInfo

- (NSString*)key
{
	return [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
}

- (NSString*)name
{
	return [[[NSBundle bundleForClass:[self class]] localizedInfoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
}

- (id)localizedStringsFileName
{
	return @"NitoTVLocalizable";
}

@end

@protocol BRTopShelfController <NSObject>
- (void)refresh;
-(id)topShelfView;
-(void)selectCategoryWithIdentifier:(id)identifier;
@end

@interface BRTopShelfView (specialAdditions)

- (BRImageControl *)productImage;

@end


@implementation BRTopShelfView (specialAdditions)

- (BRImageControl *)productImage
{
	//return nil;
	return MSHookIvar<BRImageControl *>(self, "_productImage");
}

@end


@interface NITOTVTopShelfController : NSObject <BRTopShelfController> {

}
- (void)refresh;

- (void)selectCategoryWithIdentifier:(id)identifier;
- (id)topShelfView;
@end

@implementation NITOTVTopShelfController


- (void)selectCategoryWithIdentifier:(id)identifier {
	
}

- (void)refresh
{
	
}


- (id)mainMenuShelfView
{
	return [self topShelfView];
}

- (BRTopShelfView *)topShelfView {
	
	BRTopShelfView *topShelf = [[BRTopShelfView alloc] init];
	//NSLog(@"shelf: %@", [topShelf shelf]);
	//return topShelf;
	BRImageControl *imageControl = [topShelf productImage];
	BRImage *gpImage = [BRImage imageWithPath:[[NSBundle bundleForClass:[nitoSettingsController class]] pathForResource:@"nitoTV" ofType:@"png"]];
	if ([imageControl respondsToSelector:@selector(setImage:)])
	{
		[imageControl setImage:gpImage];
	}
	
	//[topShelf setState:1];
	//[topShelf _dumpControlTree];
	return topShelf;
}

@end



@interface nitoTVAppliance : BRBaseAppliance {
	
	NITOTVTopShelfController *_topShelfController;
	NSArray *_applianceCategories;
}
@property(nonatomic, readonly, retain) id topShelfController;
+ (void)installFiles;
+ (void)updateAwkwardRepo;
+ (void)updatePrefs;
+ (NSString *)buildVersion;
+ (void)addNitoRepo;
+ (void)addXBMCRepo;
+ (void)fix44Betas;
+ (void)fixFourPointThree;

@end

@implementation nitoTVAppliance
@synthesize topShelfController = _topShelfController;

- (BRApplianceInfo*)applianceInfo
{
	if ([packageManagement ntvFivePointOnePlus])
		return [[[NTVApplianceInfo alloc] init] autorelease];
	else
		return [super applianceInfo];
}

/*
+(void)wifiObserver:(id)sender
{
	if ([[sender name] isEqualToString:@"CPNetworkObserverNetworkReachableNotification"])
	{
		id userInfo = [sender userInfo];
		int reachableValue = [[userInfo valueForKey:@"CPNetworkObserverReachable"] intValue];
			//if (reachableValue == 0)
			//{
			NSLog(@"rejoining network");
			[NSTimer scheduledTimerWithTimeInterval:3 target: self selector: @selector(delayNetworkSetup) userInfo: nil repeats: NO];
			//}
		
	}
		//NSLog(@"observin shit!: %@", sender);
}

+ (void)networkingShit
{
		BRIPConfiguration *current = [BRIPConfiguration currentConfiguration];
		[BRIPConfiguration startMonitoringNetworkChanges:TRUE];
		NSLog(@"wireless network: %@",current );
		Class NCN = NSClassFromString(@"CPNetworkObserver");
		//Class nsns = NSClassFromString(@"NSNetworkSettings");
		id sn = [NCN sharedNetworkObserver];
		[sn addWiFiObserver:self selector:@selector(wifiObserver:)];
		[sn addNetworkReachableObserver:self selector:@selector(wifiObserver:)];	
		//NSLog(@"sharedNetworkObserver: %@", sn);
		//NSLog(@"sharedNetworkSettings: %@", [nsns sharedNetworkSettings]);
	
		//Class cls = NSClassFromString(@"CPNetworkObserver");
		//id theObject = [cls sharedNetworkObserver];
		[NSTimer scheduledTimerWithTimeInterval:3 target: self selector: @selector(delayNetworkSetup) userInfo: nil repeats: NO];
}
*/


	/* 

	 locations of interest: /var/cache/apt/archives/ 
							/var/lib/apt/lists/ (_Packages files)
	 
	 [BRSoundHandler playSound:0] = pop sound (popping off a controller from menu)
	 [BRSoundHandler playSound:1] = push sound (pushing a new controller on the stack from select/play)
	 [BRSoundHandler playSound:15] = item navigation (left right up down)
	 [BRSoundHandler playSound:16] = fail sound (also 17 and 18)
	 
	 */





+ (void)initialize {
	
	NSLog(@"NITOTV INITIALIZE");

		//	NSLog(@"ALERT: mobilesubstrate DEPENDANTS: %@", depends);
	[nitoTVAppliance installFiles];
		//[packageManagement testPrintList];
		//[packageManagement updatePackageList];
		//[nitoTVAppliance checkForUpdate];
		//[nitoTVAppliance networkingShit];
	
	/*
	BOOL setupDone = [[BRPreferences sharedFrontRowPreferences] boolForKey:@"ATVSetupDone"];
	BOOL ATVSkipHDCPCheck = [[BRPreferences sharedFrontRowPreferences] boolForKey:@"ATVSkipHDCPCheck"];
	BOOL ATV_NO_SLEEP_OR_WATCHDOG = [[BRPreferences sharedFrontRowPreferences] boolForKey:@"ATV_NO_SLEEP_OR_WATCHDOG"];
	BOOL DEBUGONLYShouldAdjustWirelessPower = [[BRPreferences sharedFrontRowPreferences] boolForKey:@"DEBUGONLYShouldAdjustWirelessPower"];
	BOOL kSettingsForgetNetworkAvailable = [[BRPreferences sharedFrontRowPreferences] boolForKey:@"kSettingsForgetNetworkAvailable"];
	if (kSettingsForgetNetworkAvailable == TRUE)
	{
		[[BRPreferences sharedFrontRowPreferences] setBool:FALSE forKey:@"kSettingsForgetNetworkAvailable"];
	} else {
		NSLog(@"dont forget!!!");
	}
	if (DEBUGONLYShouldAdjustWirelessPower == TRUE)
	{
		NSLog(@"fucking with your wireless!!!");
		[[BRPreferences sharedFrontRowPreferences] setBool:FALSE forKey:@"DEBUGONLYShouldAdjustWirelessPower"];
	}
	if (ATVSkipHDCPCheck == TRUE)
	{
		NSLog(@"skip check");
	} else {
		[[BRPreferences sharedFrontRowPreferences] setBool:TRUE forKey:@"ATVSkipHDCPCheck"];
	}
	if (setupDone == TRUE)
	{
		NSLog(@"setupDone!");
	} else {
		[[BRPreferences sharedFrontRowPreferences] setBool:TRUE forKey:@"ATVSetupDone"];
	}
	if (ATV_NO_SLEEP_OR_WATCHDOG == TRUE)
	{
		NSLog(@"no sleep/dog?");
	} else {
			[[BRPreferences sharedFrontRowPreferences] setBool:TRUE forKey:@"ATV_NO_SLEEP_OR_WATCHDOG"];
	}
	 */
		//[nitoTVAppliance setInteger:1 forKey:@"notificationHooks"];
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"com.apple.CoreAnimation.CAWindowServer.DisplayChanged" object:nil];
}

	//_kRUIWiFiSetupSucceeded




+ (void)installFiles
{
	
	//
	[nitoTVAppliance updateAwkwardRepo];
	[nitoTVAppliance addNitoRepo];
	[nitoTVAppliance addXBMCRepo];
	[nitoTVAppliance fixFourPointThree];
		//[nitoTVAppliance fix44Betas];
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *localWeather = [NSBundle userWeatherFileLocation];
	NSString *weatherPath = [NSBundle weatherFileLocation];

	if (![man fileExistsAtPath:localWeather])
		[man copyItemAtPath:weatherPath toPath:localWeather error:nil];
	
	NSString *rssPath = [NSBundle rssFileLocation];
	NSString *localRss = [NSBundle userRssFileLocation];	
	
	if (![man fileExistsAtPath:localRss])
		[man copyItemAtPath:rssPath toPath:localRss error:nil];
	
	[nitoTVAppliance updatePrefs];
	int noteHooks = [[nitoDefaultManager preferences] integerForKey:@"notificationHooker"];
		//NSLog(@"noteHooks: %i", noteHooks);
	
	if (noteHooks == 1)
	{	
			//NSLog(@"hookNotifications");
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hookNotifications:) name:nil object:nil];

	}
		//NSString *lastSelfUpdateCheck = [FR_PREF stringForKey:LAST_UPDATE_CHECK];
	
	int updateCheckFrequency = [[nitoDefaultManager preferences] integerForKey:UPDATE_CHECK_FREQUENCY];
	
	if (updateCheckFrequency == 0)
	{
		[[nitoDefaultManager preferences] setInteger:HOUR_MINUTES forKey:UPDATE_CHECK_FREQUENCY];
	}
	
	
	NSString *lastSelfUpdateCheck = [[nitoDefaultManager preferences] objectForKey:LAST_UPDATE_CHECK];
		//NSLog(@"lsuc: %@", lsuc);

	if (lastSelfUpdateCheck == nil)
	{
		NSLog(@"never checked before, set old date!!!");
		
			//	NSDateFormatter *df = [[NSDateFormatter alloc] init];
			//[df setDateFormat:@"MMddyy_HHmmss"];
			//	NSString *newDate = [df stringFromDate:[NSDate distantPast]];
		
		NSLog(@"update date with value: 090410_022230");
			//[FR_PREF setObject:@"090410_022230" forKey:LAST_UPDATE_CHECK];
		[[nitoDefaultManager preferences] setObject:@"090410_022230" forKey:LAST_UPDATE_CHECK];
		
			//[df release];
	}
	
	NSArray *sectionList = [[nitoDefaultManager preferences] objectForKey:SECTION_LIST];
	

	if (sectionList == nil)
	{
		sectionList = [packageManagement kosherSections];
		NSLog(@"set section list: %@", sectionList);
		[[nitoDefaultManager preferences] setObject:sectionList forKey:SECTION_LIST];
	}
		//[[BRDisplayManager sharedInstance] _displayModeDidChange];
	
	//if ([[BRDisplayManager sharedInstance] respondsToSelector:@selector(setColorMode:)])
//	{
//		[[BRDisplayManager sharedInstance] setColorMode:3];
//		[[BRDisplayManager sharedInstance] setColorMode:0];
//	}
		//[[BRDisplayManager sharedInstance] setColorMode:];
		
	
	//BRPreferences *thePrefs = [BRPreferences sharedFrontRowPreferences];
//	NSDate *future = [NSDate distantFuture];
//	[thePrefs setObject:future forKey:@"RUISWUpdateLastCheckDate"];
//	id object = [thePrefs objectForKey:@"RUISWUpdateLastCheckDate"];
//	NSLog(@"RUISWUpdateLastCheckDate: %@", object);
	//NSLog(@"theData: %@", theData);
//	if (theData != nil)
//	{
//		NSLog(@"Raw string is '%s' (length %d)\n", [theData bytes], [theData length]);
//		NSString *theString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
//		NSLog(@"theString: %@", theString);
//	}
//	
	
	//BRAirportNetworkScanResultsAvailable
//	NSLog(@"theNetwork: %@", [BRAirportNetwork asyncNetworkWithName:@"Apple Network" error:nil]);
	//[BRAirportManager associateWithNetwork:theNetwork password:nil error:nil];
	
	/*
	NSString *preferences = @"/Library/Preferences/SystemConfiguration";
	NSString *theDest = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/bootback"];
	NSArray *contents = [man contentsOfDirectoryAtPath:preferences error:nil];
	if (![man fileExistsAtPath:theDest])
	{
		[man createDirectoryAtPath:theDest attributes:nil];
	} else {
		[man removeItemAtPath:theDest error:nil];
		[man createDirectoryAtPath:theDest attributes:nil];
	}
	//NSLog(@"contents: %@", contents);
	for (id currentItem in contents)
	{
		NSString *fullPath = [preferences stringByAppendingPathComponent:currentItem];
		NSString *finalPath = [theDest stringByAppendingPathComponent:currentItem];
		[man copyItemAtPath:fullPath toPath:finalPath error:nil];
	}
	*/
}


/*
void LogIt (NSString *format, ...)
{
    va_list args;
	
    va_start (args, format);
	
    NSString *string;
	
    string = [[NSString alloc] initWithFormat: format  arguments: args];
	
    va_end (args);
	
    printf ("%s", [string cString]);
	
    [string release];
	
} // LogIt

 */

 
+ (NSArray *)otherBlackList
{
	NSArray *blacklistNote = [NSArray arrayWithObjects:@"NSHTTPCookieManagerCookiesChangedNotification", nil];
	return blacklistNote;
}

+ (NSArray *)blacklistNotifications
{
	NSArray *blacklistNote = [NSArray arrayWithObjects:@"kBRControlFocusWillChangeNotification", @"kBRControlFocusChangedNotification", @"dataclientstatechanged", @"music.store.root.collection.updated", @"BRURLDocumentReadyNotification", @"BRTaskCompleteNotification", @"BRAccountDirtyNotification", @"dataclientstatechanged", @"BRRentalRefreshCompleteNotification", @"NSHTTPCookieManagerCookiesChangedNotification", @"BRAirportNetworkScanResultsAvailable", @"kBRControlFocusCursorFrameChangedNotification", @"dataclientupdate", @"BRAccountAuthenticationSucceededNotification", @"BRApplianceChangedNotification", @"BRProviderDataSetChangedNotification", @"TaskManagerCompletedTaskNotification", @"music.store.loadstate.changed", @"_NSThreadDidStartNotification", @"BRFeatureEnabledNotification", @"kBRScrollControlScrollInitiated", @"kBRScrollControlScrollCompleted", nil];
	return blacklistNote;
}

+ (void)ssnote:(NSNotification *)n
{
	id object = [n object];
	NSString *name = [n name];
		//NSLog(@"NAME BITCHES: %@", name);
	if (object != nil && [name isEqualToString:@"kBRScreenSaverDismissed"])
	{
		NSLog(@"object: %@", object);
			//id plugin = MSHookIvar<id>(object, "_plugin");
			//NSLog(@"plugin: %@", plugin);
	}
}

+ (void)hookNotifications:(NSNotification *)n
{
	//NSLog(@"%@", n);
	id object = [n object];
	NSString *name = [n name];
	if ([name isEqualToString:@"BRRemotePromptUpdateNotification"])
	{
		NSLog(@"N %@:", n);
	}
	if (object != nil && name != nil)
	{
			if (![[nitoTVAppliance otherBlackList] containsObject:name])
			
			{
			
			Class cls = [object superclass];
			Class cls2 = [object class];
			NSString *objectSuperName = NSStringFromClass(cls);
			NSString *objectName = NSStringFromClass(cls2);
			//NSLog(@"NOTIFICATION_HOOK: %@ class: %@ superclass: %@", name, objectName, objectSuperName);
		NSString *notifcationLog = [NSString stringWithFormat:@"NOTIFICATION: name: %@ object: %@ class: %@ superclass: %@", name, object, objectName, objectSuperName];
		NSLog(@"%@", notifcationLog);
			//printf ("%s", [notifcationLog cString]);
			//LogIt(notifcationLog);
			//NSLog(@"superclass name: %@", objectSuperName);
				//NSLog(@"class name: %@", objectName);
			
			}
			
		//LogIt(@"NOTIFICATION: name: %@", name);
	}
}

+ (void)fix44Betas
{
		//NSLog(@"fix44Betas");
	BOOL is44 = [[nitoTVAppliance buildVersion] isEqualToString:@"5.0"];
	if (is44 == TRUE)
	{
		int sysReturn = system([@"/usr/bin/nitoHelper 50 1" UTF8String]);
		if (sysReturn == 0)
		{
			NSLog(@"killed MS in BTServer for 5.0 betas, killing lowtide!");
			[[BRApplication sharedApplication] terminate];
			
		} else {
			NSLog(@"sysReturn for 5.0 fix return nonzero, already run or failed!");
		}
	}
}

+ (void)fixFourPointThree
{
		//NSLog(@"fixFourPointThree");
	NSString *filePath = [[NSBundle bundleForClass:[nitoSettingsController class]] pathForResource:@"cydia_postinst" ofType:@""];
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt/sources.list.d/cydia.list"])
	{
		NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper fix43 %@", filePath];
			//NSLog(@"command: %@", command);
		system([command UTF8String]);
			
	}
}

+ (void)addNitoRepo
{
	NSString *nitoRepo = @"/etc/apt/sources.list.d/nito.list";
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *filePath = [[NSBundle bundleForClass:[nitoSettingsController class]] pathForResource:@"com.nito" ofType:@"deb"];
		//NSLog(@"filePath: %@", filePath);
	
	if (![man fileExistsAtPath:nitoRepo])
	{
		NSLog(@"add repo");
		NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper dpkg %@", filePath];
		int sysReturn = system([command UTF8String]);
		NSLog(@"dpkg install finished with: %i", sysReturn);
	}
}

+ (void)addXBMCRepo
{
	NSString *xbmcRepo = @"/etc/apt/sources.list.d/xbmc.list";
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *filePath = [[NSBundle bundleForClass:[nitoSettingsController class]] pathForResource:@"org.xbmc" ofType:@"deb"];
		//NSLog(@"filePath: %@", filePath);
	
	if (![man fileExistsAtPath:xbmcRepo])
	{
		NSLog(@"add xbmc repo");
		NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper dpkg %@", filePath];
		int sysReturn = system([command UTF8String]);
		NSLog(@"dpkg install finished with: %i", sysReturn);
	}
}

+ (void)updateAwkwardRepo
{
		//LogSelf;
	NSString *awkwardRepo = @"/etc/apt/sources.list.d/awkward.list";
	NSString *awkwardRepoExtra = @"/etc/apt/sources.list.d/awkwardtv.list";
	NSString *awkFile = [NSString stringWithContentsOfFile:awkwardRepo encoding:NSUTF8StringEncoding error:nil];
	//NSMutableString *awkFile = [[NSMutableString alloc] initWithContentsOfFile:awkwardRepo encoding:NSUTF8StringEncoding error:nil];
	
	NSString *sm = @"stable main";
	NSRange range = [awkFile rangeOfString: sm];
	//NSLog(@"range: %@", NSStringFromRange(range));
	//NSLog(@"NSNotFound: %i", NSNotFound);
	if ( range.location == NSNotFound || ![FM fileExistsAtPath:awkwardRepo])
	{
		NSLog(@"not found");
		NSString *command = @"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/updaterepo.sh";
		//int sysReturn = system([command UTF8String]);
		system([command UTF8String]);
		//[awkFile replaceOccurrencesOfString:@"./" withString:sm options:nil range:NSMakeRange(0, [awkFile length])];
		//[[NSFileManager defaultManager] removeItemAtPath:awkwardRepo error:nil];
		//BOOL writeFile = [awkFile writeToFile:awkwardRepo atomically:YES];
		//NSLog(@"writing file: %@ success: %@", awkFile, [NSNumber numberWithBool:writeFile]);
		//[awkFile release];
	}
	
	if ([FM fileExistsAtPath:awkwardRepoExtra])
	{
		NSLog(@"fix awkward repos");
		NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper fixRepo %@", awkwardRepoExtra];
		int sysReturn = system([command UTF8String]);
		NSLog(@"fixrepo finished with: %i", sysReturn);
	}
}

+ (void)delayNetworkSetup
{

	[BRAirportManager collectWirelessNetworks];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventOccured:) name:@"BRAirportNetworkScanResultsAvailable" object:nil];
}

+ (void)eventOccured:(NSNotification *)n
{
	BOOL internetAvailable = [BRIPConfiguration internetAvailable];
	if (internetAvailable == YES)
	{
		
		//NSLog(@"interwebz already avail, return doing nothing in the future");
		return;
	}
	
	NSString *preferences = @"/Library/Preferences/SystemConfiguration/com.apple.wifi.plist";
	NSDictionary *wifiDict = [NSDictionary dictionaryWithContentsOfFile:preferences];
	NSArray *knownNetworks = [wifiDict objectForKey:@"List of known networks"];
	NSDictionary *firstObject = [knownNetworks objectAtIndex:0];
	NSString *theString = [firstObject valueForKey:@"SSID_STR"];
	//NSLog(@"eventOccured: %@", [n object]);
	NSArray *networks = [n object];
	for (id currentItem in networks)
	{
		NSString *name = [currentItem name];
		if ([name isEqualToString:theString])
		{
			//NSLog(@"thas our guy: %@", currentItem);
			
			[BRAirportManager associateWithNetwork:currentItem password:nil error:nil];
			
		}
		
	}
}



+ (void)updatePrefs
{
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *localWeather = [NSBundle userWeatherFileLocation];
	NSString *localRss = [NSBundle userRssFileLocation];	
	
	if ([man fileExistsAtPath:localWeather])
	{
		NSMutableDictionary *weatherDict = [[NSMutableDictionary alloc] initWithContentsOfFile:localWeather];
		NSArray *keys = [weatherDict allKeys];
		NSString *firstKey = [keys objectAtIndex:0];
		if ([firstKey length] == 1)
		{
			for (id currentKey in keys)
			{
				id currentItem =  [weatherDict objectForKey:currentKey];
				NSString *name = [currentItem objectForKey:@"name"];
				[weatherDict setObject:currentItem forKey:name];
				[weatherDict removeObjectForKey:currentKey];
			}
		}
		[weatherDict writeToFile:localWeather atomically:YES];
		[weatherDict release];
	}
	
	
	if ([man fileExistsAtPath:localRss])
	{
		NSDictionary *fullDict = [NSDictionary dictionaryWithContentsOfFile:localRss];
		NSMutableDictionary *rssDict = [[NSMutableDictionary alloc] initWithDictionary:[fullDict objectForKey:@"Feeds"]];
		
		NSArray *keys = [rssDict allKeys];
		NSString *firstKey = [keys objectAtIndex:0];
		if ([firstKey length] == 1)
		{
			for (id currentKey in keys)
			{
				id currentItem =  [rssDict objectForKey:currentKey];
				NSString *name = [currentItem objectForKey:@"name"];
				[rssDict setObject:currentItem forKey:name];
				[rssDict removeObjectForKey:currentKey];
			}
		}
		NSDictionary *finalDict = [NSDictionary dictionaryWithObject:rssDict forKey:@"Feeds"];
		[finalDict writeToFile:localRss atomically:YES];
		[rssDict release];
	}
	
}

- (id)init {
	if((self = [super init]) != nil) {
		_topShelfController = [[NITOTVTopShelfController alloc] init];
		
		//_applianceCategories = [[NSArray alloc] initWithObjects:
		//			FILES_CAT,STREAMS_CAT, RECENT_CAT, PLAYLIST_CAT, NETWORK_CAT,  WEATHER_CAT, RSS_CAT, SETTINGS_CAT, ABOUT_CAT ,nil];
		
		_applianceCategories = [[NSArray alloc] initWithObjects:SOFTWARE_CAT, SOURCES_CAT, WEATHER_CAT, RSS_CAT, SETTINGS_CAT, ABOUT_CAT, nil];
		
	} return self;
}


- (id)applianceController
{
	return [[nitoInstallManager alloc] initWithTitle:BRLocalizedString(@"Install Software", @"Install Software")];
}

- (id)applianceCategories {
	return _applianceCategories;
}


-(id)controllerForIdentifier:(id)identifier
{
	return [self controllerForIdentifier:identifier args:nil];
}


- (BOOL)handleObjectSelection:(id)selection userInfo:(id)info
{
	return YES;
	
}

//- (BOOL)handlePlay:(id)play userInfo:(id)info
//{
//	return YES;
//}

- (id)identifierForContentAlias:(id)contentAlias
{
	return @"nitoTV";
}

- (id)selectCategoryWithIdentifier:(id)ident {
	//NSLog(@"selecteCategoryWithIdentifier: %@", ident);
	return nil;
}

+ (NSString *)buildVersion
{
	return [ATVVersionInfo currentOSVersion];
	//Class cls = NSClassFromString(@"ATVVersionInfo");
//	if (cls != nil)
//	{ return [cls currentOSVersion]; }
//	
	return nil;	
}

-(id)controllerForIdentifier:(id)identifier args:(id)args	// 0x315bf445
{
	
	//NSLog(@"selecteCategoryWithIdentifier: %@", ident);
	BOOL internetAvailable = [BRIPConfiguration internetAvailable];
	
	
	id menuController = nil;
	
	if ([identifier isEqualToString:SOFTWARE_ID])
	{
		menuController = [[nitoInstallManager alloc] initWithTitle:BRLocalizedString(@"Install Software", @"Install Software")];
			//BRApplicationStackManager *theStack = [BRApplicationStackManager stack];
			//	NSLog(@"stackity: %@", theStack);
	}
	
	if ([identifier isEqualToString:SOURCES_ID])
	{
		
			//FIXME: i dont know yet...
		
			//NSArray *packages = [packageManagement repoReleaseDictionaries];
	
			//menuController = [[nitoSourceController alloc] initWithTitle:BRLocalizedString(@"Manage Sources", @"Manage Sources") andSources:packages];
		
		menuController = [[nitoManageMenu alloc] initWithTitle:BRLocalizedString(@"Manage", @"Title of the menu where you browse all of your installed packages")];
		
	} else if ([identifier isEqualToString:ABOUT_ID])
	{
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"kBRSetMachineToLowPowerModeNotification" object:nil];
		NSString * path = [[NSBundle bundleForClass:[nitoSettingsController class]] pathForResource:@"About" ofType:@"txt"];
		BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
		[textControls setDocumentPath:path encoding:NSUTF8StringEncoding];
		NSString *myTitle = @"About nitoTV";
		[textControls setTitle:myTitle];
		[textControls autorelease];
		menuController =  [BRController controllerWithContentControl:textControls];
	} else if ([identifier isEqualToString:WEATHER_ID])
	{
		menuController = [[ntvWeatherManager alloc] initWithArray:nil state:nil andTitle:BRLocalizedString(@"Weather Manager", @"Title of weather menu")];
		
		if (internetAvailable == FALSE)
		{
			menuController = [BRAlertController alertOfType:1 titled:BRLocalizedString(@"Internet Unavailable", @"Internet Unavailable") primaryText:@"Configure Internet First! ktnx" secondaryText:@"Seriously... do it now"];
			
			NSLog(@"No internet for you!");
			
		}
		
	} else if ([identifier isEqualToString:RSS_ID])
	{
		
		menuController = [[ntvRssBrowser alloc] initWithArray:nil state:nil andTitle:BRLocalizedString(@"RSS Feeds", @"Title of RSS menu")];
		
		if (internetAvailable == FALSE)
		{
			menuController = [BRAlertController alertOfType:0 titled:BRLocalizedString(@"Internet Unavailable", @"Internet Unavailable") primaryText:@"Configure Internet First! ktnx" secondaryText:@"Seriously... do it now"];
			
			NSLog(@"No internet for you!");
			
		}
		
		
		
	} else if ([identifier isEqualToString:SETTINGS_ID])
	{
		menuController = [[nitoSettingsController alloc] initWithTitle:BRLocalizedString(@"Settings", @"Settings")];
		
	}
	
	
	return menuController;
	
	
}

- (id)applianceSpecificControllerForIdentifier:(id)arg1 args:(id)arg2 {
	//NSLog(@"applianceSpecificControllerForIdentifier: %@ args: %@", arg1, arg2);
	return nil;
}
- (id)localizedSearchTitle { return @"nitoTV"; }
- (id)applianceName { return @"nitoTV"; }
- (id)moduleName { return @"nitoTV"; }
- (id)applianceKey { return @"nitoTV"; }

@end





// vim:ft=objc
