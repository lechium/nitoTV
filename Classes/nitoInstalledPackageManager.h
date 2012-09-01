//
//  nitoInstalledPackageManager.h
//  nitoTV
//
//  Created by kevin bradley on 9/23/11.
//  Copyright 2011 nito LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface nitoInstalledPackageManager : nitoMediaMenuController <SMFMoviePreviewControllerDelegate>  {

	NSArray *installedList;
	id		selectedObject;

}
@property(nonatomic, retain)id selectedObject;
@property (nonatomic, retain) NSArray *installedList;

- (void)_populateData;
- (NSString *)getTitleFromPackage:(NSDictionary *)packageDict;
- (void)showProtectedAlert:(NSString *)protectedPackage;
@end
