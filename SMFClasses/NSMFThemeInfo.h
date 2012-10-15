//
//  NSMFThemeInfo.h
//  SMFramework
//
//  Created by Thomas Cool on 10/30/10.
//  Copyright 2010 tomcool.org. All rights reserved.
//
//#import "Backrow/AppleTV.h"
//#import "SynthesizeSingleton.h"
/**
 *Convenience Methods with images, colors, logos, sounds and more
 */
@interface NSMFThemeInfo : NSObject {

}
///---------------------------------------------------------------------------------------
/// @name Getting the Shared Object
///---------------------------------------------------------------------------------------
/**
 *Creates a shared instance (singleton).. no need to release or retain.
 */
+(NSMFThemeInfo *)sharedTheme;


///---------------------------------------------------------------------------------------
/// @name Colors
///---------------------------------------------------------------------------------------
/**
 *@return a CGColorRef representation to a black color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)blackColor;
/**
 *@return a CGColorRef representation to a blue color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)blueColor;
/**
 *@return a CGColorRef representation to a brown color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)brownColor;
/**
 *@return a CGColorRef representation to a cyan color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)cyanColor;
/**
 *@return a CGColorRef representation to a dark gray color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)darkGrayColor;
/**
 *@return a CGColorRef representation to a green color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)greenColor;
/**
 *@return a CGColorRef representation to a light gray color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)lightGrayColor;
/**
 *@return a CGColorRef representation to a magenta color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)magentaColor;
/**
 *@return a CGColorRef representation to a orange color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)orangeColor;
/**
 *@return a CGColorRef representation to a purple color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)purpleColor;
/**
 *@return a CGColorRef representation to a red color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)redColor;
/**
 *@return a CGColorRef representation to a white color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)whiteColor;
/**
 *@return a CGColorRef representation to a yellow color
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)yellowColor;
/**
 *@return a CGColorRef representation to a transparent color (alpha=0)
 *@see colorWithRed:withGreen:withBlue:withAlpha:
 */
-(CGColorRef)clearColor;


/**
 *Method used to easily create CGColorRef
 *
 *Note CGColorRef has toll free bridging to NSColor (not available on iOS) 
 *but you can still call `retain`, `release` and `autorelease` on it. You can also
 *store it in an array or dictionary, but it is best if it is cast to `id` first to avoid
 *compiler warnings
 *
 *@param r float value for red 0.0&lt;r&lt;1.0
 *@param g float value for green `0.0&lt;g&lt;1.0`
 *@param b float value for blue `0.0&lt;b&lt;1.0`
 *@param a float value for alpha (transparency) `0.0&lt;a&lt;1.0`
 *@return autoreleased CGColorRef
 */
-(CGColorRef)colorWithRed:(float)r withGreen:(float)g withBlue:(float)b withAlpha:(float)a;

/**
 *Creates a color from the html color format
 *
 *@param n a positive integer representing the color
 *@return autoreleased CGColorRef
 */
-(CGColorRef)colorFromHTMLColor:(int)n;
///-----
/// @name Attributes
///-----

/**
 *removes the shadow from the attributes
 *
 *In fact, this method, creates an autoreleased copy of the attributes dictionary and returns a 
 *NSDictionary where `BRShadow` is set to `[[NSMFThemeInfo sharedTheme]clearColor]`
 *
 *@param attributes the attributes to use as base
 *@return autoreleased dictionary with BRShadow se
 */
-(NSDictionary *)attributesWithoutShadowForAttributes:(NSDictionary *)attributes;

///---------------------------------------------------------------------------------------
/// @name Stars
///---------------------------------------------------------------------------------------
/*
 *  Convenience methods for the BRTheme Info Stars
 */
/**
 *Orange 1 out of 5 stars image
 *@return BRImage with one stars out of 5 colored
 */
-(id)oneStar;
/**
 *Orange 1.5 out of 5 stars image
 *@return BRImage with 1.5 stars out of 5 colored
 */
-(id)onePointFiveStars;
/**
 *Orange 2 out of 5 stars image
 *@return BRImage with 2 stars out of 5 colored
 */
-(id)twoStars;
/**
 *Orange 2.5 out of 5 stars image
 *@return BRImage with 2.5 stars out of 5 colored
 */
-(id)twoPointFiveStars;
/**
 *Orange 3 out of 5 stars image
 *@return BRImage with 3 stars out of 5 colored
 */
-(id)threeStar;
/**
 *Orange 3.5 out of 5 stars image
 *@return BRImage with 3.5 stars out of 5 colored
 */
-(id)threePointFiveStars;
/**
 *Orange 4 out of 5 stars image
 *@return BRImage with 4 stars out of 5 colored
 */
-(id)fourStar;
/**
 *Orange 4.5 out of 5 stars image
 *@return BRImage with 4.5 stars out of 5 colored
 */
-(id)fourPointFiveStars;
/**
 *Orange 5 out of 5 star image
 *@return BRImage with 5 stars out of 5 colored
 */
-(id)fiveStars;

///---------------------------------------------------------------------------------------
/// @name Sound
///---------------------------------------------------------------------------------------
/**
 *Play normal select button sound
 */
-(void)playSelectSound;
/**
 *Play normal menu button sound
 */
-(void)playMenuSound;
/**
 *Play navigation sound
 */
-(void)playNavigateSound;
/**
 *Play Error sound
 */
-(void)playErrorSound;
@end
