//
//  nitoMoreMenu.m
//  nitoTV
//
//  Created by kevin bradley on 10/4/11.
//  Copyright 2011 nito, LLC. All rights reserved.
//

	//#import "nitoMoreMenu.h"
	//#import "nitoInstallManager.h"

%subclass nitoMoreMenu : SMFListDropShadowControl

	//@implementation nitoMoreMenu

- (void)dealloc
{
		//LogSelf;
	%orig;
}

%new - (id)initWithSender:(id)theSender addedTo:(id)parentController
{
	self = %orig;
	[self setCDelegate:self];
	[self setSender:theSender];
	[self setCDatasource:self];
	[self setIsAnimated:TRUE];
	return ( self );
}

%new - (NSArray *)popupItems
{
	return [NSArray arrayWithObjects:@"fix dependencies", @"dpkg configure", @"APT autoremove", @"Restart Lowtide", nil];
}

- (BOOL)popupRowSelectable:(long)row
{
	return YES;
}

- (BOOL)rowSelectable:(long)row	
{
	return YES;
}

%new - (void)popup:(id)p itemSelected:(long)row  
{
	if ([p respondsToSelector:@selector(removeFromParent)])
	{
		[p removeFromParent];
	} else {
		
		[p removeFromSuperview];
		
	}
	
	switch (row) {
			
		case 0: //fix dependencies
			
			[%c(nitoInstallManager) fixDepends];
			
			break;

			
		case 1: //configure
			
			[%c(nitoInstallManager) runConfigure];
			
			break;
			
		case 2: //autoremove
			
			[%c(nitoInstallManager) runAutoremove];
			break;
			
		case 3: //Restart Lowtide
			
			[[%c(BRApplication) sharedApplication] terminate];
			
			break;
	}
}

%new - (long)popupItemCount
{
	return 4;
}

%new - (id)popupItemForRow:(long)row
{
	id it = [%c(nitoMenuItem) ntvMenuItem];
	[it setCentered:TRUE];
	[it setTitle:[[self popupItems] objectAtIndex:row]];
	return it;
}


%end
	//@end
