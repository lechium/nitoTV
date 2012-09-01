
#import "nitoWeather.h"
#import "nitoWeatherController.h"
#import "APXML.h"
//#import "nitoMediaMenuController.h"
@class BRControl, BRHeaderControl;

@interface ntvWeatherManager : nitoMediaMenuController
{
	int _stackPosition;
	id	_parentController;
	//NSMutableArray		*_names;
	NSMutableArray		*_locations;
	NSMutableArray		*_units;
	NSMutableArray      *_locationDicts;
	NSMutableDictionary	*_globalDict;
    NSString *          _imageName;
	int					_listState;
	NSString				*_mainTitle;
	id				theController;
	NSMutableData					*loginReturnData;
	NSArray				*tempWeatherArray;
	nitoWeather			*currentNitoWeather;
	int					progressRow;
	
}
- (nitoWeather *)currentNitoWeather;
- (void)setCurrentNitoWeather:(nitoWeather *)value;

- (id)globalDict;

- (NSArray *)tempWeatherArray;
- (void)setTempWeatherArray:(NSArray *)value;
- (BOOL)mediaPreviewShouldShowMetadata;
+ (NSString *) rootMenuLabel;
- (id)parentController;
- (void)setParentController:(id)value;
+(NSDictionary *)parseYahooRSS:(APDocument*)apDoc;
- (id) init;
- (id) initWithArray: (NSArray *) inputArray state: (int) listState andTitle:(NSString *)theTitle;
- (void) dealloc;
- (id) ogpreviewControlForItem: (long) item;
- (long) controlCount;
- (id) controlAtIndex: (long) row requestedBy:(id)fp12;
- (id) previewControlForItem: (long) row;
- (void) itemSelected: (long) row;
- (void)refresh;
@end
