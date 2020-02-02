//
//  Extensions.h
//  nitoTV2
//
//  Created by Kevin Bradley on 10/17/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//

#import "ATVVersionInfo.h"
#import "../Classes/nitoMediaMenuController.h"
#import "../Classes/NitoTheme.h"
#import "../Classes/nitoDefaultManager.h"


#define LogSelf NSLog(@"%@ %s", self, _cmd)
#define FR_PREF [BRPreferences sharedFrontRowPreferences]
#define LAST_UPDATE_CHECK @"lastSelfUpdateCheck"
#define NOTIFICATION_HOOKS @"notificationHooks"
#define UPDATE_CHECK_FREQUENCY @"updateCheckFrequency"
#define ESSENTIAL_PREDICATE @"(SELF CONTAINS[c] Essential) OR (Tag contains[c] 'essential') OR (Priority == 'required') or (Package == 'com.nito.nitotv')"
#define TEMP_PREDICATE2 @"(SELF CONTAINS[c] Essential) OR (Tag contains[c] 'essential')"
#define POTENTIALLY_USEFUL_PREDICATE  @"(Section == 'Utilities') OR (Section == 'System') OR (Section == 'Development')"

#define SECTION_LIST @"sectionList"


#define HOUR_MINUTES	60
#define DAY_MINUTES		1440
#define WEEK_MINUTES	10080

	//sounds

/*
 
 [BRSoundHandler playSound:0] = pop sound (popping off a controller from menu)
 [BRSoundHandler playSound:1] = push sound (pushing a new controller on the stack from select/play)
 [BRSoundHandler playSound:15] = item navigation (left right up down)
 [BRSoundHandler playSound:16] = fail sound (also 17 and 18)
 
 */
#define PLAY_POP_SOUND [BRSoundHandler playSound:0]
#define PLAY_PUSH_SOUND [BRSoundHandler playSound:1]
#define PLAY_NAV_SOUND [BRSoundHandler playSound:15]
#define PLAY_FAIL_SOUND [BRSoundHandler playSound:16]
 

enum {

	kTVDebSearchTextEntry = 400,
	kTVDebPackageTextEntry,
};

enum {

	kBRMenuItem = 0,
	kBRFolderMenuItem,
	kBRShuffleMenuItem,
	kBRRefreshMenuItem,
	kBRSyncMenuItem,
	kBRLockMenuItem,
	kBRProgressMenuItem,
	kBRDownloadMenuItem,
	kBRComputerMenuItem,

};

@interface BRController (specialAdditions)

- (id)subControlFromClassString:(NSString *)classString;

@end


@implementation BRController (specialAdditions)

- (id)subControlFromClassString:(NSString *)classString
{
	NSEnumerator *controlEnum = [[self controls] objectEnumerator];
	id current = nil;
	while ((current = [controlEnum nextObject]))
	{
		NSString *currentClass = NSStringFromClass([current class]);
		if ([currentClass isEqualToString:classString])
		{
			return current;
		}
	}
}



@end



@interface BRThemeInfo (specialAdditions)

- (id)myMenuItemTextAttributes;

@end

@implementation BRThemeInfo (specialAdditions)

- (id)myMenuItemTextAttributes
{
	NSMutableDictionary *startDict = [[NSMutableDictionary alloc] initWithDictionary:[[BRThemeInfo sharedTheme] menuItemTextAttributes]];
	[startDict setObject:@"Progbot" forKey:@"BRFontName"];
	return [startDict autorelease];
}

@end

@interface BRMenuItem (specialAdditions)

+(BRMenuItem *)ntvMenuItem;
+(BRMenuItem *)ntvFolderMenuItem;
+(BRMenuItem *)ntvShuffleMenuItem;
+(BRMenuItem *)ntvRefreshMenuItem;
+(BRMenuItem *)ntvSyncMenuItem;
+(BRMenuItem *)ntvLockMenuItem;
+(BRMenuItem *)ntvProgressMenuItem;
+(BRMenuItem *)ntvDownloadMenuItem;
+(BRMenuItem *)ntvComputerMenuItem;

@end

@implementation BRMenuItem (specialAdditions)



+ (BRMenuItem *)ntvMenuItem
{
	BRMenuItem *object = [[BRMenuItem alloc] init];
	[object addAccessoryOfType:kBRMenuItem];
	return [object autorelease];
}

+(BRMenuItem *)ntvFolderMenuItem

{
	BRMenuItem *object = [[BRMenuItem alloc] init];
	[object addAccessoryOfType:kBRFolderMenuItem];
	return [object autorelease];
	
}

+ (BRMenuItem *)ntvShuffleMenuItem
{
	BRMenuItem *object = [[BRMenuItem alloc] init];
	[object addAccessoryOfType:kBRShuffleMenuItem];
	return [object autorelease];
}

+ (BRMenuItem *)ntvRefreshMenuItem
{
	BRMenuItem *object = [[BRMenuItem alloc] init];
	[object addAccessoryOfType:kBRRefreshMenuItem];
	return [object autorelease];
}

+ (BRMenuItem *)ntvSyncMenuItem
{
	BRMenuItem *object = [[BRMenuItem alloc] init];
	[object addAccessoryOfType:kBRSyncMenuItem];
	return [object autorelease];
}

+ (BRMenuItem *)ntvLockMenuItem
{
	BRMenuItem *object = [[BRMenuItem alloc] init];
	[object addAccessoryOfType:kBRLockMenuItem];
	return [object autorelease];
}

+ (BRMenuItem *)ntvProgressMenuItem
{
	BRMenuItem *object = [[BRMenuItem alloc] init];
	[object addAccessoryOfType:kBRProgressMenuItem];
	[object addAccessoryOfType:kBRFolderMenuItem];
	return [object autorelease];
}

+ (BRMenuItem *)ntvDownloadMenuItem
{
	BRMenuItem *object = [[BRMenuItem alloc] init];
	[object addAccessoryOfType:kBRDownloadMenuItem];
	return [object autorelease];
}

+ (BRMenuItem *)ntvComputerMenuItem;
{
	BRMenuItem *object = [[BRMenuItem alloc] init];
	[object addAccessoryOfType:kBRComputerMenuItem];
	return [object autorelease];
}


@end

@interface NSString (specialAdditions)

+ (NSString *)flattenHTML:(NSString *)html;
+ (NSString *)formattedStringUsingFormat:(NSString *)dateFormat;
+ (NSString *)currentTimeStamp;
@end

@implementation NSString (specialAdditions)

+ (NSString *)flattenHTML:(NSString *)html {
	
    NSScanner *theScanner;
    NSString *text = nil;
	
    theScanner = [NSScanner scannerWithString:html];
	
    while ([theScanner isAtEnd] == NO) {
		
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
		
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
		
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[ NSString stringWithFormat:@"%@>", text] withString:@" "];
		html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
		
    } // while //
    
    return html;
	
}

+ (NSString *)formattedStringUsingFormat:(NSString *)dateFormat
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    [formatter setCalendar:cal];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *ret = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    [cal release];
    return ret;
}

+ (NSString *)currentTimeStamp
{
	return [NSString formattedStringUsingFormat:@"MMddyy_hhmm"];
}

@end

@interface NSBundle (specialAdditions)

+ (NSString *)weatherFileLocation;
+ (NSString *)rssFileLocation;
+ (NSString *)userWeatherFileLocation;
+ (NSString *)userRssFileLocation;
+ (NSString *)outputFileWithName:(NSString *)inputName;
//+ (void)awkSaveScreenToFile:(NSString *)path;


@end

@implementation NSBundle (specialAdditions)

+ (NSString *)weatherFileLocation
{
	Class cls = NSClassFromString(@"nitoWeatherController");
	return [[NSBundle bundleForClass:cls] pathForResource:@"weather" ofType:@"plist"];
}

+ (NSString *)rssFileLocation

{
	Class cls = NSClassFromString(@"nitoWeatherController");
	return [[NSBundle bundleForClass:cls] pathForResource:@"rss" ofType:@"plist"];
}

+ (NSString *)userWeatherFileLocation
{
	NSString *theDest = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
	return [theDest stringByAppendingPathComponent:@"com.nito.nitoTV.weather.plist"];
}

+ (NSString *)userRssFileLocation
{
	NSString *theDest = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
	return [theDest stringByAppendingPathComponent:@"com.nito.nitoTV.rss.plist"];
}

+(NSString *)outputFileWithName:(NSString *)inputName
{
	NSString *theDest = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
	return [theDest stringByAppendingFormat:@"/%@.png", inputName];
}

//+(void)awkSaveScreenToFile:(NSString *)path
//{
//    CGSize screenSize = [BRWindow maxBounds];
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB(); 
//    CGContextRef ctx = CGBitmapContextCreate(nil, screenSize.width, screenSize.height, 8, 4*(int)screenSize.width, colorSpaceRef, kCGImageAlphaPremultipliedLast);
//    CALayer *c = [[[[BRApplicationStackManager singleton] stack] peekController] layer];
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGColorRef col = CGColorCreate(rgb, (CGFloat[]){ 0, 0, 0, 1 });
//    c.backgroundColor=col;
//    [c renderInContext:ctx];
//    
//    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
//    c.backgroundColor=nil;
//    UIImage  *img2 = [UIImage imageWithCGImage:cgImage];
//    [UIImagePNGRepresentation(img2) writeToFile:path atomically:YES];
//    
//}



@end

//@interface BRScrollingTextControl (specialAdditions)
//
//
//- (BRScrollingTextBoxControl *)textBox;
//
//@end
//
//
//@implementation BRScrollingTextControl (specialAdditions)
//
//- (BRScrollingTextBoxControl *)textBox
//{
//	return _textBox;
//}

	//@end





