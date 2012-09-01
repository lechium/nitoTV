//
//  nitoMoreMenu.m
//  nitoTV
//
//  Created by kevin bradley on 10/4/11.
//  Copyright 2011 nito, LLC. All rights reserved.
//

#import "nitoMoreMenu.h"
#import "nitoInstallManager.h"


@implementation nitoMoreMenu

- (void)dealloc
{
	LogSelf;
	[super dealloc];
}

- (id)initWithSender:(id)theSender addedTo:(id)parentController
{
	self = [super init];
	[self setCDelegate:self];
	[self setSender:theSender];
	[self setCDatasource:self];
	[self setIsAnimated:TRUE];
	return ( self );
}

- (NSArray *)popupItems
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

- (void)popup:(id)p itemSelected:(long)row  
{
    [p removeFromParent];
	switch (row) {
			
		case 0: //fix dependencies
			
			[nitoInstallManager fixDepends];
			
			break;

			
		case 1: //configure
			
			[nitoInstallManager runConfigure];
			
			break;
			
		case 2: //autoremove
			
			[nitoInstallManager runAutoremove];
			break;
			
		case 3: //Restart Lowtide
			
			[[BRApplication sharedApplication] terminate];
			
			break;
	}
}

- (long)popupItemCount
{
	return 4;
}

- (id)popupItemForRow:(long)row
{
	SMFMenuItem *it = [SMFMenuItem menuItem];
	[it setCentered:TRUE];
	[it setTitle:[[self popupItems] objectAtIndex:row]];
	return it;
}



@end
