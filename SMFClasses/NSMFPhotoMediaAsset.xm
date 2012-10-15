//
//  NSMFPhotoMediaAsset.m
//  SMFramework
//
//  Created by Thomas Cool on 2/15/11.
//  Copyright 2011 tomcool.org. All rights reserved.
//

	//#import "NSMFPhotoMediaAsset.h"

static char const * const kSMFPMATitleKey = "SMFPMATitle";

%subclass NSMFPhotoMediaAsset : BRPhotoMediaAsset

	//@implementation NSMFPhotoMediaAsset


%new -(id)initWithPath:(NSString *)path
{
    self=[self init];
    [self setFullURL:path];
    [self setThumbURL:path];
    [self setCoverArtURL:path];
    [self setIsLocal:YES];
		//__title=[@"" retain];
	[self setTitle:@""];
    return self;
    
}
%new -(NSString *)title
{
    return [self associatedValueForKey:(void*)kSMFPMATitleKey];
}

%new -(void)setTitle:(NSString *)title
{
    if (title==nil && ![title isKindOfClass:[NSString class]]) 
        return;

	[self associateValue:title withKey:(void*)kSMFPMATitleKey];
}

//
//-(void)dealloc
//{
//    [__title release];
//    [super dealloc];
//}

%end
	//@end
