/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: (null)
 */

#import <BackRow/BRSingleton.h>

@class LTThermalNoticeController, NSTimer, BRWindow, NSArray;

@interface MEPowerManagement : BRSingleton {
	NSTimer* _timer;
	BRWindow* _window;
	BOOL _inLowPowerMode;
	BOOL _setIdleSleepTime;
	NSTimer* _timedSleepTimer;
	NSArray* _usageKeys;
	LTThermalNoticeController* _thermalNoteController;
	unsigned _pmNoIdleSleepAssertionID;
	unsigned _ioNotifier;
	unsigned _ioConnection;
}
+(id)singleton;
+(void)setSingleton:(id)singleton;
+(void)startManagement;
+(void)showThermalLevelPopup;
-(id)init;
-(void)dealloc;
-(void)_enableIdleSleepAndWatchdog;
-(void)_registerForPowerNotifications;
-(void)_registerForThermalNotifications;
-(void)_updateAllTimersDueToActivity:(id)activity;
-(void)_updateTimedSleepTimer:(id)timer;
-(void)_enterLowPowerModeSoon:(id)soon;
-(void)_touchRemotePlayerStateChanged:(id)changed;
-(void)_playerStateChanged:(id)changed;
-(void)_displayStateChanged:(id)changed;
-(void)_enterLowPowerMode;
-(void)_updateActivity:(id)activity;
-(void)_setMachineToLowPowerMode;
-(void)_setMachineToNormalPowerMode;
-(void)_setShowSleepShroud:(BOOL)shroud;
-(void)_setDisplayBlanked:(BOOL)blanked;
-(void)_setAllowIdleSleep:(BOOL)sleep;
-(void)_setConstantAudioOutputEnabled:(BOOL)enabled;
-(void)_turnAirPlayBackOn;
-(void)_unexpectedActivityWhileInLowPower:(id)lowPower;
-(void)_handleIOPMCallbackMessage:(unsigned)message argument:(void*)argument;
-(void)_handleThermalNotification;
-(id)_usageKeys;
@end

