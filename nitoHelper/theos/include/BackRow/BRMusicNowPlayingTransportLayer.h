/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/BackRow.framework/BackRow
 */

#import "BackRow-Structs.h"
#import "BRControl.h"

@class NSDictionary;

__attribute__((visibility("hidden")))
@interface BRMusicNowPlayingTransportLayer : BRControl {
@private
	NSDictionary *_textAttributes;	// 40 = 0x28
	float _percent;	// 44 = 0x2c
	float _duration;	// 48 = 0x30
	float _elapsedTime;	// 52 = 0x34
	float _timeTextWidth;	// 56 = 0x38
	float _fillLayerHeight;	// 60 = 0x3c
	float _fillLayerWidth;	// 64 = 0x40
	float _playHeadHeight;	// 68 = 0x44
	float _ordinaryTimeTextWidth;	// 72 = 0x48
	BOOL _flip;	// 76 = 0x4c
	BOOL _isRadio;	// 77 = 0x4d
}
@property(readonly, assign) float duration;	// G=0x315f275d; converted property
@property(readonly, assign) float elapsedTime;	// G=0x315f274d; converted property
- (id)init;	// 0x315baa6d
- (void)_layoutRadioSublayers;	// 0x315f27dd
- (void)dealloc;	// 0x315bc00d
// converted property getter: - (float)duration;	// 0x315f275d
// converted property getter: - (float)elapsedTime;	// 0x315f274d
- (void)layoutSubcontrols;	// 0x315f2939
- (void)setElapsedTime:(float)time andDuration:(float)duration;	// 0x315bb659
- (void)setFlip:(BOOL)flip;	// 0x315f277d
- (void)setIsRadio:(BOOL)radio;	// 0x315f276d
- (void)setPercentage:(float)percentage;	// 0x315bb845
- (void)setTextAttributes:(id)attributes;	// 0x315f27a5
@end

