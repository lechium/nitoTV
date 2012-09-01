/* 
How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include , it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/


%group FrapHooks


%hook BRMainMenuControl 


- (id)_currentCategoryIdentifier
{

	if (%orig == nil)
	{
		NSLog(@"_currentCategoryIdentifier is nil, attempting override....");
		id categoryListProvider(MSHookIvar<id>(self, "_categoryListProvider")); //get at the list provider to find list of categories
		if (categoryListProvider != nil)
		{
			if ([categoryListProvider respondsToSelector:@selector(categories)])
			{
				NSArray *categories = [categoryListProvider categories]; //categories
				id categoryList(MSHookIvar<id>(self, "_categoryList")); //BRListView - needed to get the selected indexPath
				if (categoryList != nil)
				{
					if ([categoryList respondsToSelector:@selector(selectedIndexPath)])
					{
						id myIndexPath = [categoryList selectedIndexPath]; //IndexPath of selected menu item
						int focusedCategoryIndex = [myIndexPath row]; //just the row
						if (!(focusedCategoryIndex >= (int)[categories count]))
						{
							id category = [categories objectAtIndex:focusedCategoryIndex]; //our current category
							return [category identifier];
						}
						
					}
				}
			}
		}
	}
	
	return %orig;
}

%end

%end


%hook NSBundle

- (BOOL)load {
	BOOL orig = %orig;
	

	if (orig) {
		if ([[self bundlePath] isEqualToString:@"/var/stash/Applications/Lowtide.app"]) { // <-- Can be any appliance, in this case, Internet.frappliance
			NSLog(@"Lowtide loaded, Main Menu Patch Initilized!");
			%init(FrapHooks);
		}
	}

	return orig;
}

%end

static __attribute__((constructor)) void myHooksInit() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	[pool drain];
}