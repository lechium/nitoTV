//
//  awkScreenShot.m
//  nitoTV
//
//  Created by Kevin Bradley on 10/28/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

#import "awkScreenShot.h"


@implementation awkScreenShot


+(void)awkSaveScreenToFile:(NSString *)path
{
    CGSize screenSize = [BRWindow maxBounds];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef ctx = CGBitmapContextCreate(nil, screenSize.width, screenSize.height, 8, 4*(int)screenSize.width, colorSpaceRef, kCGImageAlphaPremultipliedLast);
    CALayer *c = [BRWindow rootLayer];
	//[[[[BRApplicationStackManager singleton] stack] peekController] layer];
   // CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    //CGColorRef col = CGColorCreate(rgb, (CGFloat[]){ 0, 0, 0, 1 });
    //c.backgroundColor=col;
    [c renderInContext:ctx];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    //c.backgroundColor=nil;
    UIImage  *img2 = [UIImage imageWithCGImage:cgImage];
    [UIImagePNGRepresentation(img2) writeToFile:path atomically:YES];
    
}
	//[[[[[[[[BRApplicationStackManager singleton] stack] peekController] controls] objectAtIndex:0] controls] objectAtIndex:0] controls];
	//
@end

	//[[[BRApplicationStackManager singleton] stack] _dumpFocusTree]
	//[[[BRApplicationStackManager singleton] stack] _dumpControlTree]


