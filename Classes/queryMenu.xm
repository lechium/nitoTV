//
//  queryMenu.m
//  SMFramework
//
//  Created by Thomas Cool on 11/5/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//	Updated by Kevin Bradley 11-13-10 added the ability to turn on and off a previewControl ala Youtube search.

	//#import "queryMenu.h"
	//#import "ntvMedia.h"
	//#import "ntvMediaPreview.h"
	//#import "kbScrollingTextControl.h"
	//#import "nitoInstallManager.h"
#import "packageManagement.h"
	
	//#import "NSTask.h"

enum  {
	
	kNTVQueryStopped = 400,
	kNTVQueryStarted,
	kNTVQueryFinished,
	kNTVQueryFailed,
};


static BOOL editorShowing = TRUE;
static BOOL isEdged = FALSE;
static int searchState = 0;

static char const * const kNitoQueryEntryControlKey = "nQueryEntryControl";
static char const * const kNitoArrowImageKey = "nArrowImage";
static char const * const kNitoQueryNamesKey = "nQueryNames";
static char const * const kNitoDescriptionsKey = "nQueryDescriptions";
static char const * const kNitoQueryInfosKey = "nQueryInfos";
static char const * const kNitoLateryQueryKey = "nQueryLatestQuery";
static char const * const kNitoQueryDelegateKey = "nQueryDelegate";
static char const * const kNitoQuerySelectedObjectKey = "nQuerySelectedObject";



/*
@interface ntvTextEntryControl : BRTextEntryControl


- (id)firstScrollControl;
- (id)firstPanelControl;
- (void)removeStupidPlayPause;
- (void)layoutSubcontrols;
- (void)fixLayout;

@end
*/


%subclass ntvTextEntryControl : BRTextEntryControl


- (void)controlWasFocused
{
	%orig;
	if ([[self parent] is50])
	{

		[self setCanWrapHorizontally:FALSE];
			//self.canWrapHorizontally = FALSE;
	}
}


%new - (id)firstScrollControl
{
	NSArray *controlArray = nil;
	
	if ([self respondsToSelector:@selector(controls)])
	{
		controlArray = [self controls];
	} else {
		controlArray = [self subviews];
	}
	
	NSEnumerator *controlEnum = [controlArray objectEnumerator];
	id current = nil;
	while ((current = [controlEnum nextObject]))
	{
		NSString *currentClass = NSStringFromClass([current class]);
		if ([currentClass isEqualToString:@"BRScrollControl"])
		{
			return current;
		}
	}
	return nil;
}

%new - (id)firstPanelControl
{
	NSArray *controlArray = nil;
	
	if ([self respondsToSelector:@selector(controls)])
	{
		controlArray = [self controls];
	} else {
		controlArray = [self subviews];
	}
	
	NSEnumerator *controlEnum = [controlArray objectEnumerator];
	id current = nil;
	while ((current = [controlEnum nextObject]))
	{
		NSString *currentClass = NSStringFromClass([current class]);
		if ([currentClass isEqualToString:@"BRPanelControl"])
		{
			return current;
		}
	}
	return nil;
}

%new - (void)removeStupidPlayPause
{
	NSArray *controlArray = nil;
	
	if ([self respondsToSelector:@selector(controls)])
	{
		controlArray = [self controls];
	} else {
		controlArray = [self subviews];
	}
	
	NSEnumerator *controlEnum = [controlArray objectEnumerator];
	id current = nil;
	while ((current = [controlEnum nextObject]))
	{
		NSString *currentClass = NSStringFromClass([current class]);
		if ([currentClass isEqualToString:@"BRTextEntryPlayPauseMessage"])
		{
			if ([current respondsToSelector:@selector(removeFromParent)])
			{
				[current removeFromParent];
			} else {
				[current removeFromSuperview];
			}
		}
	}
}

- (void)layoutSubcontrols
{
	if ([[self parent] is50])
	{
			//fix layout first, not sure if this is necessary, to change, seems to work better fixed first here.
		[self removeStupidPlayPause];
		%orig;
	} else {
		
	
		%orig;
		[self fixLayout];
	}
	
	
	
	
}

%new - (void)fixLayout
{

	if ([[%c(queryMenu) properVersion] isEqualToString:@"4.3"]) { //change back to 4.3!!
		
		[self removeStupidPlayPause];
		
		id scrollControl = [self firstScrollControl];
		CGRect scrollFrame = [scrollControl frame];
		
		scrollFrame.origin.x = 18;
		scrollFrame.origin.y = 83;
		
		[scrollControl setFrame:scrollFrame];
		
		id panelControl = [self firstPanelControl];
		
		CGRect panelFrame = [panelControl frame];
		
		panelFrame.origin.x = -2;
		[panelControl setFrame:panelFrame];
	}
}



- (void)controlWasActivated
{
	%orig;
	
	
}

	//@end

%end

%subclass queryMenu : BRMediaMenuController


	//@implementation queryMenu

	//@synthesize _latestQuery, searchState, selectedObject, isEdged;


%new -(NSArray *)names
{
	return [self associatedValueForKey:(void*)kNitoQueryNamesKey];
}

%new -(void)setNames:(NSArray *)theNames
{
	[self associateValue:theNames withKey:(void*)kNitoQueryNamesKey];
}

%new -(NSArray *)descriptions
{
	return [self associatedValueForKey:(void*)kNitoDescriptionsKey];
}

%new -(void)setDescriptions:(NSArray *)theDescs
{
	[self associateValue:theDescs withKey:(void*)kNitoDescriptionsKey];
}

%new - (void)setEdged:(BOOL)edge
{
	isEdged = edge;
		//[self setIsEdged:edge];
}


%new - (id)entryControl
{
	return [self associatedValueForKey:(void*)kNitoQueryEntryControlKey];
}

%new - (void)setEntryControl:(id)theEntryControl
{
	[self associateValue:theEntryControl withKey:(void*)kNitoQueryEntryControlKey];
}

%new -(id)arrowImage
{
	return [self associatedValueForKey:(void*)kNitoArrowImageKey];
}

%new - (void)setArrowImage:(id)theArrowImage
{
	[self associateValue:theArrowImage withKey:(void*)kNitoArrowImageKey];
}


%new - (NSArray *)infos
{
	return [self associatedValueForKey:(void*)kNitoQueryInfosKey];
}

%new - (void)setInfos:(NSArray *)theInfos
{
	[self associateValue:theInfos withKey:(void*)kNitoQueryInfosKey];
}


%new - (NSString *)latestQuery
{
	return [self associatedValueForKey:(void*)kNitoLateryQueryKey];
}

%new - (void)setLatestQuery:(NSString *)theLatestQuery
{
	[self associateValue:theLatestQuery withKey:(void*)kNitoLateryQueryKey];
}

%new - (id)delegate
{
	return [self associatedValueForKey:(void*)kNitoQueryDelegateKey];
}

%new - (void)setDelegate:(id)theDelegate
{
	[self associateValue:theDelegate withKey:(void*)kNitoQueryDelegateKey];
}

%new -(id)selectedObject
{
	return [self associatedValueForKey:(void*)kNitoQuerySelectedObjectKey];
}

%new - (void)setSelectedObject:(id)theSelectedObject
{
	[self associateValue:theSelectedObject withKey:(void*)kNitoQuerySelectedObjectKey];
}

	//end ivar - > associated objects

-(id)init
{
    self=%orig;
	[self setLabel:@"com.nito.query"];
	editorShowing = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateList:) name:@"QueryFinished" object:nil];
	
    id _names = [[NSMutableArray alloc] init];
	id _descriptions = [[NSMutableArray alloc] init];
   
	id _infos = [[NSMutableArray alloc] init];
    
	[self setNames:_names];
	[self setDescriptions:_descriptions];
	[self setInfos:_infos];
	
	CGRect f = [objc_getClass("ntvWindow") interfaceFrame];
    f.size.width=f.size.width/3.f;
   
	searchState = kNTVQueryStopped;
    [[self list] setDatasource:self];
    [[self list] setDisplaysSelectionWidget:YES];
	[self showEditorSelectingGylph:nil];
	
	[self setListTitle:BRLocalizedString(@"Search for Packages", @"Search for Packages")]; 
	[self setListIcon:[[NitoTheme sharedTheme] searchImage]];
	
    return self;
}

%new -(void)changeFocus
{
	[self _changeFocusTo:[self list]];
}


%new -(BOOL)is60Plus
{
	if ([self respondsToSelector:@selector(controls)])
		return (FALSE);
	
	return (TRUE);
}

%new -(void)_hideEditor
{
	//NSLog(@"%@ %s", self, _cmd);
	editorShowing = NO;
	
	if ([self is60Plus])
	{
		
		[[self entryControl] removeFromSuperview];
		[[self arrowImage] removeFromSuperview];
		
	} else {

		[[self entryControl] removeFromParent];
		[[self arrowImage] removeFromParent];
		
	}
	
	
	[[self list] setDatasource:self];
    [[self list] setDisplaysSelectionWidget:YES];
	
	
}
	
%new -(BOOL)is43
{
	if([[%c(queryMenu) properVersion] isEqualToString:@"4.3"])
	{
		return YES;
	}
	return NO;
}


%new -(BOOL)is50
{
	return (BOOL)(long)(void*)[packageManagement ntvFivePointZeroPlus];
}


%new -(void)showEditorSelectingGylph:(id)selectedGlyph
{
	//NSLog(@"%@ %s", self, _cmd);
	editorShowing = YES;
	id _arrowImage=[[objc_getClass("BRImageControl") alloc] init];
	CGRect arrowFrame = CGRectMake(540, 274, 46, 46);
	if ([self is50] || [self is43])
	{
		
		arrowFrame = CGRectMake(544, 87, 1, 492);
		[_arrowImage setImage:[[objc_getClass("BRThemeInfo") sharedTheme] verticalDividerImage]];
		
	} else {
		
		[_arrowImage setImage:[[objc_getClass("BRThemeInfo") sharedTheme] highlightedMenuArrowImage]];
	}
	
		//CGRect arrowFrame = CGRectMake(540, 274, 46, 46);
	[_arrowImage setFrame:arrowFrame];
	
	
	
	if ([self is60Plus])
		[self addSubview:_arrowImage];
	else
		[self addControl:_arrowImage];
	
	
	
	[self setArrowImage:_arrowImage];
	
	int entryStyle = 2; // 2 for all other appletv versions, 5 for 4.4.

	if([self is50])
	{
		entryStyle = 5; //{origin:{x:109,y:48},size:{width:400,height:534}}

	}
	
	
	id _entryControl=[[objc_getClass("ntvTextEntryControl") alloc] initWithTextEntryStyle:entryStyle]; //change to 4 for 4.4- but still need change some other shit too- not switching from keyboard over.
	NSString *query = [self latestQuery];
	if([query length] > 0)
	{
		[_entryControl setInitialText:query];
	}
	
    [_entryControl setTextFieldDelegate:self];
	
    CGRect f = [objc_getClass("BRWindow") interfaceFrame];
	
	f.size.width = 400;
	
	f.origin=CGPointMake(110, 86.0f);
	
	if ([self is50])
	{
		f.origin = CGPointMake(110, 70.0f);
	}
    if ([_entryControl tabControl] != nil)
	{
		if ([self is60Plus])
			[[_entryControl tabControl] removeFromSuperview];
		else 
		    [[_entryControl tabControl] removeFromParent];
	}

	[_entryControl setFrame:f];
		//	NSLog(@"entryControlFrame: %@", NSStringFromCGRect(f));
	
	[self clearPreviewController];
	
	
	if ([self is60Plus])
		[self addSubview:_entryControl];
	else
		[self addControl:_entryControl];
	
	[self setEntryControl:_entryControl];
	
	[self setFocusedControl:_entryControl];
	[[self list] setDatasource:self];
    [[self list] setDisplaysSelectionWidget:NO];//kBRClearGlyphName
	if (selectedGlyph != nil)
	{
		
		[_entryControl setFocusToGlyphNamed:selectedGlyph];
	}
		
}

%new - (NSArray *)doIt
{
	NSString *packageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop/apt-Parse.txt"];
	NSString *packageString = [NSString stringWithContentsOfFile:packageFile encoding:NSUTF8StringEncoding error:nil];
	NSArray *lineArray = [packageString componentsSeparatedByString:@"\n\n"];
	//NSLog(@"lineArray: %@", lineArray);
	
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
	for (id currentItem in lineArray)
	{ 
		NSArray *packageArray = [currentItem componentsSeparatedByString:@"\n"];
		//NSLog(@"packageArray: %@", packageArray);
		NSMutableDictionary *currentPackage = [[NSMutableDictionary alloc] init];
		for (id currentLine in packageArray)
		{
			NSArray *itemArray = [currentLine componentsSeparatedByString:@": "];
			if ([itemArray count] >= 2)
			{
				
				[currentPackage setObject:[itemArray objectAtIndex:1] forKey:[itemArray objectAtIndex:0]];
			}
		}
		[mutableArray addObject:currentPackage];
		[currentPackage release];
		currentPackage = nil;
		
	}
	return [mutableArray autorelease];
}



%new - (void)searchForPackage:(NSString *)customFile
{
	//NSLog(@"%@ %s", self, _cmd);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSTask *searchTask = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
    NSFileHandle *handle = [pipe fileHandleForReading];
    NSData *outData = nil;
    
    [searchTask setLaunchPath:@"/usr/bin/apt-cache"];
	
    [searchTask setStandardOutput:pipe];
    [searchTask setStandardError:pipe];
	
    [searchTask setArguments:[NSArray arrayWithObjects:@"search", customFile, nil]];
    //Variables needed for reading output
	NSString *temp = nil;
    NSMutableArray *packageList = [[NSMutableArray alloc] init];
	
    [searchTask launch];
    while((outData = [handle readDataToEndOfFile]) && [outData length])
    {
        temp = [[NSString alloc] initWithData:outData encoding:NSASCIIStringEncoding];
        [packageList addObjectsFromArray:[temp componentsSeparatedByString:@"\n"]];
        [temp release];
    }
	[handle closeFile];
	NSMutableArray *mutableList = [[NSMutableArray alloc] init];
	for (id currentItem in packageList)
	{
		NSArray *itemArray = [currentItem componentsSeparatedByString:@" - "];
		if ([itemArray count] >= 2)
		{
			NSString *packageName = [itemArray objectAtIndex:0];
			NSString *packageDescription = [itemArray objectAtIndex:1];
			//NSDictionary *packageInfo = [self packageInfo:packageName];
			//NSLog(@"packageInfo: %@", packageInfo);
			//NSDictionary *dictObject = [NSDictionary dictionaryWithObjectsAndKeys:packageName, @"name", packageDescription, @"description", @"packageInfo", packageInfo, nil];
			NSDictionary *dictObject = [NSDictionary dictionaryWithObjectsAndKeys:packageName, @"Package", packageDescription, @"Description", nil];
			[mutableList addObject:dictObject];
			
		}
		
		
	}
	[searchTask release];
	searchTask = nil;
	[pipe release];
	pipe = nil;
	[packageList release];
	id _entryControl = [self entryControl];
	if (_entryControl != nil)
		[_entryControl stopSpinning];
	[self setLatestQuery:customFile];
	
	searchState = kNTVQueryFinished;
	
	if (mutableList != nil)
	{
		NSArray *theArray = [NSArray arrayWithArray:mutableList];
		[mutableList release];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"QueryFinished" object:theArray userInfo:nil];
	} else {
		searchState = kNTVQueryFailed;
	}
	[pool release];
}

%new - (NSDictionary *)packageInfo:(NSString *)packageID
{
	//NSLog(@"%@ %s", self, _cmd);
	//apt-cache show
	NSTask *packageTask = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
    NSFileHandle *handle = [pipe fileHandleForReading];
    NSData *outData;
    
    [packageTask setLaunchPath:@"/usr/bin/apt-cache"];
	
    [packageTask setStandardOutput:pipe];
    [packageTask setStandardError:pipe];
	
    [packageTask setArguments:[NSArray arrayWithObjects:@"show", packageID, nil]];
    //Variables needed for reading output
	NSString *temp = @"";
    NSMutableArray *packageInfo = [[NSMutableArray alloc] init];
	
    [packageTask launch];
    while((outData = [handle readDataToEndOfFile]) && [outData length])
    {
        temp = [[NSString alloc] initWithData:outData encoding:NSASCIIStringEncoding];
        [packageInfo addObjectsFromArray:[temp componentsSeparatedByString:@"\n"]];
        [temp release];
    }
	NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
	for (id currentItem in packageInfo)
	{
		NSArray *itemArray = [currentItem componentsSeparatedByString:@": "];
		if ([itemArray count] >= 2)
		{
			
			[mutableDict setObject:[itemArray objectAtIndex:1] forKey:[itemArray objectAtIndex:0]];
		}
		
	}
	
	[packageTask release];
	packageTask = nil;
	[pipe release];
	pipe = nil;
	[packageInfo release];
	return [mutableDict autorelease];
	
}


%new - (void)updateList:(NSNotification *)n
{   
		//NSLog(@"%@ %s", self, _cmd);
	/*
	 
	 make sure there aren't any differences between [self latestQuery] and whatever the textField currently holds
	 
	 */
	
	id _entryControl = [self entryControl];
	
	if (_entryControl == nil)
	{
		
		id theList = [n object];
		//NSLog(@"updateList: %@", theList);
		[[self names] removeAllObjects];
		[[self descriptions] removeAllObjects];
		
		
		for (NSDictionary *item in theList)
		{
			
			NSString *package = [item objectForKey:@"Package"];
			NSString *desc = [item objectForKey:@"Description"];
			if (package != nil)
			[[self names] addObject:[item objectForKey:@"Package"]];
			//NSDictionary *packageInfo = [self packageInfo:[item objectForKey:@"name"]];
			if (desc != nil)
			[[self descriptions] addObject:desc];
			//	[_infos addObject:packageInfo];
		
		}
		//_filteredArray = [[self names] copy];
		[[self list] reload];
		return;
	}
	NSString *currentText = [[_entryControl textField]stringValue];
	NSString *latestQuery = [self latestQuery];
	if ([currentText isEqualToString:latestQuery])
	{
		
		id theList = [n object];
		//NSLog(@"updateList: %@", theList);
		[[self names] removeAllObjects];
		[[self descriptions] removeAllObjects];
		//[_infos removeAllObjects];
		
		for (NSDictionary *item in theList)
		{
			
			NSString *package = [item objectForKey:@"Package"];
			NSString *desc = [item objectForKey:@"Description"];
			if (package != nil)
			[[self names] addObject:package];
			//NSDictionary *packageInfo = [self packageInfo:[item objectForKey:@"name"]];
			if (desc != nil)
			[[self descriptions] addObject:desc];
		//	[_infos addObject:packageInfo];
			
		}
		//_filteredArray = [[self names] copy];
		[[self list] reload];
		
	} else {
		
		[self textDidChange:[_entryControl textField]];
	}
	
}




%new - (void) textDidChange: (id) sender
{
	id _entryControl = [self entryControl];
	if ([[sender stringValue] isEqualToString:[self latestQuery]])
		return;
	//NSLog(@"%@ %s", self, _cmd);
	switch (searchState) {
			
		case kNTVQueryStarted:
			return;
		
		case kNTVQueryStopped:
		case kNTVQueryFinished:
			break;
	}
	
	[_entryControl startSpinning];
	searchState = kNTVQueryStarted;
	//[[self names] removeAllObjects];
	//[[self descriptions] removeAllObjects];
	[NSThread detachNewThreadSelector:@selector(searchForPackage:) toTarget:self withObject:[sender stringValue]];
   
		//CGRectMake(544, 87, 1, 492); //frame of [imageControl setImage:[[objc_getClass("BRThemeInfo") sharedTheme] verticalDividerImage]]
	
}

- (void) textDidEndEditing: (id) sender
{
	id _entryControl = [self entryControl];
    if ([[sender stringValue] isEqualToString:[self latestQuery]])
		return;
	//NSLog(@"%@ %s", self, _cmd);
	switch (searchState) {
			
		case kNTVQueryStarted:
			return;
			
		case kNTVQueryStopped:
		case kNTVQueryFinished:
			break;
	}
	
	[_entryControl startSpinning];
	searchState = kNTVQueryStarted;
	//[[self names] removeAllObjects];
	//[[self descriptions] removeAllObjects];
	[NSThread detachNewThreadSelector:@selector(searchForPackage:) toTarget:self withObject:[sender stringValue]];
}

-(void)wasPushed
{
    %orig;
    
}

- (id)focusedControlForEvent:(id)event focusPoint:(CGPoint *)point {
		//NSLog(@"%@ %s", self, _cmd);

	switch ((int)[event remoteAction]) {
			
		case kBREventRemoteActionRight:
		case kBREventRemoteActionSwipeRight:
			if (editorShowing == YES)
			{
				if (searchState != kNTVQueryStarted)
					[self _hideEditor];
				else {
					return nil;
				}

					
			}
			break;
	}
	return %orig;
}

%new - (float)heightForRow:(long)row				{ return 0.0f;}
%new - (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[[self names] count];}



%new - (id)titleForRow:(long)row					
{ 
    
    return [[self names] objectAtIndex:row];
}



%new -(void)controller:(id)c selectedControl:(id)ctrl
{

		//NSLog(@"here: %@", ctrl);
	
	
	if ([ctrl respondsToSelector:@selector(selectedControl)])
	{
		id data = [[c provider] data];
		
		id selectedControl = [ctrl selectedControl];
			//int focusedIndex = [ctrl focusedIndex]; //FIXME: not going to work!!
		int focusedIndex = [[ctrl focusedIndexPath] indexAtPosition:1];
		id myAsset = [data objectAtIndex:focusedIndex];
		NSString *packageName = [[selectedControl title] string];
		id theImage = [myAsset coverArt];
		[self setSelectedObject:packageName];
			//selectedObject = packageName;
		[c updatePackageData:packageName usingImage:theImage];
	}
	
	
}


-(void)itemSelected:(long)selected
{
	
	NSString *item = [[self names] objectAtIndex:selected];
	[self setSelectedObject:item];
		//selectedObject = item;
		
	id controller = [[objc_getClass("PackageDataSource") alloc] initWithPackage:item usingImage:nil];
	[controller setDatasource:controller];
	[controller setDelegate:(NSObject *)self];
	[controller setCurrentPackageMode:1];
	[[self stack] pushController:controller];
		//[self customInstallAction:item];
}

	//i think these are all deprecated

%new - (void)customInstallAction:(NSString *)packageName
{
	id spinControl = [[objc_getClass("BRTextWithSpinnerController") alloc] initWithTitle:nil text:[NSString stringWithFormat:@"installing %@",packageName]];
	//NSLog(@"text string: %@", [text stringValue]);
	[[self stack] pushController:spinControl];
	[spinControl release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:packageName forKey:@"text"];
	[NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(updateCustomFinal:) userInfo: userInfo repeats: NO];
	
}

%new - (void)updateCustomFinal:(id)timer
{
	//NSLog(@"userInfo: %@", [timer userInfo]);
	[self updateCustom:[[timer userInfo] objectForKey:@"text"]];
	
}

%new - (void)updateCustom:(NSString *)customFile
{
	NSString *command = [NSString stringWithFormat:@"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/install_ntv.sh %@", customFile];
	int sysReturn = system([command UTF8String]);
	//NSLog(@"update custom returned with status %i", sysReturn);
	[packageManagement updatePackageList];
	id alert = [self installFinishedWithStatus:sysReturn andFeedback:nil];
	[[self stack] swapController:alert];
	
}

%new -(id)installFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback
{
	NSString * path = @"/tmp/aptoutput";
	
	id textControls = [[objc_getClass("kbScrollingTextControl") alloc] init];
	
	[textControls setDocumentPath:path encoding:NSUTF8StringEncoding];
	
	NSString *myTitle = nil;
	if (termStatus == 0)
	{
		myTitle = BRLocalizedString(@"Installation Successful / Up to Date",@"Installation Successful / Up to Date");
		
	} else {
		
		myTitle = BRLocalizedString(@"Installation Failed!",@"Installation Failed!" );
	}
	
	[textControls setTitle:myTitle];
	[textControls autorelease];
	return [objc_getClass("BRController") controllerWithContentControl:textControls];
	
}

	//end potential deprecated targets here

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

%new + (NSString *)properVersion
{
	Class cls = NSClassFromString(@"ATVVersionInfo");
	if (cls != nil)
	{ return [cls currentOSVersion]; }
	
	return nil;	
}


-(BOOL)brEventAction:(id)action
{
	//NSLog(@"%@ %s", self, _cmd);
	int value = (int)[action value];
	if (editorShowing == YES)
	{
			return %orig;
		
	}
	int itemCount = (int)[[[self list] datasource] itemCount];
	int theValue = (int)[action value];	
	switch ((int)[action remoteAction]) {
			
		case kBREventRemoteActionMenu:
		{
			[self showEditorSelectingGylph:@"Clear"];
			return YES;
		}
		case kBREventRemoteActionSwipeLeft:
		case kBREventRemoteActionLeft:
			if (value == 1)
			{
				[self showEditorSelectingGylph:nil];
				return YES;
			}
			
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
			%orig;
			
			
			break;
			
		default:
			return %orig;
			break;
	}
	
	return YES;
}

/*
 Package: com.nito.nitotv
 Status: install ok installed
 Section: Utilities
 Installed-Size: 1156
 Maintainer: nito
 Architecture: iphoneos-arm
 Version: 0.5-157
 Depends: beigelist, wget
 Description: Release five, weather, RSS, basic deb installer, featured packages.
 Name: nitoTV
 Website: nitosoft.com
 Author: nito
 
 
 */


 
-(id)previewControlForItem:(long)item
{
	//NSLog(@"description: %@", [[self descriptions] objectAtIndex:item]);
	if (editorShowing == NO)
	{
	id currentAsset = [[objc_getClass("ntvMedia") alloc] init];
	
	[currentAsset setTitle:[[self names] objectAtIndex:item]];
	[currentAsset setSummary:[[self descriptions] objectAtIndex:item]];
	[currentAsset setCoverArt:[[NitoTheme sharedTheme] packageImage]];
	
	id preview = [[objc_getClass("ntvMediaPreview") alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	
	return [preview autorelease];
	} else {
		return nil;
	}
}
 
%new -(id)itemForRow:(long)row
{
	if (row > [[self names] count])
	{
		return nil;
	}

	
	id result = [objc_getClass("nitoMenuItem") ntvDownloadMenuItem];
	[result setText:[[self names] objectAtIndex:row] withAttributes:[[objc_getClass("BRThemeInfo") sharedTheme] menuItemTextAttributes]];
	return	result;
}

/*

-(id)newitemForRow:(long)row
{
	//BRMenuItem *result = [BRMenuItem ntvDownloadMenuItem];
	//[result setTitle:[[self names] objectAtIndex:row]];
	BRComboMenuItemLayer *result = [[BRComboMenuItemLayer alloc] init];
	NSDictionary *currentDict = [_infos objectAtIndex:row];
	
	[result setTitle:[currentDict objectForKey:@"Name"]];
	[result setSubtitle:[currentDict objectForKey:@"Package"]];
	[result setThumbnailImage:[[NitoTheme sharedTheme] packageImage]];
	//[result setText:[[self names] objectAtIndex:row] withAttributes:[[objc_getClass("BRThemeInfo") sharedTheme] menuItemTextAttributes]];
	return	[result autorelease];
}

- (BOOL)packageInstalled:(NSString *)currentPackage
{
	NSDictionary *packageList = [self parsedPackageList];
	if ([packageList objectForKey:currentPackage] != nil)
	{
		id currentDict = [packageList objectForKey:currentPackage];
		if ([[currentDict allKeys] containsObject:@"Version"])
			return YES;
		else
			return NO;
		
	}
	
	return NO;
}
*/


%new - (NSDictionary *)parsedPackageList
{
		//NSString *endFile = @"/Installed.plist";
	NSString *endFile = [packageManagement installedLocation];
	NSDictionary *parsedDict = [NSDictionary dictionaryWithContentsOfFile:endFile];
	return parsedDict;
}

%new - (NSArray *)untoucables
{
	return [NSArray arrayWithObjects:@"openssh", @"openssl", @"cydia", @"apt7", @"apt7-key", @"apt7-lib", @"apt7-ssl", @"berkeleydb", @"com.nito.nitotv", @"beigelist", @"mobilesubstrate", @"com.nito", @"org.awkwardtv",@"bash", @"bzip2", @"coreutils-bin", @"diffutils", @"findutils", @"gzip", @"lzma", @"ncurses", @"tar", @"firmware-sbin", @"dpkg", @"gnupg", @"gzip", @"lzma", @"curl", @"coreutils", @"cy+cpu.arm", @"cy+kernel.darwin", @"cy+model.appletv", @"cy+os.ios", nil];
}

%new - (BOOL)canRemove:(NSString *)theItem
{
	if ([[self untoucables] containsObject:theItem])
	{
		return NO;
	}
	NSDictionary *packageList = [self parsedPackageList];
	NSDictionary *packageDict = [packageList valueForKey:theItem];	
	NSString *essential = [packageDict objectForKey:@"Essential"];
	NSString *priority = [packageDict objectForKey:@"Priority"];
	if ([essential length] > 1)
	{
		if ([[essential lowercaseString] isEqualToString:@"yes"])
		{
			NSLog(@"nito_install_idiot_proofing: cannot delete essential package: %@ with priority: %@", theItem, priority);
			return NO;
		}
	}
	NSLog(@"priority: %@", priority);
	if ([priority length] == 0)
		return YES;
	
	if ([priority length] > 1)
	{
		if ([[priority lowercaseString] isEqualToString:@"required"])
		{
			NSLog(@"nito_install_idiot_proofing: cannot delete package: %@ with priority: %@", theItem, priority);
			return NO;
			
		} else {
			return YES;
		} 
	}
	return NO;
}

%new -(void)controller:(id)c buttonSelectedAtIndex:(int)index
{
		id selectedButton = [[c buttons] objectAtIndex:index];
	id _selectedObject = [self selectedObject];
		//NSLog(@"%@ buttonSelectedAtIndex: %i", c, index);
	switch (index) {
			
			
		case 0: //install
	
				[c setListActionMode:kPackageInstallMode];
			[c newUberInstaller:_selectedObject withSender:selectedButton];
			break;
			
		case 1: //remove
				//NSLog(@"remove: %@", selectedObject);
			if ([self packageInstalled:_selectedObject])
			{
				if ([self canRemove:_selectedObject])
				{
					[c setListActionMode:KPackageRemoveMode];
					[c removePackage:_selectedObject withSender:selectedButton];
				} else {
						//[[self stack] popController];
					[self showProtectedAlert:_selectedObject];
					PLAY_FAIL_SOUND;
					return;
				}
				
			} else {
				PLAY_FAIL_SOUND;
			}
			
			break;
			
		case 2: //more
			
			[c showPopupFrom:c withSender:selectedButton];
			break;
	}
	
}



- (NSString *)aptStatus
{
	return [NSString stringWithContentsOfFile:@"/tmp/aptoutput" encoding:NSUTF8StringEncoding error:nil];
	
}



%new -(id)removeFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback //deprecated?
{
	NSString * path = @"/tmp/aptoutput";
	
	id textControls = [[objc_getClass("kbScrollingTextControl") alloc] init];
	
	[textControls setDocumentPath:path encoding:NSUTF8StringEncoding];
	
	NSString *myTitle = nil;
	if (termStatus == 0)
	{
		myTitle = BRLocalizedString(@"Package Removal Successful", @"Package Removal Successful");
		
	} else {
		
		myTitle = BRLocalizedString(@"Package Removal Failed!",@"Package Removal Failed!" );
	}
	
	[textControls setTitle:myTitle];
	[textControls autorelease];
	return [objc_getClass("BRController") controllerWithContentControl:textControls];
	
}

%new - (void)showProtectedAlert:(NSString *)protectedPackage
{
	id result = [[objc_getClass("BRAlertController") alloc] initWithType:0 titled:BRLocalizedString(@"Required Package", @"alert when there is a required / unremovable package") primaryText:[NSString stringWithFormat:BRLocalizedString(@"The package %@ is required for proper operation of your AppleTV and cannot be removed", @"primary text when there is a required / unremovable package"), protectedPackage] secondaryText:BRLocalizedString(@"Press menu to exit", @"seconday text when there is a required / unremovable package") ];
	[[self stack] pushController:result];
	[result release];
}


- (long)defaultIndex						{ return 0;}
-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
		//[_latestQuery release];
		//[_arrowImage removeFromParent];
	
		//[_arrowImage release];
		//[_entryControl removeFromParent];
		//[_entryControl release];
		//    _entryControl=nil;
		//[[self names] release];
		//_names = nil;
		//[[self descriptions] release];
		//_descriptions = nil;
    //[_filteredArray release];
    //_filteredArray=nil;
	//[_infos release];
	//_infos = nil;
    //_delegate=nil;
    //[super dealloc];

	%orig;
}

%end
