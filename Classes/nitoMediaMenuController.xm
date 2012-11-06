//
//  nitoMediaMenuController.m
//  nitoTV2
//
//  Created by Kevin Bradley on 10/26/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

	//#import <SMFramework/NSMFComplexProcessDropShadowControl.h>
#import "packageManagement.h"

static char const * const kNitoMMCNamesKey = "nMMCNames";

%subclass nitoMediaMenuController : BRMediaMenuController
	//@implementation nitoMediaMenuController

%new - (NSMutableArray *)names
{
	return [self associatedValueForKey:(void*)kNitoMMCNamesKey];
}

%new - (void)setNames:(NSMutableArray *)value
{
	[self associateValue:value withKey:(void*)kNitoMMCNamesKey];
}

%new -(id)initWithTitle:(NSString *)theTitle
{
	if ( [self init] == nil )
		return ( nil );
	
	[self setListTitle:theTitle];
	id _names = [[NSMutableArray alloc] init];
	[self setNames:_names];
	[[self list] setDatasource:self];
	return ( self );
}

- (void)layoutSubcontrols
{
	//hackily adjust the list and header frame to add 5 pixels upwards.
	%orig;
	CGRect headerFrame = [[self header] frame];
	//CGRect listFrame = [[self list] frame];
	headerFrame.origin.y += 16.0f;
//	listFrame.origin.y += 10.0f;
	[[self header] setFrame:headerFrame];
//	[[self list] setFrame:listFrame];
	
	
}

%new - (int)getSelection
{
		

	id list = [self list];
	int row;
	NSMethodSignature *signature = [list methodSignatureForSelector:@selector(selection)];
	NSInvocation *selInv = [NSInvocation invocationWithMethodSignature:signature];
	[selInv setSelector:@selector(selection)];
	[selInv invokeWithTarget:list];
	if([signature methodReturnLength] == 8)
	{
		double retDoub = 0;
		[selInv getReturnValue:&retDoub];
		row = retDoub;
	}
	else
		[selInv getReturnValue:&row];
	return row;
}

%new - (BOOL)leftAction:(long)theRow
{
	return NO;
}

%new - (BOOL)rightAction:(long)theRow
{
	return NO;
	
	
}


- (BOOL)brEventAction:(id)fp8
{
	
	int itemCount = (int)[[[self list] datasource] itemCount];
	long currentRow;
	int theAction = (int)[fp8 remoteAction];
	int theValue = (int)[fp8 value];
	id myFocusedControl = nil;
	switch (theAction)
	{
		case kBREventRemoteActionMenu:
			myFocusedControl = [self focusedControl];
				//NSLog(@"myFocusedControl: %@", myFocusedControl);
			if([myFocusedControl isKindOfClass:objc_getClass("NSMFComplexProcessDropShadowControl")])
			{
				if ([self respondsToSelector:@selector(removeFromParent)])
				{
					[myFocusedControl removeFromParentAnimated];
					
				} else {
					
					
					[myFocusedControl removeFromSuperviewAnimated];
					
				}
					
					
				return YES;
			}
			if ([[self focusedControl] isKindOfClass:objc_getClass("NSMFListDropShadowControl")])
			{
				if ([self respondsToSelector:@selector(removeFromParent)])
					[[self focusedControl] removeFromParentAnimated];
				else
					[[self focusedControl] removeFromSuperviewAnimated];
					
					
				return YES;
			}
			
		
			
			
			return NO;
			
		case kBREventRemoteActionRight:
		case kBREventRemoteActionSwipeRight:
			
			currentRow = (int)[self getSelection];
			
	
			if (theValue == 1)
				return (BOOL)(long)(void *)[self rightAction:currentRow];
			break;
			
		case kBREventRemoteActionLeft:
		case kBREventRemoteActionSwipeLeft:
			
			currentRow = (long)[self getSelection];
			if (theValue == 1)
			return (BOOL)(long)(void *)[self leftAction:currentRow];
			break;
			
		case kBREventRemoteActionUp:
			
			if([self getSelection] == 0 && theValue == 1)
			{
				[self setSelection:itemCount-1];
				return YES;
			}
			%orig;
			
			
			break;
			
		case kBREventRemoteActionDown:
			
			if((int)[self getSelection] == itemCount-1 && theValue == 1)
			{
				[self setSelection:0];
				return YES;
			}
			return %orig;
			
			
			break;
			
		case 17:
			
			NSLog(@"kill finder");
			[[%c(BRApplication) sharedApplication] terminate];
			break;
	
		default:
			
			return %orig;
			//return YES;
			break;
	}
	return YES;
}


%new - (float)listVerticalOffset
{
	return 5;
}

//- (void) dealloc
//{
//	
//	[_names release];
//	
//	[super dealloc];
//}

%new - (NSString *)titleForRow:(long)row {
	if(row < [[self names] count]) {
		return [[self names] objectAtIndex:row];
	} else {
		return nil;
	}
}

%new -(float)heightForRow:(long)row {
	return 0.0f;
}

%new -(id)itemForRow:(long)row {
	return [self controlAtIndex:row requestedBy:nil];
}

- (long)itemCount {
	return [[self names] count];
}



%new - (long) controlCount
{
	
	return ( [[self names] count] );
	
}

- (id)previewControlForItem:(long)item
{
	return nil;
}

%new - (id) controlAtIndex: (long) row requestedBy:(id)fp12
{
	if ( row > [[self names] count] )
		return ( nil );

	id result = nil;
	NSString *theTitle = [[self names] objectAtIndex: row];
	
	result = [objc_getClass("nitoMenuItem") ntvFolderMenuItem];
	
	[result setText:theTitle withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemTextAttributes]];			

	
	return ( result );
}

//- (void)controlWasActivated
//{
//	//progressRow = -1;
//	//[[self list] reload];
//	[super controlWasActivated];
//}


%new - (void)setSelection:(int)sel
{
	id list = [self list];
	NSMethodSignature *signature = [list methodSignatureForSelector:@selector(setSelection:)];
	NSInvocation *selInv = [NSInvocation invocationWithMethodSignature:signature];
	[selInv setSelector:@selector(setSelection:)];
	if(strcmp([signature getArgumentTypeAtIndex:2], "l"))
	{
		double dvalue = sel;
		[selInv setArgument:&dvalue atIndex:2];
	}
	else
	{
		long lvalue = sel;
		[selInv setArgument:&lvalue atIndex:2];
	}
	[selInv invokeWithTarget:list];
}


%end