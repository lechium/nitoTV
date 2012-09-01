//
//  NitoInstallManager.m
//  nitoTV
//
//  Created by Kevin Bradley on 11/11/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

#import "nitoInstallManager.h"
#import "ntvMedia.h"
#import "ntvMediaPreview.h"
#import "queryMenu.h"
#import "kbScrollingTextControl.h"
#import "PackageDataSource.h"
#import "packageManagement.h"
#import <SMFramework/SMFComplexProcessDropShadowControl.h>
#import "nitoMockMenuItem.h"
#import <SMFramework/SMFramework.h>
#import "nitoMoreMenu.h"

#define kNitoWebURL @"http://nitosoft.com/ATV2/install/payloads.plist"





@implementation nitoInstallManager

@synthesize selectedObject, queueArray, essentialUpgrade, _essentialArray, _alreadyCheckedUpdate;

+ (int)versionSafe:(NSDictionary *)pluginDict //0 = safe, 1 = too low, 2 = too high
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

+ (NSArray *)nitoPackageArray
{
	NSURL *theUrl = [[NSURL alloc]initWithString:kNitoWebURL];
	NSArray *initialArray = [[NSArray alloc] initWithContentsOfURL:[theUrl autorelease]];
	NSMutableArray *newArray = [[NSMutableArray alloc] init];
	for (id currentObject in initialArray)
	{
		if ([nitoInstallManager versionSafe:currentObject] == 0)
		{
			[newArray addObject:currentObject];
		}
	}
	[initialArray release];
	return [newArray autorelease];
}

+ (NSArray *)oldnitoPackageArray
{
	NSURL *theUrl = [[NSURL alloc]initWithString:kNitoWebURL];
	return [[[NSArray alloc] initWithContentsOfURL:[theUrl autorelease]] autorelease];
}

- (id)initWithTitle:(NSString *)theTitle

{
	
	self = [super initWithTitle:theTitle];
	[self setLabel:@"com.nito.installation"];
	NSString *settingsPng = [[NSBundle bundleForClass:[nitoInstallManager class]] pathForResource:@"packagemaker" ofType:@"png" inDirectory:@"Images"];
	self.essentialUpgrade = FALSE;
	self._alreadyCheckedUpdate = FALSE;
	queueArray = [[NSMutableArray alloc] init];
	id sp = [BRImage imageWithPath:settingsPng];
	[self setListIcon:sp horizontalOffset:0.0 kerningFactor:0.15];
	
	_versions = [[NSMutableArray alloc] init];
	updateArray = [[NSMutableArray alloc] init];
	
	BOOL internetAvailable = [BRIPConfiguration internetAvailable];
	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUpdateDialog:) name:@"CheckForUpdate" object:nil];

	if (internetAvailable == YES)
	{
		
		[updateArray addObjectsFromArray:[nitoInstallManager nitoPackageArray]];
			//	updateArray = [[NSArray alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:kNitoWebURL]];
		NSDictionary *packageSearchDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Search for Packages", @"name", @"Search for debian packages on the Cydia and awkwardTV repositories", @"description", @"url", @"com.package.search", @"1.0", @"version", nil];
		[updateArray addObject:packageSearchDict];
		NSDictionary *updateAll = [NSDictionary dictionaryWithObjectsAndKeys:@"Update All", @"name", @"runs apt-get -y -u dist-upgrade", @"description", @"url", @"com.package.search", @"1.0", @"version", nil];
		[updateArray addObject:updateAll];
		
	} else {
		
		
		BRAlertController *alertCon = [self _internetNotAvailable];
		[alertCon retain];
		return alertCon;
		
	}
	
	
	
	//[updateArray retain];
	
	[[self list] setDatasource:self];
	[[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"Featured", @"Featured menu item divider in software section")];
	[[self list] addDividerAtIndex:[updateArray count]-2 withLabel:BRLocalizedString(@"Options", @"Options menu item divider in software section")];

	
	return (self);
	
}

-(void)controller:(PackageDataSource *)c switchedFocusTo:(BRControl *)newControl {
		//NSLog(@"controller of type %@ focused", [newControl class]);	
}

void nitoLogFrame(CGRect frame)
{
    NSLog(@"{{%f, %f},{%f,%f}}",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}

void nitoLogPosition(CGPoint point)
{
	 NSLog(@"{%f, %f}", point.x ,point.y);
}

#pragma mark PackageDataSource delegate methods

-(void)controller:(PackageDataSource *)c buttonSelectedAtIndex:(int)index
{
		//NSLog(@"%@ buttonSelectedAtIndex: %i", c, index);
	id selectedButton = [[c _buttons] objectAtIndex:index];
		//NSLog(@"selectedButton: %@", selectedButton);
		//nitoLogFrame([selectedButton bounds]);
		//nitoLogPosition([selectedButton position]);
	
	switch (index) {
		
		case kNitoInstallButton: //install
			
			if ([queueArray count] > 0)
			{
				[queueArray addObject:selectedObject];
				NSString *tempFile = @"/private/var/mobile/Library/Preferences/duwm";
				[queueArray writeToFile:tempFile atomically:YES];
				[queueArray removeAllObjects];
				
					//	NSLog(@"installing: %@", tempFile);
				[c setListActionMode:kPackageInstallMode];
					//[c installQueue:tempFile];
				[c installQueue:tempFile withSender:selectedButton];
				return;
			}
			
				//NSLog(@"installing: %@", selectedObject);
				//	NSLog(@"c packageData: %@", [c packageData]);
			[c setListActionMode:kPackageInstallMode];
			[c newUberInstaller:selectedObject withSender:selectedButton];
			break;

		case kNitoQueueButton: //queue
				//NSLog(@"queue: %@", selectedObject);
			
			if ([[self queueArray] containsObject:selectedObject])
			{
				[[self queueArray] removeObject:selectedObject];
				[c removeQueuePopupWithPackage:selectedObject];
				return;
			}
			[[self queueArray] addObject:selectedObject];
			
			//NSLog(@"queueArray: %@", self.queueArray);
			[c queuePopupWithPackage:selectedObject];
			
			break;
			
		case kNitoRemoveButton: //remove
								//NSLog(@"remove: %@", selectedObject);
			if ([PM packageInstalled:selectedObject])
			{
				if ([PM canRemove:selectedObject])
				{
					[c setListActionMode:KPackageRemoveMode];
						//[c removePackage:selectedObject];
					NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:selectedObject, @"Package", selectedButton, @"Sender", nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveDialog" object:nil userInfo:userInfo];
						//[c removePackage:selectedObject withSender:selectedButton];
				} else {
					[self showProtectedAlert:selectedObject];
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




- (void)showProtectedAlert:(NSString *)protectedPackage
{
	BRAlertController *result = [[BRAlertController alloc] initWithType:0 titled:BRLocalizedString(@"Required Package", @"alert when there is a required / unremovable package") primaryText:[NSString stringWithFormat:BRLocalizedString(@"The Package %@ is required for proper operation of your AppleTV and cannot be removed", @"primary text when there is a required / unremovable package"), protectedPackage] secondaryText:BRLocalizedString(@"Press menu to exit", @"seconday text when there is a required / unremovable package") ];
	[[self stack] pushController:result];
	 [result release];
}


-(void)controller:(PackageDataSource *)c selectedControl:(BRControl *)ctrl
{
	if ([ctrl respondsToSelector:@selector(selectedControl)])
	{
		id data = [[c provider] data];
		BRPosterControl *selectedControl = [(BRMediaShelfView *)ctrl selectedControl];
		int focusedIndex = [(BRMediaShelfView *)ctrl focusedIndex];
		id myAsset = [data objectAtIndex:focusedIndex];
		NSString *packageName = [[selectedControl title] string];
		BRImage *theImage = [myAsset coverArt];
			//NSLog(@"selectedControl: %@ packageName: %@ index: %i", selectedControl, packageName, focusedIndex);
		selectedObject = packageName;
		[c updatePackageData:packageName usingImage:theImage];

	}
	
	
}






- (BRAlertController *)_internetNotAvailable
{
	BRAlertController *result = [[BRAlertController alloc] initWithType:0 titled:BRLocalizedString(@"Internet Unavailable", @"alert when there is no internet connection") primaryText:BRLocalizedString(@"Install Software requires an internet connection. Please connect your AppleTV to the Internet.", @"primary text when there is no internet connection") secondaryText:BRLocalizedString(@"Press menu to exit", @"seconday text when when there is no internet connection") ];
	return [result autorelease];
	
	
}

-(void)dealloc
{
	[updateArray release];
	updateArray = nil;
	[queueArray release];
	queueArray = nil;
	[_essentialArray release];
	_essentialArray = nil;
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


- (id)previewControlForItem:(long)item
{
	//BRImageAndSyncingPreviewController
	
	//return nil;
	ntvMedia *currentAsset = [[ntvMedia alloc] init];
	[currentAsset setTitle:[[updateArray objectAtIndex:item] valueForKey:@"name"]];
	NSString *currentURL = [[updateArray objectAtIndex:item] valueForKey:@"imageUrl"];
	NSString *currentVersion = [[updateArray objectAtIndex:item] valueForKey:@"version"];
	NSString *description = nil;
	NSString *author = nil;
	NSString *section = nil;
	if ([[[updateArray objectAtIndex:item] allKeys] containsObject:@"description"])
		description = [[updateArray objectAtIndex:item] valueForKey:@"description"];
	if (currentURL != nil)
	{	[currentAsset setCoverArt:[BRImage imageWithURL:[NSURL URLWithString:currentURL]]];
		
	} else
	{
			[currentAsset setCoverArt:[[NitoTheme sharedTheme] packageImage]];
		
	}
	
	if (item == [self itemCount])
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
	
	if ([[[updateArray objectAtIndex:item] allKeys] containsObject:@"author"])
		author = [[updateArray objectAtIndex:item] valueForKey:@"author"];
	if ([[[updateArray objectAtIndex:item] allKeys] containsObject:@"section"])
		section = [[updateArray objectAtIndex:item] valueForKey:@"section"];
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
	
	
	ntvMediaPreview *preview = [[ntvMediaPreview alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	return [preview autorelease];
}

- (CABasicAnimation *)zoomInAnimation:(CATransform3D)zoomTransform
{
	
	CABasicAnimation *zoomInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	zoomInAnimation.beginTime = 0;
	zoomInAnimation.fromValue = [NSValue valueWithCATransform3D:zoomTransform];
	zoomInAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	zoomInAnimation.duration = 0.25f;
	return zoomInAnimation;
	
}

- (CABasicAnimation *)zoomOutAnimation:(CATransform3D)zoomTransform
{
	
	CABasicAnimation *zoomOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	zoomOutAnimation.beginTime = 0;
	zoomOutAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	zoomOutAnimation.toValue = [NSValue valueWithCATransform3D:zoomTransform];
	zoomOutAnimation.duration = 0.5f;
	return zoomOutAnimation;
	
}


#pragma mark ••popover item

- (void)showPopupFrom:(id)me
{
	return [self showPopupFrom:me withSender:nil];

}

- (void)showPopupFrom:(id)me withSender:(id)sender
{
	nitoMoreMenu *c = [[nitoMoreMenu alloc] initWithSender:sender addedTo:me];
	[c addToController:me];
	[c release];
	/*
	
	SMFListDropShadowControl *c = [[SMFListDropShadowControl alloc]init];
	
	[c setCDelegate:me];
	[c setSender:sender];
	[c setCDatasource:me];
	[c setIsAnimated:TRUE];
	[c addToController:me];
	*/
	
		//nitoLogFrame(test);
		//nitoLogPosition(pos);
		//[c release];
	
}


- (id)blueLozenge //return the cursor / blue lozenge kajiger
{
	NSEnumerator *controlEnum = [[[self list] controls] objectEnumerator];
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


- (id)synthesizeMockItemFrom:(id)sender
{
	
	nitoMockMenuItem *menuItem = [[nitoMockMenuItem alloc] init];
	CGPoint newPosition = [sender position];
	newPosition.x = 948.0f;
	
	[menuItem setBounds:[sender bounds]];
	[menuItem setPosition:newPosition];
	
	return [menuItem autorelease];

}

- (id)synthesizeMockItem
{
	NSEnumerator *controlEnum = [[[self list] controls] objectEnumerator];
	id current = nil;
	while ((current = [controlEnum nextObject]))
	{
		NSString *currentClass = NSStringFromClass([current class]);
		if ([currentClass isEqualToString:@"BRBlueGlowSelectionLozengeLayer"])
		{
			
			return [self synthesizeMockItemFrom:current];
			
		}
	}
	return nil;
}



-(BOOL)rightAction:(long)theRow
{
		//id newey = [self synthesizeMockItem];
	
		//	[self showPopupFrom:self withSender:newey];
	//nitoLogPosition([bluey position]);
	//[self showPopupFrom:self withSender:bluey];
		id row = [[self list] selectedObject];
		//nitoLogFrame([row bounds]);
		//nitoLogPosition([row position]);
		//[self showPopupFrom:self];
		[self showPopupFrom:self withSender:row];
		//NSArray *packageList = [self nuParsedPackageList];
	//NSLog(@"packageList: %@", packageList);
	return YES;
}

- (void)itemSelected:(long)selected; {
	
	if (selected == [updateArray count]-2)
	{
		//NSLog(@"do package search instead");
		[self packageSearch];
		return;
	}
	if (selected == [updateArray count]-1)
	{
		id row = [[self list] selectedObject];
			//NSLog(@"do package search instead");
		[self fullUpgradeWithSender:row];
		return;
	}
	NSDictionary *currentObject = [updateArray objectAtIndex:selected];
	NSString *url = [currentObject objectForKey:@"url"];
	NSString *image = [currentObject objectForKey:@"imageUrl"];
	id controller = [[PackageDataSource alloc] initWithPackage:url usingImage:image];
	[controller setDatasource:controller];
	[controller setDelegate:self];
	 [[self stack] pushController:controller];
	selectedObject = url;
		//[self customInstallAction:url];
	
}


- (void)newUberInstaller:(NSString *)customFile
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	SMFComplexProcessDropShadowControl *thatControl = [[SMFComplexProcessDropShadowControl alloc] init];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper install %@ 2", customFile];
	[thatControl setAp:command];
		//[[self stack] pushController:thatControl];
	[thatControl setTitle:[NSString stringWithFormat:@"Installing %@", customFile]];
	[thatControl addToController:self];
	[thatControl release];
	[pool release];
	
}


+ (void)fixDepends
{
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper fixd 1 2"];
	int configReturn = system([command UTF8String]);
	NSLog(@"fixed returned with status %i", configReturn);
}


+ (void)runConfigure
{
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper configure 1 2"];
	int configReturn = system([command UTF8String]);
	NSLog(@"configure returned with status %i", configReturn);
}

+ (void)runAutoremove
{
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper autoremove 1 2"];
	int configReturn = system([command UTF8String]);
	NSLog(@"autoremove returned with status %i", configReturn);
		//id installStatus = [self installFinishedWithStatus:configReturn andFeedback:[self aptStatus]];
	
		//[[self stack] swapController:installStatus];
}

+(id)installFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback
{
	NSString * path = @"/tmp/aptoutput";
	
	kbScrollingTextControl *textControls = [[kbScrollingTextControl alloc] init];
	
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
	return [BRController controllerWithContentControl:textControls];
	
}

-(id)installFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback
{
	NSString * path = @"/tmp/aptoutput";
	
	kbScrollingTextControl *textControls = [[kbScrollingTextControl alloc] init];
	
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
	return [BRController controllerWithContentControl:textControls];
	
}


-(void)process:(SMFComplexProcessDropShadowControl *)p ended:(NSString *)s
{
		if ([p returnCode] == 0)
		{
			[p setTitle:@"Upgrade Finished Successfully!"];
			if (self.essentialUpgrade == TRUE)
			{
				NSLog(@"essential upgrade boosh finder.");
				[p setSubtitle:@"Restarting Lowtide in 3 Seconds"];
				self.essentialUpgrade = FALSE;
				[NSTimer timerWithTimeInterval:3 target:[BRApplication sharedApplication] selector:@selector(terminate) userInfo:nil repeats:NO];
					//[[BRApplication sharedApplication] terminate];
				return;
			}
		} else {
			[p setTitle:@"Upgrade Failed!"];
		}
	[p setSubtitle:@"Press Menu to exit"];
	self.essentialUpgrade = FALSE;

}

- (void)runEssentialUpgrade:(NSString *)queueFile
{
	self.essentialUpgrade = TRUE;
	[[self stack] popToControllerOfClass:[nitoInstallManager class]];
	id consoleController  = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper queue %@", queueFile];
	[consoleController setAp:command];
	[consoleController setTitle:@"Upgrading Essentials..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	
}

- (void)runNitoTVUpgrade //deprecated, already!!
{
	self.essentialUpgrade = TRUE;
	[[self stack] popToControllerOfClass:[nitoInstallManager class]];
	id consoleController  = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = @"/usr/bin/nitoHelper su 1 2";
	[consoleController setAp:command];
	[consoleController setTitle:@"Upgrading nitoTV..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	
}

- (void)fullUpgradeWithSender:(id)sender
{
	id consoleController  = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = @"/usr/bin/nitoHelper upgrade 1 2";
	[consoleController setAp:command];
	[consoleController setSender:sender];
	[consoleController setIsAnimated:TRUE];
	[consoleController setTitle:@"Upgrading All..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
}

- (void)fullUpgrade
{	
	
	id mockumentary = [self synthesizeMockItem];
	
	id consoleController  = [[SMFComplexProcessDropShadowControl alloc] init];
	[consoleController setDelegate:self];
	NSString *command = @"/usr/bin/nitoHelper upgrade 1 2";
	[consoleController setAp:command];
	[consoleController setSender:mockumentary];
	[consoleController setIsAnimated:TRUE];
	[consoleController setTitle:@"Upgrading All..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	
}



- (void)packageSearch
{
	queryMenu *qm = [[queryMenu alloc] init];
	[[self stack] pushController:qm];
	[qm release];
	
}


+ (NSString *)aptStatus
{
	return [NSString stringWithContentsOfFile:@"/tmp/aptoutput" encoding:NSUTF8StringEncoding error:nil];
	
}


- (NSString *)aptStatus
{
	return [NSString stringWithContentsOfFile:@"/tmp/aptoutput" encoding:NSUTF8StringEncoding error:nil];
	
}


- (float)heightForRow:(long)row {
	return 0.0f;
}

- (long)itemCount {
	return [updateArray count];
}


- (void)installOptionSelected:(id)option
{
		//LogSelf;
	if([[[self stack] peekController] isKindOfClass: [BROptionDialog class]])
	{
		[[self stack] popController];
	}
	
	switch ([option selectedIndex]) {
			
		case 0: //cancel
			
			break;
			
		case 1: //install essentials
			
			
			[queueArray addObjectsFromArray:_essentialArray];
			_essentialArray = nil;
			NSString *tempFile = @"/private/var/mobile/Library/Preferences/duwm";
			[queueArray writeToFile:tempFile atomically:YES];
			[queueArray removeAllObjects];
			[self runEssentialUpgrade:tempFile];
			
			break;
			
		case 2: //update all
			
			[self fullUpgrade];
			break;
	}
}

/*
- (void)installOptionSelected:(id)option
{
		//LogSelf;
	if([[[self stack] peekController] isKindOfClass: [BROptionDialog class]])
	{
		[[self stack] popController];
	}
	
	switch ([option selectedIndex]) {
			
		case 0: //cancel
			
			break;
			
		case 1: //install
			
			[self runNitoTVUpgrade];
			
			break;
	}
}
 */

- (void)showUpdateDialog:(NSNotification *)n
{
		//LogSelf;
		//	[self showUpdateDialog];
	[self performSelectorOnMainThread:@selector(showEssentialUpdateDialog:) withObject:[n object] waitUntilDone:NO];
}


- (void)showEssentialUpdateDialog:(NSArray *)theArray
{
		//LogSelf;
	
	if([[[self stack] peekController] isKindOfClass: [BROptionDialog class]])
	{
		NSLog(@"already got one of you!");
		return;
	}
	_essentialArray = theArray;
	NSString *essentialString = [packageManagement essentialDisplayStringFromArray:_essentialArray];
	[_essentialArray retain]; //might not be needed
	BROptionDialog *opDi = [[BROptionDialog alloc] init];
	[opDi setTitle:BRLocalizedString(@"Essential Updates Available", @"Essential Update Available")];
	[opDi setPrimaryInfoText:BRLocalizedString(@"The following essential updates are available, would you like to install them?",@"primary text for the alert on updating essentials")];
	[opDi setSecondaryInfoText:essentialString];
	[opDi addOptionText:BRLocalizedString(@"Cancel", @"Cancel") isDefault:YES];
	[opDi addOptionText:BRLocalizedString(@"Update Essentials", @"Update Essentials")];
	[opDi addOptionText:BRLocalizedString(@"Update All", @"Update All")];
	[opDi setActionSelector:@selector(installOptionSelected:) target:self]; //FIXME: NEED TO UPDATE THIS FOR ESSENTIAL LIST QUEUE!!!!!!!!!!!
	
	[[self stack] pushController:opDi];
	[opDi release];
		//	[opDi autorelease];
	
}

//- (void)showUpdateDialog //deprecated
//{
//		//LogSelf;
//	
//	if([[[self stack] peekController] isKindOfClass: [BROptionDialog class]])
//	{
//		NSLog(@"already got one of you!");
//		return;
//	}
//	BROptionDialog *opDi = [[BROptionDialog alloc] init];
//	[opDi setTitle:BRLocalizedString(@"nitoTV Update Available", @"nitoTV Update Available")];
//	[opDi setPrimaryInfoText:BRLocalizedString(@"An update is available for nitoTV, would you like to install it?",@"primary text for the alert on updating nitoTV")];
//	[opDi addOptionText:BRLocalizedString(@"Cancel", @"Cancel") isDefault:YES];
//	[opDi addOptionText:BRLocalizedString(@"Install", @"install")];
//	[opDi setActionSelector:@selector(installOptionSelected:) target:self];
//	
//	[[self stack] pushController:opDi];
//		//	[opDi autorelease];
//
//}

- (void)showRemoveDialog:(NSString *)packageToRemove
{
	NSString *theTitle = [NSString stringWithFormat:BRLocalizedString(@"Delete %@?", @"alert dialog for deleting playlist"),packageToRemove];
	NSString *secondaryString = [packageManagement displayDependentsForPackage:packageToRemove];
	NSString *primaryInfo = nil;
	if ([secondaryString length] > 0)
	{
		primaryInfo = [NSString stringWithFormat:BRLocalizedString(@"The following packages depend upon %@, do you wish to delete all of them?",@"primary text for the alert on removing packages"), packageToRemove];
		
	}
	int alertResult = [BROptionAlertControl postAlertWithTitle:theTitle primaryText:primaryInfo secondaryText:secondaryString firstButton:BRLocalizedString(@"Cancel", @"Cancel") secondButton:BRLocalizedString(@"Delete", @"Delete") thirdButton:nil defaultFocus:0];
	
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
	
	if (self._alreadyCheckedUpdate == TRUE)
	{
			//NSLog(@"already checked update");
		[super controlWasActivated];
		return;
	}
	
	essentialUpgrade = FALSE;
	
	[NSThread detachNewThreadSelector:@selector(checkForUpdate) toTarget:PM	withObject:nil];
	self._alreadyCheckedUpdate = TRUE;
//	if ([PM checkForUpdate] != nil)
//	{
//		self._alreadyCheckedUpdate = TRUE;
//			NSLog(@"showing updating dialog!!!");
//			//[[NSNotificationCenter defaultCenter] postNotificationName:@"CheckForUpdate" object:nil userInfo:nil];
//			[self performSelectorOnMainThread:@selector(showEssentialUpdateDialog) withObject:nil waitUntilDone:NO];
//			//[self performSelector:@selector(showUpdateDialog) withObject:nil afterDelay:5];
//			//[NSTimer timerWithTimeInterval:1 target:self selector:@selector(showUpdateDialog) userInfo:nil repeats:NO];
//	}

	[super controlWasActivated];
	

}

- (id) controlAtIndex: (long) row requestedBy:(id) fp12;
{
	if(row > [updateArray count])
		return ( nil );
	BRMenuItem * result = nil;
	NSString *theTitle = nil;
	if (row >= [updateArray count]-2)
	{

		result = [BRMenuItem ntvDownloadMenuItem];
		theTitle = [[updateArray objectAtIndex:row] valueForKey:@"name"];
		[result setText:theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
		return (result);
	}
	
	result = [BRMenuItem ntvMenuItem];
	
	theTitle = [[updateArray objectAtIndex:row] valueForKey:@"name"];
	NSString *theVersion = [[updateArray objectAtIndex:row] valueForKey:@"version"];
	id currentDict = nil;
	NSDictionary *packageList = [PM parsedPackageList];
	NSString *currentPackage = [[updateArray objectAtIndex:row] valueForKey:@"url"];
	
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
			[result setRightJustifiedText:BRLocalizedString(@"Update",@"Update") withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
		} else {
			[result setRightJustifiedText:BRLocalizedString(@"Installed", @"Installed") withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
		}
		
		
	} else {
		
		[result setRightJustifiedText:BRLocalizedString(@"Not Installed", @"Not Installed") withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
	}	
	
	
	[result setText:theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
	
	return ( result );
}

- (id)itemForRow:(long)row {
	if(row > [updateArray count])
		return nil;
	return [self controlAtIndex:row requestedBy:nil];
	//NSLog(@"%@ %s", self, _cmd);
	BRMenuItem * result = [BRMenuItem ntvDownloadMenuItem];
	//NSString *theTitle = [_menuItems objectAtIndex: row];
	NSString *theTitle = [[updateArray objectAtIndex:row] valueForKey:@"name"];
	[result setText:theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	
	return result;
}

- (BOOL)rowSelectable:(long)selectable {
	return TRUE;
}

- (void)removeDialog:(NSString *)packageToRemove
{
	BROptionDialog *opDi = [[BROptionDialog alloc] init];
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
	
	[[self stack] pushController:opDi];
	[opDi autorelease];
	greenMileFile = packageToRemove;
	[greenMileFile retain];
}

- (void)deleteOptionSelected:(id)option
{
		//NSFileManager *man = [NSFileManager defaultManager];
	
	if([[[self stack] peekController] isKindOfClass: [BROptionDialog class]])
	{
		[[self stack] popController];
	}
	
	switch ([option selectedIndex]) {
			
		case 0: //cancel
			
			break;
			
		case 1: //delete
			
			[self customRemoveAction:greenMileFile];
			
			break;
	}
}
- (BOOL)leftAction:(long)theRow
{
	NSDictionary *currentObject = [updateArray objectAtIndex:theRow];
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

- (void)customRemoveActionNew:(id)theFile
{
	id spinControl = [[BRTextWithSpinnerController alloc] initWithTitle:nil text:[NSString stringWithFormat:BRLocalizedString(@"removing %@",@"removing %@"),theFile]];
		//NSLog(@"text string: %@", [text stringValue]);
	[[self stack] swapController:spinControl];
	[spinControl release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theFile forKey:@"text"];
	[NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(removeCustomFinal:) userInfo: userInfo repeats: NO];
	
}

- (void)customRemoveAction:(id)theFile
{
	id spinControl = [[BRTextWithSpinnerController alloc] initWithTitle:nil text:[NSString stringWithFormat:BRLocalizedString(@"removing %@",@"removing %@"),theFile]];
	//NSLog(@"text string: %@", [text stringValue]);
	[[self stack] pushController:spinControl];
	[spinControl release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theFile forKey:@"text"];
	[NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(removeCustomFinal:) userInfo: userInfo repeats: NO];
	
}

- (void)removeCustomFinal:(id)timer
{
	//NSLog(@"userInfo: %@", [timer userInfo]);
	[self removeCustom:[[timer userInfo] objectForKey:@"text"]];
	
}

- (void)removeCustom:(NSString *)customFile
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

-(id)removeFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback
{
	NSString * path = @"/tmp/aptoutput";
	
	kbScrollingTextControl *textControls = [[kbScrollingTextControl alloc] init];
	
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
	return [BRController controllerWithContentControl:textControls];
	
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


@end

