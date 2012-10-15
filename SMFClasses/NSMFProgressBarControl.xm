//
//  NSMFProgressBarControl.m
//  SoftwareMenuFramework
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
//  Updated by nito 08-20-08 - works in 2.x
//  Updated by Thomas 2-2-10 - allows for different aspect Ratios


//#import "NSMFProgressBarControl.h"
//@implementation NSMFProgressBarControl


static char const * const kSMFWidgetKey = "progressWidget";
static float _maxValue = 100.0f;
static float _minValue = 0.0f;


%subclass NSMFProgressBarControl : BRControl

- (id) init
{
	self = %orig;
	
	Class brpbw = %c(BRProgressBarWidget);
	if (brpbw == nil) brpbw = objc_getClass("BRProgressBarWidget");
	
    id widget = [[brpbw alloc] init];
	
	[self setWidget:widget];
	
	if ([self respondsToSelector:@selector(addControl:)])
	{
		[self addControl: widget];

	} else { //should respond to addSubview:
		
		[self addSubview: widget];
	}
	
   
    // defaults
    _maxValue = 100.0f;
    _minValue = 0.0f;
	
    return self;
}

%new - (id)widget { return [self associatedValueForKey:(void*)kSMFWidgetKey]; }

%new - (void)setWidget:(id)theWidget { [self associateValue:theWidget withKey:(void*)kSMFWidgetKey]; }

- (void) dealloc
{
  //  [_widget release];
    
	
    %orig;
}

- (void) setFrame: (CGRect) frame
{
    %orig;
	
    CGRect widgetFrame;// = CGRectZero;
    widgetFrame.origin.x = 0.0f;
    widgetFrame.origin.y = 0.0f;
    widgetFrame.size.width = frame.size.width;
    widgetFrame.size.height = ceilf( frame.size.width * 0.1f );
    if (frame.size.height>widgetFrame.size.height) {
        widgetFrame.origin.y=widgetFrame.origin.y+ceilf((frame.size.height-widgetFrame.size.height)/2.f);
    }
    [[self widget] setFrame: widgetFrame];
}



%new - (void) setMaxValue: (float) maxValue
{
    @synchronized(self)
    {
        _maxValue = maxValue;
    }
}

%new - (float) maxValue
{
    return ( _maxValue );
}

%new - (void) setMinValue: (float) minValue
{
    @synchronized(self)
    {
        _minValue = minValue;
    }
}

%new - (float) minValue
{
    return ( _minValue );
}

%new - (void) setCurrentValue: (float) currentValue
{
    @synchronized(self)
    {
        float range = _maxValue - _minValue;
        float value = currentValue - _minValue;
        float percentage = (value / range) * 100.0f;
        [[self widget] setPercentage: percentage];
    }
}

%new - (float) currentValue
{
    float result = 0.0f;

    @synchronized(self)
    {
        float percentage = [[self widget] percentage];
        float range = _maxValue - _minValue;
        result = (percentage / 100.0f) * range;
    }

    return ( result );
}

%new - (void) setPercentage: (float) percentage
{
    [[self widget] setPercentage: percentage];
}

%new - (float) percentage
{
    return ( [[self widget] percentage] );
}

%end

//@end
