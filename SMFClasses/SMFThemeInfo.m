//
//  SMFThemeInfo.m
//  SMFramework
//
//  Created by Thomas Cool on 10/30/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//

#import "SMFThemeInfo.h"

#define BRSH objc_getClass("BRSoundHandler")
#define BRTI objc_getClass("BRThemeInfo")
#define BRI objc_getClass("BRImage")

static NSArray * colors=nil;
@implementation SMFThemeInfo
static SMFThemeInfo *sharedTheme = nil; 

+ (SMFThemeInfo *)sharedTheme 
{ 

	@synchronized(self) 
	{ 
		if (sharedTheme == nil) 
		{ 
			sharedTheme = [[self alloc] init]; 
		} 
	} 
	return sharedTheme; 
} 

+ (id)allocWithZone:(NSZone *)zone 
{ 
	@synchronized(self) 
	{ 
		if (sharedTheme == nil) 
		{ 
			sharedTheme = [super allocWithZone:zone]; 
            colors = [[NSArray arrayWithObjects:@"Black",@"Blue",@"Brown",@"Cyan",@"Dark Gray",@"Green",
                       @"Light Gray",@"Magenta",@"Orange",@"Purple",@"Red",@"White",@"Yellow",nil] retain];
			return sharedTheme; 
		} 
	} 
    
	return nil; 
} 
- (id)copyWithZone:(NSZone *)zone   { return self; } 
- (id)retain                        { return self; } 
- (NSUInteger)retainCount           { return NSUIntegerMax;}
- (void)release                     {} 
- (id)autorelease                   { return self; }
-(NSDictionary *)attributesWithoutShadowForAttributes:(NSDictionary *)attributes
{
    NSMutableDictionary *att = [[attributes mutableCopy] autorelease];
    [att setObject:(id)[self clearColor] forKey:@"BRShadowColor"];
    return att;
}

-(CGColorRef)colorWithRed:(float)r withGreen:(float)g withBlue:(float)b withAlpha:(float)a
{
    CGFloat myColor[] = {r, g, b, a};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(rgb, myColor);
    CGColorSpaceRelease(rgb);
    [(id)color autorelease];
    return color;
}
-(CGColorRef)colorFromHTMLColor:(int)c
{
    return [self colorWithRed:((c>>16)&0xFF)/255.0 withGreen:((c>>8)&0xFF)/255.0 withBlue:(c & 0xFF)/255.0 withAlpha:1.0];
}
static float red[]=  {0.0,0.0,0.6,0.0,0.33,0.0,0.66,1.0,1.0,0.5,1.0,1.0,1.0};
static float green[]={0.0,0.0,0.4,1.0,0.33,1.0,0.66,0.0,0.5,0.0,0.0,1.0,1.0};
static float blue[] ={0.0,1.0,0.2,1.0,0.33,0.0,0.66,1.0,0.0,0.5,0.0,1.0,0.0};
-(CGColorRef)blackColor
{
    return [self colorWithRed:red[0] withGreen:green[0] withBlue:blue[0] withAlpha:1.0];
}
-(CGColorRef)blueColor
{
    return [self colorWithRed:red[1] withGreen:green[1] withBlue:blue[1] withAlpha:1.0];
}
-(CGColorRef)brownColor
{
    return [self colorWithRed:red[2] withGreen:green[2] withBlue:blue[2] withAlpha:1.0];
}
-(CGColorRef)cyanColor
{
    return [self colorWithRed:red[3] withGreen:green[3] withBlue:blue[3] withAlpha:1.0];
}
-(CGColorRef)darkGrayColor
{
    return [self colorWithRed:red[4] withGreen:green[4] withBlue:blue[4] withAlpha:1.0];
}
-(CGColorRef)greenColor
{
    return [self colorWithRed:red[5] withGreen:green[5] withBlue:blue[5] withAlpha:1.0];
}
-(CGColorRef)lightGrayColor
{
    return [self colorWithRed:red[6] withGreen:green[6] withBlue:blue[6] withAlpha:1.0];
}
-(CGColorRef)magentaColor
{
    return [self colorWithRed:red[7] withGreen:green[7] withBlue:blue[7] withAlpha:1.0];
}
-(CGColorRef)orangeColor
{
    return [self colorWithRed:red[8] withGreen:green[8] withBlue:blue[8] withAlpha:1.0];
}
-(CGColorRef)purpleColor
{
    return [self colorWithRed:red[9] withGreen:green[9] withBlue:blue[9] withAlpha:1.0];
}
-(CGColorRef)redColor
{
    return [self colorWithRed:red[10] withGreen:green[10] withBlue:blue[10] withAlpha:1.0];
}
-(CGColorRef)whiteColor
{
    return [self colorWithRed:red[11] withGreen:green[11] withBlue:blue[11] withAlpha:1.0];
}
-(CGColorRef)yellowColor
{
    return [self colorWithRed:red[12] withGreen:green[12] withBlue:blue[12] withAlpha:1.0];
}
-(CGColorRef)clearColor
{
    return [self colorWithRed:0.0 withGreen:0.0 withBlue:0.0 withAlpha:0.0];
}
-(id)oneStar
{
    return [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:BRTI]pathForResource:@"stars1" ofType:@"png"]];
}
-(id)onePointFiveStars
{
    return [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:BRTI]pathForResource:@"stars1_5" ofType:@"png"]];
}
-(id)twoStars
{
    return [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:BRTI]pathForResource:@"stars2" ofType:@"png"]];
}
-(id)twoPointFiveStars
{
    return [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:BRTI]pathForResource:@"stars2_5" ofType:@"png"]];
}
-(id)threeStar
{
    return [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:BRTI]pathForResource:@"stars3" ofType:@"png"]];
}
-(id)threePointFiveStars
{
    return [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:BRTI]pathForResource:@"stars3_5" ofType:@"png"]];
}
-(id)fourStar
{
    return [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:BRTI]pathForResource:@"stars4" ofType:@"png"]];
}
-(id)fourPointFiveStars
{
    return [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:BRTI]pathForResource:@"stars4_5" ofType:@"png"]];
}
-(id)fiveStars
{
    return [objc_getClass("BRImage") imageWithPath:[[NSBundle bundleForClass:BRTI]pathForResource:@"stars5" ofType:@"png"]];
}
enum{
    kBRSelectSoundInt   =1,
    kBRMenuSoundInt     =2,
    kBRNavigateSoundInt =15,
    kBRErrorSoundInt    =18
};
-(void)playSelectSound
{
    [BRSH playSound:kBRSelectSoundInt];
}
-(void)playMenuSound
{
    [BRSH playSound:kBRMenuSoundInt];
}
-(void)playNavigateSound
{
    [BRSH playSound:kBRNavigateSoundInt];
}
-(void)playErrorSound
{
    [BRSH playSound:kBRErrorSoundInt];
}
@end
