//
//  NSMFPhotoMediaAsset.h
//  SMFramework
//
//  Created by Thomas Cool on 2/15/11.
//  Copyright 2011 tomcool.org. All rights reserved.
//
#import "Backrow/AppleTV.h"

@interface NSMFPhotoMediaAsset : BRPhotoMediaAsset {
    NSString *__title;
}
-(NSString *)title;
-(void)setTitle:(NSString *)title;
-(id)initWithPath:(NSString *)path;

@end
