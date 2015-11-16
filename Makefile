GO_EASY_ON_ME=1
FW_DEVICE_IP=apple-tv.local
#FW_DEVICE_IP=ttv.local
export DEBUG=1
export SDKVERSION=4.3


include theos/makefiles/common.mk
include theos/makefiles/aggregate.mk


BUNDLE_NAME = nitoTV
nitoTV_FILES = Classes/NSObject+AssociatedObjects.m Classes/nitoTVAppliance.xm Classes/APAttribute.m Classes/APDocument.m Classes/APElement.m Classes/nitoMediaMenuController.xm
nitoTV_FILES += Classes/ntvMedia.xm Classes/ntvUIClasses.xm Classes/nitoMenuItem.xm Classes/nitoDeadController.xm
nitoTV_FILES += Classes/ntvMediaPreview.xm Classes/nitoManageMenu.xm Classes/nitoInstalledPackageManager.xm
nitoTV_FILES += Classes/nitoWeather.m Classes/nitoWeatherController.xm Classes/nitoSourceController.xm
nitoTV_FILES += Classes/ntvWeatherManager.xm Classes/ntvWeatherViewer.xm Classes/NitoTheme.m 
nitoTV_FILES += Classes/nitoRss.m Classes/nitoRssController.xm Classes/ntvRssBrowser.xm 
nitoTV_FILES += Classes/ntvRSSViewer.xm Classes/nitoSettingsController.xm
nitoTV_FILES += Classes/nitoInstallManager.xm Classes/queryMenu.xm Classes/Reachability.m
nitoTV_FILES += Classes/kbScrollingTextControl.xm Classes/nitoDefaultManager.m Classes/packageManagement.m 
nitoTV_FILES += SMFClasses/NSMFCompatibility.m Classes/nitoMockMenuItem.m SMFClasses/NSMFDropShadowControl.xm
nitoTV_FILES += SMFClasses/NSMFBaseAsset.xm SMFClasses/NSMFComplexDropShadowControl.xm SMFClasses/NSMFComplexProcessDropShadowControl.xm 
nitoTV_FILES += SMFClasses/NSMFListDropShadowControl.xm SMFClasses/NSMFMoviePreviewController.xm 
nitoTV_FILES += SMFClasses/NSMFPhotoMediaAsset.xm SMFClasses/NSMFPopup.xm SMFClasses/NSMFProgressBarControl.xm SMFClasses/NSMFTextDropShadowControl.xm
nitoTV_FILES += SMFClasses/NSMFAnimation.m SMFClasses/NSMFCommonTools.m SMFClasses/NSMFMockMenuItem.m SMFClasses/NSMFPreferences.m SMFClasses/NSMFThemeInfo.m Classes/PackageDataSource.xm  Classes/nitoMoreMenu.xm
nitoTV_FILES += Classes/ntvMediaShelfView.xm

nitoTV_INSTALL_PATH = /Applications/AppleTV.app/Appliances

nitoTV_BUNDLE_EXTENSION = frappliance
#nitoTV_CFLAGS += -std=c99 
nitoTV_LDFLAGS =  -all_load -undefined dynamic_lookup -framework UIKit -framework ImageIO -FFrameworks -lz -lsubstrate -framework CoreGraphics -framework Foundation -framework SystemConfiguration -framework CoreFoundation

include $(FW_MAKEDIR)/bundle.mk

NTV_PATH = $(FW_STAGING_DIR)$(nitoTV_INSTALL_PATH)/$(BUNDLE_NAME).$(nitoTV_BUNDLE_EXTENSION)/$(BUNDLE_NAME)
	

after-nitoTV-stage:: 
	$(FAKEROOT) chown -R root:wheel $(FW_STAGING_DIR)
	$(PREFIX)dsymutil $(NTV_PATH) -o $(BUNDLE_NAME).dSYM
	cp $(NTV_PATH) $(BUNDLE_NAME)_unstripped
	$(PREFIX)strip -x $(NTV_PATH)
	$(_THEOS_CODESIGN_COMMANDLINE) $(NTV_PATH)
	
after-install::
	install.exec "killall -9 AppleTV"
