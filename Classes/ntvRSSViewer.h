//
//  ntvRSSViewer.h
//  maintenance
//
//  Created by kevin bradley on 7/11/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//



@class BRHeaderControl, BRTextControl, BRController, BRControl, CALayer,BRImageControl;

@interface ntvRSSViewer : BRController {
	

    BRHeaderControl *       _header;
	NSString		*		_theTitle;
    BRTextControl *         _sourceText;
	BRTextControl *			_primaryInfoText;
	BRTextControl *			_secondInfoText;
	BRTextControl *			_labelTextControl;
	BRImageControl*			_previousPageImage;
	BRImageControl*			_nextPageImage;
	NSString	  *			_labelText;
	NSDictionary *rssDict;
	NSString      *pageOne;
	NSString	  *pageTwo;

}
- (NSString *)pageOne;
- (void)setPageOne:(NSString *)value;

- (NSString *)pageTwo;
- (void)setPageTwo:(NSString *)value;


- (NSString *)labelText;
- (void)setLabelText:(NSString *)value;

	//-(CGRect)frame;
@end
