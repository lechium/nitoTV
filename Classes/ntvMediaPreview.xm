

typedef enum {
    kMetaTypePlug=0,
    kMetaTypeCust=1,
    kMetaTypeSimp=2,
    kMetaTypeDefault=3,
} ntvMetaType;

static const char * const ntvMetaKey = "ntvMediaMeta";
static const char * const ntvMetaDataTypeKey = "ntvMetaType";
static const char * const ntvImageKey = "ntvBRImageKey";
static int metaDataType;

%subclass ntvMediaPreview : BRMetadataPreviewControl


%new - (NSMutableDictionary *)meta
{
	
	return [self associatedValueForKey:(void*)ntvMetaKey];
}

%new - (void)setMeta:(NSMutableDictionary *)meta
{
	
	[self associateValue:meta withKey:(void*)ntvMetaKey];
}


- (id)init
{
	
    self=%orig;
    id meta =[[NSMutableDictionary alloc] init];
	[self setMeta:meta];
	return self;
}

- (void)dealloc
{
		//[meta release];
	%orig;
}

%new -(id)coverArtLayer
{
		//return nil;
	return MSHookIvar<id>(self, "_coverArtLayer");
}

%new - (void)setImage:(id)currentImage
{
	
		//[image release];
    [self associateValue:currentImage withKey:(void*)ntvImageKey];
		//[currentImage release];
	[[self coverArtLayer] _setCoverArtImage:currentImage];
	
}

%new - (id)image
{
	
	return [self associatedValueForKey:(void*)ntvImageKey];
}

- (void)setAsset:(id)asset
{
	
	metaDataType = kMetaTypeDefault;
		// [self setMetaDataType:kMetaTypeDefault];
    %orig;
	
	[[self coverArtLayer] _setCoverArtImage:[asset coverArt]];
	
}
%new -(void)setAssetMeta:(id)asset
{
    [self setAsset:asset];
}


%new +(id)coverArtForPath
{
	
	return [[NSBundle bundleForClass:[self class]] pathForResource:@"ApplianceIcon" ofType:@"png"];
}



%new - (id)coverArtForPath
{
	
    if ([self image]!=nil)
        return [self image];
    [self setImage:[[self asset] coverArt]];
    if ([self image]!=nil)
        return [self image];
	return [%c(ntvMediaPreview) coverArtForPath];
}


%new - (void)_loadCoverArt
{
	
		//%orig;
	if([[self coverArtLayer] texture] != nil)
		return;
	
}

%new - (void)_populateMetadata
{
	
		//%orig;
	[self doPopulation];
}


- (void)_updateMetadataLayer
{
	
	%orig;
	[self doPopulation];
}

%new - (id)gimmieMetadataLayer
{
	
	return MSHookIvar<id>(self, "_metadataLayer");
}

%new - (void)doPopulation
{
	
    id metaLayer = [self gimmieMetadataLayer];
    switch (metaDataType) {
        case kMetaTypeDefault:
        {
            id asset = [self asset];
            if ([asset respondsToSelector:@selector(orderedDictionary)]) {
                NSDictionary *assetDict=[asset orderedDictionary];
                if([[assetDict allKeys] containsObject:NTV_META_TITLE])
                    [metaLayer setTitle:[assetDict objectForKey:NTV_META_TITLE]];
                if([[assetDict allKeys] containsObject:NTV_META_SUMMARY])
                    [metaLayer setSummary:[assetDict objectForKey:NTV_META_SUMMARY]];
                if([[assetDict allKeys] containsObject:NTV_META_CUSTOM_KEYS])
                {
					
                    [metaLayer setMetadata:[assetDict objectForKey:NTV_META_CUSTOM_OBJECTS] withLabels:[assetDict objectForKey:NTV_META_CUSTOM_KEYS]];
                }
            }
            break;
        }
        default:
        {
            [metaLayer setTitle:[[self meta] objectForKey:NTV_META_TITLE]];
            [metaLayer setSummary:[[self meta] objectForKey:NTV_META_SUMMARY]];
            break;
        }
			
    }
	
	
}


%new - (BOOL)_assetHasMetadata
{
	
	return YES;
}

	//@end

%end


