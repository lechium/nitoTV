
static BOOL centered = FALSE;

%subclass nitoMenuItem : BRMenuItem



#define BRMC_CLASS NSClassFromString(@"BRMenuItem")

%new +(id)ntvMenuItem
{
	id object = [[NSClassFromString(@"MMenuItem") alloc] init];
	[object addAccessoryOfType:0];
	//NSLog(@"object: %@", object);
	return [object autorelease];
}

%new +(id)ntvFolderMenuItem

{
	id object = [[NSClassFromString(@"BRMenuItem") alloc] init];
	[object addAccessoryOfType:kBRFolderMenuItem];
	return [object autorelease];
	
}

%new +(id)ntvShuffleMenuItem
{
	id object = [[NSClassFromString(@"BRMenuItem") alloc] init];
	[object addAccessoryOfType:kBRShuffleMenuItem];
	return [object autorelease];
}

%new +(id)ntvRefreshMenuItem
{
	id object = [[NSClassFromString(@"BRMenuItem") alloc] init];
	[object addAccessoryOfType:kBRRefreshMenuItem];
	return [object autorelease];
}

%new +(id)ntvSyncMenuItem
{
	id object = [[NSClassFromString(@"BRMenuItem") alloc] init];
	[object addAccessoryOfType:kBRSyncMenuItem];
	return [object autorelease];
}

%new +(id)ntvLockMenuItem
{
	id object = [[NSClassFromString(@"BRMenuItem") alloc] init];
	[object addAccessoryOfType:kBRLockMenuItem];
	return [object autorelease];
}

%new +(id)ntvProgressMenuItem
{
	id object = [[NSClassFromString(@"BRMenuItem") alloc] init];
	[object addAccessoryOfType:kBRProgressMenuItem];
	[object addAccessoryOfType:kBRFolderMenuItem];
	return [object autorelease];
}

%new +(id)ntvDownloadMenuItem
{
	id object = [[NSClassFromString(@"BRMenuItem") alloc] init];
	[object addAccessoryOfType:kBRDownloadMenuItem];
	return [object autorelease];
}

%new +(id)ntvComputerMenuItem
{
	id object = [[NSClassFromString(@"BRMenuItem") alloc] init];
	[object addAccessoryOfType:kBRComputerMenuItem];
	return [object autorelease];
}

%new -(void)setCentered:(BOOL)value
{
	centered = value;
}

%new -(void)setTitle:(NSString *)title
{
	if (centered == TRUE)
	{
		[self setText:title withAttributes:[self centeredTextAttributes]];
		
		
	} else {
		
		[self setText:title withAttributes:[[%c(BRThemeInfo) sharedTheme]menuItemTextAttributes]];
	}
	
    
}
%new -(void)setRightText:(NSString *)txt
{
    [self setRightJustifiedText:txt withAttributes:[[%c(BRThemeInfo) sharedTheme] menuItemSmallTextAttributes]];
}

%end
