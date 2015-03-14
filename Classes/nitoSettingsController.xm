//
//  nitoSettingsController.m
//  nitoTV2
//
//  Created by Kevin Bradley on 10/26/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//
//#import "ntvMediaPreview.h"
//#import "ntvMedia.h"
//#import "nitoSettingsController.h"
//#import "kbScrollingTextControl.h"
//#import "CPlusFunctions.mm"
//#import "PackageDataSource.h"
//#import <UIKit/UIKit.h>
// deb http://apt.awkwardtv.org ./
// /etc/apt/sources.list.d

	///private/var/cache/apt/archives < --where deb packages are stored

#define BRTHEME [objc_getClass("BRThemeInfo") sharedTheme]
#define THEME [NitoTheme sharedTheme]

static int _textEntryType;

enum {
	
	kNUpdateNitoTVMenuItem = 0,
	kNUpdateCheckFrequencyMenuItem,
	kNViewSyslogMenuItem,
	kNRestartLowtideMenuItem,
	kNRebootAppleTVMenuItem,
	
};

/*
[_names addObject:BRLocalizedString(@"Update nitoTV", @"Update nitoTV menu item")];
[_names addObject:BRLocalizedString(@"AppleTV Updates", @"Block updates menu item")];
[_names addObject:BRLocalizedString(@"Log All Notifications", @"Log All Notifications")];
[_names addObject:BRLocalizedString(@"Check For Updates", @"Check For Updates")];
[_names addObject:BRLocalizedString(@"View System Log", @"View System Log")];
[_names addObject:BRLocalizedString(@"Restart Lowtide", @"Restart Lowtide menu item")];
[_names	addObject:BRLocalizedString(@"Reboot AppleTV", @"Reboot AppleTV menu item")];
*/

%subclass nitoScrollingTextControl : BRScrollingTextControl
	
%new -(id)textBox
{

	return MSHookIvar<id>(self, "_textBox");
}


%end

/*

@interface BRScrollingTextControl (specialAdditions)


- (BRScrollingTextBoxControl *)textBox;

@end


@implementation BRScrollingTextControl (specialAdditions)

- (BRScrollingTextBoxControl *)textBox
{
	return MSHookIvar<BRScrollingTextBoxControl *>(self, "_textBox");
}


@end

@interface BRScrollingTextBoxControl (specialAdditions)


- (BRVerticalScrollBarControl *)scrollBar;
- (BRListControl *)list;


@end


@implementation BRScrollingTextBoxControl (specialAdditions)

- (BRVerticalScrollBarControl *)scrollBar
{
	return MSHookIvar<BRVerticalScrollBarControl *>(self, "_scrollBar");
}

- (BRListControl *)list
{
	return MSHookIvar<BRListControl *>(self, "_list");
}

@end

*/


%subclass nitoSettingsController : nitoMediaMenuController

	//@implementation nitoSettingsController



-(id)initWithTitle:(NSString *)theTitle
{
	self = %orig;
	
	if (self != nil)
	{
		id _names = [self names];
			//id settingsImage = [[%c(BRThemeInfo) sharedTheme] gearImage];
			//[self setListIcon:settingsImage];
		[_names addObject:BRLocalizedString(@"Update nitoTV", @"Update nitoTV menu item")];
			//[_names addObject:BRLocalizedString(@"AppleTV Updates", @"Block updates menu item")];
		[_names addObject:BRLocalizedString(@"Check For Updates", @"Check For Updates")];
		//[_names addObject:BRLocalizedString(@"Log All Notifications", @"Log All Notifications")];
		[_names addObject:BRLocalizedString(@"View System Log", @"View System Log")];
		[_names addObject:BRLocalizedString(@"Restart Lowtide", @"Restart Lowtide menu item")];
		
		//if (![packageManagement ntvFivePointOnePlus])
		[_names	addObject:BRLocalizedString(@"Reboot AppleTV", @"Reboot AppleTV menu item")];
		
		
		
		
		[[self list] setDatasource:self];
		[[self list] addDividerAtIndex:3 withLabel:BRLocalizedString(@"Restart Options", @"Restart options menu divider in settings")];
		
		
		
		
		return self;
	}
	
	return nil;
}



- (id)previewControlForItem:(long)item
{
		//BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
		//BRImage *previewImage = nil;
	
	NSString *summary = nil;
	
	NSString *theTitle = [[self names] objectAtIndex:item];
	
	id previewImage = nil;
	
	switch (item) {
			
		
		case kNUpdateNitoTVMenuItem: //update nitoTV
			
			summary = @"Update nitoTV to the latest version";
			previewImage = [THEME settingsImage];
			break;
		
		case kNUpdateCheckFrequencyMenuItem:
				//case kNToggleUpdateMenuItem: //block updates
			
			summary = @"How frequently to check for essential updates";
			previewImage = [THEME settingsImage];
			break;
		
		//case kNNotificationLogMenuItem: //notification logs
		case kNViewSyslogMenuItem: //console
			
			summary = @"View /var/log/syslog";
			previewImage = [THEME consoleImage];
			
			break;
			
		case kNRestartLowtideMenuItem: //reboot lowtide
			
			summary = @"Restart/Respring AppleTV.app";
			previewImage = [THEME rebootImage];
			break;
			
		case kNRebootAppleTVMenuItem: //reboot appletv
			
			summary = @"Restart AppleTV";
			previewImage = [THEME shutDownImage];
			break;
			
		default:
			break;
	}

	id currentAsset = [[objc_getClass("ntvMedia") alloc] init];
	
	[currentAsset setTitle:theTitle];
	[currentAsset setCoverArt:previewImage];
	[currentAsset setSummary:summary];
	
	id preview = [[%c(ntvMediaPreview) alloc]init];
	
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	return [preview autorelease];
}

%new + (int)updateStatus //0 = update possible (block menu option) 1 = update blocked
{
	
	NSString *hosts = [NSString stringWithContentsOfFile:@"/etc/hosts" encoding:NSUTF8StringEncoding error:nil];
	NSRange range = [hosts rangeOfString:@"mesu.apple.com"];
	if ( range.location == NSNotFound )
	{
		return 0;
	}
	
	return 1;
	
}

%new + (int)notificationStatus //0 = hooks off 1 = hooks on
{

	return [[nitoDefaultManager preferences] integerForKey:NOTIFICATION_HOOKS];
	
}

%new + (int)updateCheckFrequency
{
	return [[nitoDefaultManager preferences] integerForKey:UPDATE_CHECK_FREQUENCY];
}


%new + (NSString *)stringForTime:(int)checkTime
{
	switch (checkTime) {
		
		case HOUR_MINUTES:
		
			return @"Hourly";
			break; //i know i know
	
		case DAY_MINUTES:
			
			return @"Daily";
			break;
			
		case WEEK_MINUTES:
			
			return @"Weekly";
			break;
			
	}
	
	return @"Not Set, what'd you do!?!?";
}

/*
 
 kNUpdateNitoTVMenuItem = 0,
 kNToggleUpdateMenuItem,
 kNNotificationLogMenuItem,
 kNUpdateCheckFrequencyMenuItem,
 kNViewSyslogMenuItem,
 kNRestartLowtideMenuItem,
 kNRebootAppleTVMenuItem,
 
 */

-(id)itemForRow:(long)row
{
	id result = nil;
	int status;	
	switch (row) {
			
		case kNUpdateNitoTVMenuItem: // install nitoTV
			result = [%c(nitoMenuItem) ntvDownloadMenuItem];
			break;
		
			
		case kNUpdateCheckFrequencyMenuItem:
			
			result = [%c(nitoMenuItem) ntvMenuItem];
			
			status = (int)[%c(nitoSettingsController) updateCheckFrequency];
			[result setRightJustifiedText:[%c(nitoSettingsController) stringForTime:status]	withAttributes:[BRTHEME menuItemSmallTextAttributes]];
			
			break;
			
		case kNViewSyslogMenuItem: //system log
			result = [%c(nitoMenuItem) ntvComputerMenuItem];
			break;
		case kNRestartLowtideMenuItem: //restart Lowtide
		case kNRebootAppleTVMenuItem:	//reboot AppleTV
			result = [%c(nitoMenuItem) ntvRefreshMenuItem];
			break;
		
		
			
		
		default:
			result = [%c(nitoMenuItem) ntvMenuItem];
			break;
			
	}
	
	[result setText:[[self names] objectAtIndex:row] withAttributes:[BRTHEME menuItemTextAttributes]];
	 
	 return result;
}

- (id)_alertWithMessage:(NSString *)errorDescription andTitle:(NSString *)theTitle
{
	
	NSString *errorString = [NSString stringWithFormat:BRLocalizedString(@"%@", @"primaryText for generic settings alert"), errorDescription];
	
	id result = [[%c(BRAlertController) alloc] initWithType:0 titled:theTitle primaryText:errorString secondaryText:BRLocalizedString(@"Re-directed to settings facade in 5 seconds", @"secondary text when error in settings controller")];
	
	return result;
	
	
}

%new - (void)jumpToEnd:(id)scrollBarInfo
{
	id theList = [[scrollBarInfo userInfo] valueForKey:@"ListControl"];
	int theCount = (int)[theList dataCount];
	[theList setSelection:theCount];
		//NSLog(@"theList: %@", theList);
		//[theList _dumpControlTree];
		//id listProvider = [[scrollBar providers] objectAtIndex:0];
		//NSLog(@"dataCount: %i", [listProvider dataCount]);
		//[scrollBar _performScrollInitiationActivities];
		//[scrollBar setSelection:[listProvider dataCount]];
		//[scrollBar _setNewScrollIndex:[listProvider dataCount]];
		//[scrollBar _performScrollTerminationActivities];
}

-(void)controller:(id)c selectedControl:(id)ctrl
{
	NSLog(@"BRControl: %@", ctrl);
}

//- (void)uideviceTestTwo
//{
//	LogSelf
//	id cd = nil;
//	
//	@try {
//		cd = [UIDevice currentDevice];
//	}
//	
//	@catch ( NSException *e ) {
//		NSLog(@"exception beyotch!: %@", e);
//	}
//	
//	@finally {
//		NSLog(@"will it work the second try?");
//		
//		cd = [UIDevice currentDevice];
//		NSLog(@"cd: %@", cd);
//		
//	}
//}

//- (void)uideviceTest
//{
//	NSLog(@"ui device test");
//	Class uid = NSClassFromString(@"UIDevice");
//	if (uid != nil)
//	{
//		id cd = [UIDevice currentDevice];
//		if (cd != nil)
//		{
//			NSLog(@"currentDevice: %@", cd);
//			
//		} else {
//			NSLog(@"current device is nil bitch!");
//		}
//		
//	}
//		
//}

%new - (void)runNitoTVUpgradeWithSender:(id)sender 
{
	
	id consoleController  = [[objc_getClass("NSMFComplexProcessDropShadowControl") alloc] init];
	[consoleController setDelegate:self];
	NSString *command = @"/usr/bin/nitoHelper su 1 2";
	[consoleController setAp:command];
	[consoleController setSender:sender];
	[consoleController setTitle:@"Upgrading nitoTV..."];
	[consoleController setShowsProgressBar:FALSE];
	[consoleController addToController:self];
	
}

%new -(void)process:(id)p ended:(NSString *)s
{
    BOOL fixReq = CPLUSPLUS_SUCKS[p sourceFixRequired];
    if (fixReq == TRUE)
    {
        NSLog(@"source fix required!!");
        [%c(nitoInstallManager) fixSourceFolder];
    }
    
    BOOL fixDepend = CPLUSPLUS_SUCKS[p requiresDependencyFix];
    if (fixDepend == TRUE)
    {
        NSLog(@"depend fix required!!");
        [%c(nitoInstallManager) fixDepends];
    }
    
	if ([p returnCode] == 0)
	{
		[p setTitle:@"Upgrade Finished Successfully!"];
			//if (_essentialUpgrade == TRUE)
			//	{
			NSLog(@"essential upgrade boosh finder.");
			[p setSubtitle:@"Restarting Lowtide in 3 Seconds"];
			
		[NSTimer timerWithTimeInterval:3 target:[%c(BRApplication) sharedApplication] selector:@selector(terminate) userInfo:nil repeats:NO];
				//[[BRApplication sharedApplication] terminate];
			return;
			//	}
	} else {
		[p setTitle:@"Upgrade Failed!"];
	}
	[p setSubtitle:@"Press Menu to exit"];

	
}

- (void)itemSelected:(long)selected
{
	id spinControl = nil;
	BOOL returnValue = YES;
	id controller = nil;
	id scrollBar = nil;
	NSDictionary *lcd = nil;
	id textControls = nil;
	id tb;
	id list;
	
	id row = [[self list] selectedObject];
	
	switch (selected) {
			
		case kNUpdateNitoTVMenuItem: //update nitoTV
			
			
				//[self uideviceTestTwo];
			
				//spinControl = [[%c(BRTextWithSpinnerController) alloc] initWithTitle:BRLocalizedString(@"Updating, Please wait...", @"title for Spinner text control while updating nitoTV") text:BRLocalizedString(@"Updating nitoTV, please wait...",@"main text for Spinner text control while updating nitoTV" )];
				//[ROOT_STACK pushController:spinControl];
				//sleep(1);
				//[NSTimer scheduledTimerWithTimeInterval:.5 target: self selector: @selector(updateNitoTV) userInfo: nil repeats: NO];
			//[self updateNitoTV];
			[self runNitoTVUpgradeWithSender:row];
			break;
			
			
		case kNViewSyslogMenuItem: //view system log
				
			
				//temp
			system("tail -n 200 /var/log/syslog >/tmp/temp.log");
			textControls = [[objc_getClass("nitoScrollingTextControl") alloc] init];
			tb = [textControls textBox];
			list = MSHookIvar<id>(tb, "_list");
			scrollBar = [[list providers] objectAtIndex:0];
				//NSLog(@"list %@", scrollBar);
			[textControls setDocumentPath:@"/tmp/temp.log" encoding:NSUTF8StringEncoding];
			[textControls setTitle:@"syslog"];
			
			controller =  [%c(BRController) controllerWithContentControl:textControls];
			
				//NSLog(@"%@", [[textControls textBox] text]);
			
			
			[ROOT_STACK pushController:controller];
			
			lcd = [NSDictionary dictionaryWithObject:list forKey:@"ListControl"];
			
			[textControls release];
			
			
			[NSTimer scheduledTimerWithTimeInterval:.1 target: self selector: @selector(jumpToEnd:) userInfo:lcd  repeats: NO];
				//[scrollBar setScrollPosition:0];
			break;
			
		case kNRestartLowtideMenuItem: //reboot lowtide
		
			[[%c(BRApplication) sharedApplication] terminate];
			
			break;
			
		case kNRebootAppleTVMenuItem: //reboot appletv
			
			[self rebootAppleTV];
			break;
			
		//case kNNotificationLogMenuItem:
//			
//			[self toggleNotificationHooks];
//			[[self list] reload];
//			break;
	
		case kNUpdateCheckFrequencyMenuItem:
			
			[self toggleUpdateFrequency];
			[[self list] reload];
			break;
		
	}
	
}


%new - (void)toggleNotificationHooks
{
	int currentState = (int)[%c(nitoSettingsController) notificationStatus];
	switch (currentState) {
			
		case 0: //make it 1!!!!
			
			[[nitoDefaultManager preferences] setInteger:1 forKey:NOTIFICATION_HOOKS];
			break;
			
		case 1: //make it 0!!!
			
			[[nitoDefaultManager preferences] setInteger:0 forKey:NOTIFICATION_HOOKS];
			break;
	
	}
	
	
}

%new - (void)toggleUpdateFrequency
{
	int currentState = (int)[%c(nitoSettingsController) updateCheckFrequency];
	switch (currentState) {
			
		case 0:
		case 1:
			
			[[nitoDefaultManager preferences] setInteger:HOUR_MINUTES forKey:UPDATE_CHECK_FREQUENCY];
			break;
			
		case HOUR_MINUTES: //make it DAY_MINUTES
			
			[[nitoDefaultManager preferences] setInteger:DAY_MINUTES forKey:UPDATE_CHECK_FREQUENCY];
			break;
			
		case DAY_MINUTES: //make it WEEK_MINUTES!!!
			
			[[nitoDefaultManager preferences] setInteger:WEEK_MINUTES forKey:UPDATE_CHECK_FREQUENCY];
			break;
			
		case WEEK_MINUTES: //make it HOURS_MINUTES!!!
			
			[[nitoDefaultManager preferences] setInteger:HOUR_MINUTES forKey:UPDATE_CHECK_FREQUENCY];
			
			break;
			
		default:
			
			NSLog(@"toggleUpdateFrequency hit default case!! wtf??: %i setting to HOUR_MINUTES (60)", currentState);
			[[nitoDefaultManager preferences] setInteger:HOUR_MINUTES forKey:UPDATE_CHECK_FREQUENCY];			
			
			break;
			
	}
	
}


%new - (void) popTop
{
	[[self stack] popController];
	
}

%new - (BOOL)toggleUpdate
{
	NSString *command = @"/usr/bin/nitoHelper toggleBlock _";
	int sysReturn = system([command UTF8String]);
	NSLog(@"toggleBlock finished with: %i", sysReturn);
	
	if (sysReturn == 0) //update blocked
		return YES;
	else if (sysReturn == 1) //update unblocked
		return NO;
	
	return NO;
}


/*
 
 waitUntilExit
 
 int main(int argc, char **argv, char **envp) {
 id p = [[NSAutoreleasePool alloc] init];
 id t = [NSTask launchedTaskWithLaunchPath:@"/bin/sleep" arguments:[NSArray arrayWithObject:@"5"]];
 NSLog(@"launched task %@", t);
 waitpid([t processIdentifier], NULL, 0); // instead of [t waitUntilExit]
 NSLog(@"task %@ exited", t);
 [p drain];
 return 0;
 }
 
 
 
 */




%new -(id)blockSuccess
{
	id alertCon = [%c(BRAlertController) alertOfType:0 titled:BRLocalizedString(@"Updates Blocked Successfully", @"update blocker alert title for success") primaryText:BRLocalizedString(@"Software Update Blocked Successfully!",@"update blocker alert main text for success" ) secondaryText:BRLocalizedString(@"press menu to exit", @"press menu to exit")];
	return alertCon;
}

%new -(id)blockFailed
{
	id alertCon = [%c(BRAlertController) alertOfType:0 titled:BRLocalizedString(@"Update Block Failed", ) primaryText:BRLocalizedString(@"Software Updates Blocking Failed!", ) secondaryText:BRLocalizedString(@"press menu to exit",@"press menu to exit") ];
	return alertCon;
}


%new - (void)rebootAppleTV
{
	NSString *command = @"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/reboot.sh";
	system([command UTF8String]);
}

%new - (void)updateNitoTV
{
	
	
	NSString *command = [NSString stringWithFormat:@"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/install_ntv.sh %@", @"com.nito.nitotv"];
	int sysReturn = system([command UTF8String]);
	//NSLog(@"NITOTV: post run command: %i", sysReturn);
	//NSLog(@"aptoutput: %@", [self aptStatus]);
	
	NSLog(@"update status: %i", sysReturn);
	[[self stack] popController];
	if (sysReturn == 0)
	{
		[[%c(BRApplication) sharedApplication] terminate];
	}
}

%new - (NSString *)aptStatus
{
	return [NSString stringWithContentsOfFile:@"/tmp/aptoutput" encoding:NSUTF8StringEncoding error:nil];

}



%end
						 //@end




