//
//  nitoMoreMenu.h
//  nitoTV
//
//  Created by kevin bradley on 10/4/11.
//  Copyright 2011 nito, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface nitoMoreMenu : SMFListDropShadowControl <SMFListDropShadowDatasource, SMFListDropShadowDelegate> {

}

- (id)initWithSender:(id)theSender addedTo:(id)parentController;

@end
