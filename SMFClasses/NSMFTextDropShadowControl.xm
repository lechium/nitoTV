//
//  SMFTextDropShadowControl.m
//  SMFramework
//
//  Created by Thomas Cool on 2/27/11.
//  Copyright 2011 Thomas Cool. All rights reserved.
//

	//#import "SMFTextDropShadowControl.h"
	#import "NSMFThemeInfo.h"
	//#import "SMFDefines.h"
	//#import <substrate.h>

/*

@implementation SMFTextDropShadowControl
@synthesize text=_text;
@synthesize attributedString=_att;
 
 NSMutableString *_text;
 NSMutableAttributedString *_att;
 BRScrollingTextBoxControl *_scrolling;
 BRListControl *_list;
 
 */

static char const * const kSMFTDSCText = "_text";
static char const * const kSMFTDSCAttString = "_att"; //doesnt appear to ever be used
static char const * const kSMFTDSCScrolling = "_scrolling";
static char const * const kSMFTDSCList = "_list";

@interface SMFTextDropShadowControl : NSObject


- (id)scrolling;

@end


%subclass SMFTextDropShadowControl: NSMFDropShadowControl

%new -(id)attributedStringForString:(NSString*)s
{
    NSMutableDictionary *d = [[[[objc_getClass("BRThemeInfo") sharedTheme]metadataTitleAttributes] mutableCopy] autorelease];
    [d setObject:[NSNumber numberWithInt:0] forKey:@"BRTextAlignmentKey"];
    [d setObject:[NSNumber numberWithInt:0] forKey:@"BRLineBreakModeKey"];
    return [[[NSAttributedString alloc]initWithString:s attributes:d]autorelease];
}

%new - (id)text {
	
	return [self associatedValueForKey:(void*)kSMFTDSCText];
}

%new - (void)setText:(id)theText {
	
	[self associateValue:theText withKey:(void*)kSMFTDSCText];
}

%new - (id)scrolling {
	
	return [self associatedValueForKey:(void*)kSMFTDSCScrolling];
	
}

%new - (void)setScrolling:(id)theScroller
{
	[self associateValue:theScroller withKey:(void*)kSMFTDSCScrolling];
}

%new - (id)list
{
	return [self associatedValueForKey:(void*)kSMFTDSCList];
}

%new - (void)setList:(id)theList
{
	[self associateValue:theList withKey:(void*)kSMFTDSCList];
}

-(id)init
{
    self=%orig;

		// self.text=[NSMutableString stringWithString:@"Hello"];
    [self setText: [NSMutableString stringWithString:@"Hello"]];  
	[self setBackgroundColor:[[NSMFThemeInfo sharedTheme]blackColor]];
	[self setBorderColor:[[NSMFThemeInfo sharedTheme] whiteColor]];
    [self setBorderWidth:3.0];
	id ic = [[objc_getClass("BRImageControl") alloc] init];
	[ic setImage:[[NSMFThemeInfo sharedTheme]btstackIcon]];
	id _scrolling=[[objc_getClass("BRScrollingTextBoxControl") alloc]init];
	[_scrolling setText:[self attributedStringForString:[self text]]];
    id _list=MSHookIvar<id>(_scrolling, "_list");
    
	[self setContent:_scrolling];
    [self setScrolling:_scrolling];
	[self setList:_list];
	[ic autorelease];
    return self;
}

-(void)dealloc
{
		//  self.text=nil;
		//[_scrolling release];
		//_scrolling=nil;
    %orig;
}
-(void)controlWasActivated
{
    [self setFocusedControl:[self scrolling]];
    [self _setFocus:[self scrolling]];
    %orig;
}
-(BOOL)brEventAction:(id)event
{
    id _list = [self list];
    int remoteAction = (int)[event remoteAction];
    switch (remoteAction)
    {
        case kBREventRemoteActionMenu:
			if ([self respondsToSelector:@selector(removeFromParent)])
				[self removeFromParent];
            else
				[self removeFromSuperview];
            return YES;
            break;
        case kBREventRemoteActionUp:
            if ((int)[event value]==1) {
                if ([_list selection]==0)
                {
                    [_list setSelection:([_list dataCount]-1)];
                    return YES;
                }
            }
            break;
        case kBREventRemoteActionDown:
            if ((int)[event value]==1) {
                if ([_list selection]==([_list dataCount]-1)) {
                    return YES;
                }
            }
            break;
    }
    return %orig;
}
%new -(void)appendToText:(NSString *)t
{
	id _text = [self text];
	id _list = [self list];
    [_text appendString:t];
    [[self scrolling] setText:[self attributedStringForString:_text]];
    [_list setSelection:([_list dataCount]-1)];
    [[self scrolling] layoutSubcontrols];
}
	//@end

%end