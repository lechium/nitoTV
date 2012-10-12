//
//  SMFMoviePreviewDelegateDatasource.h
//  SMFramework
//
//  Created by Thomas Cool on 7/13/11.
//  Copyright 2011 tomcool.org. All rights reserved.
//

#import <Foundation/Foundation.h>
	//#import "Backrow/AppleTV.h"

@protocol SMFMoviePreviewControllerDatasource
-(NSString *)title;
-(NSString *)subtitle;
-(NSString *)summary;
-(NSArray  *)headers;
-(NSArray  *)columns;
-(NSString *)rating;
-(id)coverArt;
-(id)providerForShelf;

@optional
-(NSString *)shelfTitle;
-(NSArray *)buttons;
-(NSString *)posterPath;
@end

	//@class SMFMoviePreviewController;
@protocol SMFMoviePreviewControllerDelegate
//If a delegate responds to a method... 
//it needs to implement the sounds for selection itself
//See SMFThemeInfo or BRSoundHandler
-(void)controller:(id)c selectedControl:(id)ctrl;
@optional
-(void)controller:(id)c buttonSelectedAtIndex:(int)index;
-(void)controller:(id)c switchedFocusTo:(id)newControl;
-(void)controller:(id)c shelfLastIndex:(long)index;
-(void)controllerSwitchToNext:(id)c ;
-(void)controllerSwitchToPrevious:(id)c ;
-(BOOL)controllerCanSwitchToNext:(id)c ;
-(BOOL)controllerCanSwitchToPrevious:(id)c;
@end