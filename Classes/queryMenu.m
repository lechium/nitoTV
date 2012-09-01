//
//  queryMenu.m
//  SMFramework
//
//  Created by Thomas Cool on 11/5/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//	Updated by Kevin Bradley 11-13-10 added the ability to turn on and off a previewControl ala Youtube search.

#import "queryMenu.h"
#import "ntvMedia.h"
#import "ntvMediaPreview.h"
#import "kbScrollingTextControl.h"
#import "nitoInstallManager.h"
#import "packageManagement.h"
	//#import "NSTask.h"

@interface ntvTextEntryControl : BRTextEntryControl


- (id)firstScrollControl;
- (id)firstPanelControl;
- (void)removeStupidPlayPause;
- (void)layoutSubcontrols;
- (void)fixLayout;

@end

@implementation ntvTextEntryControl


- (void)controlWasFocused
{
	[super controlWasFocused];
	if ([[self parent] is50])
	{

		self.canWrapHorizontally = FALSE;
	}
}


- (id)firstScrollControl
{
	NSEnumerator *controlEnum = [[self controls] objectEnumerator];
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

- (id)firstPanelControl
{
	NSEnumerator *controlEnum = [[self controls] objectEnumerator];
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

- (void)removeStupidPlayPause
{
	NSEnumerator *controlEnum = [[self controls] objectEnumerator];
	id current = nil;
	while ((current = [controlEnum nextObject]))
	{
		NSString *currentClass = NSStringFromClass([current class]);
		if ([currentClass isEqualToString:@"BRTextEntryPlayPauseMessage"])
		{
			[current removeFromParent];
		}
	}
}

- (void)layoutSubcontrols
{
	if ([[self parent] is50])
	{
			//fix layout first, not sure if this is necessary, to change, seems to work better fixed first here.
		[self removeStupidPlayPause];
		[super layoutSubcontrols];
	} else {
		
	
		[super layoutSubcontrols];
			[self fixLayout];
	}
	
	
	
	
}

- (void)fixLayout
{

	if ([[queryMenu properVersion] isEqualToString:@"4.3"]) { //change back to 4.3!!
		
		[self removeStupidPlayPause];
			//NSLog(@"controls: %@", [self controls]);

		id scrollControl = [self firstScrollControl];
		CGRect scrollFrame = [scrollControl frame];
			//NSLog(@"scrollFrame og: %@", NSStringFromCGRect(scrollFrame));
		scrollFrame.origin.x = 18;
		scrollFrame.origin.y = 83;
			//scrollFrame.size.height = 329;
			//scrollFrame.size.width = 390;
		[scrollControl setFrame:scrollFrame];
		
		id panelControl = [self firstPanelControl];
			//	NSLog(@"panelControl controls: %@", [panelControl controls]);
		CGRect panelFrame = [panelControl frame];
			//	NSLog(@"panelFrame: %@", NSStringFromCGRect(panelFrame));	
		panelFrame.origin.x = -2;
		[panelControl setFrame:panelFrame];
	}
	
		//	NSLog(@"scrollFrame: %@", NSStringFromCGRect(scrollFrame));	
		//[self setNeedsLayout];
}



- (void)controlWasActivated
{
	[super controlWasActivated];
	
	
}

@end



@implementation queryMenu

@synthesize _latestQuery, searchState, selectedObject, isEdged;



-(NSArray *)names
{
	return _names;
}

- (void)setEdged:(BOOL)edge
{
	[self setIsEdged:edge];
}

-(id)init;
{
    self=[super init];
	[self setLabel:@"com.nito.query"];
	editorShowing = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateList:) name:@"QueryFinished" object:nil];
	
    _names = [[NSMutableArray alloc] init];
	_descriptions = [[NSMutableArray alloc] init];
    //_filteredArray = [[NSMutableArray alloc] init];
	_infos = [[NSMutableArray alloc] init];
    CGRect f = [BRWindow interfaceFrame];
    f.size.width=f.size.width/3.f;
   // _filteredArray=[_names copy];
	searchState = kNTVQueryStopped;
    [[self list] setDatasource:self];
    [[self list] setDisplaysSelectionWidget:YES];
	[self showEditorSelectingGylph:nil];
		//[self showEditorSelectingGylph:nil];
	[self setListTitle:BRLocalizedString(@"Search for Packages", @"Search for Packages")]; 
	[self setListIcon:[[NitoTheme sharedTheme] searchImage]];
	
    return self;
}

-(void)changeFocus
{
	[self _changeFocusTo:[self list]];
}

-(void)_hideEditor
{
	//NSLog(@"%@ %s", self, _cmd);
	editorShowing = NO;
	[_entryControl removeFromParent];
	[_entryControl release];
	[_arrowImage removeFromParent];
	[_arrowImage release];
	[[self list] setDatasource:self];
    [[self list] setDisplaysSelectionWidget:YES];
	//[_entryControl release];
	
}
	
-(BOOL)is43
{
	if([[queryMenu properVersion] isEqualToString:@"4.3"])
	{
		return YES;
	}
	return NO;
}

-(BOOL)is50
{
	return [packageManagement ntvFivePointZeroPlus];
}

//-(BOOL)is50
//{
//	if([[queryMenu properVersion] isEqualToString:@"5.0"] || [[queryMenu properVersion] isEqualToString:@"5.1"])
//	   {
//		   return YES;
//	   }
//	   return NO;
//}

	//CGRectMake(544, 87, 1, 492); //frame of [imageControl setImage:[[BRThemeInfo sharedTheme] verticalDividerImage]]

-(void)showEditorSelectingGylph:(id)selectedGlyph
{
	//NSLog(@"%@ %s", self, _cmd);
	editorShowing = YES;
	_arrowImage=[[BRImageControl alloc] init];
	CGRect arrowFrame = CGRectMake(540, 274, 46, 46);
	if ([self is50] || [self is43])
	{
		
		arrowFrame = CGRectMake(544, 87, 1, 492);
		[_arrowImage setImage:[[BRThemeInfo sharedTheme] verticalDividerImage]];
		
	} else {
		
		[_arrowImage setImage:[[BRThemeInfo sharedTheme] highlightedMenuArrowImage]];
	}
	
		//CGRect arrowFrame = CGRectMake(540, 274, 46, 46);
	[_arrowImage setFrame:arrowFrame];
	[self addControl:_arrowImage];
	int entryStyle = 2; // 2 for all other appletv versions, 5 for 4.4.

	if([self is50])
	{
		entryStyle = 5; //{origin:{x:109,y:48},size:{width:400,height:534}}

	}
	
	
	_entryControl=[[ntvTextEntryControl alloc] initWithTextEntryStyle:entryStyle]; //change to 4 for 4.4- but still need change some other shit too- not switching from keyboard over.
	NSString *query = self._latestQuery;
	if([query length] > 0)
	{
		[_entryControl setInitialText:query];
	}
	
    [_entryControl setTextFieldDelegate:self];
    CGRect f = [BRWindow interfaceFrame];
		//NSLog(@"[BRWindow interfaceFrame]: %@", NSStringFromCGRect(f));
		//f.size.width=f.size.width/3.f;
	f.size.width = 400;
		//float extra = [BRWindow interfaceFrame].size.width*(1/2.0f-1/3.0f)/2.0f;
    f.origin=CGPointMake(110, 86.0f);
	
	if ([self is50])
	{
		f.origin = CGPointMake(110, 70.0f);
	}
    if ([_entryControl tabControl] != nil)
	{
			[[_entryControl tabControl] removeFromParent];
	}

	[_entryControl setFrame:f];
		//	NSLog(@"entryControlFrame: %@", NSStringFromCGRect(f));
	
	[self clearPreviewController];
	[self addControl:_entryControl];
	[self setFocusedControl:_entryControl];
	[[self list] setDatasource:self];
    [[self list] setDisplaysSelectionWidget:NO];//kBRClearGlyphName
	if (selectedGlyph != nil)
	{
		
		[_entryControl setFocusToGlyphNamed:selectedGlyph];
	}
		//[_entryControl _dumpControlTree];
	
		//
		//CGRect scrollFrame = [scrollControl frame];
		//NSLog(@"scroll controls: %@", [[[scrollControl controls]objectAtIndex:0] controls]);
		//NSLog(@"controls: %@", [[_entryControl controls] objectAtIndex:2]);
	//
//	[_entryControl fixLayout];
//	[self setNeedsLayout];
//	[self setNeedsDisplay];
}

- (NSArray *)doIt
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

/*
- (void)nusearchForPackage:(NSString *)customFile
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
	
    [searchTask setArguments:[NSArray arrayWithObjects:@"search", @"--full", customFile, nil]];
    [searchTask launch];
	 NSString *str = nil;
	
	NSMutableString *temp = [[NSMutableString alloc] init];
	
	while((outData = [handle readDataToEndOfFile]) && [outData length])
    {
        str = [[[NSString alloc] initWithData:outData encoding:NSASCIIStringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[temp appendString:str];
        [str release];
    }
	[handle closeFile];
	//outData = [handle readDataToEndOfFile];
	//NSString *temp = [[NSString alloc] initWithData:outData encoding:NSASCIIStringEncoding];
	//NSLog(@"temp: %@", temp);

	NSArray *lineArray = [temp componentsSeparatedByString:@"\n\n"];
	//NSLog(@"lineArray: %@", lineArray);
	[temp release];
	NSMutableArray *mutableList = [[NSMutableArray alloc] init];
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
		
		//NSLog(@"currentPackage: %@\n\n", currentPackage);
		if ([[currentPackage allKeys] count] > 4)
			[mutableList addObject:currentPackage];
		[currentPackage release];
		currentPackage = nil;
		
	}
	[searchTask release];
	searchTask = nil;
	[pipe release];
	pipe = nil;

	if (_entryControl != nil)
		[_entryControl stopSpinning];
	self._latestQuery = customFile;
	self.searchState = kNTVQueryFinished;
	if (mutableList != nil)
	{
		NSString *endFile = @"/var/mobile/Library/Preferences/test.plist";
		[mutableList writeToFile:endFile atomically:YES];
		NSArray *theArray = [NSArray arrayWithArray:[mutableList copy]];
		[mutableList release];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"QueryFinished" object:theArray userInfo:nil];
	} else {
		self.searchState = kNTVQueryFailed;
	}
	[pool drain];
}
*/


- (void)searchForPackage:(NSString *)customFile
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
	if (_entryControl != nil)
		[_entryControl stopSpinning];
	self._latestQuery = customFile;
	self.searchState = kNTVQueryFinished;
	if (mutableList != nil)
	{
		NSArray *theArray = [NSArray arrayWithArray:mutableList];
		[mutableList release];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"QueryFinished" object:theArray userInfo:nil];
	} else {
		self.searchState = kNTVQueryFailed;
	}
	[pool release];
}

- (NSDictionary *)packageInfo:(NSString *)packageID
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


- (void)updateList:(NSNotification *)n
{   
		//NSLog(@"%@ %s", self, _cmd);
	/*
	 
	 make sure there aren't any differences between self._latestQuery and whatever the textField currently holds
	 
	 */
	
	if (_entryControl == nil)
	{
		
		id theList = [n object];
		//NSLog(@"updateList: %@", theList);
		[_names removeAllObjects];
		[_descriptions removeAllObjects];
		//[_infos removeAllObjects];
		
		for (NSDictionary *item in theList)
		{
			
			NSString *package = [item objectForKey:@"Package"];
			NSString *desc = [item objectForKey:@"Description"];
			if (package != nil)
			[_names addObject:[item objectForKey:@"Package"]];
			//NSDictionary *packageInfo = [self packageInfo:[item objectForKey:@"name"]];
			if (desc != nil)
			[_descriptions addObject:desc];
			//	[_infos addObject:packageInfo];
		
		}
		//_filteredArray = [_names copy];
		[[self list] reload];
		return;
	}
	NSString *currentText = [[_entryControl textField]stringValue];
	NSString *latestQuery = self._latestQuery;
	if ([currentText isEqualToString:latestQuery])
	{
		
		id theList = [n object];
		//NSLog(@"updateList: %@", theList);
		[_names removeAllObjects];
		[_descriptions removeAllObjects];
		//[_infos removeAllObjects];
		
		for (NSDictionary *item in theList)
		{
			
			NSString *package = [item objectForKey:@"Package"];
			NSString *desc = [item objectForKey:@"Description"];
			if (package != nil)
			[_names addObject:package];
			//NSDictionary *packageInfo = [self packageInfo:[item objectForKey:@"name"]];
			if (desc != nil)
			[_descriptions addObject:desc];
		//	[_infos addObject:packageInfo];
			
		}
		//_filteredArray = [_names copy];
		[[self list] reload];
		
	} else {
		
		[self textDidChange:[_entryControl textField]];
	}
	
}


-(void)setDelegate:(id<QueryDelegate>)d
{
    _delegate=d;
}
-(id<QueryDelegate>)delegate
{
    return _delegate;
}
-(void)ogreloadItems
{
    NSString *filter = [[[_entryControl textField]stringValue] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    if ([filter length]>0) {
		
			//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@",filter,nil];
        //[_filteredArray release];
        //_filteredArray=[[_names filteredArrayUsingPredicate:predicate] retain];
		//[_entryControl stopSpinning];
    }
    else {
        //[_filteredArray release];
        //_filteredArray=[_names copy];

    }


    [[self list] reload];
}
- (void) textDidChange: (id) sender
{
	if ([[sender stringValue] isEqualToString:self._latestQuery])
		return;
	//NSLog(@"%@ %s", self, _cmd);
	switch (self.searchState) {
			
		case kNTVQueryStarted:
			return;
		
		case kNTVQueryStopped:
		case kNTVQueryFinished:
			break;
	}
	
	[_entryControl startSpinning];
	self.searchState = kNTVQueryStarted;
	//[_names removeAllObjects];
	//[_descriptions removeAllObjects];
	[NSThread detachNewThreadSelector:@selector(searchForPackage:) toTarget:self withObject:[sender stringValue]];
   
		//CGRectMake(544, 87, 1, 492); //frame of [imageControl setImage:[[BRThemeInfo sharedTheme] verticalDividerImage]]
	
}

- (void) textDidEndEditing: (id) sender
{
    if ([[sender stringValue] isEqualToString:self._latestQuery])
		return;
	//NSLog(@"%@ %s", self, _cmd);
	switch (self.searchState) {
			
		case kNTVQueryStarted:
			return;
			
		case kNTVQueryStopped:
		case kNTVQueryFinished:
			break;
	}
	
	[_entryControl startSpinning];
	self.searchState = kNTVQueryStarted;
	//[_names removeAllObjects];
	//[_descriptions removeAllObjects];
	[NSThread detachNewThreadSelector:@selector(searchForPackage:) toTarget:self withObject:[sender stringValue]];
}

-(void)wasPushed
{
    [super wasPushed];
    
}

- (id)focusedControlForEvent:(id)event focusPoint:(CGPoint *)point {
		//NSLog(@"%@ %s", self, _cmd);

	switch ([event remoteAction]) {
			
		case kBREventRemoteActionRight:
		case kBREventRemoteActionSwipeRight:
			if (editorShowing == YES)
			{
				if (self.searchState != kNTVQueryStarted)
					[self _hideEditor];
				else {
					return nil;
				}

					
			}
			break;
	}
	return [super focusedControlForEvent:event focusPoint:point];
}

- (float)heightForRow:(long)row				{ return 0.0f;}
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_names count];}


/*

- (id)ogitemForRow:(long)row					
{
    BRMenuItem *m = [BRMenuItem	ntvMenuItem];
    NSArray * f =[(NSString *)[_filteredArray objectAtIndex:row] componentsSeparatedByString:@"/"];
    NSString *t = nil;
    if ([f count]==2) {
        t=[f objectAtIndex:1];
		[m setRightJustifiedText:[f objectAtIndex:0] withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
    }
    else if([f count]==3)
    {
        t=[f objectAtIndex:([f count]-1)];
        NSArray *ff = [f subarrayWithRange:NSMakeRange(0, [f count]-1)];
        [m setRightJustifiedText:[ff componentsJoinedByString:@" / "] withAttributes:[[BRThemeInfo sharedTheme] menuItemSmallTextAttributes]];
    }
    else
        t=[_filteredArray objectAtIndex:row];
   // [m setTitle:[t stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
    [m setText:[t stringByReplacingOccurrencesOfString:@"_" withString:@" "] withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	return m;
}
 */
- (id)titleForRow:(long)row					
{ 
    
    return [_names objectAtIndex:row];
}

/*
-(void)ogitemSelected:(long)selected
{
    if (selected<[_filteredArray count] && _delegate!=nil) {
        [_delegate queryMenu:self itemSelected:[_filteredArray objectAtIndex:selected]];
    }
}
*/

-(void)controller:(PackageDataSource *)c selectedControl:(BRControl *)ctrl
{

		//NSLog(@"here: %@", ctrl);
	
	
	if ([ctrl respondsToSelector:@selector(selectedControl)])
	{
		id data = [[c provider] data];
		
		BRPosterControl *selectedControl = [(BRMediaShelfView *)ctrl selectedControl];
		int focusedIndex = [(BRMediaShelfView *)ctrl focusedIndex];
		id myAsset = [data objectAtIndex:focusedIndex];
		NSString *packageName = [[selectedControl title] string];
		BRImage *theImage = [myAsset coverArt];
		selectedObject = packageName;
		[c updatePackageData:packageName usingImage:theImage];
	}
	
	
}


-(void)itemSelected:(long)selected
{
	
	NSString *item = [_names objectAtIndex:selected];
	selectedObject = item;
		
	PackageDataSource *controller = [[PackageDataSource alloc] initWithPackage:item usingImage:nil];
	[controller setDatasource:controller];
	[controller setDelegate:self];
	[controller setCurrentMode:kPKGSearchListMode];
	[[self stack] pushController:controller];
		//[self customInstallAction:item];
}

- (void)customInstallAction:(NSString *)packageName
{
	id spinControl = [[BRTextWithSpinnerController alloc] initWithTitle:nil text:[NSString stringWithFormat:@"installing %@",packageName]];
	//NSLog(@"text string: %@", [text stringValue]);
	[[self stack] pushController:spinControl];
	[spinControl release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:packageName forKey:@"text"];
	[NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(updateCustomFinal:) userInfo: userInfo repeats: NO];
	
}

- (void)updateCustomFinal:(id)timer
{
	//NSLog(@"userInfo: %@", [timer userInfo]);
	[self updateCustom:[[timer userInfo] objectForKey:@"text"]];
	
}

- (void)updateCustom:(NSString *)customFile
{
	NSString *command = [NSString stringWithFormat:@"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/install_ntv.sh %@", customFile];
	int sysReturn = system([command UTF8String]);
	//NSLog(@"update custom returned with status %i", sysReturn);
	[packageManagement updatePackageList];
	id alert = [self installFinishedWithStatus:sysReturn andFeedback:nil];
	[[self stack] swapController:alert];
	
}

-(id)installFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback
{
	NSString * path = @"/tmp/aptoutput";
	
	kbScrollingTextControl *textControls = [[kbScrollingTextControl alloc] init];
	
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
	return [BRController controllerWithContentControl:textControls];
	
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

+ (NSString *)properVersion
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
	//	id scrollControl = nil;
//		CGRect scrollFrame;
//		if ([[queryMenu properVersion] isEqualToString:@"4.2.1"])
//			
//		{
//			scrollControl = [[_entryControl controls] objectAtIndex:3];
//			scrollFrame = [scrollControl frame];
//			
//		} else if ([[queryMenu properVersion] isEqualToString:@"4.3"]) {
//			scrollControl = [[_entryControl controls] objectAtIndex:2];
//			scrollFrame = [scrollControl frame];
//			scrollFrame.origin.x = 18;
//			scrollFrame.origin.y = 83;
//			[scrollControl setFrame:scrollFrame];
//			
//		}
//			//id important = [[scrollControl controls]objectAtIndex:0];
//			//NSLog(@"scrollControl: %@ important: %@", scrollControl, important);
//			//CGRect scrollFrame = [scrollControl frame];
//		NSLog(@"scrollFrame: %@", NSStringFromCGRect(scrollFrame));
		return [super brEventAction:action];
		
	}
	int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	int theValue = (int)[action value];	
	switch ([action remoteAction]) {
			
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
			[super brEventAction:action];
			break;
			
		case kBREventRemoteActionDown:
			
			if([self getSelection] == itemCount-1 && theValue == 1)
			{
				[self setSelection:0];
				return YES;
			}
			[super brEventAction:action];
			
			
			break;
			
		default:
			return [super brEventAction:action];
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

/*
 

-(id)previewControlForItem:(long)item
{
	//NSLog(@"description: %@", [_descriptions objectAtIndex:item]);
	if (editorShowing == NO)
	{

		ntvMedia *currentAsset = [[ntvMedia alloc] init];
		NSDictionary *currentInfo = [_infos objectAtIndex:item];
		NSString *packageName = [currentInfo objectForKey:@"Name"];
		NSString *version = [currentInfo objectForKey:@"Version"];
		NSString *author = [currentInfo objectForKey:@"Author"];
		NSString *section = [currentInfo objectForKey:@"Section"];
		
		[currentAsset setTitle:packageName];
		[currentAsset setSummary:[_descriptions objectAtIndex:item]];
		[currentAsset setCoverArt:[[NitoTheme sharedTheme] packageImage]];
		
		NSMutableArray *customKeys = [[NSMutableArray alloc] init];
		NSMutableArray *customObjects = [[NSMutableArray alloc] init];
		
		[customKeys addObject:BRLocalizedString(@"Author", @"Author")];
		[customObjects addObject:author];
		
		[customKeys addObject:BRLocalizedString(@"Section", @"Section")];
		[customObjects addObject:section];
		
		[customKeys addObject:BRLocalizedString(@"Version",@"Version")];
		[customObjects addObject:version];
		
		[currentAsset setCustomKeys:[customKeys autorelease] 
						 forObjects:[customObjects autorelease]];
		
		ntvMediaPreview *preview = [[ntvMediaPreview alloc]init];
		[preview setAsset:currentAsset];
		[preview setShowsMetadataImmediately:YES];
		[currentAsset release];
		
		return [preview autorelease];
	} else {
		return nil;
	}

}

*/

 
-(id)previewControlForItem:(long)item
{
	//NSLog(@"description: %@", [_descriptions objectAtIndex:item]);
	if (editorShowing == NO)
	{
	ntvMedia *currentAsset = [[ntvMedia alloc] init];
	
	[currentAsset setTitle:[_names objectAtIndex:item]];
	[currentAsset setSummary:[_descriptions objectAtIndex:item]];
	[currentAsset setCoverArt:[[NitoTheme sharedTheme] packageImage]];
	
	ntvMediaPreview *preview = [[ntvMediaPreview alloc]init];
	[preview setAsset:currentAsset];
	[preview setShowsMetadataImmediately:YES];
	[currentAsset release];
	
	return [preview autorelease];
	} else {
		return nil;
	}
}
 
-(id)itemForRow:(long)row
{
	if (row > [_names count])
	{
		return nil;
	}

	
	BRMenuItem *result = [BRMenuItem ntvDownloadMenuItem];
	[result setText:[_names objectAtIndex:row] withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	return	result;
}


-(id)newitemForRow:(long)row
{
	//BRMenuItem *result = [BRMenuItem ntvDownloadMenuItem];
	//[result setTitle:[_names objectAtIndex:row]];
	BRComboMenuItemLayer *result = [[BRComboMenuItemLayer alloc] init];
	NSDictionary *currentDict = [_infos objectAtIndex:row];
	
	[result setTitle:[currentDict objectForKey:@"Name"]];
	[result setSubtitle:[currentDict objectForKey:@"Package"]];
	[result setThumbnailImage:[[NitoTheme sharedTheme] packageImage]];
	//[result setText:[_names objectAtIndex:row] withAttributes:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
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

- (NSDictionary *)parsedPackageList
{
		//NSString *endFile = @"/Installed.plist";
	NSString *endFile = [packageManagement installedLocation];
	NSDictionary *parsedDict = [NSDictionary dictionaryWithContentsOfFile:endFile];
	return parsedDict;
}

- (NSArray *)untoucables
{
	return [NSArray arrayWithObjects:@"openssh", @"openssl", @"cydia", @"apt7", @"apt7-key", @"apt7-lib", @"apt7-ssl", @"berkeleydb", @"com.nito.nitotv", @"beigelist", @"mobilesubstrate", @"com.nito", @"org.awkwardtv",@"bash", @"bzip2", @"coreutils-bin", @"diffutils", @"findutils", @"gzip", @"lzma", @"ncurses", @"tar", @"firmware-sbin", @"dpkg", @"gnupg", @"gzip", @"lzma", @"curl", @"coreutils", @"cy+cpu.arm", @"cy+kernel.darwin", @"cy+model.appletv", @"cy+os.ios", nil];
}

- (BOOL)canRemove:(NSString *)theItem
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

-(void)controller:(PackageDataSource *)c buttonSelectedAtIndex:(int)index
{
		id selectedButton = [[c _buttons] objectAtIndex:index];
		//NSLog(@"%@ buttonSelectedAtIndex: %i", c, index);
	switch (index) {
			
			
		case 0: //install
	
				[c setListActionMode:kPackageInstallMode];
			[c newUberInstaller:selectedObject withSender:selectedButton];
			break;
			
		case 1: //remove
				//NSLog(@"remove: %@", selectedObject);
			if ([self packageInstalled:selectedObject])
			{
				if ([self canRemove:selectedObject])
				{
					[c setListActionMode:KPackageRemoveMode];
					[c removePackage:selectedObject withSender:selectedButton];
				} else {
						//[[self stack] popController];
					[self showProtectedAlert:selectedObject];
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

- (void)customRemoveActionNew:(id)theFile
{
	id spinControl = [[BRTextWithSpinnerController alloc] initWithTitle:nil text:[NSString stringWithFormat:BRLocalizedString(@"removing %@",@"removing %@"),theFile]];
		//NSLog(@"text string: %@", [text stringValue]);
	[[self stack] swapController:spinControl];
	[spinControl release];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:theFile forKey:@"text"];
	[NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(removeCustomFinal:) userInfo: userInfo repeats: NO];
	
}

- (void)removeCustomFinal:(id)timer
{
		//NSLog(@"userInfo: %@", [timer userInfo]);
	[self removeCustom:[[timer userInfo] objectForKey:@"text"]];
	
}

- (NSString *)aptStatus
{
	return [NSString stringWithContentsOfFile:@"/tmp/aptoutput" encoding:NSUTF8StringEncoding error:nil];
	
}

- (void)removeCustom:(NSString *)customFile
{
	NSString *command = [NSString stringWithFormat:@"/usr/libexec/nitotv/setuid /usr/libexec/nitotv/uninstall_dpkg.sh %@", customFile];
		//NSString *command = [NSString stringWithFormat:@"/usr/bin/nitoHelper remove %@", customFile];
	int sysReturn = system([command UTF8String]);
		//NSTask *helperTask = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/nitoHelper" arguments:[NSArray arrayWithObjects:@"remove", customFile, nil]];
	/*
	 NSTask *helperTask = [[NSTask alloc] init];
	 NSPipe *pipe = [[NSPipe alloc] init];
	 NSFileHandle *handle = [pipe fileHandleForReading];
	 NSData *outData;
	 [helperTask setLaunchPath:@"/usr/bin/nitoHelper"];
	 [helperTask setArguments:[NSArray arrayWithObjects:@"remove", customFile, nil]];
	 [helperTask setStandardOutput:pipe];
	 [helperTask setStandardError:pipe];
	 [helperTask launch];
	 //waitpid(-1, NULL , WNOHANG);
	 waitpid([helperTask processIdentifier], NULL, WUNTRACED);
	 //[helperTask waitUntilExit];
	 //int sysReturn = [helperTask terminationStatus];
	 */
	[packageManagement updatePackageList];
		//[[self list] reload];
	NSLog(@"remove custom returned with status %i", sysReturn);
	id installStatus = [self removeFinishedWithStatus:sysReturn andFeedback:[self aptStatus]];
		//[helperTask release];
		//helperTask = nil;
	
	[[self stack] swapController:installStatus];
}

-(id)removeFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback
{
	NSString * path = @"/tmp/aptoutput";
	
	kbScrollingTextControl *textControls = [[kbScrollingTextControl alloc] init];
	
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
	return [BRController controllerWithContentControl:textControls];
	
}

- (void)showProtectedAlert:(NSString *)protectedPackage
{
	BRAlertController *result = [[BRAlertController alloc] initWithType:0 titled:BRLocalizedString(@"Required Package", @"alert when there is a required / unremovable package") primaryText:[NSString stringWithFormat:BRLocalizedString(@"The package %@ is required for proper operation of your AppleTV and cannot be removed", @"primary text when there is a required / unremovable package"), protectedPackage] secondaryText:BRLocalizedString(@"Press menu to exit", @"seconday text when there is a required / unremovable package") ];
	[[self stack] pushController:result];
	[result release];
}


- (long)defaultIndex						{ return 0;}
-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_latestQuery release];
	[_arrowImage removeFromParent];
	[_arrowImage release];
    [_entryControl removeFromParent];
    [_entryControl release];
    _entryControl=nil;
    [_names release];
    _names = nil;
	[_descriptions release];
	_descriptions = nil;
    //[_filteredArray release];
    //_filteredArray=nil;
	[_infos release];
	_infos = nil;
    _delegate=nil;
    [super dealloc];
}
@end
