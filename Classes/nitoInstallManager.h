//
//  NitoInstallManager.h
//  nitoTV
//
//  Created by Kevin Bradley on 11/11/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//




@interface nitoInstallManager : nitoMediaMenuController <NSMFMoviePreviewControllerDelegate>{

	NSMutableArray		*_versions;
    NSString *          _imageName;
	NSMutableArray *updateArray;
	int _textEntryType;
	NSString *greenMileFile;
	id selectedObject;
	BOOL essentialUpgrade;
	NSMutableArray *queueArray;
	NSArray *_essentialArray;
	
	BOOL _alreadyCheckedUpdate;
	
}
@property(nonatomic, retain)id selectedObject;
@property(nonatomic, retain)NSMutableArray *queueArray;
@property(nonatomic, retain)NSArray *_essentialArray;
@property(assign, readwrite)BOOL essentialUpgrade;
@property(assign, readwrite)BOOL _alreadyCheckedUpdate;

+ (void)fixDepends;
- (void)fullUpgradeWithSender:(id)sender;
+ (NSArray *)nitoPackageArray;
- (void)runEssentialUpgrade:(NSString *)queueFile;
- (void)runNitoTVUpgrade; //deprecated, already!!
- (void)fullUpgrade;
- (void)packageSearch;
+ (NSString *)aptStatus;
- (NSString *)aptStatus;
- (void)installOptionSelected:(id)option;
- (void)showUpdateDialog:(NSNotification *)n;
- (void)showEssentialUpdateDialog:(NSArray *)theArray;
- (void)removeDialog:(NSString *)packageToRemove;
- (void)deleteOptionSelected:(id)option;
- (BOOL)leftAction:(long)theRow;
- (void)customRemoveActionNew:(id)theFile;
- (void)customRemoveAction:(id)theFile;
- (void)removeCustomFinal:(id)timer;
- (void)removeCustom:(NSString *)customFile;
-(id)removeFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback;
- (void)showProtectedAlert:(NSString *)protectedPackage;
- (BRAlertController *)_internetNotAvailable;
-(void)controller:(SMFMoviePreviewController *)c selectedControl:(BRControl *)ctrl;
+ (void)runConfigure;
+ (void)runAutoremove;
-(id)installFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback;


@end
