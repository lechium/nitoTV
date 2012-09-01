//
//  nitoMediaMenuController.h
//  nitoTV2
//
//  Created by Kevin Bradley on 10/26/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//


#import <BackRow/BackRow.h>

@interface nitoMediaMenuController : BRMediaMenuController {

		NSMutableArray		*_names;
}

-(id)initWithTitle:(NSString *)theTitle;
- (int)getSelection;
- (BOOL)brEventAction:(id)fp8;
- (void)setSelection:(int)sel;
- (BOOL)leftAction:(long)theRow;
- (BOOL)rightAction:(long)theRow;
- (id) controlAtIndex: (long) row requestedBy:(id)fp12;
@end
