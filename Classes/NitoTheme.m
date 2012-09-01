//
//  NitoTheme.m
//  nitoTV
//
//  Created by Kevin Bradley on 5/22/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

#import "NitoTheme.h"
//#import "IconFamily.h"


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

-(id)clockImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"clock" ofType:@"png" inDirectory:@"Images"]];
}

-(id)consoleImage {

    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"Console" ofType:@"png" inDirectory:@"Images"]];
}

-(id)kextImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"KEXT" ofType:@"png" inDirectory:@"Images"]];
}
-(id)musicImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"Music" ofType:@"png" inDirectory:@"Images"]];
}

-(id)utilitiesImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ToolbarUtilitiesFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}

-(id)shutDownImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"shutdown" ofType:@"png" inDirectory:@"Images"]];
}

-(id)rebootImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"reboot" ofType:@"png" inDirectory:@"Images"]];
}

-(id)sshImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ssh" ofType:@"png" inDirectory:@"Images"]];
}

-(id)afpImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"afp" ofType:@"png" inDirectory:@"Images"]];
}

-(id)ftpImage {
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ftp" ofType:@"png" inDirectory:@"Images"]];
}

//installer icons

-(id)searchImage {
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"search" ofType:@"png" inDirectory:@"Images"]];
}

-(id)packageImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"package" ofType:@"png" inDirectory:@"Images"]];
}

-(id)packageMakerImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"packagemaker" ofType:@"png" inDirectory:@"Images"]];
}

-(id)perianImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"perian_logo" ofType:@"png" inDirectory:@"Images"]];
}

-(id)smartInstallerImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"smartpackage" ofType:@"png" inDirectory:@"Images"]];
}

-(id)installerImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"installer" ofType:@"png" inDirectory:@"Images"]];
}

-(id)iTunesFSImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"iTunesFS" ofType:@"png" inDirectory:@"Images"]];
}

-(id)flashImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"flash" ofType:@"png" inDirectory:@"Images"]];
}


//networking

-(id)fileServerImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericFileServerIcon" ofType:@"png" inDirectory:@"Images"]];
}

- (id)networkImage {
	
	 return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericNetworkIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)remoteMountImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"RemoteMount" ofType:@"png" inDirectory:@"Images"]];
}


-(id)sharePointImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericSharepoint" ofType:@"png" inDirectory:@"Images"]];
}



//categories images

-(id)applianceIcon {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"nitoTVSettings" ofType:@"png"]];
}


-(id)applicationImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ApplicationsFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)recentItemsImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"RecentDocs" ofType:@"png" inDirectory:@"Images"]]; //kRecentDocumentsFolderType
}


-(id)rssImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"rss" ofType:@"png" inDirectory:@"Images"]];
}


-(id)weatherImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"weather" ofType:@"png" inDirectory:@"Images"]];
}

-(id)playlistImage {
	/*
	if ([self LeoCoreTypes] == YES)
	{
		IconFamily* iconFamily;
		NSBitmapImageRep* bitmapImageRep;
		NSImage* image;
		NSString *smartFolderPath = @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/SmartFolderIcon.icns";
		iconFamily = [IconFamily iconFamilyWithContentsOfFile:
					  smartFolderPath];
		bitmapImageRep = [iconFamily bitmapImageRepWithAlphaForIconFamilyElement:'ic08'];
		//[bitmapImageRep setSize:NSMakeSize(512, 512)];
		//[bitmapImageRep setPixelsHigh:512];
		//[bitmapImageRep setPixelsWide:512];
		if (bitmapImageRep) {
			image = [[[NSImage alloc] initWithSize:[bitmapImageRep size]] autorelease];
		//	[IconFamily resampleImage:image toIconWidth:512 usingImageInterpolation:NSImageInterpolationHigh];
			[image addRepresentation:bitmapImageRep];
			NSLog(@"%@", [image representations]);
		//BRImage *myImage = [BRImage imageWithData:[image TIFFRepresentationUsingCompression:NSTIFFCompressionJPEG factor:1.0f]];
			BRImage *myImage = [BRImage imageWithData:[image TIFFRepresentation]];
			return myImage;
	}
	}
	 */
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"SmartFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)aboutImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericQuestionMarkIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)folderImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"GenericFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)openFolderImage {
	/*
	if ([self LeoCoreTypes] == YES)
	{
		
		NSImage *ofImage = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kOpenFolderIcon)];
		[ofImage setSize:NSMakeSize(512.0,512.0)];
		BRImage *myImage = [BRImage imageWithData:[ofImage TIFFRepresentationUsingCompression:NSTIFFCompressionJPEG factor:1.0f]];
		return myImage;
	}
	*/
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"OpenFolderIcon" ofType:@"png" inDirectory:@"Images"]];
}


-(id)ejectImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"ejectroll" ofType:@"png" inDirectory:@"Images"]];
}

-(id)nuejectImage {
	
    //NSFileManager *man = [NSFileManager defaultManager];
	NSString *ejectImagePath = @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/EjectMediaIcon.icns";
	return [BRImage imageWithPath:ejectImagePath];
}

//media images

-(id)leftImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"left" ofType:@"png" inDirectory:@"Images"]];
}


-(id)minusImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"minus" ofType:@"png" inDirectory:@"Images"]];
}


-(id)mplayerImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"mplayer" ofType:@"png" inDirectory:@"Images"]];
}


-(id)rightImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"right" ofType:@"png" inDirectory:@"Images"]];
}

-(id)playImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"play" ofType:@"png" inDirectory:@"Images"]];
}


-(id)plusImage {
	
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"plus" ofType:@"png" inDirectory:@"Images"]];
}

-(id)videoTSImage {
	 return [self dvdImage];
	NSString *videoTs = [[self coreTypesPath] stringByAppendingPathComponent:@"VideoTSFolder.png"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:videoTs])
	{
		return [BRImage imageWithPath:videoTs];
	}
   
}

-(id)dvdImage {
	
	/*
	
	if ([self LeoCoreTypes] == YES)
	{
		
		NSString *dvdPath = @"/System/Library/Extensions/IODVDStorageFamily.kext/Contents/Resources/DVD.icns";
		IconFamily* iconFamily = [IconFamily iconFamilyWithContentsOfFile:
					  dvdPath];
		NSBitmapImageRep* bitmapImageRep = [iconFamily bitmapImageRepWithAlphaForIconFamilyElement:'ic08'];
		//[bitmapImageRep setSize:NSMakeSize(512, 512)];
		//[bitmapImageRep setPixelsHigh:512];
		//[bitmapImageRep setPixelsWide:512];
		if (bitmapImageRep) {
			NSImage* image = [[[NSImage alloc] initWithSize:[bitmapImageRep size]] autorelease];
			//	[IconFamily resampleImage:image toIconWidth:512 usingImageInterpolation:NSImageInterpolationHigh];
			[image addRepresentation:bitmapImageRep];
			NSLog(@"%@", [image representations]);
			//BRImage *myImage = [BRImage imageWithData:[image TIFFRepresentationUsingCompression:NSTIFFCompressionJPEG factor:1.0f]];
			BRImage *myImage = [BRImage imageWithData:[image TIFFRepresentation]];
			return myImage;
		}
	}
	*/
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[NitoTheme class]] pathForResource:@"DVD" ofType:@"png" inDirectory:@"Images"]];
}

- (id)coreTypesPath {
	
	return @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/";
	
}

/*

- (id)finderImage {
	
		NSImage *finderImages = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kFinderIcon)];
		[finderImages setSize:NSMakeSize(512.0,512.0)];
		id myImage = [BRImage imageWithData:[finderImages TIFFRepresentationUsingCompression:NSTIFFCompressionJPEG factor:1.0f]];
		return myImage;
		
}
*/

- (id)macImage {
	
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *macImagePath = @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/com.apple.mac.icns";
	if ([man fileExistsAtPath:macImagePath])
		return [BRImage imageWithPath:macImagePath];
	else
		return [self fileServerImage];
}



/*
- (id)trashFullImage {
	
	NSImage *trashIcon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kFullTrashIcon)];	
	[trashIcon setSize:NSMakeSize(512.0,512.0)];
	return [BRImage imageWithData:[trashIcon TIFFRepresentationUsingCompression:NSTIFFCompressionJPEG factor:1.0f]];

}

- (id)trashImage{
	
	
	NSImage *trashIcon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kTrashIcon)];	
	[trashIcon setSize:NSMakeSize(512.0,512.0)];
	return [BRImage imageWithData:[trashIcon TIFFRepresentationUsingCompression:NSTIFFCompressionJPEG factor:1.0f]];
	
}
*/

- (id)unsupportedImage{
	
	return [BRImage imageWithPath:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Unsupported.icns"];
	
}

- (id)picturesFolderImage{
	
	/*
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *pfPath = @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/PicturesFolderIcon.icns";
	if ([man fileExistsAtPath:pfPath])
	{
		NSString *picturesPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"];
		if (![man fileExistsAtPath:picturesPath])
		{
			[man createDirectoryAtPath:picturesPath attributes:nil];
		}
		NSImage *pfImage = [[NSWorkspace sharedWorkspace] iconForFile:picturesPath];
		//NSImage *pfImage = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode('pdoc')];
		[pfImage setSize:NSMakeSize(512.0,512.0)];
		id myImage = [BRImage imageWithData:[pfImage TIFFRepresentationUsingCompression:NSTIFFCompressionJPEG factor:1.0f]];
		return myImage;
	} else {
	 */
		return [self utilitiesImage];
	//}
		

}

- (id)appleTVImage {
	
	
	return [BRImage imageWithPath:@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/appleTVImage.png"];
}


@end
