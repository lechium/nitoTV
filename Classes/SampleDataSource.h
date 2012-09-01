//
//  SampleDataSource.h
//  nitoTV
//
//  Created by Kevin Bradley on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//




@interface SampleDataSource : SMFMoviePreviewController <SMFMoviePreviewControllerDelegate> {

}

-(void)controller:(SMFMoviePreviewController *)c selectedControl:(BRControl *)ctrl;

@end
