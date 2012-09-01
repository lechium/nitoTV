#import "nitoRss.h"
#import "ntvRssBrowser.h"
//#import "nitoKB.h"

enum 
{
	ntvCreateRSSPoint = 0,
	ntvEditRSSPoint = 1,
	
};
typedef int ntvRssMode;


@interface nitoRssController : BRMediaMenuController
{
	
	ntvRssMode			rssMode;
	NSMutableDictionary		*rssDictionary;
	int						_stackPosition;
	id						_parentController;
	NSMutableArray			*_things; //menu items in the main menu
    NSString				*_imageName;
	
	id						theController;
	NSString				*rssKey;
	long					_currentRow;
	int _kbType;
}

- (long)currentRow;
- (void)setCurrentRow:(long)value;

- (NSString*)rssKey;
- (void)setRssKey:(NSString *)value;

- (ntvRssMode)rssMode;
- (void)setRssMode:(ntvRssMode)value;

- (NSMutableDictionary *)rssDictionary;

+ (NSString *) rootMenuLabel;
- (id)parentController;
- (void)setParentController:(id)value;

- (id) init;
- (id) initWithRss:(NSDictionary *)rssPoint withMode:(ntvRssMode)theMode;
- (void) dealloc;

- (long) controlCount;
- (id) controlAtIndex: (long) row requestedBy:(id)fp12;
- (id) previewControlForItem: (long) row;
- (void) itemSelected: (long) row;

@end
