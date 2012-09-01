//
//  nitoMediaMenuController.m
//  nitoTV2
//
//  Created by Kevin Bradley on 10/26/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

#import <SMFramework/SMFComplexProcessDropShadowControl.h>

@implementation nitoMediaMenuController

-(id)initWithTitle:(NSString *)theTitle
{
	if ( [super init] == nil )
		return ( nil );
	
	[self setListTitle:theTitle];
	_names = [[NSMutableArray alloc] init];
	
	[[self list] setDatasource:self];
	return ( self );
}

- (void)layoutSubcontrols
{
	//hackily adjust the list and header frame to add 5 pixels upwards.
	[super layoutSubcontrols];
	CGRect headerFrame = [[self header] frame];
	//CGRect listFrame = [[self list] frame];
	headerFrame.origin.y += 16.0f;
//	listFrame.origin.y += 10.0f;
	[[self header] setFrame:headerFrame];
//	[[self list] setFrame:listFrame];
	
	
}

- (int)getSelection
{
		

	BRListControl *list = [self list];
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

- (BOOL)leftAction:(long)theRow
{
	return NO;
}

- (BOOL)rightAction:(long)theRow
{
	return NO;
	
	
}

- (BOOL)brEventAction:(id)fp8;
{
//	NSLog(@"brEventAction: %@", fp8);
	int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	long currentRow;
	int theAction = [fp8 remoteAction];
	int theValue = (int)[fp8 value];	
	switch (theAction)
	{
		case kBREventRemoteActionMenu:
			if([[self focusedControl] isKindOfClass:[SMFComplexProcessDropShadowControl class]])
			{
				[[self focusedControl] removeFromParent];
				return YES;
			}
			if ([[self focusedControl] isKindOfClass:[SMFListDropShadowControl class]])
			{
				[[self focusedControl] removeFromParent];
				return YES;
			}
			
			return NO;
			
		case kBREventRemoteActionRight:
		case kBREventRemoteActionSwipeRight:
			
			currentRow = [self getSelection];
			
			//NSLog(@"currentRow: %d, %i", currentRow, [_names count]);
			//if (currentRow+1 == [_names count])
			//{
			//	return NO;
			//}
			if (theValue == 1)
				return [self rightAction:currentRow];
			break;
			
		case kBREventRemoteActionLeft:
		case kBREventRemoteActionSwipeLeft:
			
			currentRow = [self getSelection];
			if (theValue == 1)
			return [self leftAction:currentRow];
			break;
			
		case kBREventRemoteActionUp:
			
			if([self getSelection] == 0 && theValue == 1)
			{
				[self setSelection:itemCount-1];
				return YES;
			}
			[super brEventAction:fp8];
			
			
			break;
			
		case kBREventRemoteActionDown:
			
			if([self getSelection] == itemCount-1 && theValue == 1)
			{
				[self setSelection:0];
				return YES;
			}
			[super brEventAction:fp8];
			
			
			break;
			
		case 17:
			
			NSLog(@"kill finder");
			[[BRApplication sharedApplication] terminate];
			break;
	
		default:
			
			[super brEventAction:fp8];
			//return YES;
			break;
	}
	return YES;
}


- (float)listVerticalOffset
{
	return 5;
}

- (void) dealloc
{
	
	[_names release];
	
	[super dealloc];
}

- (NSString *)titleForRow:(long)row {
	if(row < [_names count]) {
		return [_names objectAtIndex:row];
	} else {
		return nil;
	}
}

-(float)heightForRow:(long)row {
	return 0.0f;
}

-(id)itemForRow:(long)row {
	return [self controlAtIndex:row requestedBy:nil];
}

- (long)itemCount {
	return [_names count];
}



- (long) controlCount
{
	
	return ( [_names count] );
	
}

- (id)previewControlForItem:(long)item
{
	return nil;
}

- (id) controlAtIndex: (long) row requestedBy:(id)fp12
{
	if ( row > [_names count] )
		return ( nil );

	BRMenuItem *result = nil;
	NSString *theTitle = [_names objectAtIndex: row];
	
	result = [BRMenuItem ntvFolderMenuItem];
	
	[result setText:theTitle withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];			

	
	return ( result );
}

//- (void)controlWasActivated
//{
//	//progressRow = -1;
//	//[[self list] reload];
//	[super controlWasActivated];
//}


- (void)setSelection:(int)sel
{
	BRListControl *list = [self list];
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



@end
