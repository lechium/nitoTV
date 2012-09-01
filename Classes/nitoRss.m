//
//  nitoRss.m
//  nitoTV
//
//  Created by nito on 7/11/07.
//  Copyright 2007 nito. All rights reserved.
//

#import "nitoRss.h"


@implementation nitoRss


- (id) init
{
	if ((self = [super init]))
	{
	
		NSArray *keys =		[NSArray arrayWithObjects: @"name", @"location" ,  nil];
		NSArray *values =	[NSArray arrayWithObjects: @"New Location", @"http://" , nil];
		
		properties = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
		
	
		
		
	}
	return self;
}





- (void)dealloc {
	
	[super dealloc];
}

- (NSMutableDictionary *)properties
{
	return properties;
}

- (void)setProperties:(NSMutableDictionary *)newProperties
{
	[newProperties retain];
	[properties release];
	properties = [[NSMutableDictionary alloc] initWithDictionary: newProperties];
}

- (void)setTheProps:(NSDictionary *)newTheProps
{
	[newTheProps retain];
	[properties release];
	properties = [[NSMutableDictionary alloc] initWithDictionary:newTheProps];
	
	NSString *tempStr = nil;

	
	if((tempStr = [properties objectForKey:@"name"]))
		[self setName:tempStr];
	
	if((tempStr = [properties objectForKey:@"location"]))
		[self setLocation:tempStr];
	
	
	
}

- (NSDictionary *)theProps
{
	NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
	
	//First make sure it is not nil
	//Then add it if so
	if([self name])
		[props setObject:[self name] forKey:@"name"];
	
	if([self location])
		[props setObject:[self location] forKey:@"location"];
	

		
	return [NSDictionary dictionaryWithDictionary:[props autorelease]];
}

- (NSString *)location {
    return [[location retain] autorelease];
}

- (void)setLocation:(NSString *)value {
    if (location != value) {
        [location release];
        location = [value copy];
    }
}

- (NSString *)name {
    return [[name retain] autorelease];
}

- (void)setName:(NSString *)value {
    if (name != value) {
        [name release];
        name = [value copy];
    }
}





@end
