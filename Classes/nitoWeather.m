//
//  nitoWeather.m
//  nitoTV
//
//  Created by nito on 7/11/07.
//  Copyright 2007 nito. All rights reserved.
//

#import "nitoWeather.h"


@implementation nitoWeather


- (id) init
{
	if ((self = [super init]))
	{
	
		NSArray *keys =		[NSArray arrayWithObjects: @"name", @"location", @"units" ,  nil];
		NSArray *values =	[NSArray arrayWithObjects: @"New Location", @"85048" ,@"f", nil];
		
		properties = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];

	
		
		
	}
	return (self);
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
	
	if((tempStr = [properties objectForKey:@"units"]))
		[self setUnits:tempStr];
	
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
	
	if([self units])
		[props setObject:[self units] forKey:@"units"];
	
		
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

- (NSString *)units {
    return [[units retain] autorelease];
}

- (void)setUnits:(NSString *)value {
    if (units != value) {
        [units release];
        units = [value copy];
    }
}



@end
