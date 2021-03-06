//
//  NSMFPreferences.h
//  SMFramework
//
//  Created by Thomas Cool on 12/6/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//


	//#import "Backrow/AppleTV.h"

@interface NSMFPreferences : NSUserDefaults {
	NSString * _applicationID;
	NSDictionary * _registrationDictionary;
}

-(id)initWithPersistentDomainName:(NSString *)domainName;
+(NSMFPreferences *)preferences;
@end

