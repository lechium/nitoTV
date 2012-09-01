//
//  defaultHelper.h
//  nitoTV
//
//  Created by blunt on 11/10/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

#define NITO_LIST @"/etc/apt/sources.list.d/nitotv.list"
#define CYDIA_LIST @"/etc/apt/sources.list.d/cydia.list"
#define AWK_LIST @"/etc/apt/sources.list.d/awkwardtv.list"

#define SAURIK_SOURCE @"deb http://apt.saurik.com/ ios/675.00 main"
#define ZODTTD_SOURCE @"deb http://cydia.zodttd.com/repo/cydia/ stable main"
#define BIGBOSS_SOURCE @"deb http://apt.thebigboss.org/repofiles/cydia/ stable main"
#define MODMYI_SOURCE @"deb http://apt.modmyi.com/ stable main"

#define AWK_SOURCE @"deb http://apt.awkwardtv.org/ stable main"

enum {

	kNitoSaurikSource,
	kNitoZodttdSource,
	kNitoBigbossSource,
	kNitoModmyiSource,
	kNitoAwkSource,
	
};

@interface nitoHelperClass : NSObject {
	
	NSFileHandle *logHandle;
	
}
+(int)fixRepo;
- (int)installPackage:(NSString *)packageId;
- (int)removePackage:(NSString *)packageId;
- (NSFileHandle *)logHandle;
+(void)reboot;
+(int)installKey;
+(int)updateRepo;
+(int)toggleUpdate;
-(int)dpkgPackage:(NSString *)packagePath;
- (int)autoremove;
- (int)configure;
- (int)updateAll;
+ (int)updateSelf;
+ (int)fixDepends;
+(int)aptUpdateQuiet;
@end
