/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/BackRow.framework/BackRow
 */

#import "BackRow-Structs.h"
#import "BRControl.h"

@class NSMutableArray, BRImage, BRImageControl, BRTextControl;

@interface BRHorizontalSegmentedWidget : BRControl {
@private
	BRImage *_leftImage;	// 40 = 0x28
	BRImage *_centerImage;	// 44 = 0x2c
	BRImage *_rightImage;	// 48 = 0x30
	BRTextControl *_textControl;	// 52 = 0x34
	BRImageControl *_leftEndLayer;	// 56 = 0x38
	NSMutableArray *_centerLayers;	// 60 = 0x3c
	BRImageControl *_rightEndLayer;	// 64 = 0x40
	float _animationDuration;	// 68 = 0x44
	BOOL _animationEnabled;	// 72 = 0x48
	int _numSegments;	// 76 = 0x4c
}
@property(assign) float animationDuration;	// G=0x31609259; S=0x316095f1; converted property
@property(retain) id attributedString;	// G=0x31609511; S=0x31609531; converted property
@property(readonly, retain) BRImage *centerImage;	// G=0x31609239; converted property
@property(readonly, retain) NSMutableArray *centerLayers;	// G=0x31609299; converted property
@property(readonly, retain) BRImageControl *leftEndLayer;	// G=0x31609289; converted property
@property(readonly, retain) BRImage *leftImage;	// G=0x31609229; converted property
@property(readonly, retain) BRImageControl *rightEndLayer;	// G=0x316092a9; converted property
@property(readonly, retain) BRImage *rightImage;	// G=0x31609249; converted property
@property(assign) BOOL sublayerAnimationEnabled;	// G=0x31609279; S=0x31609269; converted property
- (id)init;	// 0x315af8f9
- (void)_reloadSegments;	// 0x316092b9
// converted property getter: - (float)animationDuration;	// 0x31609259
// converted property getter: - (id)attributedString;	// 0x31609511
// converted property getter: - (id)centerImage;	// 0x31609239
- (id)centerLayer;	// 0x316094ed
// converted property getter: - (id)centerLayers;	// 0x31609299
- (void)dealloc;	// 0x315b3c01
- (void)layoutSubcontrols;	// 0x316098d9
// converted property getter: - (id)leftEndLayer;	// 0x31609289
// converted property getter: - (id)leftImage;	// 0x31609229
// converted property getter: - (id)rightEndLayer;	// 0x316092a9
// converted property getter: - (id)rightImage;	// 0x31609249
// converted property setter: - (void)setAnimationDuration:(float)duration;	// 0x316095f1
// converted property setter: - (void)setAttributedString:(id)string;	// 0x31609531
- (void)setLeftFile:(id)file centerFile:(id)file2 rightFile:(id)file3;	// 0x315af939
- (void)setLeftImage:(id)image centerImage:(id)image2 rightImage:(id)image3;	// 0x315af9f1
- (void)setNumSegments:(int)segments;	// 0x31609735
// converted property setter: - (void)setSublayerAnimationEnabled:(BOOL)enabled;	// 0x31609269
- (void)setText:(id)text withAttributes:(id)attributes;	// 0x31609761
- (CGSize)sizeThatFits:(CGSize)fits;	// 0x316097e1
// converted property getter: - (BOOL)sublayerAnimationEnabled;	// 0x31609279
@end

