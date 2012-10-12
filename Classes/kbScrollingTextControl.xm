	//#import "kbScrollingTextControl.h"

	//@implementation kbScrollingTextControl

%subclass kbScrollingTextControl : BRScrollingTextControl

%new -(id)_paragraphTextAttributes
{
	NSMutableDictionary *attrs = [[NSMutableDictionary alloc] initWithDictionary:[[objc_getClass("BRThemeInfo") sharedTheme] menuItemTextAttributes]];
	[attrs setObject:[NSNumber numberWithInteger:2] forKey:@"BRTextAlignmentKey"];
	[attrs setObject:[NSNumber numberWithInteger:20] forKey:@"BRFontPointSize"];
	[attrs setObject:[NSNumber numberWithInteger:0] forKey:@"BRLineBreakModeKey"];
	[attrs setObject:[NSNumber numberWithInteger:2] forKey:@"BRTextAlignmentKey"];
	return [attrs autorelease];
}

%end
	//@end