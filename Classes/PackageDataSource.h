//
//  PackageDataSource.h
//  nitoTV
//
//  Created by Kevin Bradley on 2/26/11.
//  Copyright 2011 nito, LLC. All rights reserved.
//

#import "packageManagement.h"
enum  {
	
	kPKGFavoritesListMode,
	kPKGSearchListMode,
	kPKGDependListMode,
	kPKGRepoListMode,
	kPKGInstalledListMode,
	
};

enum {

	kPackageInstallMode,
	KPackageRemoveMode,
};

enum buttons {
	
	kNitoInstallButton = 0,
	kNitoQueueButton,
	kNitoRemoveButton,
	kNitoMoreButton,
};


@interface PackageDataSource : SMFMoviePreviewController <SMFMoviePreviewControllerDelegate, SMFMoviePreviewControllerDatasource> {

	NSDictionary *packageData;
	NSString	 *imageURL;
	int			currentMode;
	BRImage		*rawCoverArt;
	id			provider;
	BOOL		installed;
	int			listActionMode;	

	
}

@property (nonatomic, retain) NSDictionary *packageData;
@property (nonatomic, retain) NSString *imageURL;
@property (readwrite, assign) int currentMode;
@property (readwrite, assign) int listActionMode;
@property (nonatomic, assign) BRImage *rawCoverArt;
@property (nonatomic, retain) id provider;
@property (readwrite, assign) BOOL installed;

-(NSString *)title;
-(NSString *)subtitle;
-(NSString *)summary;
-(NSArray *)headers;
-(NSArray *)columns;
-(NSString *)rating;
-(BRImage *)coverArt;
-(BRPhotoDataStoreProvider *)providerForShelf;

-(void)controller:(SMFMoviePreviewController *)c selectedControl:(BRControl *)ctrl;
- (id)initWithPackageInfo:(NSDictionary *)packageInfo;
- (void)removeQueuePopupWithPackage:(NSString *)thePackage;
- (void)queuePopupWithPackage:(NSString *)thePackage;
- (long)popupItemCount;
- (id)popupItemForRow:(long)row;
- (void)popup:(id)p itemSelected:(long)row;
- (NSArray *)installedDataStore;
- (NSArray *)favoriteDataStore;
- (NSArray *)repoDataStore;
-(NSString *)shelfTitle;

- (void)installQueue:(NSString *)queueFile;
- (void)removePackage:(NSString *)customFile;
- (void)newUberInstaller:(NSString *)customFile;
- (void)showPopupFrom:(id)me;
- (void)updatePackageData:(NSString *)packageId usingImage:(id)theImage;
- (void)installQueue:(NSString *)queueFile withSender:(id)sender;
- (void)newUberInstaller:(NSString *)customFile withSender:(id)sender;
- (id)initWithPackage:(NSString *)packageId usingImage:(id)theImage;
- (void)showPopupFrom:(id)me withSender:(id)sender;
- (void)removePackage:(NSString *)customFile withSender:(id)sender;
@end
