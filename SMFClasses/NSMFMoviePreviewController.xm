//
//  SMFMoviePreviewController.m
//  SMFramework
//
//  Created by Thomas Cool on 2/6/11.
//  Copyright 2011 tomcool.org. All rights reserved.
//

/*
#import "Backrow/BRThemeInfo.h"
#import "Backrow/BRController.h"
#import "Backrow/BRControl.h"
#import "SMFControlFactory.h"
#import "SMFMoviePreviewController.h"
#import "SMFDefines.h"
#import "NSMFBaseAsset.h"
#import "NSMFListDropShadowControl.h"
#import "NSMFCompatibility.h"

*/

#import "../Classes/packageManagement.h"

#import "NSMFMockMenuItem.h"

#import "NSMFMoviePreviewDelegateDatasource.h"
#define NOSHELF
#define BTI objc_getClass("BRThemeInfo")

NSString * const kSMFMoviePreviewTitle = @"title";
NSString * const kSMFMoviePreviewSubtitle = @"substitle";
NSString * const kSMFMoviePreviewSummary = @"summary";
NSString * const kSMFMoviePreviewPosterPath = @"posterPath";
NSString * const kSMFMoviePreviewPoster = @"poster";
NSString * const kSMFMoviePreviewHeaders = @"headers";
NSString * const kSMFMoviePreviewColumns = @"columns";
NSString * const kSMFMoviePreviewRating = @"rating";
NSString * const kMoviePreviewControllerSelectionChanged = @"kMoviePreviewControllerSelectionChanged";
NSString * const kMoviePreviewControllerNewSelectedControl = @"kMoviePreviewControllerNewSelectedControl";

/*
@implementation SMFMoviePreviewController
@synthesize delegate;
@synthesize datasource;

@synthesize shelfControl=_shelfControl;


@synthesize _buttons;

 */

/*
 BRMetadataTitleControl *_metadataTitleControl;
 objc_getClass("BRTextControl")			* _summaryControl;
 NSMutableArray			* _buttons;
 BRImageControl			*_previousArrowImageControl;
 BRImageControl			*_nextArrowImageControl;
 id						_shelfControl;
 id						_adap;
 BRCoverArtPreviewControl	*_previewControl;
 NSMutableDictionary        *_info;
 NSObject<NSMFMoviePreviewControllerDatasource> *datasource;
 NSObject<NSMFMoviePreviewControllerDelegate> *delegate;
 BRDividerControl			*_div3;
 objc_getClass("BRTextControl")				*_alsoWatched;
 NSMutableArray				*_hideList;
 BRDataStoreProvider		*_provider;
 
 BOOL                _summaryToggled;
 BOOL				_previousArrowTurnedOn;
 BOOL				_nextArrowTurnedOn;
 BOOL                _usingShelfView;

 
 */

static BOOL _summaryToggled = TRUE;
static BOOL _previewArrowTurnedOn = TRUE;
static BOOL _nextArrowTurnedOn = TRUE;
static BOOL _previousArrowTurnedOn;
static BOOL _usingShelfView = TRUE;

static char const * const kSMFMPCMetaTitleControlKey = "SMFMPCMetaTitleControl";
static char const * const kSMFMPCSummaryControlKey = "SMFMPCSummaryControl";
static char const * const kSMFMPCButtonsKey = "SMFMPCButtons";
static char const * const kSMFMPCPreviousArrowKey = "SMFMPCPreviousArrow";
static char const * const kSMFMPCNextArrowKey = "SMFMPCNextArrow";
static char const * const kSMFMPCShelfControlKey = "SMFMPCShelfControl";
static char const * const kSMFMPCAdapKey = "SMFMPCAdap";
static char const * const kSMFMPCInfoKey = "SMFMPCInfo";
static char const * const kSMFMPCDatasourceKey = "SMFMPCDatasource";
static char const * const kSMFMPCDelegateKey = "SMFMPCDelegate";
static char const * const kSMFMPCDiv3Key = "SMFMPCDiv3";
static char const * const kSMFMPCAlsoWatchedKey = "SMFMPCAlsoWatched";
static char const * const kSMFMPCHideListKey = "SMFMPCHideList";
static char const * const kSMFMPCProviderKey = "SMFMPCProvider";
static char const * const kSMFMPCPreviewControlKey = "SMFMPCPreviewControl";

@interface NSMFMoviePreviewController : NSObject

-(BOOL)isSixPointOhPlus;

@end



%subclass NSMFMoviePreviewController : BRController

%new -(id)metadataTitleControl {
	
	return [self associatedValueForKey:(void*)kSMFMPCMetaTitleControlKey];
}

%new -(void)setMetadataTitleControl:(id)mdtc {
	
	[self associateValue:mdtc withKey:(void*)kSMFMPCMetaTitleControlKey];
}

%new -(id)summaryControl {
	
	return [self associatedValueForKey:(void*)kSMFMPCSummaryControlKey];
}

%new -(void)setSummaryControl:(id)theSummaryControl {
	
	[self associateValue:theSummaryControl withKey:(void*)kSMFMPCSummaryControlKey];
}

%new -(id)buttons {
	
	return [self associatedValueForKey:(void*)kSMFMPCButtonsKey];
}

%new -(void)setButtons:(id)theButtons {
	
	[self associateValue:theButtons withKey:(void*)kSMFMPCButtonsKey];
}

%new -(id)previousArrowImageControl {
	
	return [self associatedValueForKey:(void*)kSMFMPCPreviousArrowKey];
}

%new -(void)setPreviousArrowImageControl:(id)paic {
	
	[self associateValue:paic withKey:(void*)kSMFMPCPreviousArrowKey];
}

%new -(id)nextArrowImageControl {
	
	return [self associatedValueForKey:(void*)kSMFMPCNextArrowKey];
}

%new -(void)setNextArrowImageControl:(id)naic {
	
	[self associateValue:naic withKey:(void*)kSMFMPCNextArrowKey];
}


%new -(id)_shelfControl {
	return [self associatedValueForKey:(void*)kSMFMPCShelfControlKey];
}

%new -(void)setShelfControl:(id)theShelfControl {
	
	[self associateValue:theShelfControl withKey:(void*)kSMFMPCShelfControlKey];
}

%new -(id)adap {
	
	return [self associatedValueForKey:(void*)kSMFMPCAdapKey];
}

%new -(void)setAdap:(id)theAdap {
	[self associateValue:theAdap withKey:(void*)kSMFMPCAdapKey];
}

%new -(id)info {
	return [self associatedValueForKey:(void*)kSMFMPCInfoKey];
}

%new -(void)setInfo:(id)theInfo {
	[self associateValue:theInfo withKey:(void*)kSMFMPCInfoKey];
}

%new -(id)previewControl {
	
	return [self associatedValueForKey:(void*)kSMFMPCPreviewControlKey];
}

%new -(void)setPreviewControl:(id)thePreviewControl {
	
	[self associateValue:thePreviewControl withKey:(void*)kSMFMPCPreviewControlKey];
}

%new -(id)datasource {
	
	return [self associatedValueForKey:(void*)kSMFMPCDatasourceKey];
}

%new -(void)setDatasource:(id)theDS {
	
	[self associateValue:theDS withKey:(void*)kSMFMPCDatasourceKey];
}

%new -(id)delegate {
	
	return [self associatedValueForKey:(void*)kSMFMPCDelegateKey];
}

%new -(void)setDelegate:(id)theDelegate {
	
	[self associateValue:theDelegate withKey:(void*)kSMFMPCDelegateKey];
}

%new -(id)div3 {
	
	return [self associatedValueForKey:(void*)kSMFMPCDiv3Key];
}

%new -(void)setDiv3:(id)theDiv {
	
	[self associateValue:theDiv withKey:(void*)kSMFMPCDiv3Key];
}

%new -(id)alsoWatched {
	
	return [self associatedValueForKey:(void*)kSMFMPCAlsoWatchedKey];
}

%new -(void)setAlsoWatched:(id)aw {
	
	[self associateValue:aw withKey:(void*)kSMFMPCAlsoWatchedKey];
}

%new -(id)hideList {
	
	return [self associatedValueForKey:(void*)kSMFMPCHideListKey];
}

%new -(void)setHideList:(id)theHideList {
	
	[self associateValue:theHideList withKey:(void*)kSMFMPCHideListKey];
}

%new -(id)provider {
	
	return [self associatedValueForKey:(void*)kSMFMPCProviderKey];
}

%new -(void)setProvider:(id)theProvider {
	
	[self associateValue:theProvider withKey:(void*)kSMFMPCProviderKey];
}



%new +(NSDictionary *)columnHeaderAttributes {
    return [[BTI sharedTheme]movieMetadataLabelAttributes];
}

%new +(NSDictionary *)columnLabelAttributes
{
    return [[BTI sharedTheme]metadataLineAttributes];
}

%new -(void)logFrame:(CGRect)frame
{
	NSLog(@"{{%f, %f},{%f,%f}}",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}

//void logFrame(CGRect frame)
//{
//    NSLog(@"{{%f, %f},{%f,%f}}",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
//}

%new -(id)getProviderForShelf
{
    return [[self datasource] providerForShelf];
}

%new -(NSMutableDictionary *)getInformation
{
    NSMutableDictionary *d = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                              @"",kSMFMoviePreviewTitle,
                              @"",kSMFMoviePreviewSubtitle,
                              @"(no summary)",kSMFMoviePreviewSummary,
                              [NSArray array],kSMFMoviePreviewHeaders,
                              [NSArray array],kSMFMoviePreviewColumns,
                              [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:[NSMFMockMenuItem class]] pathForResource:@"colorAppleTVNameImage" ofType:@"png"]],kSMFMoviePreviewPoster,
                              @"",kSMFMoviePreviewPosterPath,
                              @"pg",kSMFMoviePreviewRating,
                              nil];
		//NSLog(@"get information %@",[self datasource]);
    if ([self datasource]!=nil /*&& [[self datasource] conformsToProtocol:@protocol(NSMFMoviePreviewControllerDatasource)]*/) {
			//NSLog(@"conforms to protocol");
        NSString *t = [[self datasource] title];
        if (t!=nil)  {[d setObject:t forKey:kSMFMoviePreviewTitle];}
        t = [[self datasource] subtitle];
        if (t!=nil)  {[d setObject:t forKey:kSMFMoviePreviewSubtitle];}         
        t = [[self datasource] summary];
        if (t!=nil)  {[d setObject:t forKey:kSMFMoviePreviewSummary];}         
        NSArray *a = [[self datasource] headers];
        if (a!=nil)  {[d setObject:a forKey:kSMFMoviePreviewHeaders];}         
        a = [[self datasource] columns];
        if (a!=nil)  {[d setObject:a forKey:kSMFMoviePreviewColumns];} 
        if ([[self datasource] respondsToSelector:@selector(coverArt)]) {
            id i = [[self datasource] coverArt];
            if (i!=nil)  {[d setObject:i forKey:kSMFMoviePreviewPoster];}
        }
        else if([[self datasource] respondsToSelector:@selector(posterPath)])
        {
            t = [[self datasource] posterPath];
            if (t!=nil)  {[d setObject:t forKey:kSMFMoviePreviewPosterPath];}
        }
        
		
        t = [[self datasource] rating];
        if (t!=nil)  {[d setObject:t forKey:kSMFMoviePreviewRating];}
    }
    return [d autorelease];
    
}
void checkNil(NSObject *ctrl)
{
	return; //FIXME: JUST FOR NOW
    if (ctrl!=nil) {
        [ctrl release];
        ctrl=nil;
    }
}


%new -(void)reload
{
	
    Class __BRProxyManager=NSClassFromString(@"BRProxyManager");
    
	BOOL is60 = FALSE;
	
    if (__BRProxyManager !=nil)
        _usingShelfView=YES;
    
	
    //[self _removeAllControls];
	// if (_hideList!=nil) {
	//  [_hideList release];
	//  _hideList=nil;
	// }
  
		id _hideList=[[NSMutableArray alloc] init];
	
		
	id myControls = nil;
	
	if ([self respondsToSelector:@selector(controls)])
	{
		myControls = [self controls];
		is60 = FALSE;
	} else {
		myControls = [self subviews];
		is60 = TRUE;
	}
	
    for (id c in myControls) {
        if (c!=[self _shelfControl]) {
           
			if ([c respondsToSelector:@selector(removeFromParent)])
				[c removeFromParent];
             else 
				 [c removeFromSuperview];
		}
    }
    
    CGRect masterFrame=[objc_getClass("BRWindow") interfaceFrame];
		//  [_info release];
		//_info=nil;
		//  id _info = [[self getInformation] retain];
    id _info = [self getInformation];
	[self setInfo:_info];
	
	_summaryToggled=NO;
    
    
	/*
     *  The Poster
     */
    //checkNil(_previewControl);
    CGRect imageFrame = CGRectMake(-100.f,//masterFrame.origin.x+masterFrame.size.width*0.00f,
                                   164.f,//masterFrame.origin.y+masterFrame.size.height*0.20f,
                                   masterFrame.size.width*0.48f,
                                   masterFrame.size.height*0.843f);
    id _previewControl =[[objc_getClass("BRCoverArtPreviewControl") alloc]init];
	
    id a  = [objc_getClass("NSMFBaseAsset") asset];
    [a setCoverArt:[_info objectForKey:kSMFMoviePreviewPoster]];
    id proxy = [[objc_getClass("BRPhotoImageProxy") alloc] initWithAsset:a];
    [_previewControl setImageProxy:proxy];
    [proxy release];
	
    [_previewControl setFrame:imageFrame];
	[self setPreviewControl:_previewControl];
	
	if (!is60)[self addControl:_previewControl];
    else [self addSubview:_previewControl];
    /*
     *  The Title
     */
		// NSLog(@"1");
    //checkNil(_metadataTitleControl);
    id _metadataTitleControl=[[objc_getClass("BRMetadataTitleControl") alloc]init];
    [_metadataTitleControl setTitle:[_info objectForKey:kSMFMoviePreviewTitle]];
    [_metadataTitleControl setTitleSubtext:[_info objectForKey:kSMFMoviePreviewSubtitle]];
    [_metadataTitleControl setRating:[_info objectForKey:kSMFMoviePreviewRating]];
    CGRect mtcf=CGRectMake(masterFrame.size.width*0.29766f, 
                           masterFrame.size.height*0.875f, 
                           masterFrame.size.width*0.648f,
                           masterFrame.size.height*0.0695);
	
	[_metadataTitleControl setFrame:mtcf];
    
	[self setMetadataTitleControl:_metadataTitleControl];
	
	if (!is60)[self addControl:_metadataTitleControl];
    else [self addSubview:_metadataTitleControl];
  
	
	
    
    
    /*
     *  The Subtitle
     */
	
    
    /*
     *  First Divider
     */
	
	Class divClass = objc_getClass("BRDividerControl");
	if (divClass == nil)
		divClass = objc_getClass("BRHorizontalDividerControl");
	
	
    id div1 = [[divClass alloc]init];
    CGRect div1Frame = CGRectMake(mtcf.origin.x , 
								  mtcf.origin.y-masterFrame.size.height*(10.f/720.f), 
								  mtcf.size.width,//masterFrame.size.width*0.64f, 
								  masterFrame.size.height*(10.f/720.f));
    [div1 setFrame:div1Frame];
	
	if (!is60)[self addControl:div1];
    else [self addSubview:div1];

	
	[div1 release];
    
    /*
     *  Summary
     */
    //checkNil(_summaryControl);
    id _summaryControl = [[objc_getClass("BRTextControl") alloc]init];
    CGRect summaryFrame = CGRectMake(mtcf.origin.x, 
                                     div1Frame.origin.y-masterFrame.size.height*(94.f/720.f),//masterFrame.size.height*0.118f,
                                     mtcf.size.width,//masterFrame.size.width*0.64f, 
                                     masterFrame.size.height*(94.f/720.f));//masterFrame.size.height*0.113f);
    [_summaryControl setFrame:summaryFrame];
    [_summaryControl setText:[_info  objectForKey:kSMFMoviePreviewSummary]
			  withAttributes:[[BTI sharedTheme]metadataSummaryFieldAttributes]];
    
	
    
    
    /*
     *  Second Divider
     */
    id div2 = [[divClass alloc]init];
    CGRect div2Frame =CGRectMake(mtcf.origin.x , 
                                 summaryFrame.origin.y-10.f/720.f*masterFrame.size.height,//masterFrame.size.height*0.01f,
                                 mtcf.size.width,//masterFrame.size.width*0.64f, 
                                 masterFrame.size.height*(10.f/720.f));
    [div2 setFrame:div2Frame];
   
	if (!is60)[self addControl:div2];
    else [self addSubview:div2];
	
	[_hideList addObject:div2];
    [div2 release];
    
		//NSLog(@"2");
	
    /*
     *  Headers for information
     */
    NSArray *headers = [_info objectForKey:kSMFMoviePreviewHeaders];
    float increment = (mtcf.size.width/masterFrame.size.width)/(float)[headers count];
    //int counter=0;
    float lastOriginY=0.0f;
		//NSLog(@"obj: %@",headers);
    for(int counter=0;counter<[headers count];counter++)
    {
        id head = [[objc_getClass("BRTextControl") alloc]init];
        [head setText:[headers objectAtIndex:counter] withAttributes:[%c(NSMFMoviePreviewController) columnHeaderAttributes] ];
        CGRect headFrame;
        headFrame.size=[head renderedSize];
        if (headFrame.size.width>(masterFrame.size.width*increment*0.95f))
            headFrame.size.width=(masterFrame.size.width*increment*0.95f);
        headFrame.origin.x=mtcf.origin.x+masterFrame.size.width*increment*(float)counter;
        headFrame.origin.y=div2Frame.origin.y-masterFrame.size.height*0.001-headFrame.size.height;
        lastOriginY=headFrame.origin.y;
        [head setFrame:headFrame];
			//[self addControl:head];
        if (!is60)[self addControl:head];
		else [self addSubview:head];
		
		[_hideList addObject:head];
        [head release];
    }
    /*
     *  Main Information
     */
		//NSLog(@"3");
    NSArray *objects = [_info objectForKey:kSMFMoviePreviewColumns];
    for (int counter=0; counter<[objects count]; counter++) {
        NSArray *current = [objects objectAtIndex:counter];
        int maxObj = [current count]>5?5:[current count];
        float tempY = lastOriginY;
        for (int objcount=0; objcount<maxObj; objcount++) {
            if ([[current objectAtIndex:objcount] isKindOfClass:[NSArray class]]) { //we are dealing with an array
                NSArray *objects = [current objectAtIndex:objcount];
                float x = mtcf.origin.x+masterFrame.size.width*increment*(float)counter;
                float maxX=mtcf.origin.x+masterFrame.size.width*increment*(float)counter+masterFrame.size.width*increment*0.95;
                float maxY=0.0;
                for (int i=0;i<[objects count];i++)
                {
                    id ctrl = nil;
                    CGRect r= CGRectMake(x, 0.0, 0.0, 0.0 );
                    if ([[objects objectAtIndex:i] isKindOfClass:[NSAttributedString class]])
                    {
                        ctrl = [[objc_getClass("BRTextControl") alloc]init];
                        [ctrl setAttributedString:[objects objectAtIndex:i]];
                        r.size=[ctrl renderedSize];
                        r.origin.y=tempY-r.size.height;
                        if (r.size.width+r.origin.x>maxX) {
                            r.size.width=maxX-r.origin.x;
                        }
                        [self logFrame:r];
                    }
                    else if([[objects objectAtIndex:i] isKindOfClass:[NSString class]])
                    {
                        ctrl = [[objc_getClass("BRTextControl") alloc]init];
                        [ctrl setText:[objects objectAtIndex:i] withAttributes:[%c(NSMFMoviePreviewController) columnLabelAttributes]];
                        r.size=[ctrl renderedSize];
                        r.origin.y=tempY-r.size.height;
                        if (r.size.width+r.origin.x>maxX) {
                            r.size.width=maxX-r.origin.x;
                        }
                        [self logFrame:r];
                    }
                    else if([[objects objectAtIndex:i] isKindOfClass:objc_getClass("BRImage")])
                    {
                        ctrl = [[objc_getClass("BRImageControl") alloc]init];
                        [ctrl setImage:[objects objectAtIndex:i]];
                        float ar = (float)[ctrl aspectRatio];
                        r.size=[ctrl pixelBounds];
                        r.size.height=22.f;
                        r.size.width=r.size.height*ar;
                        if (r.size.width+r.origin.x>maxX)
                        {
                            float rescaleFactor=r.size.width/(maxX-r.origin.x);
                            r.size.width=r.size.width*rescaleFactor;
                            r.size.height=r.size.height*rescaleFactor;
                            ctrl=nil;
                        }
                        r.origin.y=tempY-r.size.height;
                        [self logFrame:r];
                        
                    }
                    if (maxY<r.size.height)
                        maxY=r.size.height;
                    
                    if(i==([objects count]-1))
                        tempY=tempY-maxY;
                    
                    
                    if (ctrl!=nil) {
                        [ctrl setFrame:r];
                        
						if (!is60) [self addControl:ctrl];
                        else [self addSubview:ctrl];
						
						[ctrl release];
                        [_hideList addObject:ctrl];
                        x=r.origin.x+r.size.width;
                    }
					
                }
            }
            else { //dealing with something other than an array, a string, an image, etc.
				
                id obj=nil; //BRControl
                CGRect objFrame=CGRectMake(0.0, 0.0, 0.0, 0.0);
                if ([[current objectAtIndex:objcount] isKindOfClass:[NSString class]]) {
                    obj = [[objc_getClass("BRTextControl") alloc] init];
                    [(id )obj setText:[current objectAtIndex:objcount] withAttributes:[%c(NSMFMoviePreviewController) columnLabelAttributes]];
                    objFrame.size=[(id )obj renderedSize];
                    if (objFrame.size.width>(masterFrame.size.width*increment*0.95f))
                        objFrame.size.width=(masterFrame.size.width*increment*0.95f);
                }
                else if ([[current objectAtIndex:objcount] isKindOfClass:[NSAttributedString class]]) {
                    obj = [[objc_getClass("BRTextControl") alloc] init];
                    [(id )obj setAttributedString:[current objectAtIndex:objcount]];
                    objFrame.size=[(id )obj renderedSize];
                    if (objFrame.size.width>(masterFrame.size.width*increment*0.95f))
                        objFrame.size.width=(masterFrame.size.width*increment*0.95f);
                }
                else if([[current objectAtIndex:objcount] isKindOfClass:objc_getClass("BRImage")])
                {
                    obj = [[objc_getClass("BRImageControl") alloc]init];
                    [obj setImage:[current objectAtIndex:objcount]];
                    objFrame.size=[obj pixelBounds];
                    float ar = (float)[obj aspectRatio];
                    objFrame.size.height=24.f;
                    objFrame.size.width=objFrame.size.height*ar;
                    if (objFrame.size.width>(masterFrame.size.width*increment*0.95f))
                    {
                        float rescaleFactor=objFrame.size.width/(masterFrame.size.width*increment*0.95f);
                        objFrame.size.width=objFrame.size.width*rescaleFactor;
                        objFrame.size.height=objFrame.size.height*rescaleFactor;
                    }
                    
                }
                
                objFrame.origin.x=mtcf.origin.x+masterFrame.size.width*increment*(float)counter;
                objFrame.origin.y=tempY-objFrame.size.height;
                tempY=objFrame.origin.y;
                [obj setFrame:objFrame];
                
				if (!is60)[self addControl:obj];
				else [self addSubview:obj];
				
				[_hideList addObject:obj];
                [obj release];
                
            }
            
        } //dont with objects in kSMFMoviePreviewColumns
    }
		//NSLog(@"buttons");
    //checkNil(_buttons);
	
	[self setHideList:_hideList];
	
	[_hideList release];
	
	
    id _buttons=[[NSMutableArray alloc]init];
    NSArray *tbuttons=nil;//[NSArray array];
    if ([[self datasource] respondsToSelector:@selector(buttons)]) {
        tbuttons = [[self datasource] buttons];
    }
    else {
        tbuttons=[[NSMutableArray alloc]init];
        [(NSMutableArray *)tbuttons addObject:[objc_getClass("BRButtonControl") actionButtonWithImage:[[BTI sharedTheme]previewActionImage] 
                                                                           subtitle:@"Preview" 
                                                                              badge:nil]];
        [(NSMutableArray *)tbuttons addObject:[objc_getClass("BRButtonControl") actionButtonWithImage:[[BTI sharedTheme]playActionImage] 
                                                                           subtitle:@"Play" 
                                                                              badge:nil]];
        [(NSMutableArray *)tbuttons addObject:[objc_getClass("BRButtonControl") actionButtonWithImage:[[BTI sharedTheme]queueActionImage] 
                                                                           subtitle:@"Queue" 
                                                                              badge:nil]];
        [(NSMutableArray *)tbuttons addObject:[objc_getClass("BRButtonControl") actionButtonWithImage:[[BTI sharedTheme]rateActionImage] 
                                                                           subtitle:@"More" 
                                                                              badge:nil]];
        [tbuttons autorelease];
        
    }
	
    CGRect previewFrame=CGRectMake(masterFrame.origin.x + masterFrame.size.width*0.42f, 
                                   masterFrame.origin.y + masterFrame.size.height *0.32f,
                                   masterFrame.size.height*0.15, 
                                   masterFrame.size.height*0.15f);
	
    CGRect firstButtonFrame = CGRectZero;
	CGRect lastButtonFrame = CGRectZero;
    int button=0;
    for(int i=0;i<[tbuttons count];i++)
    {
        id b = [tbuttons objectAtIndex:i];
        if([b isKindOfClass:objc_getClass("BRButtonControl")])
        {
            CGRect f = previewFrame;
            f.origin.x=f.origin.x+ masterFrame.size.height*0.17*(float)button;
           
            if (!is60)[self addControl:b];
			else [self addSubview:b];
            [b setFrame:f];
			button++;
            [_buttons addObject:b];
			
			if (i == 0) {
				firstButtonFrame = f;
			} else if (i == [tbuttons count]-1) {
				lastButtonFrame = f;
			}
			
        }
    }
	
	[self setButtons:_buttons]; //remember to release
	
	
	/*
     *  Next/Previous arrows
     */
	//checkNil(_previousArrowImageControl);
	//checkNil(_nextArrowImageControl);
	
	float arrowImageControlMargin = 20.0f;
	if ([tbuttons count] > 0) { //if there are no buttons, we cannot go next/previous
		//next/previous arrows	
		if ([[self delegate] respondsToSelector:@selector(controllerCanSwitchToPrevious:)]) {
			//does respond
			if ([[self delegate] controllerCanSwitchToPrevious:self]) {
				//draw previous arrow
				ntvImageControl *_previousArrowImageControl = [(ntvImageControl*)[objc_getClass("ntvImageControl") alloc] init];
				
				if (_previousArrowTurnedOn) {
					[self switchPreviousArrowOn];
				} else {
					[self switchPreviousArrowOff];
				}
				
				CGRect objFrame = firstButtonFrame;
				objFrame.origin.x -= [(ntvImage*)[_previousArrowImageControl image] pixelBounds].width + arrowImageControlMargin;
				objFrame.origin.y += (objFrame.size.height/2) - ([(ntvImage*)[_previousArrowImageControl image] pixelBounds].height / 2);
				objFrame.size.height = [(ntvImage*)[_previousArrowImageControl image] pixelBounds].height;
				objFrame.size.width = [(ntvImage*)[_previousArrowImageControl image] pixelBounds].width;
				[_previousArrowImageControl setFrame:objFrame];
				
				//rotate imageview so arrow points in the right direction
				CGAffineTransform cgCTM = CGAffineTransformMakeRotation(M_PI);
				_previousArrowImageControl.affineTransform = cgCTM;
				
				[self setPreviousArrowImageControl:_previousArrowImageControl];
				
				if (!is60)[self addControl:_previousArrowImageControl];
				else [self addSubview:_previousArrowImageControl];
			}
		}
		if ([[self delegate] respondsToSelector:@selector(controllerCanSwitchToNext:)]) {
			//does respond
			if ([[self delegate] controllerCanSwitchToNext:self]) {
				//draw next arrow
				BRImageControl *_nextArrowImageControl = [[objc_getClass("BRImageControl") alloc] init];
				if (_nextArrowTurnedOn) {
					[self switchNextArrowOn];
				} else {
					[self switchNextArrowOff];
				}
				
				CGRect objFrame = lastButtonFrame;
				objFrame.origin.x += lastButtonFrame.size.width + arrowImageControlMargin;
				objFrame.origin.y += (objFrame.size.height/2) - ([[_nextArrowImageControl image] pixelBounds].height / 2);
				objFrame.size.height = [[_nextArrowImageControl image] pixelBounds].height;
				objFrame.size.width = [[_nextArrowImageControl image] pixelBounds].width;
				[_nextArrowImageControl setFrame:objFrame];
				
					//[self addControl:_nextArrowImageControl];
				
				[self setNextArrowImageControl:_nextArrowImageControl];
				
				if (!is60)[self addControl:_nextArrowImageControl];
				else [self addSubview:_nextArrowImageControl];
			}
		}
	}
		//NSLog(@"end buttons");
	
	id moviesControl =[[objc_getClass("BRTextControl") alloc] init];
    NSString *title=@"";
    if([[self datasource] respondsToSelector:@selector(shelfTitle)])
        title=[[self datasource] shelfTitle];
    else
        title=@"Movies";
    [moviesControl setText:title withAttributes:[[BTI sharedTheme]metadataSummaryFieldAttributes]];
    CGRect mf;
    mf.size = [moviesControl renderedSize];
    mf.origin.x=masterFrame.size.width*0.1;
    mf.origin.y=masterFrame.size.height*0.29f,
    [moviesControl setFrame:mf];
	
    if(!is60)[self addControl:moviesControl];
    else [self addSubview:moviesControl];
	
	[moviesControl release];
    
    id div3 = [[divClass alloc]init];
    
    CGRect div3Frame =CGRectMake(mf.origin.x + mf.size.width+masterFrame.size.width*0.02f, 
                                 mf.origin.y+(mf.size.height-[div3 recommendedHeight])/2.0f,
                                 mtcf.origin.x+mtcf.size.width-(mf.origin.x + mf.size.width+masterFrame.size.width*0.02), 
                                 [div3 recommendedHeight]);
    [div3 setFrame:div3Frame];
    if (!is60)[self addControl:div3];
    else [self addSubview:div3];
	
	[div3 release];
    
    
    
    id cursor = [[[objc_getClass("BRCursorControl") alloc] init] autorelease];
   
	[self setSummaryControl:_summaryControl];
	
   if(!is60)
   {
	   [self addControl:cursor];
	   [self addControl:_summaryControl];

   } else {
	
	   [self addSubview:cursor];
	   [self addSubview:_summaryControl];
	   
   }
   
}

%new -(BOOL)isSixPointOhPlus
{
	if ([self respondsToSelector:@selector(controls)])
	{
		return (FALSE);
	}
	
	return (TRUE);
}

/*
 
 
 try making a box control instead?
 
 @"<BRBoxControl: 0x12812a70> Recently Watched"
 cy# [boxControl frame]
 {origin:{x:0,y:35.999992370605469},size:{width:1280,height:208.80000305175781}}
 
 
 */

%new -(void)reloadShelf
{
	NSLog(@"reloadShelf");

	BOOL is60 = [self isSixPointOhPlus];
	if (is60)
	{
		NSLog(@"is 6.0+, return!");
			//return;
		
	}
		
	id _shelfControl = nil;
	BRDataStoreProvider *_provider = nil;
	id _adap = nil;
    if ([self _shelfControl]!=nil) {
	
		[self setShelfControl:_shelfControl];
	}

    CGRect masterFrame=[objc_getClass("BRWindow") interfaceFrame];
    
    if(![SMF_COMPAT usingFourPointFourPlus] && ![SMF_COMPAT usingFourPointFourGM])
    {
        _shelfControl = [[NSClassFromString(@"BRMediaShelfControl") alloc] init];
        [_shelfControl setProvider:[self getProviderForShelf]];
        [_shelfControl setColumnCount:8];
        [_shelfControl setCentered:NO];
        [_shelfControl setHorizontalGap:23];
		
		
		CGRect gframe=CGRectMake(masterFrame.size.width*0.00, 
								 masterFrame.origin.y+masterFrame.size.height*0.04f, 
								 masterFrame.size.width*1.f,
								 masterFrame.size.height*0.24f);
		[_shelfControl setFrame:gframe];
			// [self addControl:_shelfControl];
		if (!is60)[self addControl:_shelfControl];
		else [self addSubview:_shelfControl];
		
		
		[self setAdap:_adap];
		[self setShelfControl:_shelfControl];
		[self setProvider:_provider];
		return;
		
    }
    else
    {
        _shelfControl=[[objc_getClass("BRMediaShelfView") alloc]init];
        [_shelfControl setCentered:YES];
        if ([self provider]!=nil) {
				
			
			
			[self setProvider:_provider];
		}
		
		
		CGRect gframe=CGRectMake(masterFrame.size.width*0.00, 
								 masterFrame.origin.y+masterFrame.size.height*0.04f, 
								 masterFrame.size.width*1.f,
								 masterFrame.size.height*0.24f);
		[_shelfControl setFrame:gframe];
			// [self addControl:_shelfControl];
		if (!is60)[self addControl:_shelfControl];
		else [self addSubview:_shelfControl];
		
		
        _provider=[[self getProviderForShelf] retain];
        _adap = [[NSClassFromString(@"BRProviderDataSourceAdapter") alloc] init];
        [_adap setProviders:[NSArray arrayWithObject:_provider]];
			//NSLog(@"Provider: %@ %@",_provider,_provider.controlFactory);
        [_provider.controlFactory setDefaultImage:[[BTI sharedTheme]appleTVImage]];
        [_adap setGridColumnCount:8];
        if ([_shelfControl respondsToSelector:@selector(setColumnCount:)]) {
            [_shelfControl setColumnCount:8];
        }
        
        [_shelfControl setCentered:NO];
        [_shelfControl setDataSource:_adap];
        [_shelfControl setDelegate:_adap];
       
		[_shelfControl reloadData];
        
        [_shelfControl setColumnCount:8];
        [_shelfControl setHorizontalGap:33];
        [_shelfControl setReadyToDisplay];
        [_shelfControl layoutSubcontrols];
        [_shelfControl loadWithCompletionBlock:nil];
        
		
        
        
        
        
        
    }
  
	
    [self setAdap:_adap];
	[self setShelfControl:_shelfControl];
	[self setProvider:_provider];
    
}
//
//- (void)layoutSubcontrols
//{
//	%orig;
//	[self reload];
//	[self reloadShelf];
//}

-(void)wasPushed
{
	%orig;
		    [self reload];
		[self reloadShelf];
	
}
-(void)controlWasActivated
{

    //[_shelfControl _loadControlWithStartIndex:0 start:YES];
    %orig;
//    if([_shelfControl respondsToSelector:@selector(_loadControlWithStartIndex:start:)])
//        [_shelfControl _loadControlWithStartIndex:0 start:YES];
}
%new -(void)toggleLongSummary
{
    CGRect f = [[self summaryControl] frame];
    CGSize masterSize = [objc_getClass("BRWindow") maxBounds];
    float sh=94.f/720.f*masterSize.height;
    float lh=275.f/720.f*masterSize.height;
    if (_summaryToggled==YES) {
        f.origin.y=f.origin.y+(lh-sh);
        f.size.height=sh;
        _summaryToggled=NO;
        for (id c in [self hideList])
            [c setHidden:NO];

    }
    else {
        f.origin.y=f.origin.y-(lh-sh);
        f.size.height=lh;
        _summaryToggled=YES;
        for (id c in [self hideList])
            [c setHidden:YES];
    }
    [[self summaryControl] setFrame:f];
    
    
    [[self summaryControl] layoutSubcontrols];
}
%new -(void)switchPreviousArrowOn 
{
	ntvImageControl *_previousArrowImageControl = [self previousArrowImageControl];
	_previousArrowTurnedOn = YES; //used to retain arrow state if view is reloaded
	if (_previousArrowImageControl) {
		id arrowImageON = [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:[BTI class]]pathForResource:@"Arrow_ON" ofType:@"png"]];
		[_previousArrowImageControl setImage:arrowImageON];
		[_previousArrowImageControl setNeedsLayout];
	}
}
%new -(void)switchPreviousArrowOff 
{
	id _previousArrowImageControl = [self previousArrowImageControl];
	_previousArrowTurnedOn = NO; //used to retain arrow state if view is reloaded
	if (_previousArrowImageControl) {
		id arrowImageOFF = [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:[BTI class]]pathForResource:@"Arrow_OFF" ofType:@"png"]];
		[_previousArrowImageControl setImage:arrowImageOFF];
		[_previousArrowImageControl setNeedsLayout];
	}
}
%new -(void)switchNextArrowOn 
{
	id _nextArrowImageControl = [self nextArrowImageControl];
	_nextArrowTurnedOn = YES; //used to retain arrow state if view is reloaded
	if (_nextArrowImageControl) {
		id arrowImageON = [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:[BTI class]]pathForResource:@"Arrow_ON" ofType:@"png"]];
		[_nextArrowImageControl setImage:arrowImageON];
		[_nextArrowImageControl setNeedsLayout];
	}
}
%new -(void)switchNextArrowOff 
{
	id _nextArrowImageControl = [self nextArrowImageControl];
	_nextArrowTurnedOn = NO; //used to retain arrow state if view is reloaded
	if (_nextArrowImageControl) {
		id arrowImageOFF = [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:[BTI class]]pathForResource:@"Arrow_OFF" ofType:@"png"]];
		[_nextArrowImageControl setImage:arrowImageOFF];
		[_nextArrowImageControl setNeedsLayout];
	}
}
-(BOOL)brEventAction:(id)action
{
//    NSLog(@"shelf D D: %@ %@",_shelfControl.delegate,_shelfControl.dataSource);
//    _shelfControl.dataSource=self;
    id c = [self focusedControl];
    long shelfIndex=1;
    if ([[self stack] peekController]!=self)
        return %orig;
    int remoteAction = [action remoteAction];

	
    if (remoteAction==kBREventRemoteActionUp&&(int)[action value]==1) {
        if ([[self focusedControl] isKindOfClass:[objc_getClass("BRButtonControl") class]]) {
            [self toggleLongSummary];
            return YES;
        }
    }
	if([[self focusedControl] isKindOfClass:objc_getClass("NSMFListDropShadowControl")])
	{
		return %orig;
	}
	
		// if ([self delegate] && [[self delegate] conformsToProtocol:@protocol(NSMFMoviePreviewControllerDelegate)]) {
     if ([self delegate]) {
	}
	
	
    if (remoteAction==kBREventRemoteActionPlay && 
        [self delegate]!=nil && 
        (int)[action value]==1 && 
        [[self delegate] respondsToSelector:@selector(controller:buttonSelectedAtIndex:)]) {
			//NSLog(@"play and all that shit is true");
        id selectedC = [self focusedControl];
		
		if ([selectedC respondsToSelector:@selector(subtitle)])
		{
			NSLog(@"selectedC subtitle: %@", [selectedC subtitle]);
			for (int j=0;j<[[self buttons] count];j++) {
				
				id subtitle = [[[self buttons] objectAtIndex:j] subtitle];
				id subtitle2 = [selectedC subtitle];
				if ([subtitle respondsToSelector:@selector(string)] && [subtitle2 respondsToSelector:@selector(string)])
				{
					if ([[[[[self buttons] objectAtIndex:j] subtitle]string] isEqualToString:[[selectedC subtitle]string]])
					{
						NSLog(@"checking subtitles, not so elegant, but it should work for now");
						[[self delegate] controller:self buttonSelectedAtIndex:j];
						return YES;
					}
				}
				
					// if([[self buttons] objectAtIndex:j]==selectedC)
					//                [[self delegate] controller:self buttonSelectedAtIndex:j];
			}
			
		}
		
			//NSLog(@"buttons: %@", [self buttons]);
    }
    if (remoteAction==kBREventRemoteActionPlay && 
        [self delegate]!=nil && 
       (int)[action value]==1)
    {
        [[self delegate] controller:self selectedControl:[self focusedControl]];
        return YES;
    }
    else if((int)[action value]==1 && [self delegate]!=nil)
    {
        if ((remoteAction==kBREventRemoteActionRight || 
			 remoteAction==kBREventRemoteActionSwipeRight) &&
            [[self delegate] respondsToSelector:@selector(controllerCanSwitchToNext:)] &&
            [self focusedControl]==[[self buttons] lastObject]) {
			if ([[self delegate] controllerCanSwitchToNext:self]) {
				if ([[self delegate] respondsToSelector:@selector(controllerSwitchToNext:)]) {
					[[self delegate] controllerSwitchToNext:self];
					return YES;
				}
			}
        }
        else if((remoteAction==kBREventRemoteActionLeft || 
                 remoteAction==kBREventRemoteActionSwipeLeft) &&
                [[self delegate] respondsToSelector:@selector(controllerCanSwitchToPrevious:)] &&
                [self focusedControl]==[[self buttons] objectAtIndex:0]) {
			if ([[self delegate] controllerCanSwitchToPrevious:self]) {
				if ([[self delegate] respondsToSelector:@selector(controllerSwitchToPrevious:)]) {
					[[self delegate] controllerSwitchToPrevious:self];
					return YES;
				}
			}
        }
    }
    BOOL b=%orig;
	id _delegate = [self delegate];
    id d = [self focusedControl];
    if ((int)[action value]==1 && c!=d) {
        if (_delegate!=nil && [_delegate respondsToSelector:@selector(controller:shelfLastIndex:)]) {
            [_delegate controller:self shelfLastIndex:shelfIndex];
        }
        if (_delegate!=nil && [_delegate respondsToSelector:@selector(controller:switchedFocusTo:)]) {
            [_delegate controller:self switchedFocusTo:d];
        }
		
    }
    return b;
	
}

/*
-(void)dealloc
{
	
    [_previewControl release];
    [_metadataTitleControl release];
    [self datasource]=nil;
    [self delegate]=nil;

    [_shelfControl release];

    [_buttons release];
    //checkNil(_adap);
    //checkNil(_previousArrowImageControl);
	//checkNil(_nextArrowImageControl);
    //checkNil(_info);
    //checkNil(_summaryControl);
    //checkNil(_hideList);
    //checkNil(_provider);
    [super dealloc];
}

@end

*/

%end