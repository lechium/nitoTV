%hook BRScrollControl


- (CGRect)_visibleRectOfControl:(id)control
{
	//%log;
	Class cls = NSClassFromString(@"ATVVersionInfo");
	if (cls != nil)
	{ 
		float theVersion =  [[cls currentOSVersion] floatValue]; 
		if (theVersion >= 4.3f)
		{
			 id top = [[[[self parent] parent]parent]parent];
	 NSString *topClass = NSStringFromClass([top class]);
	// NSLog(@"top: %@", top);
	CGRect controlRect = [control frame];
	CGRect newRect = %orig;
	//int controlOriginY = controlRect.origin.y;
	//int focusOriginY = newRect.origin.y;
	//NSString *visibleRect = NSStringFromCGRect(%orig);
	//NSString *controlRectString = NSStringFromCGRect([control frame]);
	//NSLog(@"visibleRect: %@ controlRect: %@", visibleRect, controlRectString);
	if ([topClass isEqualToString:@"SMFComplexProcessDropShadowControl"])
	{
		
	//	NSLog(@"SMFComplexProcessDropShadowControl");
		newRect.origin.y = 0;
		controlRect.origin.y = 0;
		[control setFrame:controlRect];
		
	}

	
	return newRect;
		}
		
		return %orig;
		
	}
	
	return %orig;
}

%end