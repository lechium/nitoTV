
#import "packageManagement.h"

%subclass ntvMedia : BRXMLMediaAsset


static int installType;
static char const * const ntvMediaDownloadURLKey = "nMediaDownloadURL";
static char const * const ntvMediaVersionKey = "nMediaVersion";
static char const * const ntvMediaImagePathKey = "nMediaImagePath";
static char const * const ntvMediaMetaKey = "nMediaMeta";

/*
 
 NSString			*version;
 NSString			*imagePath;
 BRImage *_image;
 
 */

%new - (id)initWithDictionary:(NSDictionary *)dict
{
		//This is here to fix 2.2
	self = [self init];
	[self setTitle:[dict valueForKey:@"name"]];
	[self setObject:[dict valueForKey:@"name"] forKey:@"title"];
	[self setObject:[dict valueForKey:@"name"] forKey:@"id"];
	[self setObject:[%c(BRMediaType) TVShow] forKey:@"mediaType"];
	installType = [[dict valueForKey:@"installType"] intValue];
		//[self setInstallType:[[dict valueForKey:@"installType"] intValue]];
	[self setDownloadURL:[dict valueForKey:@"url"]];
		//[self setVersion:[dict valueForKey:@"version"]];
	[self setImagePath:[dict valueForKey:@"imageUrl"]];
	NSURL *imageURL = [NSURL URLWithString:[dict valueForKey:@"imageUrl"]];
	[self setCoverArt:[packageManagement _imageWithURL:imageURL]];
    //[self setCoverArt:[%c(BRImage) imageWithURL:imageURL]];
	
	return self;
}

%new - (void)setMeta:(NSMutableDictionary *)theMeta { [self associateValue:theMeta withKey:(void*)ntvMediaMetaKey];}

%new - (NSMutableDictionary *)meta { return [self associatedValueForKey:(void*)ntvMediaMetaKey]; }

%new - (void)setDownloadURL:(NSString *)theDownloadURL { [self associateValue:theDownloadURL withKey:(void*)ntvMediaDownloadURLKey]; }

%new - (NSString *)downloadURL { return [self associatedValueForKey:(void*)ntvMediaDownloadURLKey]; }

%new - (void)setImagePath:(NSString *)theImagePath { [self associateValue:theImagePath withKey:(void*)ntvMediaImagePathKey]; }

%new - (NSString *)imagePath { return [self associatedValueForKey:(void*)ntvMediaImagePathKey]; }

%new - (void)setVersion:(NSString *)theVersion { [self associateValue:theVersion withKey:(void*)ntvMediaVersionKey]; }

%new - (NSString *)version { return [self associatedValueForKey:(void*)ntvMediaVersionKey]; }

%new - (void)setImage:(id)theImage { [self associateValue:theImage withKey:(void*)ntvMediaImagePathKey]; }

%new - (id)image { return [self associatedValueForKey:(void*)ntvMediaImagePathKey]; }


- (void)dealloc
{
	
	%orig;
}
-(id)init
{
    self=%orig;
    NSMutableDictionary *myMeta =[[NSMutableDictionary alloc]init];
	[self setMeta:myMeta];
    return self;
}

-(void)setObject:(id)arg1 forKey:(id)arg2
{
    [[self meta] setObject:arg1 forKey:arg2];
}
%new -(void)setTitle:(NSString *)title
{
    [[self meta] setObject:title forKey:NTV_META_TITLE];
}
%new -(void)setSummary:(NSString *)summary
{
    [[self meta] setObject:summary forKey:NTV_META_SUMMARY];
}

%new -(void)setCustomKeys:(NSArray *)keys forObjects:(NSArray *)objects
{
    if([keys count]==[objects count])
    {
        [[self meta] setObject:keys forKey:NTV_META_CUSTOM_KEYS];
        [[self meta] setObject:objects forKey:NTV_META_CUSTOM_OBJECTS];
    }
}
-(id)coverArt
{
    return [self image];
}
%new -(void)setCoverArt:(id)coverArt
{
	[self setImage:coverArt];
		//_image = coverArt;
}

%new -(void)setCoverArtPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			// [_image release];
        [self setImage:[packageManagement _imageWithPath:path]];
        
        // [self setImage:[%c(BRImage) imageWithPath:path]];
			//_image=[[BRImage imageWithPath:path] retain];
    }
	
}
%new -(NSDictionary *)orderedDictionary
{
    NSMutableDictionary *a=[[NSMutableDictionary alloc] init];
    if([[self meta] objectForKey:NTV_META_TITLE]!=nil)
        [a setObject:[[self meta] objectForKey:NTV_META_TITLE] forKey:NTV_META_TITLE];
    if([[self meta] objectForKey:NTV_META_SUMMARY]!=nil)
        [a setObject:[[self meta] objectForKey:NTV_META_SUMMARY] forKey:NTV_META_SUMMARY];
    if ([[self meta] objectForKey:NTV_META_CUSTOM_KEYS]!=nil && [[self meta] objectForKey:NTV_META_CUSTOM_OBJECTS]!=nil) {
        [a setObject:[[self meta] objectForKey:NTV_META_CUSTOM_KEYS] forKey:NTV_META_CUSTOM_KEYS];
        [a setObject:[[self meta] objectForKey:NTV_META_CUSTOM_OBJECTS] forKey:NTV_META_CUSTOM_OBJECTS];
        
    }
	NSDictionary *returnDict = [NSDictionary dictionaryWithDictionary:a];
	[a release];
    return returnDict;
}
- (id)mediaType
{
    return [%c(BRMediaType) movie];
}
-(id)assetID
{
    return @"BaseAsset";
}
-(id)title
{
    return [[self meta] objectForKey:NTV_META_TITLE];
}
%new -(id)summary
{
    return [[self meta] objectForKey:NTV_META_SUMMARY];
}

- (id)mediaSummary
{
	return [self summary];
}

- (BOOL)hasCoverArt
{
	return YES;
}


%new +(id)notFoundImage
{
    return [packageManagement _imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"ApplianceIcon" ofType:@"png"]];
   // return [%c(BRImage) imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"ApplianceIcon" ofType:@"png"]] ;
}


%new - (id)initWithMediaURL:(NSURL *)url
{
		//This is here to fix 2.2
	self = [%c(BRXMLMediaAsset) initWithMediaProvider:nil];
	NSString *urlString = [url absoluteString];
	NSString *filename = [url path];
	[self setObject:[filename lastPathComponent] forKey:@"id"];
	[self setObject:[%c(BRMediaType) movie] forKey:@"mediaType"];
	[self setObject:urlString forKey:@"mediaURL"];
	
	return self;
}


%end
	//@end
