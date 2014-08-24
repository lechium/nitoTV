//
//  NitoTheme.m
//  nitoTV
//
//  Created by Kevin Bradley on 5/22/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

#import "NitoTheme.h"
#import "packageManagement.h"

#define BRIMAGECLASS objc_getClass("BRImage")

@implementation NitoTheme

+ (id)sharedTheme
{
	static NitoTheme *shared = nil;
	if(shared == nil)
		shared = [[NitoTheme alloc] init];
	
	return shared;
}
//
//+ (NitoTheme *)sharedInstance
//{
//    return [[self alloc] init];
//}

//settings icons

+ (id)myMenuItemTextAttributes
{
	NSMutableDictionary *startDict = [[NSMutableDictionary alloc] initWithDictionary:[[objc_getClass("BRThemeInfo") sharedTheme] menuItemTextAttributes]];
	[startDict setObject:@"Progbot" forKey:@"BRFontName"];
	return [startDict autorelease];
}

-(id)settingsImage {
	
	//return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"settings" ofType:@"png"]];
	return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"settings" ofType:@"png"]];
	
}


-(id)clockImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"clock" ofType:@"png" inDirectory:@"Images"]];
    //return [BRIMAGECLASS imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"clock" ofType:@"png" inDirectory:@"Images"]];
}

-(id)consoleImage {

    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"Console" ofType:@"png" inDirectory:@"Images"]];
}

-(id)kextImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"KEXT" ofType:@"png" inDirectory:@"Images"]];
}
-(id)musicImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"Music" ofType:@"png" inDirectory:@"Images"]];
}

-(id)utilitiesImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ToolbarUtilitiesFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}

-(id)shutDownImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"shutdown" ofType:@"png" inDirectory:@"Images"]];
}

-(id)rebootImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"reboot" ofType:@"png" inDirectory:@"Images"]];
}

-(id)sshImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ssh" ofType:@"png" inDirectory:@"Images"]];
}

-(id)afpImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"afp" ofType:@"png" inDirectory:@"Images"]];
}

-(id)ftpImage {
	return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ftp" ofType:@"png" inDirectory:@"Images"]];
}

//installer icons

-(id)searchImage {
	return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"search" ofType:@"png" inDirectory:@"Images"]];
}

-(id)packageImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"package" ofType:@"png" inDirectory:@"Images"]];
}

-(id)packageMakerImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"packagemaker" ofType:@"png" inDirectory:@"Images"]];
}

-(id)perianImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"perian_logo" ofType:@"png" inDirectory:@"Images"]];
}

-(id)smartInstallerImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"smartpackage" ofType:@"png" inDirectory:@"Images"]];
}

-(id)installerImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"installer" ofType:@"png" inDirectory:@"Images"]];
}

-(id)iTunesFSImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"iTunesFS" ofType:@"png" inDirectory:@"Images"]];
}

-(id)flashImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"flash" ofType:@"png" inDirectory:@"Images"]];
}


//networking

-(id)fileServerImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericFileServerIcon" ofType:@"png" inDirectory:@"Images"]];
}

- (id)networkImage {
	
	 return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericNetworkIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)remoteMountImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"RemoteMount" ofType:@"png" inDirectory:@"Images"]];
}


-(id)sharePointImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericSharepoint" ofType:@"png" inDirectory:@"Images"]];
}



//categories images

-(id)applianceIcon {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"nitoTVSettings" ofType:@"png"]];
}


-(id)applicationImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ApplicationsFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)recentItemsImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"RecentDocs" ofType:@"png" inDirectory:@"Images"]]; //kRecentDocumentsFolderType
}


-(id)rssImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"rss" ofType:@"png" inDirectory:@"Images"]];
}


-(id)weatherImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"weather" ofType:@"png" inDirectory:@"Images"]];
}

-(id)playlistImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"SmartFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)aboutImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericQuestionMarkIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)folderImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)openFolderImage {


    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"OpenFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)ejectImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ejectroll" ofType:@"png" inDirectory:@"Images"]];
}

-(id)nuejectImage {
	
    //NSFileManager *man = [NSFileManager defaultManager];
	NSString *ejectImagePath = @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/EjectMediaIcon.icns";
	return [packageManagement _imageWithPath:ejectImagePath];
}

//media images

-(id)leftImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"left" ofType:@"png" inDirectory:@"Images"]];
}


-(id)minusImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"minus" ofType:@"png" inDirectory:@"Images"]];
}


-(id)mplayerImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"mplayer" ofType:@"png" inDirectory:@"Images"]];
}


-(id)rightImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"right" ofType:@"png" inDirectory:@"Images"]];
}

-(id)playImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"play" ofType:@"png" inDirectory:@"Images"]];
}


-(id)plusImage {
	
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"plus" ofType:@"png" inDirectory:@"Images"]];
}

-(id)videoTSImage {
	 return [self dvdImage];
	NSString *videoTs = [[self coreTypesPath] stringByAppendingPathComponent:@"VideoTSFolder.png"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:videoTs])
	{
		return [packageManagement _imageWithPath:videoTs];
	}
   
}

-(id)dvdImage {
	

	return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"DVD" ofType:@"png" inDirectory:@"Images"]];
}

- (id)coreTypesPath {
	
	return @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/";
	
}


- (id)macImage {
	
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *macImagePath = @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/com.apple.mac.icns";
	if ([man fileExistsAtPath:macImagePath])
		return [packageManagement _imageWithPath:macImagePath];
	else
		return [self fileServerImage];
}




- (id)unsupportedImage{
	
	return [packageManagement _imageWithPath:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Unsupported.icns"];
	
}

- (id)picturesFolderImage{
	

		return [self utilitiesImage];

}

- (id)appleTVImage {
	
	
	return [packageManagement _imageWithPath:@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/appleTVImage.png"];
}


@end
