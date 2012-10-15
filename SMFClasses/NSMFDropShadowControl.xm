//
//  NSMFDropShadowControl.m
//  SMFramework
//
//  Created by Kevin Bradley on 9/13/11.
//  Copyright 2011 nito, LLC. All rights reserved.
//

	//#import "NSMFDropShadowControl.h"
	//#import "SMFDefines.h"
#import "NSMFMockMenuItem.h"
#import "NSMFAnimation.h"

#define ZOOM_TO_POINT CGPointMake(591.5999755859375, 284.39999389648438)

/*
 
 if you are sending from a BRMenuItem there is a proper way to get the current menu item selection
 
 id selectedObject = [[self list] selectedObject];
 
 (keeping in mind this is from your controller you are adding a pop over to)
 
 you also need to set isAnimation to TRUE before adding the controller.
 
 i.e.
 
 NSMFListDropShadowControl *c = [[NSMFListDropShadowControl alloc]init];
 
 [c setCDelegate:me]; (me being the controller attached to)
 [c setSender:sender];
 [c setCDatasource:me];
 [c setIsAnimated:TRUE];
 [c addToController:me];
 
 
 note: there are a lot of repeat functions between here and NSMFListDropShadowControl, hopefully at some point that can become a subclass of this as well
 and that code can be pruned out.
 
 
 this class should NEVER be called directly, its sole purpose is for all other SMFDropShadow subclasses to easily subclass and retain the animation goodness.
 
 */

static char const * const kSMFDSCSenderKey = "SMFDSCSender";

static BOOL _isAnimated = TRUE;

%subclass NSMFDropShadowControl : BRDropShadowControl

	//@implementation NSMFDropShadowControl

	//@synthesize isAnimated, sender;

%new - (id)sender {
	
	return [self associatedValueForKey:(void*)kSMFDSCSenderKey];
	
}

%new - (void)setSender:(id)theSender {
	
	[self associateValue:theSender withKey:(void*)kSMFDSCSenderKey];
}

-(id)init
{
    self = %orig;
    if (self!=nil) {

        _isAnimated = TRUE; //up to you, can be false by default if you dont like it
    }
    return self;
}

%new - (void)setIsAnimated:(BOOL)itIsAnimated
{
	_isAnimated = itIsAnimated;
}

%new - (BOOL)isAnimated {
	
	return _isAnimated;
	
}

%new - (void)setZoomInPosition
{
	CABasicAnimation *pos = [CABasicAnimation animationWithKeyPath:@"position"];
	id theSender = [self sender];
	if (theSender != nil)
	{
		pos.fromValue = [NSValue valueWithCGPoint:[theSender position]];
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
	pos.fromValue = [NSValue valueWithCGPoint:CGPointMake(640.0, 360.0)]; //
	id theSender = [self sender];
	if (theSender != nil)
	{
		pos.toValue = [NSValue valueWithCGPoint:[theSender position]];
	} else {
		pos.toValue = [NSValue valueWithCGPoint:ZOOM_TO_POINT];
	}

	pos.fillMode = kCAFillModeForwards;
	[[self layer] addAnimation:pos forKey:@"position"];
}

-(BOOL)avoidsCursor //of course it was easier than i was making it!!
{
	return TRUE;
}

%new - (void)removeFromSuperviewAnimated
{
	if (_isAnimated == TRUE)
	{
		NSLog(@"is animated!");
			//CATransform3D zoomTransform = CATransform3DMakeScale(0.1, 0.1, 1.0);
		CAAnimationGroup *zoomOutAnimation = nil;
		id theSender = [self sender];
		if (theSender != nil)
			zoomOutAnimation = [NSMFAnimation zoomOutFadedToRect:[theSender bounds]];
		else
			zoomOutAnimation = [NSMFAnimation zoomOutFadedToRect:CGRectZero];
		
		[zoomOutAnimation setDelegate:self];
		[self setZoomOutPosition];
		[zoomOutAnimation setValue:@"removeFromParent" forKey:@"Name"];
		[[self layer] addAnimation:zoomOutAnimation forKey:@"removeFromParent"];
		
	} else {
		
		
		[self removeFromSuperview];
	}
	
}

%new - (void)removeFromParentAnimated
{
	if (_isAnimated == TRUE)
	{
			//CATransform3D zoomTransform = CATransform3DMakeScale(0.1, 0.1, 1.0);
		CAAnimationGroup *zoomOutAnimation = nil;
		id theSender = [self sender];
		if (theSender != nil)
			zoomOutAnimation = [NSMFAnimation zoomOutFadedToRect:[theSender bounds]];
		else
			zoomOutAnimation = [NSMFAnimation zoomOutFadedToRect:CGRectZero];

		[zoomOutAnimation setDelegate:self];
		[self setZoomOutPosition];
		[zoomOutAnimation setValue:@"removeFromParent" forKey:@"Name"];
		[[self layer] addAnimation:zoomOutAnimation forKey:@"removeFromParent"];
		
	} else {
		
		
		[self removeFromParent];
	}
	
}

%new -(void)addToController:(id)ctrl
{
    CGRect f = CGRectMake(256.0,72.0,768.0,576.0);//(s.width*0.2, s.height*0.1, s.width*0.6, s.height*0.8);
    [self setFrame:f];
	
	if (_isAnimated == TRUE)
	{
		CAAnimationGroup *zoomInAnimation = nil;
		
		if ([self sender] != nil)
		{
			[self updateSender]; //fixes the sender to have a proper X value for purposes of zooming in and out
			
			zoomInAnimation = [NSMFAnimation zoomInFadedToRect:[[self sender] bounds]];
		} else {
			zoomInAnimation = [NSMFAnimation zoomInFadedToRect:CGRectZero];
		}
		
		
		[self setZoomInPosition]; //wish there was some way for me to implement this into the animation class, but its specific to self
		[zoomInAnimation setValue:@"zoomInAnimation" forKey:@"Name"];
		[zoomInAnimation setDelegate:self];
		
		[self addAnimation:zoomInAnimation forKey:@"zoomInAnimation"];
		
	}
	
		// [ctrl addControl:self];
    if ([self respondsToSelector:@selector(addControl)])
	{
		[ctrl addControl:self];
	} else {
		[ctrl addSubview:self];
	}
	[ctrl setFocusedControl:self]; //FIXME: now private ivar GRRR
		//[ctrl _setControlFocused:TRUE];
	[ctrl _setFocus:self];
}


%new - (void)animationDidStart:(CAAnimation *)anim
{
	
		//NSLog(@"animationDidStart: %@", anim);
}

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
				//	NSLog(@"setting new sender to: %@", newSender);
			
			[self setSender:newSender];
				//NSLog(@"sender check: %@", sender);
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
    %orig;
}


	//@end

%end