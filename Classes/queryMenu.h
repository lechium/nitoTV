//
//  SMFQueryMenu.h
//  SMFramework
//
//  Created by Thomas Cool on 11/5/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//

//#import "SMFramework.h"
#import "PackageDataSource.h"

enum  {
	
	kNTVQueryStopped = 400,
	kNTVQueryStarted,
	kNTVQueryFinished,
	kNTVQueryFailed,
};

@class queryMenu;
@protocol QueryDelegate

-(void)queryMenu:(queryMenu *)q itemSelected:(NSString *)it;

@end
@interface queryMenu : BRMediaMenuController <NSMFMoviePreviewControllerDelegate> {
    BRTextEntryControl  * _entryControl;
	BRImageControl		* _arrowImage;
    NSMutableArray      * _names;
	NSMutableArray		* _descriptions;
	NSMutableArray		* _infos;
    //NSMutableArray      * _filteredArray;
	NSString			* _latestQuery;
    id<QueryDelegate>  _delegate;
	BOOL				editorShowing;
	int					searchState;
	id selectedObject;
	BOOL				isEdged;
}

@property (nonatomic, retain) NSString *_latestQuery;
@property (readwrite, assign) int searchState;
@property(nonatomic, retain)id selectedObject;
@property(readwrite, assign)BOOL isEdged;
-(void)setDelegate:(id<QueryDelegate>)d;
-(id<QueryDelegate>)delegate;
-(BOOL)is50;
- (void) textDidChange: (id) sender;
+ (NSString *)properVersion;
-(NSArray *)names;
-(void)_hideEditor;
-(void)showEditorSelectingGylph:(id)selectedGlyph;
-(void)searchForPackage:(NSString *)customFile;
-(void)updateList:(NSNotification *)n;
-(void)updateCustomFinal:(id)timer;
-(void)updateCustom:(NSString *)customFile;
-(id)installFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback;
-(void)controller:(SMFMoviePreviewController *)c selectedControl:(BRControl *)ctrl;
- (BOOL)packageInstalled:(NSString *)currentPackage;
- (NSDictionary *)parsedPackageList;
- (NSArray *)untoucables;
- (BOOL)canRemove:(NSString *)theItem;
- (void)showProtectedAlert:(NSString *)protectedPackage;
- (void)customRemoveActionNew:(id)theFile;
- (void)removeCustomFinal:(id)timer;
- (void)removeCustom:(NSString *)customFile;
-(id)removeFinishedWithStatus:(int)termStatus andFeedback:(NSString *)theFeeback;
@end



