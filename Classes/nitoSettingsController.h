//
//  nitoSettingsController.h
//  nitoTV2
//
//  Created by Kevin Bradley on 10/26/10.
//  Copyright 2010 nito, LLC. All rights reserved.
//



@interface nitoSettingsController : nitoMediaMenuController {

	int _textEntryType;
}

- (BOOL)toggleUpdate;
- (void)rebootAppleTV;
- (void)updateNitoTV;
- (void)toggleNotificationHooks;
- (void)toggleUpdateFrequency;
- (void)jumpToEnd:(id)scrollBarInfo;
@end
