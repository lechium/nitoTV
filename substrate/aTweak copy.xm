/* 
How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include , it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/

%hook BRMediaMenuController

- (id)focusedControlForEvent:(id)event focusPoint:(CGPoint *)point
{
	NSLog(@"%@ %s", self, _cmd);
	NSLog(@"event: %@",  event);
	//%log;
	return %orig;
}



%end

%hook BRAirportManager

+ (BOOL)associateWithNetwork:(id)network password:(id)password error:(id *)error
{
	//%log;
	NSLog(@"associateWithNetwork: %@ password: %@", network, password);
	return %orig;
}



%end

%hook BRAirportNetwork

+ (void)asyncNetworkWithName:(id)name error:(id *)error
{
	%log;
	
	return %orig;
}

+ (id)networkWithWiFiNetwork:(void/*WiFiNetwork*/ *)wiFiNetwork
{
	%log;
	//NSString *className = NSStringFromClass([%orig class]);
	NSLog(@"name: %@", [%orig name]);
	return %orig;
}


- (BOOL)asyncAssociateUsingPassword:(id)password error:(id *)error
{
	//%log;
	NSLog(@"asyncAssociateUsingPassword: %@", password);
	return %orig;
}

%end




