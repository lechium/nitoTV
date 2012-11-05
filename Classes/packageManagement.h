//
//  packageManagement.h
//  nitoTV
//
//  Created by Kevin Bradley on 10/29/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

/*
@interface kbScrollingTextControl : BRScrollingTextControl


-(id)_paragraphTextAttributes;

@end

@implementation kbScrollingTextControl

-(id)_paragraphTextAttributes
{
	NSMutableDictionary *attrs = [[NSMutableDictionary alloc] initWithDictionary:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	[attrs setObject:[NSNumber numberWithInteger:2] forKey:@"BRTextAlignmentKey"];
	[attrs setObject:[NSNumber numberWithInteger:20] forKey:@"BRFontPointSize"];
	[attrs setObject:[NSNumber numberWithInteger:0] forKey:@"BRLineBreakModeKey"];
	[attrs setObject:[NSNumber numberWithInteger:2] forKey:@"BRTextAlignmentKey"];
	return [attrs autorelease];
}

@end
*/

#define AWK_DOMAIN				@"apt.awkwardtv.org"
#define MODMYI_DOMAIN			@"apt.modmyi.com"
#define SAURIK_DOMAIN			@"apt.saurik.com"
#define BIGBOSS_DOMAIN			@"apt.thebigboss.org"
#define XBMC_DOMAIN				@"mirrors.xbmc.org"
#define NITO_SOURCE_DOMAIN		@"nitosoft.com"
#define ZODTTD_DOMAIN			@"cydia.zodttd.com"




/*

deb http://apt.saurik.com/ ios/675.00 main
deb http://cydia.zodttd.com/repo/cydia/ stable main
deb http://apt.thebigboss.org/repofiles/cydia/ stable main
deb http://apt.modmyi.com/ stable main

*/

@interface packageManagement : NSObject {

}
+ (BOOL)ntvSixPointOhPLus;
+ (BOOL)ntvFivePointOnePlus;
+ (NSArray *)defaultDomains;
+ (int)sourceIntegerForRepo:(NSString *)theRepo;
+ (NSArray *)missingDefaultDomains;
+ (NSArray *)parsedPackageArray;
+ (NSArray *)repoReleaseDictionaries;
+ (int)addSource:(NSString *)theSource;
+ (BOOL)addLine:(NSString *)theLine toFile:(NSString *)theFile;
+ (NSString *)displayDependentsForPackage:(NSString *)thePackage;
+ (NSArray *)dependentsForPackage:(NSString *)thePackage;
+ (void)PMRunConfigure;
+ (void)PMRunAutoremove;
+ (NSArray *)basicAppleTVUpdatesAvailable;
+ (NSString *)XBMCLocation;
+ (NSString *)installedLocation;
- (BOOL)packageInstalled:(NSString *)currentPackage;
+(id)sharedManager;
+ (int)aptUpdate;
- (NSString *)packageVersion:(NSString *)currentPackage;
- (void)_updateDateCheck;
- (NSString *)_lastCheckDate;
-(BOOL)_shouldCheckUpdate;
- (void)checkForUpdate;
- (NSString *)packageVersion:(NSString *)currentPackage;
+ (NSArray *)essentialUpdatesAvailable;
+ (BOOL)essentialUpdatesExist;
+ (NSString *)essentialDisplayStringFromArray:(NSArray *)essentialArray;
+ (NSArray *)basicEssentialUpdatesAvailable;
+ (NSArray *)filteredListArray;
+ (NSString *)listLocationFromString:(NSString *)predicateString;
+ (NSDictionary *)parsedPackageListForRepo:(NSString *)theRepo;
+ (NSDictionary *)parsedPackageList;
- (NSDictionary *)parsedPackageList;
- (NSArray *)untoucables;
- (BOOL)canRemove:(NSString *)theItem;
+ (void)updatePackageList;
+ (NSString *)sauriksListLocation;
+ (NSString *)awkListLocation;
+ (NSString *)nitoListLocation;
+ (NSArray *)parsedPackageArrayForRepo:(NSString *)theRepo;
+ (NSDictionary *)parsedPackageListForRepo:(NSString *)theRepo;
+ (NSArray *)sourcesFromFile:(NSString *)theSourceFile;
+ (NSArray *)repoDomainList;
+ (NSString *)releaseLocationFromString:(NSString *)predicateString;
+ (NSArray *)filteredReleaseArray;
+ (NSDictionary *)parsedReleaseForRepo:(NSString *)theRepo;
- (NSArray *)depedenciesForPackage:(NSString *)currentPackage;
+ (NSDictionary *)easyLazyIHateYouParsedPackageList; //with a name like this, how can i forget why my lazy ass made it?? :)
+ (NSArray *)newParsedPackageArrayForRepo:(NSString *)theRepo;
+ (NSArray *)fullSectionList;
+ (int)aptUpdateQuiet;
@end
