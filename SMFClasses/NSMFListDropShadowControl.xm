//
//  NSMFListDropShadowControl.m
//  SMFramework
//
//  Created by Thomas Cool on 1/21/11.
//  Copyright 2011 tomcool.org. All rights reserved.
//

#define ZOOM_TO_POINT CGPointMake(591.5999755859375, 284.39999389648438)


#import "NSMFThemeInfo.h"

#import "NSMFMockMenuItem.h"
#import "NSMFAnimation.h"

%subclass ntvListControl : BRListControl

-(BOOL)brEventAction:(id)event
{
		//LogSelf;
	return %orig;
}


%end


static char const * const kSMFLDSCDelegateKey = "SMFLDSCDelegate";
static char const * const kSMFLDSCDatasourceKey = "SMFLDSCDatasource";
static char const * const kSMFLDSCListKey = "SMFLDSCList";
static char const * const kSMFLDSCSenderKey = "SMFLDSCSender";

static BOOL _isAnimated = TRUE;

@interface NSMFListDropShadowControl : NSObject

-(CGRect)rectForSize:(CGSize)s;

@end


%subclass NSMFListDropShadowControl : BRDropShadowControl
/*
 
 sender is a new variable to determine the bounds and position for zoom animations, if it descends from BRMenuItem we synthesize a stub class 
 that only has position and bounds variables, i can't figure out how to get the proper bounds/position from BRListControl from and standard BRMenuController
 so what i do is take the blue lozenge from the list grab its position and modify the x value (the y variables are accurate here, only X needs an attitude adjustment) 
 
 
 */



%new - (id)list
{
	return [self associatedValueForKey:(void*)kSMFLDSCListKey];
}

%new - (void)setList:(id)value
{
	[self associateValue:value withKey:(void*)kSMFLDSCListKey];
}

%new - (id)cDelegate {
	
	return [self associatedValueForKey:(void*)kSMFLDSCDelegateKey];
}

%new - (void)setCDelegate:(id)theDelegate {
	
	[self associateValue:theDelegate withKey:(void*)kSMFLDSCDelegateKey];
}

%new - (id)cDatasource {
	
	return [self associatedValueForKey:(void*)kSMFLDSCDatasourceKey];
}

%new - (void)setCDatasource:(id)theDataSource {
	
	[self associateValue:theDataSource withKey:(void*)kSMFLDSCDatasourceKey];
}

%new - (id)sender {
	
	return [self associatedValueForKey:(void*)kSMFLDSCSenderKey];
}

%new - (void)setSender:(id)theSender {
	
	[self associateValue:theSender withKey:(void*)kSMFLDSCSenderKey];
	
}

%new - (void)setIsAnimated:(BOOL)animated
{
	_isAnimated = animated;
}

%new - (BOOL)isAnimated
{
	return _isAnimated;
}


#define BRLC objc_getClass("ntvListControl")

%new -(BOOL)seventyPlus
{
	return CPLUSPLUS_SUCKS[%c(packageManagement) ntvSevenPointOhPLus];
    //if ([self respondsToSelector:@selector(controls)])
    //	{
    //		return (FALSE);
    //	}
    //	return (TRUE);
}

%new -(BOOL)sixtyPlus
{
	return CPLUSPLUS_SUCKS[%c(packageManagement) ntvSixPointOhPLus];
		//if ([self respondsToSelector:@selector(controls)])
		//	{
		//		return (FALSE);
		//	}
		//	return (TRUE);
}

 -(id)init
{
    self =%orig;
    if (self!=nil) {
        id theList = [[[BRLC alloc]init]autorelease];
		[self setList:theList];
        [theList setDatasource:self];
        _isAnimated = FALSE; 
        
		if ([self sixtyPlus] == FALSE)
		{
			NSLog(@"we in here, i forget what to check :(");
			[self setBackgroundColor:[[NSMFThemeInfo sharedTheme]blackColor]];
			[self setBorderColor:[[NSMFThemeInfo sharedTheme] whiteColor]];
		} else {
			[[self layer] setBackgroundColor:[[NSMFThemeInfo sharedTheme]blackColor]];
			[[self layer] setBorderColor:[[NSMFThemeInfo sharedTheme] whiteColor]];
		}
		
		[self setInhibitsFocusForChildren:TRUE];
		[self setAvoidsCursor:TRUE];
		[self setContent:theList];
    }
    return self;
}

%new -(void)reloadList
{
    [[self list] reload];
}

%new -(void)logFrame:(CGRect)frame
{
	NSLog(@"{{%f, %f},{%f,%f}}",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}

%new -(void)logSize:(CGSize)size
{
	NSLog(@"{%f,%f}}", size.width,size.height);
}

%new -(void)addToController:(id)ctrl
{
    CGRect f = [self rectForSize:CGSizeMake(528., 154.)];
    
   
    //{{376.000000, 230.000000}
    NSLog(@"addToController");
	[self logFrame:f];
	
    [self setFrame:f];
	
	if (_isAnimated == TRUE)
	{
		CAAnimationGroup *zoomInAnimation = nil;
		id theSender = [self sender];
		if (theSender != nil)
		{
			[self updateSender];
			[self logFrame:[theSender bounds]];
			zoomInAnimation = [NSMFAnimation zoomInFadedToRect:[theSender bounds]];
		} else {
			zoomInAnimation = [NSMFAnimation zoomInFadedToRect:CGRectZero];
		}
		
		[self setZoomInPosition]; //if we dont set this the position goes haywire
		
		[zoomInAnimation setValue:@"zoomInAnimation" forKey:@"Name"];
		[zoomInAnimation setDelegate:self];
		[self addAnimation:zoomInAnimation forKey:@"zoomInAnimation"];
		
	}
    if ([ctrl respondsToSelector:@selector(addControl:)])
		[ctrl addControl:self];
    else 
		[ctrl addSubview:(UIView *)self];
	
	[ctrl setFocusedControl:(BRControl *)self];
    [ctrl _setFocus:self];
}
-(void)controlWasActivated
{    
//    [list setSelection:0];
	[self setFocusedControl:[self list]];
    [self _setFocus:[self list]];
    %orig;
}

%new - (float)heightForRow:(long)row				
{ 
	id theDatasource = [self cDatasource];
	
    if (theDatasource && [theDatasource respondsToSelector:@selector(popupHeightForRow:)]) {
        return (float)(long)(void*)[theDatasource popupHeightForRow:row];
    }
    return 0.0f;
}
%new - (BOOL)rowSelectable:(long)row				
{ 
	id theDatasource = [self cDatasource];
    if(theDatasource && [theDatasource respondsToSelector:@selector(popupRowSelectable:)])
        return (BOOL)(long)(void*)[theDatasource popupRowSelectable:row];
    return YES;
}

%new - (long)itemCount							
{ 
	id theDatasource = [self cDatasource];
    if(theDatasource && [theDatasource respondsToSelector:@selector(popupItemCount)])
        return (long)[theDatasource popupItemCount];
    
	return (long)3;
}
%new - (id)itemForRow:(long)row					
{ 
	id theDatasource = [self cDatasource];
    if(theDatasource && [theDatasource respondsToSelector:@selector(popupItemForRow:)])
        return [theDatasource popupItemForRow:row];
	
    id it = [%c(nitoMenuItem) ntvMenuItem]; //FIXME: change menu item type to one i use here
    [it setTitle:@"Default Item"];
    return it;
}
%new - (id)titleForRow:(long)row					
{ 
	id theDatasource = [self cDatasource];
    if(theDatasource && [theDatasource respondsToSelector:@selector(popupTitleForRow:)])
        return [theDatasource popupTitleForRow:row];
    if (row>=(long)[self itemCount])
        return nil;
    return [[self itemForRow:row] text];
}
%new - (long)defaultIndex						
{ 
	id theDatasource = [self cDatasource];
    if(theDatasource && [theDatasource respondsToSelector:@selector(popupDefaultIndex)])
        return (long)[theDatasource popupDefaultIndex];
    return 0;
}

%new -(void)itemSelected:(long)selected
{
	id theDelegate = [self cDelegate];
    if (theDelegate && [theDelegate respondsToSelector:@selector(popup:itemSelected:)])
        [theDelegate popup:self itemSelected:selected];
    else if (theDelegate && [theDelegate respondsToSelector:@selector(popupItemSelected:)]) {
        [theDelegate popupItemSelected:selected];
    }
    else {
        [self removeFromParent];
    }
}


%new - (void)removeFromSuperviewAnimated
{
	if (_isAnimated == TRUE)
	{
		[self setZoomOutPosition];
		id theSender = nil;
		theSender = [self sender];
		CAAnimationGroup *zoomOutAnimation = nil;
		if (theSender != nil)
			zoomOutAnimation = [NSMFAnimation zoomOutFadedToRect:[theSender bounds]];
		else
			zoomOutAnimation = [NSMFAnimation zoomOutFadedToRect:CGRectZero];
		
		[zoomOutAnimation setDelegate:self];
		[zoomOutAnimation setValue:@"removeFromParent" forKey:@"Name"];
		[[self layer] addAnimation:zoomOutAnimation forKey:@"removeFromParent"];
			//%orig;
	//} else {
//		
//		
//		%orig;
	} else {
		
		[self removeFromSuperview];
		
	}
	
}
%new - (void)removeFromParentAnimated
{
	if (_isAnimated == TRUE)
	{
		[self setZoomOutPosition];
		id theSender = nil;
		theSender = [self sender];
		CAAnimationGroup *zoomOutAnimation = nil;
		if (theSender != nil)
			zoomOutAnimation = [NSMFAnimation zoomOutFadedToRect:[theSender bounds]];
		else
			zoomOutAnimation = [NSMFAnimation zoomOutFadedToRect:CGRectZero];
		
		[zoomOutAnimation setDelegate:self];
		[zoomOutAnimation setValue:@"removeFromParent" forKey:@"Name"];
		[[self layer] addAnimation:zoomOutAnimation forKey:@"removeFromParent"];
		
	} else {
	
		[self removeFromParent];
	}	
}
	 
	//- (void)actuallyRemove //deprecated
	 
	//{ [super removeFromParent]; }

-(BOOL)brEventAction:(id)event
{
		//LogSelf;
    int remoteAction = (int)[event remoteAction];
    switch (remoteAction)
    {
        case kBREventRemoteActionMenu:
			NSLog(@"are we getting the menu action?");
			if ([self respondsToSelector:@selector(removeFromParent)])
				[self removeFromParent];
			else
				[self removeFromSuperview];
				
            return YES;
            break;
        case kBREventRemoteActionPlay:
            [self itemSelected:[[self list] selection]];
            return YES;
            break;
    }
    return %orig;
}


%new -(CGRect)rectForSize:(CGSize)s
{
    if ([self seventyPlus])
    {
        return CGRectMake(376, 230, 528, 260);
    }
    CGRect r;
    r.size.width=s.width;
    id a = [%c(SMFMenuItem) menuItem];
    CGSize ss = [a sizeThatFits:s];
		//	[self logSize:ss];
	long it = (long)[self itemCount];
    if (it>6)
        it=6;
    r.size.height=52.+52.*it;
        
    Class nw = objc_getClass("ntvWindow");
        CGSize windowSize;
        
    if ([nw respondsToSelector:@selector(maxBounds)])
    {
        windowSize = [objc_getClass("ntvWindow") maxBounds];
        
    } else {
        windowSize = CGSizeMake(1080,720);
    }
    r.origin.y=(windowSize.height-r.size.height)/2.0f;
    r.origin.x=(windowSize.width-r.size.width)/2.0f;
		
			NSLog(@"window size");
			[self logSize:windowSize];
	
		
    return r;
}

# pragma mark animation stuff

%new - (void)animationDidStart:(CAAnimation *)anim
{
	
		//NSLog(@"animationDidStart: %@", anim);
}


	//okay so remove from superview isnt going to work when we ovverride it with animation now, i dont know how this worked before.


%new - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	NSString *animationName = [anim valueForKey:@"Name"];
	if ([animationName isEqualToString:@"removeFromParent"])
	{
		if ([self respondsToSelector:@selector(removeFromParent)])
			[self removeFromParent];
		else 
			[self removeFromSuperview];
	}
	[self removeAnimationForKey:animationName];	
	
}


%new - (void)setZoomInPosition
{
	CABasicAnimation *pos = [CABasicAnimation animationWithKeyPath:@"position"];
	if ([self sender] != nil)
	{
		pos.fromValue = [NSValue valueWithCGPoint:[(UIView *)[self sender] position]];
	} else {
		pos.fromValue = [NSValue valueWithCGPoint:ZOOM_TO_POINT]; //
	}
	
	pos.toValue = [NSValue valueWithCGPoint:CGPointMake(640.0, 360.0)];
	pos.fillMode = kCAFillModeForwards;
	[[self layer] addAnimation:pos forKey:@"position"];
}

%new - (void)setZoomOutPosition
{
	CABasicAnimation *pos = [CABasicAnimation animationWithKeyPath:@"position"];
	pos.fromValue = [NSValue valueWithCGPoint:CGPointMake(640.0, 360.0)];
	if ([self sender] != nil)
	{
		pos.toValue = [NSValue valueWithCGPoint:[(UIView *)[self sender] position]];
	} else {
		pos.toValue = [NSValue valueWithCGPoint:ZOOM_TO_POINT];
	}
	
	pos.fillMode = kCAFillModeForwards;
	[[self layer] addAnimation:pos forKey:@"position"];
}

/*
 
if we are a BRMenuItem there are very minimal chances that you will get a usable position and bounds from it for zooming purposes
here are all the functions where i handle what is mentioned at the top (the comments about sender)
 
 */

%new - (void)updateSender
{
	if ([[self sender] isKindOfClass:objc_getClass("BRMenuItem")]) //is or descends from BRMenuItem
	{
		id newSender = [self synthesizeMockItem]; //create our stub menu item that has 2 variables total.
		if (newSender != nil)
		{
				//NSLog(@"setting new sender to: %@", newSender);
			
			[self setSender:newSender];
			
				//NSLog(@"sender check: %@", [self sender]);
		}
		
	}
	
}

	// find the list given the BRMenuItem (or said subclass of BRMenuItem)

%new - (id)getListFromMenuItem:(id)menuItem
{
	id listControl = [[[menuItem parent] parent] parent]; //parent = BRGridControl, grand parent = BRScrollControl, great grand parent = BRListControl
	NSString *theClass = NSStringFromClass([listControl class]);
	if (![theClass isEqualToString:@"BRListControl"])
	{
		NSLog(@"cant find list control!!!, found %@ instead!", theClass); //bail!!!
		return nil;
	}
	return listControl;
}

	//given the BRBlueGlowSelectionLozengeLayer control, spit out our stub class with the proper positioning.

%new - (id)synthesizeMockItemFrom:(id)theSender withX:(float)xValue
{
	
	NSMFMockMenuItem *menuItem = [[NSMFMockMenuItem alloc] init];
	CGPoint newPosition = [theSender position];
		//newPosition.x = xValue; //said attitude adjustment, without setting this x variable properly, all hell breaks loose.
	newPosition.x = 948.5;
	[menuItem setBounds:[theSender bounds]];
	[menuItem setPosition:newPosition];
	
	return menuItem;
	
}

%new - (id)synthesizeMockItem
{
	id theList = [self getListFromMenuItem:[self sender]];
	if (theList == nil)
		return nil;
	
	id listObjects = nil;
	
	if ([self respondsToSelector:@selector(controls)])
		listObjects = [theList controls];
		else
			listObjects = [theList subviews];
			
			
			CGPoint listPosition = [theList position];
			float xValue = listPosition.x;
			NSEnumerator *controlEnum = [listObjects objectEnumerator];
			id current = nil;
			while ((current = [controlEnum nextObject]))
			{
				NSLog(@"current: %@", current);
				NSString *currentClass = NSStringFromClass([current class]);
				if ([currentClass isEqualToString:@"BRBlueGlowSelectionLozengeLayer"])
				{
					
					return [self synthesizeMockItemFrom:current withX:xValue];
					
				}
			}
	return nil;
}



-(void)dealloc
{
		//[sender release];
		//self.sender = nil;
		//self.cDelegate=nil;
		//self.cDatasource=nil;
		//self.list=nil;
    %orig;
}

%end
	//@end
