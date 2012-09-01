//
//  NitoTheme.h
//  nitoTV
//
//  Created by Kevin Bradley on 5/22/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

enum {
	ntvStandardKeyboard = 1,
	ntvYTKeyboard = 2,
};
typedef int ntvKeyboardStyle;

enum {
	ntvChainMode = 0,
	ntvSingleMode = 1,
};
typedef int ntvKBMode;

enum {
	ntvPlaylistKBType = 0,
	ntvUserKBType = 1,
	ntvUserPWKBType = 2,
	ntvMountNameKBType = 3,
	ntvMountIPStringKB = 4,
	ntvMountVolumeNameKB = 5,
	ntvMountLoginKBType = 6,
	ntvMountPWKBType = 7,
	ntvInputDestinationType = 8,
	ntvImageDestinationType = 9,
	ntvCustomVolumeNameKB = 10,
	ntvAddMainSuffix = 11,
	ntvAddMPSuffix = 12,
	ntvAddQTSuffix = 13,
	ntvAddMusicSuffix = 14,
	ntvAddBlackistVolume = 15,
	ntvAddMPArgument = 16,
	ntvZipCodeType = 17,
	ntvWeatherNameKBType = 18,
	ntvWeatherLocationKBType = 19,
	ntvPJPODLoginKBType	= 20,
	ntvPJPODPasswordKBType = 21,
	ntvDomPODLoginKBType = 22,
	ntvDomPODPasswordKBType = 23,
	ntvEditMPArgument = 24,
	ntvEditBlacklistArgument = 25,
	ntvEditCustomArgs = 26,
	ntvUpKey = 27,
	ntvDownKey = 28,
	ntvLeftKey = 29,
	ntvRightKey = 30,
	ntvHoldRight = 31,
	ntvHoldLeft = 32,
	ntvPlayKey = 33,
	ntvStreamNameKBType = 34,
	ntvStreamLocationKBType = 35,
	ntvRssNameKBType = 36,
	ntvRssLocationKBType = 37,
	ntvHostnameType = 38,
	
};
typedef int ntvKBType;


@interface NitoTheme : NSObject {

}

+(id)sharedTheme;


//settings icons

-(id)clockImage;
-(id)consoleImage;
-(id)kextImage;
-(id)musicImage;
-(id)utilitiesImage;
-(id)shutDownImage;
-(id)rebootImage;
-(id)sshImage;
-(id)afpImage;
-(id)ftpImage;

//installer icons

-(id)searchImage;
-(id)packageImage;
-(id)packageMakerImage;
-(id)perianImage;
-(id)smartInstallerImage;
-(id)installerImage;
-(id)iTunesFSImage;
-(id)flashImage;

//networking

-(id)fileServerImage;
-(id)remoteMountImage;
-(id)sharePointImage;

//categories images

-(id)applianceIcon;
-(id)applicationImage;
-(id)recentItemsImage;
-(id)rssImage;
-(id)weatherImage;
-(id)playlistImage;
-(id)aboutImage;
-(id)folderImage;
-(id)openFolderImage;
-(id)ejectImage;

//media images

-(id)leftImage;
-(id)minusImage;
-(id)mplayerImage;
-(id)rightImage;
-(id)playImage;
-(id)plusImage;
-(id)dvdImage;
-(id)videoTSImage;

//convenience methods

-(id)coreTypesPath;
-(id)macImage;
-(id)unsupportedImage;
-(id)picturesFolderImage;
- (id)appleTVImage;

@end
