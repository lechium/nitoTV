/* 
 How to Hook with Logos
 Hooks are written with syntax similar to that of an Objective-C @implementation.
 You don't need to #include , it will be done automatically, as will
 the generation of a class list and an automatic constructor.
 */

%group FrapHooks

%hook COMPUTERSAppliance

- (id)topShelfController {
	%log;
	return %orig;
}

-(id)controllerForIdentifier:(id)identifier args:(id)args;
{
	%log;
	return %orig;
}

%end


%end


%hook NSBundle

- (BOOL)load {
	BOOL orig = %orig;
	
	
	if (orig) {
		if ([[self bundlePath] isEqualToString:@"/var/stash/Applications/Lowtide.app/Appliances/Computers.frappliance"]) { // <-- Can be any appliance, in this case, Internet.frappliance
			CMLog(@"Internet frappliance loaded, ATV Internet Browser initialized");
			%init(FrapHooks);
		}
	}
	
	return orig;
}

%end

static __attribute__((constructor)) void webBrowserHooksInit() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	[pool drain];
}