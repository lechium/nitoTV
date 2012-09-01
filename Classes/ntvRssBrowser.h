
#import "ntvRssDelegate.h"
#import "nitoRss.h"
#import "nitoRssController.h"

@class  BRControl, BRHeaderControl;

@interface ntvRssBrowser : nitoMediaMenuController
{
	
	int _stackPosition;
	id	_parentController;
	//NSMutableArray		*_names;
	NSMutableArray		*_locations;
	NSMutableArray      *_locationDicts;
	NSMutableDictionary	*_globalDict;
    NSString *          _imageName;
	int					_listState;
	NSString				*_mainTitle;
	id				theController;
	NSMutableData					*loginReturnData;
	nitoRss							*currentNitoRss;
}
- (nitoRss *)currentNitoRss;
- (void)setCurrentNitoRss:(nitoRss *)value;
- (BOOL)mediaPreviewShouldShowMetadata;
+ (NSString *) rootMenuLabel;
- (id)parentController;
- (void)setParentController:(id)value;

- (id) init;
- (id) initWithArray: (NSArray *) inputArray state: (int) listState andTitle:(NSString *)theTitle;
- (void) dealloc;

- (long) controlCount;
- (id) controlAtIndex: (long) row requestedBy:(id)fp12;
- (id) previewControlForItem: (long) row;
- (void) itemSelected: (long) row;
- (void)refresh;
- (id)globalDict;

- (void)finishRssWithArray:(NSArray *)inputArray withMainTitle:(NSString *)theTitle;
@end
