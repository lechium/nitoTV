//
//  SampleDataSource.m
//  nitoTV
//
//  Created by Kevin Bradley on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SampleDataSource.h"


@implementation SampleDataSource

/*
 
 Package: com.nito.nitotv
 Status: install ok installed
 Section: Utilities
 Installed-Size: 1380
 Maintainer: nito
 Architecture: iphoneos-arm
 Version: 0.6.4-91
 Depends: beigelist, mobilesubstrate, com.nito.gs
 Description: Release six, weather, RSS, basic deb installer, featured packages, revamped search, package deletion (featured packages only).
 Name: nitoTV
 Website: nitosoft.com
 Author: nito
 
 
 */


-(NSString *)title
{
    return @"nitoTV";
}
-(NSString *)subtitle
{
    return @"com.nito.nitotv";
}
-(NSString *)summary
{
    return @"Release six, weather, RSS, basic deb installer, featured packages, revamped search, package deletion (featured packages only).";
}

- (NSArray *)headers
{
	return [NSArray arrayWithObjects:@"Version",@"Author",@"Section",@"Dependencies",nil];
}

-(NSArray *)columns
{
    NSArray *author = [NSArray arrayWithObjects:@"nito",nil];
    NSArray *section = [NSArray arrayWithObjects:@"Utilities",nil];
    NSArray *depends = [NSArray arrayWithObjects:@"beigelist",@"mobilesubstrate",@"com.nito.gs", @"org.tomcool.smframework",nil];
    NSArray *version = [NSArray arrayWithObjects:@"0.6.4-91", nil];
    NSArray *objects = [NSArray arrayWithObjects:version,author,section,depends,nil];
    return objects;
}
-(NSString *)rating
{
    return @"TV-NITO";
}
-(BRImage *)coverArt
{

    return [[NitoTheme sharedTheme] applianceIcon];
}
-(NSString *)posterPath
{
    return [[NitoTheme sharedTheme] packageImage];
}
-(BRPhotoDataStoreProvider *)providerForShelf
{
    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"Hello" predicate:_pred mediaTypes:_set];
    NSArray *assets = [SMFPhotoMethods mediaAssetsForPath:[[NSBundle bundleForClass:[self class]]pathForResource:@"Posters" ofType:@""]];
    for (id a in assets) {
        [store addObject:a];
    }
    
		//id dSPfCClass = NSClassFromString(@"BRPhotoDataStoreProvider");
    
    id tcControlFactory = [BRPosterControlFactory factory];
    id provider    = [BRPhotoDataStoreProvider providerWithDataStore:store controlFactory:tcControlFactory];
    [store release];
    return provider; 
}
-(NSArray *)buttons
{
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    BRButtonControl* b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]previewActionImage] 
													   subtitle:@"Install" 
														  badge:nil];
    [buttons addObject:b];
    
    
    b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]queueActionImage] 
									  subtitle:@"Queue" 
										 badge:nil];
    
    [buttons addObject:b];
    
    b = [BRButtonControl actionButtonWithImage:[[BRThemeInfo sharedTheme]deleteActionImage] 
									  subtitle:@"Remove" 
										 badge:nil];
    [buttons addObject:b];
    return [buttons autorelease];
    
}

-(void)controller:(SMFMoviePreviewController *)c selectedControl:(BRControl *)ctrl
{
		//NSLog(@"here: %@", ctrl);
	if ([ctrl respondsToSelector:@selector(subtitle)])
	{
		NSLog(@"button subtitle: %@", [[ctrl subtitle]string]);
	}	
		if ([ctrl respondsToSelector:@selector(selectedControl)])
		{
			NSLog(@"selectedControl: %@", [[[ctrl selectedControl]title]string ]);
		}
	
	 
}

	//deletegate -(void)controller:(SMFMoviePreviewController *)c selectedControl:(BRControl *)ctrl;


@end
