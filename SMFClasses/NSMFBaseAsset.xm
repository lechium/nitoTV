//
//  NSMFBaseAsset.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

	//#import "NSMFBaseAsset.h"
	//#import "SMFMediaPreview.h"

static char const * const kSMFBAMetaKey = "SMFBAMeta";
static char const * const kSMFBAImageKey = "SMFBAImage";


%subclass NSMFBaseAsset : BRXMLMediaAsset

%new - (id)meta {
	
	return [self associatedValueForKey:(void*)kSMFBAMetaKey];
}

%new - (id)image {
	
	return [self associatedValueForKey:(void*)kSMFBAImageKey];
	
}

%new - (void)setMeta:(id)theMeta {
	
	[self associateValue:theMeta withKey:(void*)kSMFBAMetaKey];
}

%new - (void)setImage:(id)theImage {
	
	[self associateValue:theImage withKey:(void*)kSMFBAImageKey];
}

	//@implementation NSMFBaseAsset
%new +(NSMFBaseAsset *)asset
{
    return [[[%c(NSMFBaseAsset) alloc ]init] autorelease];
}

-(id)init
{
    self=%orig;
	id _meta=[[NSMutableDictionary alloc]init];
	[self setMeta:_meta];
	
		//[_meta release]; //not sure if ithis is okay.
	
	id _image=[[objc_getClass("BRThemeInfo") sharedTheme]appleTVImage];
	[self setImage:_image];
	
		//[_image release];
		//[_image retain];

    return self;
}

-(void)setObject:(id)arg1 forKey:(id)arg2
{
    [[self meta] setObject:arg1 forKey:arg2];
}

%new -(void)setTitle:(NSString *)title
{
    [[self meta] setObject:title forKey:METADATA_TITLE];
}

%new -(void)setSummary:(NSString *)summary
{
    [[self meta] setObject:summary forKey:METADATA_SUMMARY];
}

%new -(void)setCustomKeys:(NSArray *)keys forObjects:(NSArray *)objects
{
    if([keys count]==[objects count])
    {
        [[self meta] setObject:keys forKey:METADATA_CUSTOM_KEYS];
        [[self meta] setObject:objects forKey:METADATA_CUSTOM_OBJECTS];
    }
}
-(id)coverArt
{
    return [self image];
}

%new -(void)setCoverArt:(id)coverArt
{
	[self setImage:coverArt];
    //[_image release];
    //_image=[coverArt retain];
}

%new -(void)setCoverArtPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			// [_image release];
			// _image=[[objc_getClass("BRImage") imageWithPath:path] retain];
		[self setImage:[objc_getClass("BRImage") imageWithPath:path]];
	}

}
%new -(NSDictionary *)orderedDictionary
{
	id _meta = [self meta];
    NSMutableDictionary *a=[[NSMutableDictionary alloc] init];
    if([_meta objectForKey:METADATA_TITLE]!=nil)
        [a setObject:[_meta objectForKey:METADATA_TITLE] forKey:METADATA_TITLE];
    if([_meta objectForKey:METADATA_SUMMARY]!=nil)
        [a setObject:[_meta objectForKey:METADATA_SUMMARY] forKey:METADATA_SUMMARY];
    if ([_meta objectForKey:METADATA_CUSTOM_KEYS]!=nil && [_meta objectForKey:METADATA_CUSTOM_OBJECTS]!=nil) {
        [a setObject:[_meta objectForKey:METADATA_CUSTOM_KEYS] forKey:METADATA_CUSTOM_KEYS];
        [a setObject:[_meta objectForKey:METADATA_CUSTOM_OBJECTS] forKey:METADATA_CUSTOM_OBJECTS];
        
    }
    return [a autorelease];
}
- (id)mediaType
{
    return [objc_getClass("BRMediaType") movie];
}
-(id)assetID
{
    return @"BaseAsset";
}
-(id)title
{
    return [[self meta] objectForKey:METADATA_TITLE];
}
-(id)summary
{
    return [[self meta] objectForKey:METADATA_SUMMARY];
}
- (BOOL)hasCoverArt
{
	return YES;
}
- (void)dealloc
{
		//   [_image release];
		//[_meta release];
		//[super dealloc];
	%orig;
}
	//@end

%end