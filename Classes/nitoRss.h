//
//  nitoRss.h
//  nitoTV
//
//  Created by nito on 7/11/07.
//  Copyright 2007 nito. All rights reserved.
//





@interface nitoRss : NSObject {
	NSMutableDictionary *properties;
	NSDictionary *theProps;
	
	NSString *location;
	NSString *name;

	
}
- (void)setTheProps:(NSDictionary *)newTheProps;
- (NSMutableDictionary *)properties;
- (void)setProperties:(NSMutableDictionary *)value;

- (NSString *)location;
- (void)setLocation:(NSString *)value;

- (NSString *)name;
- (void)setName:(NSString *)value;



@end
