GO_EASY_ON_ME=1
FW_DEVICE_IP=apple-tv.local
export SDKVERSION=5.0


include theos/makefiles/common.mk
include theos/makefiles/aggregate.mk


BUNDLE_NAME = nitoTV
nitoTV_FILES = Classes/nitoTVAppliance.mm Classes/APAttribute.m Classes/APDocument.m Classes/APElement.m 
nitoTV_FILES += Classes/ntvMedia.m
nitoTV_FILES += Classes/ntvMediaPreview.mm 
nitoTV_FILES += Classes/CPlusFunctions.mm Classes/nitoWeather.m Classes/nitoWeatherController.m 
nitoTV_FILES += Classes/ntvWeatherManager.m Classes/ntvWeatherViewer.m Classes/NitoTheme.m 
nitoTV_FILES += Classes/nitoRss.m Classes/nitoRssController.mm Classes/ntvRssBrowser.mm 
nitoTV_FILES += Classes/ntvRSSViewer.m Classes/nitoMediaMenuController.m Classes/nitoSettingsController.mm
nitoTV_FILES += Classes/awkScreenShot.m Classes/nitoInstallManager.m Classes/queryMenu.m
nitoTV_FILES += Classes/kbScrollingTextControl.m Classes/nitoDefaultManager.m Classes/PackageDataSource.m Classes/packageManagement.m
nitoTV_INSTALL_PATH = /Applications/Lowtide.app/Appliances

nitoTV_BUNDLE_EXTENSION = frappliance
nitoTV_CFLAGS += -std=c99 
nitoTV_LDFLAGS = -std=c99 -undefined dynamic_lookup -framework UIKit -framework ImageIO -FFrameworks -framework SMFramework #-L$(FW_PROJECT_DIR) -lBackRow

include $(FW_MAKEDIR)/bundle.mk


after-nitoTV-make::
	echo "MURDERDEATHKILLBILE"

after-nitoTV-stage:: 
	mkdir -p $(FW_STAGING_DIR)/Applications/AppleTV.app/Appliances; ln -f -s /Applications/Lowtide.app/Appliances/nitoTV.frappliance $(FW_STAGING_DIR)/Applications/AppleTV.app/Appliances/


after-install::
	install.exec "killall -9 AppleTV"
