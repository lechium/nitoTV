/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/BackRow.framework/BackRow
 */

#import "BRImageProxy.h"

@class BRXMLMediaAsset;

__attribute__((visibility("hidden")))
@interface BRXMLImageProxy : NSObject <BRImageProxy> {
@private
	BRXMLMediaAsset *_asset;	// 4 = 0x4
}
+ (id)imageProxyForAsset:(id)asset;	// 0x315d0f95
- (id)initWithAsset:(id)asset;	// 0x315d14c9
- (void)cancelImageRequestsForImageSizes:(int)imageSizes;	// 0x315d0e3d
- (void)dealloc;	// 0x315d1481
- (id)defaultImageForImageSize:(int)imageSize;	// 0x315d0eb1
- (id)imageForImageSize:(int)imageSize;	// 0x315d0ef5
- (id)imageIDForImageSize:(int)imageSize;	// 0x315d0f45
- (id)object;	// 0x315d0e41
- (BOOL)supportsImageForImageSize:(int)imageSize;	// 0x315d0e51
@end

