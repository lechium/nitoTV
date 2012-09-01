//
//  nitoFilesController.h
//  nitoTV
//
//  Created by Kevin Bradley on 10/13/10.

#import "ntvMedia.h"
#import "ntvMediaPreview.h"

@interface nitoFilesController : BRMediaMenuController {
	NSMutableArray *_menuItems;
	NSMutableArray		*_names;
	NSMutableArray		*_versions;
    NSString *          _imageName;
	NSMutableArray *updateArray;
}
//list provider
- (float)heightForRow:(long)row;
- (long)itemCount;
- (id)itemForRow:(long)row;
- (BOOL)rowSelectable:(long)selectable;
- (id)titleForRow:(long)row;

@end
