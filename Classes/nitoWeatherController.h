
#import "nitoWeather.h"

enum 
{
	ntvCreateWeatherPoint = 0,
	ntvEditWeatherPoint = 1,
	
};
typedef int ntvWeatherMode;


@interface nitoWeatherController : BRMediaMenuController
{
	ntvWeatherMode			weatherMode;
	NSMutableDictionary		*weatherDictionary;
	int						_stackPosition;
	id		_parentController;
	NSMutableArray			*_things; //menu items in the main menu
    NSString				*_imageName;
	
	id						theController;
	NSString				*weatherKey;
	long					_currentRow;
	int _kbType;
}
- (id)parentController;
- (void)setParentController:(id)value; 
- (long)currentRow;
- (void)setCurrentRow:(long)value;

- (NSString *)weatherKey;
- (void)setWeatherKey:(NSString *)value;

- (ntvWeatherMode)weatherMode;
- (void)setWeatherMode:(ntvWeatherMode)value;

- (NSMutableDictionary *)weatherDictionary;

+ (NSString *) rootMenuLabel;
- (id) init;
- (id) initWithWeather:(NSDictionary *)weatherPoint withMode:(ntvWeatherMode)theMode;
- (void) dealloc;

- (long) controlCount;
- (id) controlAtIndex: (long) row requestedBy:(id)fp12;
- (id) previewControlForItem: (long) row;
- (void) itemSelected: (long) row;

@end
