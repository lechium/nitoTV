/* 
How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include , it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/


%group FrapHooks

%hook BRApplianceCategoryListProvider

- (long)categoryIndexForIdentifier:(id)identifier
{
	NSLog(@"AppliaceListProvider categoryIndex %d ForIdentifier %@",%orig, identifier);
	return %orig;

}

- (void)setCategories:(id)categories
{
 	%log;
	NSLog(@"%@", categories);
	//NSLog(@"%@ setCategories: %@", %orig, categories);
	return %orig;
}

%end

%hook BRApplianceManager

- (id)applianceInfoList
{
	%log;
	NSLog(@"%@", [%orig lastObject]);
	return %orig;

}

- (id)controllerForApplianceInfo:(id)applianceInfo identifier:(id)identifier args:(id)args
{
	%log;
	NSLog(@"%@ controllerForApplianceInfo: %@ identifier: %@ args: %@", %orig, applianceInfo, identifier, args);
	return %orig;

}

- (id)controllerForApplianceKey:(id)applianceKey identifier:(id)identifier args:(id)args
{
	%log;
	NSLog(@"%@ controllerForApplianceKey: %@ identifier: %@ args: %@", %orig, applianceKey,identifier, args);
	return %orig;
}

- (id)controllerForContentAlias:(id)contentAlias
{
	%log;
	return %orig;
}
%end

%hook BRMainMenuSelectionHandler

- (BOOL)handleSelectionForControl:(id)control
{
	%log;
	NSLog(@"control: %@", control);
	return %orig;
}
%end

%hook BRMediaShelfView

- (id)selectedControl
{
	%log;
	NSLog(@"selectedControl:%@", %orig);
	return %orig;
}

%end

%hook BRListView

- (id)itemAtIndex:(long)index
{
	//%log;
	//NSLog(@"index: %d item: %@", index, %orig);
	return %orig;

}

- (void)list:(id)list didSelectItemAtIndexPath:(id)indexPath
{
	//%log;
	//NSLog(@"list: %@ didSelectItemAtIndexPath: %@", list, indexPath);
	return %orig;

}

- (id)itemIDAtIndex:(long)index
{

	%log;
	NSLog(@"ID: %@ at index: %i", %orig, index);
	return %orig;
}

%end

%hook BRFeatureManager

- (void)enableFeatureNamed:(id)named
{

	%log;
	return %orig;

}

%end

%hook BRTopShelfView

- (void)setState:(int)state
{
	//%log;
	//NSLog(@"state: %i", state);
	return %orig;


}

- (id)preferredActionForKey:(id)key
{
	//%log;
	//NSLog(@"key: %@", key);
	return %orig;

}

%end


%hook BRBaseAppliance

- (id)applianceCategoryDescriptions
{
	NSLog(@"applianceCategoryDescriptions: %@", %orig);
	return %orig;
	
}

- (id)identifierForContentAlias:(id)contentAlias
{
	%log;
	NSLog(@"%@ id for contentAlias: %@", %orig, contentAlias);
	return %orig;

}

- (id)categoryWithIdentifier:(id)identifier
{
	NSLog(@"identifier: %@",identifier );
	%log;
	return %orig;

}

- (id)controllerForIdentifier:(id)identifier args:(id)args
{
	NSLog(@"identifier: %@",identifier );
	%log;
	return %orig;
}

- (id)applianceCategories {
	//%log;
	return %orig;
}
%end

%hook BRMainMenuControl 

- (void)setDelegate:(id)delegate
{

	NSLog(@"delegate; %@", delegate);
	%log;
	return %orig;

}

- (void)setDatasource:(id)datasource
{
	NSLog(@"dataSource; %@", datasource);
	%log;
	return %orig;

}


- (id)_currentApplianceKey
{
	%log;
	NSLog(@"key: %@", %orig);
	return %orig;
}

- (long)_focusedCategoryIndex
{
	%log;
	NSLog(@"_focusedCategoryIndex: %d", %orig);
	return %orig;

}

- (id)_currentCategoryIdentifier
{
	%log;
	//NSArray *columns(MSHookIvar<NSArray *>(self, "_columns"));
	//long activeColumn(MSHookIvar<long>(self, "_activeColumn"));
	//id currentColumn = [columns objectAtIndex:activeColumn];
	//NSLog(@"currentColumn: %@", currentColumn);
	BRApplianceCategoryListProvider *categoryListProvider(MSHookIvar<BRApplianceCategoryListProvider *>(self, "_categoryListProvider"));
	//NSLog(@"categoryListProvider: %@", categoryListProvider);
	NSArray *categories = [categoryListProvider categories];
	NSLog(@"categories: %@", categories);
	BRListView *categoryList(MSHookIvar<BRListView *>(self, "_categoryList"));
	id myIndexPath = [categoryList selectedIndexPath];
	int focusedCategoryIndex = [myIndexPath row];
	id category = [categories objectAtIndex:focusedCategoryIndex];
	
	if (%orig != nil);
		return [category identifier];


	return %orig;

}

- (BOOL)_categorySelected:(id)selected
{
	NSLog(@"category: %@", selected);
	%log;
	return %orig;

}

- (id)actionForCurrentSelection
{
	%log;
	NSLog(@"action: %@", %orig);
	//NSLog(@"class %@", %orig);
	return %orig;

}

- (id)controllerForCurrentSelection
{
	NSLog(@"%@", NSStringFromClass([%orig class]));
	%log;
	return %orig;

}

%end

%hook BRApplianceCategory

- (void)setAction:(id)action
{
	
	NSLog(@"action: %@", action);
	%log;
	return %orig;

}

%end

%hook BRApplianceInfo

-(id)icon
{
	//%log;
	return %orig;

}

-(id)iconPath
{
	//NSLog(@"%@", NSStringFromClass([self class]));
	//%log;
	return %orig;

}

- (void)setIconPath:(id)path
{

	//%log;
	//NSLog(@"path: %@", path);
	
	return %orig;

}


- (id)initWithDictionary:(id)dictionary
{

	//NSLog(@"dictionary: %@", dictionary);
	//%log;
	return %orig;

}

%end

%hook BRApplianceProvider

-(id)dataAtIndex:(long)index

{
	//NSLog(@"%@", NSStringFromClass([self class]));
	//%log;
	return %orig;

}

- (id)applianceInfoAtIndex:(long)index
{
	//NSLog(@"%@", %orig);
	//NSLog(@"%@", NSStringFromClass([%orig class]));
	//NSArray *&_applianceInfo(MSHookIvar<NSArray *>(self, "_applianceInfo"));
	//NSLog(@"_applianceInfo:%@", _applianceInfo);
	//%log;
	return %orig;
}


- (long)applianceInfoIndexForKey:(id)key
{
	//%log;
	return %orig;
}

%end

%hook BRMainMenuController


- (void)_highlightApplianceWithKey:(id)key andCategoryWithIdentifier:(id)identifier
{
	%log;
	return %orig;

}

- (void)_setHandlingMainMenuEvent:(BOOL)event
{

	%log;
	return %orig;

}

- (void)mainMenu:(id)menu didSelectCategoryAtIndexPath:(id)indexPath
{
        %log;
      //NSLog(@"menu: %@ indexPath: %@", menu, indexPath);
    
      return %orig;

}


%end

%hook COMPUTERSAppliance

-(id)controllerForIdentifier:(id)identifier args:(id)args
{
	NSLog(@"%@", NSStringFromClass([self class]));
	%log;
	return %orig;

}

%end

%hook SETTINGSTopShelfController

-(void)selectCategoryWithIdentifier:(id)identifier
{
	NSLog(@"identifier: %@", identifier);
	%log;
	return;
	//return %orig;

}

- (id)identifierForContentAlias:(id)contentAlias
{
	%log;
	NSLog(@"%@ id for contentAlias: %@", %orig, contentAlias);
	return %orig;

}

-(id)topShelfView
{
      //NSLog(@"super: %@", NSStringFromClass([%orig class]) );
	 // [%orig _dumpControlTree];
      %log;
	  NSLog(@"shelf: %@", [%orig shelf]);
      return %orig;
}

-(id)applianceCategories
{
	%log;
	NSLog(@"orig: %@", %orig);
	return %orig;

}

%end

%hook COMPUTERSTopShelfController

+ (id)singleton
{
 	//NSLog(@"super: %@", NSStringFromClass([self super]) );
	 %log;
     return %orig;

}

+(void)setSingleton:(id)singleton
{
	NSLog(@"singleton: %@", singleton);
	%log;
	return %orig;
	
}

-(id)topShelfView
{
      NSLog(@"super: %@", NSStringFromClass([%orig class]) );
	 // [%orig _dumpControlTree];
      %log;
      return %orig;
}

%end


%end


%hook NSBundle

- (BOOL)load {
	BOOL orig = %orig;
	

	if (orig) {
		if ([[self bundlePath] isEqualToString:@"/var/stash/Applications/Lowtide.app/Appliances/Settings.frappliance"]) { // <-- Can be any appliance, in this case, Internet.frappliance
			CMLog(@"Internet frappliance loaded, ATV Internet Browser initialized");
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