	//
	//  SMFPopup.xm
	//  SMFramework
	//
	//  Created by Thomas Cool on 11/20/10.
	//  Copyright 2010 tomcool.org. All rights reserved.
	//
	//%hook BRTrackInfoControl
	//-(void)_updateCoverArt:(id)art
	//{
	//    NSLog(@"art: %@",art);
	//    return %orig;
	//
	//}
	//%end

	//#import "SMFPopup.h"
%subclass NSMFPopupInfo : BRTrackInfoControl
- (id)_fetchCoverArt
{
    return [[%c(BRThemeInfo) sharedTheme] appleTVImage];
}
- (void)_updateTrackInfo
{
	
	BOOL pre60 = [self respondsToSelector:@selector(controls)];
	
	
    id l = nil;
	
	if (pre60) l = MSHookIvar<id>(self, "_layer");
		else l = MSHookIvar<id>(self, "_trackInfoLayer");


	
	
    id obj=[self object];
    if(obj!=nil && [obj isKindOfClass:[NSDictionary class]])
    {
			//NSLog(@"obj: %@",obj);
        if([obj objectForKey:@"Image"])
        {
	
			if([obj objectForKey:@"Lines"])
                [l setLines:[obj objectForKey:@"Lines"] withImage:[obj objectForKey:@"Image"]];
            else
                [l setImage:[obj objectForKey:@"Image"]];
		}
        else
        {
		
			[l setLines:[NSArray arrayWithObjects:@"error",nil] withImage:[self _fetchCoverArt]];
        }
		
        
    }
    else
        [l setLines:[NSArray arrayWithObjects:@"error",nil] withImage:[self _fetchCoverArt]];
		
}
%end