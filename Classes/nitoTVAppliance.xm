
	//#import "nitoFilesController.h"
	//#import "CPlusFunctions.mm"
	//#import "ntvWeatherManager.h"
	//#import "ntvRssBrowser.h"
	//#import "nitoSettingsController.h"
	//#import "nitoInstallManager.h"
	//#import "queryMenu.h"
	#import "packageManagement.h"
	//#import "nitoManageMenu.h"


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

#define SOFTWARE_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"Install Software", @"Install Software") identifier:SOFTWARE_ID preferredOrder:0]
#define SOURCES_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"Manage", @"Manage") identifier:SOURCES_ID preferredOrder:7]
#define FILES_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"Files", @"Files") identifier:FILES_ID preferredOrder:0]
#define STREAMS_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"Streams", @"Streams") identifier:STREAMS_ID preferredOrder:1]
#define RECENT_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"Recent Files", @"Recent Files") identifier:RECENT_ID preferredOrder:2]
#define PLAYLIST_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"Playlists", @"Playlists") identifier:PLAYLIST_ID preferredOrder:3]
#define NETWORK_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"Network", @"Network") identifier:NETWORK_ID preferredOrder:4]
#define WEATHER_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"Weather",@"Weather" ) identifier:WEATHER_ID preferredOrder:5]
#define RSS_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"RSS Feeds", @"RSS Feeds") identifier:RSS_ID preferredOrder:6]
#define SETTINGS_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"Settings", @"Settings") identifier:SETTINGS_ID preferredOrder:8]
#define ABOUT_CAT [%c(BRApplianceCategory) categoryWithName:BRLocalizedString(@"About", @"About") identifier:ABOUT_ID preferredOrder:9]

	//plutil -setvalue 1 -key notificationHooker /var/mobile/Library/Preferences/com.nito.nitoTV.plist


//plutil -setvalue 0 -key notificationHooker /var/mobile/Library/Preferences/com.nito.nitoTV.plist

	//@interface NTVApplianceInfo : BRApplianceInfo
	//@end

	//@implementation NTVApplianceInfo

%subclass NTVApplianceInfo : BRApplianceInfo

- (NSDictionary *)info
{
	return [[NSBundle bundleForClass:[NitoTheme class]] infoDictionary];
}

- (NSString*)key
{
	return [[[NSBundle bundleForClass:[NitoTheme class]] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
}

- (NSString*)name
{
	return [[[NSBundle bundleForClass:[NitoTheme class]] localizedInfoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
}

- (float)preferredOrder
{
	return 0.0;
}


- (id)localizedStringsFileName
{
	return @"NitoTVLocalizable";
}

%end

%subclass nitoTopShelfView : BRTopShelfView

%new - (id)productImage
{
	return MSHookIvar<id>(self, "_productImage");
}

%end

//@protocol BRTopShelfController <NSObject>
//- (void)refresh;
//-(id)topShelfView;
//-(void)selectCategoryWithIdentifier:(id)identifier;
//@end


@interface NITOTVTopShelfController : NSObject  {

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

- (id )topShelfView {
	
	id topShelf = [[%c(nitoTopShelfView) alloc] init];
	//NSLog(@"shelf: %@", [topShelf shelf]);
	//return topShelf;
	id imageControl = [topShelf productImage];
	id gpImage = [%c(BRImage) imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"nitoTV" ofType:@"png"]];
	if ([imageControl respondsToSelector:@selector(setImage:)])
	{
		[imageControl setImage:gpImage];
	}
	
	//[topShelf setState:1];
	//[topShelf _dumpControlTree];
	return topShelf;
}

@end


static char const * const ntvTopShelfControllerKey = "nTopShelfController";
static char const * const ntvApplianceCategoriesKey = "nApplianceCategories";

	/*
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
*/

%subclass nitoTVAppliance : BRBaseAppliance

	//@implementation nitoTVAppliance
	//@synthesize topShelfController = _topShelfController;

- (id)applianceInfo
{
	if ([packageManagement ntvFivePointOnePlus])
	{	
		return [[[%c(NTVApplianceInfo) alloc] init] autorelease];
		
	}
	else 

		{
			
				//NSDictionary *infoDict = [[NSBundle bundleForClass:[MDefaultManager class]] infoDictionary];
			
				//	Class cls = objc_getClass("MaintApplianceInfoOld");
				//NSLog(@"cls: %@", cls);
				//	return [[[cls alloc] initWithDictionary:infoDict] autorelease];
			
				//NSLog(@"orig: %@", %orig);
			
			id original = %orig;
			id info =  MSHookIvar<id>(original, "_info");
				//	NSLog(@"info: %@", info);
			id myId = [[[NSBundle bundleForClass:[nitoDefaultManager class]] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
			id myName = [[[NSBundle bundleForClass:[nitoDefaultManager class]] localizedInfoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
			[info setObject:@"nitoTV" forKey:@"CFBundleName"];
			[info setObject:myName forKey:@"FRApplianceName"];
			[info setObject:myId forKey:@"CFBundleIdentifier"];
			[info setObject:@"/Applications/AppleTV.app/Appliances/nitoTV.frappliance" forKey:@"NSBundleInitialPath"];
			[info setObject:[NSNumber numberWithInt:0] forKey:@"FRAppliancePreferedOrderValue"];
			
			return original;
		}
		
	
}



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
	[%c(nitoTVAppliance) installFiles];
		
}

	//_kRUIWiFiSetupSucceeded




%new + (void)installFiles
{
	
	
		//
	[%c(nitoTVAppliance) updateAwkwardRepo];
	[%c(nitoTVAppliance) addNitoRepo];
	[%c(nitoTVAppliance) addXBMCRepo];
	[%c(nitoTVAppliance) fixFourPointThree];
		//[nitoTVAppliance fix44Betas];
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *localWeather = [NSBundle userWeatherFileLocation];
	NSString *weatherPath = [NSBundle weatherFileLocation];
	
	
	if (![man fileExistsAtPath:localWeather] && (weatherPath != nil))
		[man copyItemAtPath:weatherPath toPath:localWeather error:nil];
	
	NSString *rssPath = [NSBundle rssFileLocation];
	NSString *localRss = [NSBundle userRssFileLocation];
	
	if (![man fileExistsAtPath:localRss] && (rssPath != nil))
		[man copyItemAtPath:rssPath toPath:localRss error:nil];
	
	[%c(nitoTVAppliance) updatePrefs];
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
		
}


 
%new + (NSArray *)otherBlackList
{
	NSArray *blacklistNote = [NSArray arrayWithObjects:@"NSHTTPCookieManagerCookiesChangedNotification", nil];
	return blacklistNote;
}

%new + (NSArray *)blacklistNotifications
{
	NSArray *blacklistNote = [NSArray arrayWithObjects:@"kBRControlFocusWillChangeNotification", @"kBRControlFocusChangedNotification", @"dataclientstatechanged", @"music.store.root.collection.updated", @"BRURLDocumentReadyNotification", @"BRTaskCompleteNotification", @"BRAccountDirtyNotification", @"dataclientstatechanged", @"BRRentalRefreshCompleteNotification", @"NSHTTPCookieManagerCookiesChangedNotification", @"BRAirportNetworkScanResultsAvailable", @"kBRControlFocusCursorFrameChangedNotification", @"dataclientupdate", @"BRAccountAuthenticationSucceededNotification", @"BRApplianceChangedNotification", @"BRProviderDataSetChangedNotification", @"TaskManagerCompletedTaskNotification", @"music.store.loadstate.changed", @"_NSThreadDidStartNotification", @"BRFeatureEnabledNotification", @"kBRScrollControlScrollInitiated", @"kBRScrollControlScrollCompleted", nil];
	return blacklistNote;
}

%new + (void)ssnote:(NSNotification *)n
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

%new + (void)hookNotifications:(NSNotification *)n
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
			if (![[%c(nitoTVAppliance) otherBlackList] containsObject:name])
			
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

%new + (void)fix44Betas
{
		//NSLog(@"fix44Betas");
	BOOL is44 = [[%c(nitoTVAppliance) buildVersion] isEqualToString:@"5.0"];
	if (is44 == TRUE)
	{
		int sysReturn = system([@"/usr/bin/nitoHelper 50 1" UTF8String]);
		if (sysReturn == 0)
		{
			NSLog(@"killed MS in BTServer for 5.0 betas, killing lowtide!");
			[[%c(BRApplication) sharedApplication] terminate];
			
		} else {
			NSLog(@"sysReturn for 5.0 fix return nonzero, already run or failed!");
		}
	}
}

%new + (void)fixFourPointThree
{
		//NSLog(@"fixFourPointThree");
	NSString *filePath = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"cydia_postinst" ofType:@""];
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt/sources.list.d/cydia.list"])
	{
		NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper fix43 %@", filePath];
			//NSLog(@"command: %@", command);
		system([command UTF8String]);
			
	}
}

%new + (void)addNitoRepo
{
	NSString *nitoRepo = @"/etc/apt/sources.list.d/nito.list";
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *filePath = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"com.nito" ofType:@"deb"];
		//NSLog(@"filePath: %@", filePath);
	
	if (![man fileExistsAtPath:nitoRepo])
	{
		NSLog(@"add repo");
		NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper dpkg %@", filePath];
		int sysReturn = system([command UTF8String]);
		NSLog(@"dpkg install finished with: %i", sysReturn);
	}
}

%new + (void)addXBMCRepo
{
	NSString *xbmcRepo = @"/etc/apt/sources.list.d/xbmc.list";
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *filePath = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"org.xbmc" ofType:@"deb"];
		//NSLog(@"filePath: %@", filePath);
	
	if (![man fileExistsAtPath:xbmcRepo])
	{
		NSLog(@"add xbmc repo");
		NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper dpkg %@", filePath];
		int sysReturn = system([command UTF8String]);
		NSLog(@"dpkg install finished with: %i", sysReturn);
	}
}

%new + (void)updateAwkwardRepo
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


%new + (void)updatePrefs
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

- (id)topShelfController { return [self associatedValueForKey:(void*)ntvTopShelfControllerKey]; }

%new - (void)setTopShelfController:(id)topShelfControl { [self associateValue:topShelfControl withKey:(void*)ntvTopShelfControllerKey]; }



- (id)applianceCategories {
		//LOG_SELF
	return [self associatedValueForKey:(void*)ntvApplianceCategoriesKey];
}

%new - (void)setApplianceCategories:(id)appCategories
{
	[self associateValue:appCategories withKey:(void*)ntvApplianceCategoriesKey];
}




- (id)initWithApplianceInfo:(id)applianceInfo
{
	if((self = %orig) != nil) {
		
		id topShelfControl = [[NITOTVTopShelfController alloc] init];
		[self setTopShelfController:topShelfControl];
		NSArray *catArray = [[NSArray alloc] initWithObjects:SOFTWARE_CAT, SOURCES_CAT, WEATHER_CAT, RSS_CAT, SETTINGS_CAT, ABOUT_CAT, nil];
		[self setApplianceCategories:catArray];
		
		
	}
	return self;
}

- (id)init {
		//LOG_SELF
	if((self = %orig) != nil) {
		
		id topShelfControl = [[NITOTVTopShelfController alloc] init];
		[self setTopShelfController:topShelfControl];
		NSArray *catArray = [[NSArray alloc] initWithObjects:SOFTWARE_CAT, SOURCES_CAT, WEATHER_CAT, RSS_CAT, SETTINGS_CAT, ABOUT_CAT, nil];
		[self setApplianceCategories:catArray];
		
		
	}
	return self;
}

//- (id)init {
//	if((self = %orig) != nil) {
//		id _topShelfController = [[%c(NITOTVTopShelfController) alloc] init];
//		
//		//_applianceCategories = [[NSArray alloc] initWithObjects:
//		//			FILES_CAT,STREAMS_CAT, RECENT_CAT, PLAYLIST_CAT, NETWORK_CAT,  WEATHER_CAT, RSS_CAT, SETTINGS_CAT, ABOUT_CAT ,nil];
//		
//		_applianceCategories = [[NSArray alloc] initWithObjects:SOFTWARE_CAT, SOURCES_CAT, WEATHER_CAT, RSS_CAT, SETTINGS_CAT, ABOUT_CAT, nil];
//		
//	} return self;
//}




-(id)controllerForIdentifier:(id)identifier
{
	return [self controllerForIdentifier:identifier args:nil];
}



//- (BOOL)handlePlay:(id)play userInfo:(id)info
//{
//	return YES;
//}



%new + (NSString *)buildVersion
{
	return [%c(ATVVersionInfo) currentOSVersion];
	//Class cls = NSClassFromString(@"ATVVersionInfo");
//	if (cls != nil)
//	{ return [cls currentOSVersion]; }
//	
	return nil;	
}

-(id)controllerForIdentifier:(id)identifier args:(id)args	// 0x315bf445
{
	
	//NSLog(@"selecteCategoryWithIdentifier: %@", ident);
	BOOL internetAvailable = (BOOL)(long)(void *)[%c(BRIPConfiguration) internetAvailable];
	
	
	id menuController = nil;
	
	if ([identifier isEqualToString:SOFTWARE_ID])
	{
		menuController = [[objc_getClass("nitoInstallManager") alloc] initWithTitle:BRLocalizedString(@"Install Software", @"Install Software")];
		
			//BRApplicationStackManager *theStack = [BRApplicationStackManager stack];
			//	NSLog(@"stackity: %@", theStack);
	}
	
	if ([identifier isEqualToString:SOURCES_ID])
	{
		
			//FIXME: i dont know yet...
		
			//NSArray *packages = [packageManagement repoReleaseDictionaries];
	
			//menuController = [[nitoSourceController alloc] initWithTitle:BRLocalizedString(@"Manage Sources", @"Manage Sources") andSources:packages];
		
		menuController = [[objc_getClass("nitoManageMenu") alloc] initWithTitle:BRLocalizedString(@"Manage", @"Title of the menu where you browse all of your installed packages")];
		
	} else if ([identifier isEqualToString:ABOUT_ID])
	{
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"kBRSetMachineToLowPowerModeNotification" object:nil];
		NSString * path = [[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"About" ofType:@"txt"];
		id textControls = [[%c(BRScrollingTextControl) alloc] init];
		[textControls setDocumentPath:path encoding:NSUTF8StringEncoding];
		NSString *myTitle = @"About nitoTV";
		[textControls setTitle:myTitle];
		[textControls autorelease];
		menuController =  [%c(BRController) controllerWithContentControl:textControls];
	} else if ([identifier isEqualToString:WEATHER_ID])
	{
		menuController = [[objc_getClass("ntvWeatherManager") alloc] initWithArray:nil state:nil andTitle:BRLocalizedString(@"Weather Manager", @"Title of weather menu")];
		
		if (internetAvailable == FALSE)
		{
			menuController = [%c(BRAlertController) alertOfType:1 titled:BRLocalizedString(@"Internet Unavailable", @"Internet Unavailable") primaryText:@"Configure Internet First! ktnx" secondaryText:@"Seriously... do it now"];
			
			NSLog(@"No internet for you!");
			
		}
		
	} else if ([identifier isEqualToString:RSS_ID])
	{
		
		menuController = [[objc_getClass("ntvRssBrowser") alloc] initWithArray:nil state:nil andTitle:BRLocalizedString(@"RSS Feeds", @"Title of RSS menu")];
		
		if (internetAvailable == FALSE)
		{
			menuController = [%c(BRAlertController) alertOfType:0 titled:BRLocalizedString(@"Internet Unavailable", @"Internet Unavailable") primaryText:@"Configure Internet First! ktnx" secondaryText:@"Seriously... do it now"];
			
			NSLog(@"No internet for you!");
			
		}
		
		
		
	} else if ([identifier isEqualToString:SETTINGS_ID])
	{
		menuController = [[objc_getClass("nitoSettingsController") alloc] initWithTitle:BRLocalizedString(@"Settings", @"Settings")];
		
	}
	
	
	return menuController;
	
	
}


- (id)localizedSearchTitle { return @"nitoTV"; }
- (id)applianceName { return @"nitoTV"; }
- (id)moduleName { return @"nitoTV"; }
- (id)applianceKey { return @"nitoTV"; }

	//@end
%end




// vim:ft=objc
