//
//  nitoSourceController.h
//  nitoTV
//
//  Created by Kevin Bradley on 9/20/11.
//  Copyright 2011 nito, LLC. All rights reserved.
//


enum  {
	
	kNTVConnectionPackagesCheck = 1,
	kNTVConnectionPackagesBZ2Check,
	kNTVSourcesListMode,
	kNTVSourceBrowseMode,
	kNTVSourceMissingDefaultsMode,
};


@interface nitoSourceController : nitoMediaMenuController <SMFMoviePreviewControllerDelegate> {

	NSArray						*sourceArray;
	NSString					*potentialSource;
	int							connectionMode;
	int							listMode;
	NSURLConnection *           _connection;
	int							_validSourceCheck;
	NSDictionary				*currentRepo;
	id							selectedObject;
	BOOL						processing;
	int							progressIndex;
	NSArray						*missingDomains;
	BOOL						missingDefaults;

}
@property(nonatomic, retain)id selectedObject;
@property (nonatomic, retain) NSArray *sourceArray;
@property (nonatomic, retain) NSArray *missingDomains;
@property (nonatomic, retain) NSString *potentialSource;
@property (readwrite, assign) int connectionMode;
@property (readwrite, assign) int listMode;
@property (readwrite, assign) int progressIndex;
@property (readwrite, assign) BOOL processing;
@property (readwrite, assign) BOOL missingDefaults;
@property (nonatomic, retain) NSDictionary *currentRepo;

- (id)initWithTitle:(NSString *)theTitle andSources:(NSArray *)sources;
- (id)initWithTitle:(NSString *)theTitle andSources:(NSArray *)sources inMode:(int)theListMode;
- (NSString *)currentRepoString;
- (void)_processSources;
- (void)_processList;
- (NSArray *)bzipMimeArray;
- (id)previewControlForSourceRow:(long)item;
+ (NSArray *)untouchableSources;
- (BOOL)canRemoveSource:(NSString *)theSource;
- (void)removeDialog:(NSDictionary *)sourceToRemove;
- (void)deleteOptionSelected:(id)option;
- (void)removeSource:(NSDictionary *)theSource;
- (void)finishRemovingSource:(id)timer;
- (id)previewControlForPackageRow:(long)item;
- (void)promptForSource;
- (void)processRepoThreaded:(id)theRepo;
- (void)listFinished:(NSNotification *)n;
- (void)finishAddingSource:(id)timer;
- (void)addSource:(NSString *)theSource;
- (void)showProtectedAlert:(NSString *)protectedPackage;

@end
