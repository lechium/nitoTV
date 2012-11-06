//
//  NitoInstallManager.m
//  nitoTV
//
//  Created by Kevin Bradley on 11/11/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//
/*
#import "nitoInstallManager.h"
#import "ntvMedia.h"
#import "ntvMediaPreview.h"
#import "queryMenu.h"
#import "kbScrollingTextControl.h"
#import "PackageDataSource.h"
#import <SMFramework/NSMFComplexProcessDropShadowControl.h>

#import <SMFramework/SMFramework.h>
#import "nitoMoreMenu.h"

 */

#import "nitoMockMenuItem.h"
#import "packageManagement.h"


#define kNitoWebURL @"http://nitosoft.com/ATV2/install/payloads.plist"

static BOOL _essentialUpgrade = FALSE;
static BOOL _alreadyCheckedUpdate = FALSE;
static int _textEntryType = 0;

static char const * const kNitoInstallVersionsKey = "nInstallVersions";
static char const * const kNitoInstallImageNameKey = "nInstallImageName";
static char const * const kNitoInstallUpdateArrayKey = "nInstallUpdateArray";
static char const * const kNitoInstallGreenMileFileKey = "nInstallGreenMileFile";
static char const * const kNitoInstallSelectedObjectKey = "nInstallSelectedObject";
static char const * const kNitoInstallQueueArrayKey = "nInstallQueueArray";
static char const * const kNitoInstallEssentialArrayKey = "nInstallEssentialArray";


%subclass nitoInstallManager : nitoMediaMenuController


	//global bools/ints

%new - (BOOL)essentialUpgrade
{
	return _essentialUpgrade;
}

%new - (void)setEssentialUpgrade:(BOOL)essential
{
	_essentialUpgrade = essential;
}

%new - (BOOL)alreadyCheckedUpdate
{
	return _alreadyCheckedUpdate;
}

%new - (void)setAlreadyCheckedUpdate:(BOOL)alreadyChecked
{
	_alreadyCheckedUpdate = alreadyChecked;
}

%new - (int)textEntryType
{
	return _textEntryType;
}

%new - (void)setTextEntryType:(int)theType
{
	_textEntryType = theType;
}

%new - (NSMutableArray *)versions
{
	return [self associatedValueForKey:(void*)kNitoInstallVersionsKey];
}

%new - (void)setVersions:(NSMutableArray *)theVersions
{
	[self associateValue:theVersions withKey:(void*)kNitoInstallVersionsKey];
}

%new - (NSString *)imageName
{
	return [self associatedValueForKey:(void*)kNitoInstallImageNameKey];
}

%new - (void)setImageName:(NSString *)theImageName
{
	[self associateValue:theImageName withKey:(void*)kNitoInstallImageNameKey];
}


%new - (NSMutableArray *)updateArray
{
	return [self associatedValueForKey:(void*)kNitoInstallUpdateArrayKey];
}

%new - (void)setUpdateArray:(NSMutableArray *)theUpdateArray
{
	[self associateValue:theUpdateArray withKey:(void*)kNitoInstallUpdateArrayKey];
}

%new - (NSString *)greenMileFile
{
	return [self associatedValueForKey:(void*)kNitoInstallGreenMileFileKey];
}

%new - (void)setGreenMileFile:(NSString *)theGreenMileFile
{
	[self associateValue:theGreenMileFile withKey:(void*)kNitoInstallGreenMileFileKey];
}

%new - (id)selectedObject
{
	return [self associatedValueForKey:(void*)kNitoInstallSelectedObjectKey];
}

%new - (void)setSelectedObject:(id)theSelectedObject
{
	[self associateValue:theSelectedObject withKey:(void*)kNitoInstallSelectedObjectKey];
}


%new - (NSMutableArray *)queueArray
{
	return [self associatedValueForKey:(void*)kNitoInstallQueueArrayKey];
}

%new - (void)setQueueArray:(NSMutableArray *)theQueueArray
{
	[self associateValue:theQueueArray withKey:(void*)kNitoInstallQueueArrayKey];
}


%new - (NSArray *)essentialArray
{
	return [self associatedValueForKey:(void*)kNitoInstallEssentialArrayKey];
}

%new - (void)setEssentialArray:(NSArray *)theEssentialArray
{
	[self associateValue:theEssentialArray withKey:(void*)kNitoInstallEssentialArrayKey];
}

	//end ivar -> associated objects



%new + (int)versionSafe:(NSDictionary *)pluginDict //0 = safe, 1 = too low, 2 = too high
{
	
	NSString *installVersion = [packageManagement properVersion];
	//NSLog(@"installVersion: %@", installVersion);
	NSString *lowVersion = [pluginDict valueForKey:@"osMin"];
	NSString *highVersion = [pluginDict valueForKey:@"osMax"];
	if ([lowVersion intValue] == 0 || [highVersion intValue] == 0)
		return 0;
	
	
	//check the lower boundary
	
	NSComparisonResult theResult = [installVersion compare:lowVersion options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
		
		//low version is not greater than installVersion. do nothing.
		//NSLog(@"low check: NSOrderedDescending"); 
		
	} else if ( theResult == NSOrderedAscending ){
		
		//NSLog(@"low check: NSOrderedAscending");
		//low version is greater than installVersion
		return 1;
		
	} else if ( theResult == NSOrderedSame ) {
		
		//mimimum version is equal to installVersion
		//NSLog(@"low check: NSOrderedSame");
		
	}
	
	//check the upper boundary
	NSComparisonResult theResult2 = [installVersion compare:highVersion options:NSNumericSearch];
	if ( theResult2 == NSOrderedDescending ){
		
		//high version is not greater than installVersion. display warning.
		
		//NSLog(@"high check: NSOrderedDescending"); 
		return 2;
		
	} else if ( theResult2 == NSOrderedAscending ){
		
		//NSLog(@"high check: NSOrderedAscending");
		//high version is greater than installVersion
		return 0;
		
	} else if ( theResult2 == NSOrderedSame ) {
		
		//maximum version is equal to installVersion
		//NSLog(@"high check: NSOrderedSame");
		return 0;
	}
	
	return 0;
}

%new + (NSArray *)nitoPackageArray
{
	NSURL *theUrl = [[NSURL alloc]initWithString:kNitoWebURL];
	NSArray *initialArray = [[NSArray alloc] initWithContentsOfURL:[theUrl autorelease]];
		//	NSLog(@"initialArray: %@", initialArray);
	NSMutableArray *newArray = [[NSMutableArray alloc] init];
	for (id currentObject in initialArray)
	{
		if ([%c(nitoInstallManager) versionSafe:currentObject] == 0)
		{
			[newArray addObject:currentObject];
		}
	}
	[initialArray release];
	return [newArray autorelease];
}


- (id)initWithTitle:(NSString *)theTitle

{
	LogSelf;
	self = %orig;
	[self setLabel:@"com.nito.installation"];
	NSString *settingsPng = [[NSBundle bundleForClass:[packageManagement class]] pathForResource:@"packagemaker" ofType:@"png" inDirectory:@"Images"];
	_essentialUpgrade = FALSE;
	_alreadyCheckedUpdate = FALSE;
	
	id _queueArray = [[NSMutableArray alloc] init];
	[self setQueueArray:_queueArray];
	id sp = [objc_getClass("BRImage") imageWithPath:settingsPng];
	[self setListIcon:sp horizontalOffset:0.0 kerningFactor:0.15];
	
		//id _versions = [[NSMutableArray alloc] init];
	id _updateArray = [[NSMutableArray alloc] init];
	
		//BOOL internetAvailable = [(BRIPConfiguration *)objc_getClass("BRIPConfiguration") internetAvailable];
	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUpdateDialog:) name:@"CheckForUpdate" object:nil];

		//if (internetAvailable == YES)
		//	{
		
		[_updateArray addObjectsFromArray:[%c(nitoInstallManager) nitoPackageArray]];
		//NSLog(@"_updateArray: %@", _updateArray);
			//	updateArray = [[NSArray alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:kNitoWebURL]];
		NSDictionary *packageSearchDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Search for Packages", @"name", @"Search for debian packages on the Cydia and awkwardTV repositories", @"description", @"url", @"com.package.search", @"1.0", @"version", nil];
		[_updateArray addObject:packageSearchDict];
		NSDictionary *updateAll = [NSDictionary dictionaryWithObjectsAndKeys:@"Update All", @"name", @"runs apt-get -y -u dist-upgrade", @"description", @"url", @"com.package.search", @"1.0", @"version", nil];
		[_updateArray addObject:updateAll];
		
	//} else {
//		
//		
//		id alertCon = [self _internetNotAvailable];
//		[alertCon retain];
//		return alertCon;
//		
//	}
//	
	[self setUpdateArray:_updateArray];
	
	//[updateArray retain];
	
	[[self list] setDatasource:self];
	[[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"Featured", @"Featured menu item divider in software section")];
	[[self list] addDividerAtIndex:[_updateArray count]-2 withLabel:BRLocalizedString(@"Options", @"Options menu item divider in software section")];
	
	
	return (self);
	
}

%new -(void)controller:(id )c switchedFocusTo:(id)newControl {
		//NSLog(@"controller of type %@ focused", [newControl class]);	
}

%new void nitoLogFrame(CGRect frame)
{
    NSLog(@"{{%f, %f},{%f,%f}}",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}

%new void nitoLogPosition(CGPoint point)
{
	 NSLog(@"{%f, %f}", point.x ,point.y);
}

#pragma mark PackageDataSource delegate methods

%new -(void)controller:(id)c buttonSelectedAtIndex:(int)index
{
	
		//	NSLog(@"%@ buttonSelectedAtIndex: %i", c, index);
	id selectedButton = [[c buttons] objectAtIndex:index];
		//NSLog(@"selectedButton: %@", selectedButton);
		//nitoLogFrame([selectedButton bounds]);
		//nitoLogPosition([selectedButton position]);
	
	id _selectedObject = [self selectedObject];
	
	switch (index) {
		
		case kNitoInstallButton: //install
								 //	NSLog(@"queueArray: %@", [self queueArray]);
			if ([[self queueArray] count] > 0)
			{
				[[self queueArray] addObject:_selectedObject];
				NSString *tempFile = @"/private/var/mobile/Library/Preferences/duwm";
				[[self queueArray] writeToFile:tempFile atomically:YES];
				[[self queueArray] removeAllObjects];
				
					//	NSLog(@"installing: %@", tempFile);
				[c setListActionMode:kPackageInstallMode];
					//[c installQueue:tempFile];
				[c installQueue:tempFile withSender:selectedButton];
				return;
			}
			
				//NSLog(@"installing: %@", selectedObject);
				//	NSLog(@"c packageData: %@", [c packageData]);
			[c setListActionMode:kPackageInstallMode];
			[c newUberInstaller:_selectedObject withSender:selectedButton];
			break;

		case kNitoQueueButton: //queue
				//NSLog(@"queue: %@", selectedObject);
			
			if ([[self queueArray] containsObject:_selectedObject])
			{
				[[self queueArray] removeObject:_selectedObject];
				[c removeQueuePopupWithPackage:_selectedObject];
				return;
			}
			[[self queueArray] addObject:_selectedObject];
			
			//NSLog(@"queueArray: %@", self.queueArray);
			[c queuePopupWithPackage:_selectedObject];
			
			break;
			
		case kNitoRemoveButton: //remove
								//NSLog(@"remove: %@", selectedObject);
			if ([PM packageInstalled:_selectedObject])
			{
				if ([PM canRemove:_selectedObject])
				{
					[c setListActionMode:KPackageRemoveMode];
						//[c removePackage:selectedObject];
					NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_selectedObject, @"Package", selectedButton, @"Sender", nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveDialog" object:nil userInfo:userInfo];
						//[c removePackage:selectedObject withSender:selectedButton];
				} else {
					[self showProtectedAlert:_selectedObject];
					PLAY_FAIL_SOUND;
					return;
				}
				
			} else {
				PLAY_FAIL_SOUND;
			}
			
			break;
			
		case kNitoMoreButton: //more
			
				//NSLog(@"more: %@", selectedObject);
				//[c showPopupFrom:c];
			[c showPopupFrom:c withSender:selectedButton];
			break;
	}
	
}




%new - (void)showProtectedAlert:(NSString *)protectedPackage
{
	id result = [[objc_getClass("BRAlertController") alloc] initWithType:0 titled:BRLocalizedString(@"Required Package", @"alert when there is a required / unremovable package") primaryText:[NSString stringWithFormat:BRLocalizedString(@"The Package %@ is required for proper operation of your AppleTV and cannot be removed", @"primary text when there is a required / unremovable package"), protectedPackage] secondaryText:BRLocalizedString(@"Press menu to exit", @"seconday text when there is a required / unremovable package") ];
	[ROOT_STACK pushController:result];
	 [result release];
}


%new -(void)controller:(id)c selectedControl:(id)ctrl
{
	if ([ctrl respondsToSelector:@selector(selectedControl)])
	{
		id data = [[c provider] data];
		id selectedControl = [ctrl selectedControl]; //BRPosterControl
		int focusedIndex = (int)[[ctrl focusedIndexPath] indexAtPosition:1]; //FIXME: okay so we need to fix this cuz we cant categorize!! 
		id myAsset = [data objectAtIndex:focusedIndex];
		NSString *packageName = [[selectedControl title] string];
		id theImage = [myAsset coverArt];
			//NSLog(@"selectedControl: %@ packageName: %@ index: %i", selectedControl, packageName, focusedIndex);
		[self setSelectedObject:packageName];
			//selectedObject = packageName;
		[c updatePackageData:packageName usingImage:theImage];

	}
	
	
}






%new - (id)_internetNotAvailable
{
	id result = [[objc_getClass("BRAlertController") alloc] initWithType:0 titled:BRLocalizedString(@"Internet Unavailable", @"alert when there is no internet connection") primaryText:BRLocalizedString(@"Install Software requires an internet connection. Please connect your AppleTV to the Internet.", @"primary text when there is no internet connection") secondaryText:BRLocalizedString(@"Press menu to exit", @"seconday text when when there is no internet connection") ];
	return [result autorelease];
	
	
}

-(void)dealloc
{
/*
	[updateArray release];
	updateArray = nil;
	[queueArray release];
	queueArray = nil;
	[_essentialArray release];
	_essentialArray = nil;
*/
 [[NSNotificationCenter defaultCenter] removeObserver:self];
	%orig;
}


- (id)previewControlForItem:(long)item
{
		//BRImageAndSyncingPreviewController
	
	id _updateArray = [self updateArray];
	
		//return nil;
	id currentAsset = [[objc_getClass("ntvMedia") alloc] init];
	[currentAsset setTitle:[[_updateArray objectAtIndex:item] valueForKey:@"name"]];
	NSString *currentURL = [[_updateArray objectAtIndex:item] valueForKey:@"imageUrl"];
	NSString *currentVersion = [[_updateArray objectAtIndex:item] valueForKey:@"version"];
	NSString *description = nil;
	NSString *author = nil;
	NSString *section = nil;
	if ([[[_updateArray objectAtIndex:item] allKeys] containsObject:@"description"])
		description = [[_updateArray objectAtIndex:item] valueForKey:@"description"];
		if (currentURL != nil)
		{	[currentAsset setCoverArt:[objc_getClass("BRImage") imageWithURL:[NSURL URLWithString:currentURL]]];
			
		} else
		{
			[currentAsset setCoverArt:[[NitoTheme sharedTheme] packageImage]];
			
		}
	
	if (item == (int)[self itemCount])
	{
		[currentAsset setCoverArt:[[NitoTheme sharedTheme] searchImage]];
		
	}
	
	NSMutableArray *customKeys = [[NSMutableArray alloc] init];
	NSMutableArray *customObjects = [[NSMutableArray alloc] init];
	
	[customKeys addObject:@"Version"];
	[customObjects addObject:currentVersion];
	if(description != nil)
	{
		[currentAsset setSummary:description];
	}
	
	if ([[[_updateArray objectAtIndex:item] allKeys] containsObject:@"author"])
		author = [[_updateArray objectAtIndex:item] valueForKey:@"author"];
		if ([[[_updateArray objectAtIndex:item] allKeys] containsObject:@"section"])
			section = [[_updateArray objectAtIndex:item] valueForKey:@"section"];
			if (author != nil)
			{
				[customKeys addObject:BRLocalizedString(@"Author", @"Author")];
				[customObjects addObject:author];
			}
	
	if (section != nil)
	{
		[customKeys addObject:BRLocalizedString(@"Section", @"Section")];
		[customObjects addObject:section];
	}
	
	
	[currentAsset setCustomKeys:[customKeys autorelease] 
					 forObjects:[customObjects autorelease]];
	
	
	id preview = [[objc_getClass("ntvMediaPreview") alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	return [preview autorelease];
}

%new - (CABasicAnimation *)zoomInAnimation:(CATransform3D)zoomTransform
{
	
	CABasicAnimation *zoomInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	zoomInAnimation.beginTime = 0;
	zoomInAnimation.fromValue = [NSValue valueWithCATransform3D:zoomTransform];
	zoomInAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	zoomInAnimation.duration = 0.25f;
	return zoomInAnimation;
	
}

%new - (CABasicAnimation *)zoomOutAnimation:(CATransform3D)zoomTransform
{
	
	CABasicAnimation *zoomOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	zoomOutAnimation.beginTime = 0;
	zoomOutAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	zoomOutAnimation.toValue = [NSValue valueWithCATransform3D:zoomTransform];
	zoomOutAnimation.duration = 0.5f;
	return zoomOutAnimation;
	
}


#pragma mark ••popover item

%new - (void)showPopupFrom:(id)me
{
	[self showPopupFrom:me withSender:nil];

}

%new - (void)showPopupFrom:(id)me withSender:(id)sender
{
	id c = [[objc_getClass("nitoMoreMenu") alloc] initWithSender:sender addedTo:me];
	[c addToController:me];
	[c release];
	
	
}


%new - (id)blueLozenge //return the cursor / blue lozenge kajiger
{
	
	id controlArray = nil;
	
	if ([[self list] respondsToSelector:@selector(controls)])
	{
		controlArray = [[self list] controls];
	} else {
		
			//6.0!
		controlArray = [[self list] subviews];
	}
	
	NSEnumerator *controlEnum = [controlArray objectEnumerator];
	id current = nil;
	while ((current = [controlEnum nextObject]))
	{
		NSString *currentClass = NSStringFromClass([current class]);
		if ([currentClass isEqualToString:@"BRBlueGlowSelectionLozengeLayer"])
		{
			
			return current;

		}
	}
	return nil;
}


%new - (id)synthesizeMockItemFrom:(id)sender
{
	
	nitoMockMenuItem *menuItem = [[nitoMockMenuItem alloc] init];
	CGPoint newPosition = [sender position];
	newPosition.x = 948.0f;
	
	[menuItem setBounds:[sender bounds]];
	[menuItem setPosition:newPosition];
	
	return [menuItem autorelease];

}

%new - (id)synthesizeMockItem
{
	id controlArray = nil;
	
	if ([[self list] respondsToSelector:@selector(controls)])
	{
		controlArray = [[self list] controls];
	} else {
		
			//6.0!
		controlArray = [[self list] subviews];
	}
	NSEnumerator *controlEnum = [controlArray objectEnumerator];
	id current = nil;
	while ((current = [controlEnum nextObject]))
	{
			//NSLog(@"current: %@", current);
		NSString *currentClass = NSStringFromClass([current class]);
		if ([currentClass isEqualToString:@"BRBlueGlowSelectionLozengeLayer"])
		{
				//NSLog(@"we got that blueglow beyotch!");
			return [self synthesizeMockItemFrom:current];
			
		}
	}
	return nil;
}



-(BOOL)rightAction:(long)theRow
{
	
	id row = [[self list] selectedObject];
	
	[self showPopupFrom:self withSender:row];
	
	return YES;
}

- (void)itemSelected:(long)selected {
	
	id _updateArray = [self updateArray];
	if (selected == [_updateArray count]-2)
	{
		//NSLog(@"do package search instead");
		[self packageSearch];
		return;
	}
	if (selected == [_updateArray count]-1)
	{
		id row = [[self list] selectedObject];
			//NSLog(@"do package search instead");
		[self fullUpgradeWithSender:row];
		return;
	}
	NSDictionary *currentObject = [_updateArray objectAtIndex:selected];
	NSString *url = [currentObject objectForKey:@"url"];
	NSString *image = [currentObject objectForKey:@"imageUrl"];
	id controller = [[objc_getClass("PackageDataSource") alloc] initWithPackage:url usingImage:image];
	[controller setDatasource:controller];
	[controller setDelegate:self];
		//NSLog(@"controller: %@", controller);
	 [ROOT_STACK pushController:controller];
	[self setSelectedObject:url];
		//selectedObject = url;
		//[self customInstallAction:url];
	
}


%new - (void)newUberInstaller:(NSString *)customFile
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	id thatControl = [[objc_getClass("NSMFComplexProcessDropShadowControl") alloc] init];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper install %@ 2", customFile];
	[thatControl setAp:command];
		//[ROOT_STACK pushController:thatControl];
	[thatControl setTitle:[NSString stringWithFormat:@"Installing %@", customFile]];
	[thatControl addToController:self];
	[thatControl release];
	[pool release];
	
}


%new + (void)fixDepends
{
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper fixd 1 2"];
	int configReturn = system([command UTF8String]);
	NSLog(@"fixed returned with status %i", configReturn);
}


%new + (void)runConfigure
{
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper configure 1 2"];
	int configReturn = system([command UTF8String]);
	NSLog(@"configure returned with status %i", configReturn);
}

%new + (void)runAutoremove
{
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper autoremove 1 2"];
	int configReturn = system([command UTF8String]);
	NSLog(@"autoremove returned with status %i", configReturn);
		//id installStatus = [self installFinishedWithStatus:configReturn andFeedback:[self aptStatus]];
	
		//[[self stack] swapController:installStatus];
}

%new +(id)installFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback //deprecated?
{
	NSString * path = @"/tmp/aptoutput";
	
	id textControls = [[objc_getClass("kbScrollingTextControl") alloc] init];
	
	[textControls setDocumentPath:path encoding:NSUTF8StringEncoding];
	
	NSString *myTitle = nil;
	if (termStatus == 0)
	{
		myTitle = BRLocalizedString(@"Installation Successful / Up to Date",@"Installation Successful / Up to Date");
		
	} else {
		
		myTitle = BRLocalizedString(@"Installation Failed!",@"Installation Failed!" );
		NSString *returnString = [NSString stringWithContentsOfFile:@"/tmp/aptoutput" encoding:NSUTF8StringEncoding error:nil];
		NSLog(@"failure return: -%@-", returnString);
		
		if ([returnString isEqualToString:@"dpkg was interrupted, you must manually run 'dpkg --configure -a' to correct the problem. "])
		{
			NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper configure 1 2"];
			int configReturn = system([command UTF8String]);
			NSLog(@"configure returned with status %i", configReturn);
		}
	}
	
	[textControls setTitle:myTitle];
	[textControls autorelease];
	return [objc_getClass("BRController") controllerWithContentControl:textControls];
	
}

%new -(id)installFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback //deprecated?
{
	NSString * path = @"/tmp/aptoutput";
	
	id textControls = [[objc_getClass("kbScrollingTextControl") alloc] init];
	
	[textControls setDocumentPath:path encoding:NSUTF8StringEncoding];
	
	NSString *myTitle = nil;
	if (termStatus == 0)
	{
		myTitle = BRLocalizedString(@"Installation Successful / Up to Date",@"Installation Successful / Up to Date");
		
	} else {
		
		myTitle = BRLocalizedString(@"Installation Failed!",@"Installation Failed!" );
		NSString *returnString = [NSString stringWithContentsOfFile:@"/tmp/aptoutput" encoding:NSUTF8StringEncoding error:nil];
		NSLog(@"failure return: -%@-", returnString);
		
		if ([returnString isEqualToString:@"dpkg was interrupted, you must manually run 'dpkg --configure -a' to correct the problem. "])
		{
			NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper configure 1 2"];
			int configReturn = system([command UTF8String]);
			NSLog(@"configure returned with status %i", configReturn);
		}
	}
	
	[textControls setTitle:myTitle];
	[textControls autorelease];
	return [objc_getClass("BRController") controllerWithContentControl:textControls];
	
}


%new -(void)process:(id)p ended:(NSString *)s
{
		if ([p returnCode] == 0)
		{
			[p setTitle:@"Upgrade Finished Successfully!"];
			if (_essentialUpgrade == TRUE)
			{
				NSLog(@"essential upgrade boosh finder.");
				[p setSubtitle:@"Restarting Lowtide in 3 Seconds"];
				_essentialUpgrade = FALSE;
				[NSTimer timerWithTimeInterval:3 target:[%c(BRApplication) sharedApplication] selector:@selector(terminate) userInfo:nil repeats:NO];
					//[[BRApplication sharedApplication] terminate];
				return;
			}
		} else {
			[p setTitle:@"Upgrade Failed!"];
		}
	[p setSubtitle:@"Press Menu to exit"];
	_essentialUpgrade = FALSE;

}

%new - (void)runEssentialUpgrade:(NSString *)queueFile
{
	_essentialUpgrade = TRUE;
	[[self stack] popToControllerOfClass:%c(nitoInstallManager)];
	id consoleController  = [[objc_getClass("NSMFComplexProcessDropShadowControl") alloc] init];
	[consoleController setDelegate:self];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper queue %@", queueFile];
	[consoleController setAp:command];
	[consoleController setTitle:@"Upgrading Essentials..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	
}

%new - (void)runNitoTVUpgrade //deprecated, already!!
{
	_essentialUpgrade = TRUE;
	[[self stack] popToControllerOfClass:%c(nitoInstallManager)];
	id consoleController  = [[%c(NSMFComplexProcessDropShadowControl) alloc] init];
	[consoleController setDelegate:self];
	NSString *command = @"/usr/bin/nitoHelper su 1 2";
	[consoleController setAp:command];
	[consoleController setTitle:@"Upgrading nitoTV..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	
}

%new - (void)fullUpgradeWithSender:(id)sender
{
	id consoleController  = [[objc_getClass("NSMFComplexProcessDropShadowControl") alloc] init];
	[consoleController setDelegate:self];
	NSString *command = @"/usr/bin/nitoHelper upgrade 1 2";
	[consoleController setAp:command];
	[consoleController setSender:sender];
	[consoleController setIsAnimated:TRUE];
	[consoleController setTitle:@"Upgrading All..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
}

%new - (void)fullUpgrade
{	
	
	id mockumentary = [self synthesizeMockItem];
	
	id consoleController  = [[objc_getClass("NSMFComplexProcessDropShadowControl") alloc] init];
	[consoleController setDelegate:self];
	NSString *command = @"/usr/bin/nitoHelper upgrade 1 2";
	[consoleController setAp:command];
	[consoleController setSender:mockumentary];
	[consoleController setIsAnimated:TRUE];
	[consoleController setTitle:@"Upgrading All..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	
}



%new - (void)packageSearch
{
	id qm = [[objc_getClass("queryMenu") alloc] init];
	[ROOT_STACK pushController:qm];
	[qm release];
	
}


%new + (NSString *)aptStatus
{
	return [NSString stringWithContentsOfFile:@"/tmp/aptoutput" encoding:NSUTF8StringEncoding error:nil];
	
}


%new - (NSString *)aptStatus
{
	return [NSString stringWithContentsOfFile:@"/tmp/aptoutput" encoding:NSUTF8StringEncoding error:nil];
	
}


- (float)heightForRow:(long)row {
	return 0.0f;
}

- (long)itemCount {
	return [[self updateArray] count];
}


%new - (void)installOptionSelected:(id)option
{
	NSString *tempFile = @"/private/var/mobile/Library/Preferences/duwm";
		//LogSelf;
	if([[[self stack] peekController] isKindOfClass:objc_getClass("BROptionDialog")])
	{
		[[self stack] popController];
	}
	
	switch ([option selectedIndex]) {
			
		case 0: //cancel
			
			break;
			
		case 1: //install essentials
			
			
			[[self queueArray] addObjectsFromArray:[self essentialArray]];
			[self setEssentialArray:nil];
			
			[[self queueArray] writeToFile:@"/private/var/mobile/Library/Preferences/duwm" atomically:YES];
			[[self queueArray] removeAllObjects];
			[self runEssentialUpgrade:tempFile];
			
			break;
			
		case 2: //update all
			
			[self fullUpgrade];
			break;
	}
}



%new - (void)showUpdateDialog:(NSNotification *)n
{
		//LogSelf;
		//	[self showUpdateDialog];
	[self performSelectorOnMainThread:@selector(showEssentialUpdateDialog:) withObject:[n object] waitUntilDone:NO];
}


%new - (void)showEssentialUpdateDialog:(NSArray *)theArray
{
		//LogSelf;
	
	if([[[self stack] peekController] isKindOfClass: objc_getClass("BROptionDialog")])
	{
		NSLog(@"already got one of you!");
		return;
	}
	[self setEssentialArray:theArray];
		//_essentialArray = theArray;
	NSString *essentialString = [packageManagement essentialDisplayStringFromArray:theArray];
		//[_essentialArray retain]; //might not be needed
	id opDi = [[objc_getClass("BROptionDialog") alloc] init];
	[opDi setTitle:BRLocalizedString(@"Essential Updates Available", @"Essential Update Available")];
	[opDi setPrimaryInfoText:BRLocalizedString(@"The following essential updates are available, would you like to install them?",@"primary text for the alert on updating essentials")];
	[opDi setSecondaryInfoText:essentialString];
	[opDi addOptionText:BRLocalizedString(@"Cancel", @"Cancel") isDefault:YES];
	[opDi addOptionText:BRLocalizedString(@"Update Essentials", @"Update Essentials")];
	[opDi addOptionText:BRLocalizedString(@"Update All", @"Update All")];
	[opDi setActionSelector:@selector(installOptionSelected:) target:self]; //FIXME: NEED TO UPDATE THIS FOR ESSENTIAL LIST QUEUE!!!!!!!!!!!
	
	[ROOT_STACK pushController:opDi];
	[opDi release];
		//	[opDi autorelease];
	
}



%new - (void)showRemoveDialog:(NSString *)packageToRemove
{
	NSString *theTitle = [NSString stringWithFormat:BRLocalizedString(@"Delete %@?", @"alert dialog for deleting playlist"),packageToRemove];
	NSString *secondaryString = [packageManagement displayDependentsForPackage:packageToRemove];
	NSString *primaryInfo = nil;
	if ([secondaryString length] > 0)
	{
		primaryInfo = [NSString stringWithFormat:BRLocalizedString(@"The following packages depend upon %@, do you wish to delete all of them?",@"primary text for the alert on removing packages"), packageToRemove];
		
	}
	int alertResult = (int)[objc_getClass("BROptionAlertControl") postAlertWithTitle:theTitle primaryText:primaryInfo secondaryText:secondaryString firstButton:BRLocalizedString(@"Cancel", @"Cancel") secondButton:BRLocalizedString(@"Delete", @"Delete") thirdButton:nil defaultFocus:0];
	
	NSLog(@"showUpdateDialog result: %i", alertResult);
	
	switch (alertResult) {
			
		case 1: //remove
			
			[self customRemoveAction:packageToRemove];
			break;
	}	
	
	[[self list] reload];
}


- (void)controlWasActivated
{
		//LogSelf;
	
	if (_alreadyCheckedUpdate == TRUE)
	{
			//NSLog(@"already checked update");
		%orig;
		return;
	}
	
	_essentialUpgrade = FALSE;
	
		[NSThread detachNewThreadSelector:@selector(checkForUpdate) toTarget:PM	withObject:nil];
	_alreadyCheckedUpdate = TRUE;
//	if ([PM checkForUpdate] != nil)
//	{
//		self._alreadyCheckedUpdate = TRUE;
//			NSLog(@"showing updating dialog!!!");
//			//[[NSNotificationCenter defaultCenter] postNotificationName:@"CheckForUpdate" object:nil userInfo:nil];
//			[self performSelectorOnMainThread:@selector(showEssentialUpdateDialog) withObject:nil waitUntilDone:NO];
//			//[self performSelector:@selector(showUpdateDialog) withObject:nil afterDelay:5];
//			//[NSTimer timerWithTimeInterval:1 target:self selector:@selector(showUpdateDialog) userInfo:nil repeats:NO];
//	}

	%orig;
	

}

- (id) controlAtIndex: (long) row requestedBy:(id) fp12
{
	id _updateArray = [self updateArray];
	if(row > [_updateArray count])
		return ( nil );
	id  result = nil;
	NSString *theTitle = nil;
	if (row >= [_updateArray count]-2)
	{

		
		result = [objc_getClass("nitoMenuItem") ntvDownloadMenuItem];
		theTitle = [[_updateArray objectAtIndex:row] valueForKey:@"name"];
		[result setText:theTitle withAttributes:[[objc_getClass("BRThemeInfo") sharedTheme] menuItemTextAttributes]];
		
		return (result);
		
	}
	
	result = [objc_getClass("nitoMenuItem") ntvMenuItem];
	
	theTitle = [[_updateArray objectAtIndex:row] valueForKey:@"name"];
	NSString *theVersion = [[_updateArray objectAtIndex:row] valueForKey:@"version"];
	id currentDict = nil;
	NSDictionary *packageList = [PM parsedPackageList];
	NSString *currentPackage = [[_updateArray objectAtIndex:row] valueForKey:@"url"];
	
	if ([packageList objectForKey:currentPackage] != nil)
	{
		
			//NSLog(@"%@", theTitle);
		currentDict = [packageList objectForKey:currentPackage];
			//NSLog(@"current version: %@", [currentDict valueForKey:@"Version"]);
		NSString *installedVersion = [currentDict valueForKey:@"Version"];
		NSComparisonResult theResult = [theVersion compare:installedVersion options:NSNumericSearch];
			//NSLog(@"theversion: %@  installed version %@", theVersion, installedVersion);
		if ( theResult == NSOrderedDescending )
		{
				//	NSLog(@"%@ is greater than %@", theVersion, installedVersion);
			[result setRightJustifiedText:BRLocalizedString(@"Update",@"Update") withAttributes:[[objc_getClass("BRThemeInfo") sharedTheme] menuItemSmallTextAttributes]];
		} else {
			[result setRightJustifiedText:BRLocalizedString(@"Installed", @"Installed") withAttributes:[[objc_getClass("BRThemeInfo") sharedTheme] menuItemSmallTextAttributes]];
		}
		
		
	} else {
		
		[result setRightJustifiedText:BRLocalizedString(@"Not Installed", @"Not Installed") withAttributes:[[objc_getClass("BRThemeInfo") sharedTheme] menuItemSmallTextAttributes]];
	}	
	
	
	[result setText:theTitle withAttributes:[[objc_getClass("BRThemeInfo") sharedTheme] menuItemTextAttributes]];
	
	
	return ( result );
}

- (id)itemForRow:(long)row {
	if(row > [[self updateArray] count])
		return nil;
	return [self controlAtIndex:row requestedBy:nil];
}

- (BOOL)rowSelectable:(long)selectable {
	return TRUE;
}

%new - (void)removeDialog:(NSString *)packageToRemove
{
	id opDi = [[objc_getClass("BROptionDialog") alloc] init];
	NSString *secondaryString = [packageManagement displayDependentsForPackage:packageToRemove];
	[opDi setTitle:[NSString stringWithFormat:BRLocalizedString(@"Delete %@?", @"alert dialog for deleting playlist"),packageToRemove]];
	
	if ([secondaryString length] > 0)
	{
		NSString *primaryInfo = [NSString stringWithFormat:BRLocalizedString(@"The following packages depend upon %@, do you wish to delete all of them?",@"primary text for the alert on removing packages"), packageToRemove];
		[opDi setPrimaryInfoText:primaryInfo];
		[opDi setSecondaryInfoText:[packageManagement displayDependentsForPackage:packageToRemove]];
	}

	[opDi addOptionText:BRLocalizedString(@"Cancel Delete", @"cancel button") isDefault:YES];
	[opDi addOptionText:BRLocalizedString(@"Delete", @"cancel delete")];
	[opDi setActionSelector:@selector(deleteOptionSelected:) target:self];
	
	[ROOT_STACK pushController:opDi];
	[opDi autorelease];
	[self setGreenMileFile:packageToRemove];
		//greenMileFile = packageToRemove;
		//[greenMileFile retain];
}

%new - (void)deleteOptionSelected:(id)option
{
		//NSFileManager *man = [NSFileManager defaultManager];
	
	if([[[self stack] peekController] isKindOfClass:objc_getClass("BROptionDialog")])
	{
		[[self stack] popController];
	}
	
	switch ([option selectedIndex]) {
			
		case 0: //cancel
			
			break;
			
		case 1: //delete
			
			[self customRemoveAction:[self greenMileFile]];
			
			break;
	}
}
- (BOOL)leftAction:(long)theRow
{
	NSDictionary *currentObject = [[self updateArray] objectAtIndex:theRow];
	NSString *url = [currentObject objectForKey:@"url"];
	if ([PM packageInstalled:url])
	{
		if ([PM canRemove:url])
		{
				//[self removeDialog:url];
			[self showRemoveDialog:url];
			return YES;
		} else {
			[self showProtectedAlert:url];
			PLAY_FAIL_SOUND;
			return YES;
		}
		
	} else {
		return NO;
	}
	
	return NO;
	
}

%new - (void)customRemoveActionNew:(id)theFile
{
	id spinControl = [[objc_getClass("BRTextWithSpinnerController") alloc] initWithTitle:nil text:[NSString stringWithFormat:BRLocalizedString(@"removing %@",@"removing %@"),theFile]];
		//NSLog(@"text string: %@", [text stringValue]);
	[[self stack] swapController:spinControl];
	[spinControl release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theFile forKey:@"text"];
	[NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(removeCustomFinal:) userInfo: userInfo repeats: NO];
	
}

%new - (void)customRemoveAction:(id)theFile
{
	id spinControl = [[objc_getClass("BRTextWithSpinnerController") alloc] initWithTitle:nil text:[NSString stringWithFormat:BRLocalizedString(@"removing %@",@"removing %@"),theFile]];
	//NSLog(@"text string: %@", [text stringValue]);
	[ROOT_STACK pushController:spinControl];
	[spinControl release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theFile forKey:@"text"];
	[NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(removeCustomFinal:) userInfo: userInfo repeats: NO];
	
}

%new - (void)removeCustomFinal:(id)timer
{
	//NSLog(@"userInfo: %@", [timer userInfo]);
	[self removeCustom:[[timer userInfo] objectForKey:@"text"]];
	
}

%new - (void)removeCustom:(NSString *)customFile
{
	NSString *command = [NSString stringWithFormat:@"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/uninstall_dpkg.sh %@", customFile];
	//NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper remove %@", customFile];
	int sysReturn = system([command UTF8String]);

	[packageManagement updatePackageList];
		//[[self list] reload];
	NSLog(@"remove custom returned with status %i", sysReturn);
	id installStatus = [self removeFinishedWithStatus:sysReturn andFeedback:[self aptStatus]];

	
	[[self stack] swapController:installStatus];
}

%new -(id)removeFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback
{
	NSString * path = @"/tmp/aptoutput";
	
	id textControls = [[objc_getClass("kbScrollingTextControl") alloc] init];
	
	[textControls setDocumentPath:path encoding:NSUTF8StringEncoding];
	
	NSString *myTitle = nil;
	if (termStatus == 0)
	{
		myTitle = BRLocalizedString(@"Package Removal Successful", @"Package Removal Successful");
		
	} else {
		
		myTitle = BRLocalizedString(@"Package Removal Failed!",@"Package Removal Failed!" );
	}
	
	[textControls setTitle:myTitle];
	[textControls autorelease];
	return [objc_getClass("BRController") controllerWithContentControl:textControls];
	
}


/* random cycript shit?
 
 [[[[[[[[[BRApplicationStackManager singleton] stack] controllers] objectAtIndex:0] controls] objectAtIndex:0] controls] lastObject] constrainAllContentToEdges]
 [[[[[[[[BRApplicationStackManager singleton] stack] controllers] objectAtIndex:0] controls] objectAtIndex:0] controls] lastObject]
 [[[[[[[[[BRApplicationStackManager singleton] stack] controllers] objectAtIndex:0] controls] objectAtIndex:0] controls] lastObject] _attemptToRemoveFadeMask]
 [[[[BRApplicationStackManager singleton] stack] peekController] isKindOfClass: [nitoInstallManager class]]
 
 //[[[[[[[[[[[BRApplicationStackManager singleton] stack] controllers] objectAtIndex:0] controls] objectAtIndex:0] controls] lastObject] controls] lastObject] removeFromParent]
 //[self _dumpControlTree];
 //[[[[[BRApplicationStackManager singleton] stack] controllers] objectAtIndex:0] _dumpControlTree]
 //[[[[[[[[BRApplicationStackManager singleton] stack] controllers] objectAtIndex:0] controls] objectAtIndex:0] controls] lastObject]
 [[[[[[[[[[[BRApplicationStackManager singleton] stack] controllers] objectAtIndex:0] controls] objectAtIndex:0] controls] lastObject] _bottomFadeFilters] objectAtIndex:0] valueForKey:@"inputColor0"]
 
 var a = [[[[[[[[[[[BRApplicationStackManager singleton] stack] controllers] objectAtIndex:0] controls] objectAtIndex:0] controls] lastObject] _bottomFadeFilters] objectAtIndex:0] valueForKey:@"inputColor0"];
 [[[[[[[[[[[BRApplicationStackManager singleton] stack] controllers] objectAtIndex:0] controls] objectAtIndex:0] controls] lastObject] _bottomFadeFilters] objectAtIndex:0] setValue:a forKey:@"inputColor1"];
 
 [[[BRApplicationStackManager singleton] stack] layoutSubcontrols]
 
 */


%end
	//@end

