//
//  SMFComplexDropShadowControl.m
//  SMFramework
//
//  Created by Thomas Cool on 2/28/11.
//  Copyright 2011 Thomas Cool. All rights reserved.
//

//#import "SMFComplexDropShadowControl.h"
#import "SMFThemeInfo.h"
//#import "SMFDefines.h"
//#import <substrate.h>

#define SHRINK_RECT CGRectMake(270.0,85.0,730.0,530.0)


static char const * const kSMFCDSBGControlKey = "SMFCDSBGControl";
static char const * const kSMFCDSScrollingTextKey = "SMFCDSScrollingTextKey";
static char const * const kSMFCDSSpinnerKey = "SMFCDSSpinner";
static char const * const kSMFCDSProgressBarKey = "SMFCDSProgressBar";
static char const * const kSMFCDSMetaTitleKey = "SMFCDSMetaTitle";
static char const * const kSMFCDSTitleKey = "SMFCDSTitle";
static char const * const kSMFCDSSubtitleKey = "SMFCDSSubtitle";
static char const * const kSMFCDSTextKey = "SMFCDSText";
static char const * const kSMFCDSListKey = "SMFCDSList";
static char const * const kSMFCDSDelegateKey = "kSMFCDSDelegate";

static BOOL _pbShows = TRUE;
static BOOL _blocking = FALSE;
static BOOL _showWaitSpinner = TRUE;

@interface SMFComplexDropShadowControl : NSObject

- (id)scrolling;
- (CGRect)frame;
@end


%subclass SMFComplexDropShadowControl : SMFDropShadowControl

/*
@implementation SMFComplexDropShadowControl
@synthesize title=_title;
@synthesize subtitle=_subtitle;
@synthesize progress=_progress;
@synthesize blocking=_blocking;
@synthesize delegate;
*/

%new - (id)bg {
	
	return [self associatedValueForKey:(void*)kSMFCDSBGControlKey];
}

%new - (void)setBg:(id)theBg {
	
	[self associateValue:theBg withKey:(void*)kSMFCDSBGControlKey];
}

%new - (id)scrolling {
	
	return [self associatedValueForKey:(void*)kSMFCDSScrollingTextKey];
}

%new - (void)setScrolling:(id)theScrolling {
	
	[self associateValue:theScrolling withKey:(void*)kSMFCDSScrollingTextKey];
}

%new - (id)spinner {
	
	return [self associatedValueForKey:(void*)kSMFCDSSpinnerKey];
}

%new - (void)setSpinner:(id)theSpinner {
	
	[self associateValue:theSpinner withKey:(void*)kSMFCDSSpinnerKey];
}

%new - (id)progressBar {
	
	return [self associatedValueForKey:(void*)kSMFCDSProgressBarKey];
}

%new - (void)setProgressBar:(id)theProgress {
	
	[self associateValue:theProgress withKey:(void*)kSMFCDSProgressBarKey];
}

%new - (id)titleControl {
	
	return [self associatedValueForKey:(void*)kSMFCDSMetaTitleKey];
	
}

%new - (void)setTitleControl:(id)theTitleControl {
	
	[self associateValue:theTitleControl withKey:(void*)kSMFCDSMetaTitleKey];
}

%new - (id)text {
	
	return [self associatedValueForKey:(void*)kSMFCDSTextKey];
}

%new - (void)setText:(id)theText {
	
	[self associateValue:theText withKey:(void*)kSMFCDSTextKey];
}

%new - (id)title {
	
	return [self associatedValueForKey:(void*)kSMFCDSTitleKey];
}

%new - (void)setTitle:(id)theTitle {
	
	[self associateValue:theTitle withKey:(void*)kSMFCDSTitleKey];
}

%new - (id)subtitle {
	
	return [self associatedValueForKey:(void*)kSMFCDSSubtitleKey];
}

%new - (void)setSubtitle:(id)theSubTitle {
	
	[self associateValue:theSubTitle withKey:(void*)kSMFCDSSubtitleKey];
}

%new - (id)list {
	
	return [self associatedValueForKey:(void*)kSMFCDSListKey];
}

%new - (void)setList:(id)theList {
	
	[self associateValue:theList withKey:(void*)kSMFCDSListKey];
}

%new - (id)delegate {
	
	return [self associatedValueForKey:(void*)kSMFCDSDelegateKey];
	
}

%new - (void)setDelegate:(id)theDelegate {
	
	[self associateValue:theDelegate withKey:(void*)kSMFCDSDelegateKey];
}

#define BRC objc_getClass("BRControl")
#define SMPBC objc_getClass("SMFProgressBarControl")
#define BRMDTC objc_getClass("BRMetadataTitleControl")
#define BRSTBC objc_getClass("BRScrollingTextBoxControl")

%new -(BOOL)sixtyPlus
{
	if ([self respondsToSelector:@selector(controls)])
	{
		return (FALSE);
	}
	return (TRUE);
}

-(id)init
{
    self=%orig;
    CGRect f = CGRectMake(256.0,72.0,768.0,576.0);//(s.width*0.2, s.height*0.1, s.width*0.6, s.height*0.8);
    [self setFrame:f];
    id _bg=[[BRC alloc] init];
	
	[self setBg:_bg];
	
    id _progress=[[SMPBC alloc]init];
	id _titleControl=[[BRMDTC alloc]init];
    id _scrolling=[[BRSTBC alloc]init];
    id _list=MSHookIvar<id>(_scrolling, "_list");
	[_list setSelectionLozengeStyle:0];
	[_list setAvoidsCursor:TRUE];
	[_list setDisplaysSelectionWidget:FALSE];
	NSLog(@"is this where we die?");
	if ([self sixtyPlus])
	{
		[[self layer] setBackgroundColor:[[SMFThemeInfo sharedTheme]blackColor]];
		[[self layer] setBorderColor:[[SMFThemeInfo sharedTheme] whiteColor]];
		[[self layer] setBorderWidth:3.0];
	} else {
		[self setBackgroundColor:[[SMFThemeInfo sharedTheme]blackColor]];
		[self setBorderColor:[[SMFThemeInfo sharedTheme] whiteColor]];
		[self setBorderWidth:3.0];
	}
	
	NSLog(@"yep");
		//self.backgroundColor=[[SMFThemeInfo sharedTheme]blackColor];
		//self.borderColor=[[SMFThemeInfo sharedTheme] whiteColor];
		//self.borderWidth=3.0;
	[self setTitle:@"								"];
	[self setSubtitle:@" "];
	
	[self setProgressBar:_progress];
	[self setTitleControl:_titleControl];
	[self setScrolling:_scrolling];
	[self setList:_list];
    [self setContent:_bg];
    id _text=[[NSMutableString alloc] initWithString:@" "];
    [self setText:_text];
	
	[self addObserver:self forKeyPath:@"title" options:0 context:nil];
    [self addObserver:self forKeyPath:@"subtitle" options:0 context:nil];
    return self;
}

%new void logFrame(CGRect frame)
{
    NSLog(@"{{%f, %f},{%f,%f}}",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)o change:(NSDictionary *)change context:(void *)context
{
    if (o==self && [keyPath isEqualToString:@"title"]) {
			//  NSLog(@"changing title");
        [[self titleControl] setTitle:[self title]];
        [[self titleControl] layoutSubcontrols];
    }
    else if(o==self && [keyPath isEqualToString:@"subtitle"])
    {
			//   NSLog(@"changing subtitle");
        [[self titleControl] setTitleSubtext:[self subtitle]];
        [[self titleControl] layoutSubcontrols];
    }
}

%new - (void)removeAllSubviews
{
	NSArray *views = [[self bg] subviews];
	NSEnumerator *subviewEnum = [views objectEnumerator];
	id current = nil;
	while ((current = [subviewEnum nextObject]))
	{
		[current removeFromSuperview];
	}
}

%new -(void)reload
{
	BOOL sixPlus = FALSE;
	
	id theBg = [self bg];
	id theTitleControl = [self titleControl];
	id theProgress = [self progressBar];
	id theScrolling = [self scrolling];
	
	if ([self respondsToSelector:@selector(_removeAllControls)])
	{ 
		[theBg _removeAllControls];
	
	} else {
	
		sixPlus = TRUE;
		[self removeAllSubviews];
		
	}
   
	CGRect pf = [self frame];
    [theProgress setFrame:CGRectMake(pf.size.width*0.2f, pf.size.height*0.02f, pf.size.width*0.6f, pf.size.height*0.06f)];

    
    [theTitleControl setTitle:[self title]];
    [theTitleControl setTitleSubtext:[self subtitle]];
    [theTitleControl setFrame:CGRectMake(pf.size.width*0.02f, pf.size.height*0.83f, pf.size.width*0.6f, pf.size.height*0.15f)];
    
    
    [theScrolling setFrame:CGRectMake(0.0, pf.size.height*0.11, pf.size.width, pf.size.height*0.75f)];
    [theScrolling setText:[self attributedStringForString:[self text]]];
   
	if (sixPlus)
	{
		
		[theBg addSubview:theScrolling];
		[theBg addSubview:theProgress];
		[theBg addSubview:theTitleControl];
		
	} else {
		
		[theBg addControl:theScrolling];
		[theBg addControl:theProgress];
		[theBg addControl:theTitleControl];
		
	}
	
	
    
}

%new -(id)attributedStringForString:(NSString*)s
{
    NSMutableDictionary *d = [[[[%c(BRThemeInfo) sharedTheme]metadataTitleAttributes] mutableCopy] autorelease];
    [d setObject:[NSNumber numberWithInt:0] forKey:@"BRTextAlignmentKey"];
    [d setObject:[NSNumber numberWithInt:0] forKey:@"BRLineBreakModeKey"];
    return [[[NSAttributedString alloc]initWithString:s attributes:d]autorelease];
}
%new -(void)appendToText:(NSString *)t
{
	id theList = [self list];
    [[self text] appendString:t];
    [[self scrolling] setText:[self attributedStringForString:[self text]]];
    [theList setSelection:([theList dataCount]-1)];
    [[self scrolling] layoutSubcontrols];
	[self _setFocus:nil];
	[self setFocusedControl:nil];
}

%new - (void)removeBlueLozenge //thats (sort of) the weird thing going on when you use this controller in conjunction w/ SMFMoviePreviewController
{
	id objects = nil;

	id theList = [self list];
	
	if ([self respondsToSelector:@selector(controls)])
	{
		objects = [theList controls];

	} else {
	
		objects = [theList subviews];
		
	}
	
	NSEnumerator *controlEnum = [objects objectEnumerator];
	id current = nil;
	while ((current = [controlEnum nextObject]))
	{
		NSString *currentClass = NSStringFromClass([current class]);
		if ([currentClass isEqualToString:@"BRBlueGlowSelectionLozengeLayer"])
		{

			if ([current respondsToSelector:@selector(removeFromParent)])
				[current removeFromParent];
			else
				[current removeFromSuperview];
			
			
			[theList layoutSubcontrols];
		}
	}
}



-(void)controlWasActivated
{
    %orig;

		
    [self reload];
}
%new -(void)setShowsProgressBar:(BOOL)shows
{
    [[self progressBar] setHidden:!shows];
    _pbShows=shows;
}
%new -(BOOL)showsProgressBar
{
    return _pbShows;
}
%new -(void)setShowsWaitSpinner:(BOOL)shows
{
    [[self spinner] setHidden:!shows];
    _showWaitSpinner=shows;
}
-(BOOL)brEventAction:(id)event
{
    id theList = [self list];
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
                if ([theList selection]==0)
                {
                    [theList setSelection:([theList dataCount]-1)];
                    return YES;
                }
            }
            break;
        case kBREventRemoteActionDown:
            if ((int)[event value]==1) {
                if ([theList selection]==([theList dataCount]-1)) {
                    return YES;
                }
            }
            break;
    }
    return %orig;
}
%new -(BOOL)showsWaitSpinner
{
    return _showWaitSpinner;
}
%new -(void)updateHeader
{
	id theTitleControl = [self titleControl];
    [theTitleControl setTitle:[self title]];
    [theTitleControl setTitleSubtext:[self subtitle]];
    [theTitleControl layoutSubcontrols];
}


-(void)dealloc
{
		// [_titleControl release];
		//_titleControl=nil;
		//[_bg release];
		//_bg=nil;
		//[_scrolling release];
		//_scrolling=nil;
		//[_progress release];
		//_progress=nil;
		//[_spinner release];
		//_spinner = nil;
    
		//_list=nil;
    [self removeObserver:self forKeyPath:@"title"];
    [self removeObserver:self forKeyPath:@"subtitle"];
		// self.title=nil;
		//   self.subtitle=nil;
    %orig;
    
}
				//@end

%end