GO_EASY_ON_ME=1
FW_DEVICE_IP=apple-tv.local
export SDKVERSION=4.3


include theos/makefiles/common.mk
include theos/makefiles/aggregate.mk


BUNDLE_NAME = nitoTV
nitoTV_FILES = Classes/nitoTVAppliance.xm Classes/APAttribute.m Classes/APDocument.m Classes/APElement.m Classes/nitoMediaMenuController.xm 
nitoTV_FILES += Classes/ntvMedia.xm Classes/ntvUIClasses.xm Classes/nitoMenuItem.xm Classes/nitoDeadController.xm
nitoTV_FILES += Classes/ntvMediaPreview.xm Classes/nitoManageMenu.xm Classes/nitoInstalledPackageManager.xm
nitoTV_FILES += Classes/nitoWeather.m Classes/nitoWeatherController.xm Classes/nitoSourceController.xm
nitoTV_FILES += Classes/ntvWeatherManager.xm Classes/ntvWeatherViewer.xm Classes/NitoTheme.m 
nitoTV_FILES += Classes/nitoRss.m Classes/nitoRssController.xm Classes/ntvRssBrowser.xm 
nitoTV_FILES += Classes/ntvRSSViewer.xm Classes/nitoSettingsController.xm
nitoTV_FILES += Classes/nitoInstallManager.xm Classes/queryMenu.xm
nitoTV_FILES += Classes/kbScrollingTextControl.xm Classes/nitoDefaultManager.m Classes/packageManagement.m 
nitoTV_FILES += SMFClasses/SMFCompatibility.m Classes/nitoMockMenuItem.m
nitoTV_FILES += SMFClasses/SMFBaseAsset.xm SMFClasses/SMFComplexDropShadowControl.xm SMFClasses/SMFComplexProcessDropShadowControl.xm 
nitoTV_FILES += SMFClasses/SMFDropShadowControl.xm SMFClasses/SMFListDropShadowControl.xm SMFClasses/SMFMoviePreviewController.xm 
nitoTV_FILES += SMFClasses/SMFPhotoMediaAsset.xm SMFClasses/SMFPopup.xm SMFClasses/SMFProgressBarControl.xm SMFClasses/SMFTextDropShadowControl.xm
nitoTV_FILES += SMFClasses/SMFAnimation.m SMFClasses/SMFCommonTools.m SMFClasses/SMFMockMenuItem.m SMFClasses/SMFPreferences.m SMFClasses/SMFThemeInfo.m Classes/PackageDataSource.xm 

nitoTV_INSTALL_PATH = /Applications/Lowtide.app/Appliances

nitoTV_BUNDLE_EXTENSION = frappliance
#nitoTV_CFLAGS += -std=c99 
nitoTV_LDFLAGS =  -all_load -undefined dynamic_lookup -framework UIKit -framework ImageIO -FFrameworks -lz -lsubstrate -framework CoreGraphics

include $(FW_MAKEDIR)/bundle.mk


after-nitoTV-stage:: 
	mkdir -p $(FW_STAGING_DIR)/Applications/AppleTV.app/Appliances; ln -f -s /Applications/Lowtide.app/Appliances/nitoTV.frappliance $(FW_STAGING_DIR)/Applications/AppleTV.app/Appliances/


after-install::
	install.exec "killall -9 AppleTV"
