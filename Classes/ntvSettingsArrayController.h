
enum
{
	kNTVSectionArray = 770,
};

@interface ntvSettingsArrayController : nitoMediaMenuController
{
	int					_currentType;
	int					_kbType;
	int					_currentRow;
}

- (id) initWithTitle:(NSString *)theTitle withType:(int)sType;
@end
