#define NTV_META_IMAGE_URL      @"ImageURL"
#define NTV_META_TITLE          @"Name"
#define NTV_META_SUMMARY        @"Summary"
#define NTV_META_CUSTOM_KEYS    @"KeysArray"
#define NTV_META_CUSTOM_OBJECTS @"ObjectsArray"

typedef enum {
    kMetaTypePlug=0,
    kMetaTypeCust=1,
    kMetaTypeSimp=2,
    kMetaTypeDefault=3,
} ntvMetaType;


@interface ntvMediaPreview : BRMetadataPreviewControl{
	NSMutableDictionary			*meta;
	ntvMetaType                MetaDataType;
	BRImage                     *image;

}

- (id)coverArtForPath;
- (void)setImage:(BRImage *)currentImage;


@end

@interface ntvMediaPreview (Private)
- (void)doPopulation;
- (NSString *)coverArtForPath;
@end
