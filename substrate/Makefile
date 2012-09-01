export GO_EASY_ON_ME=1
export SDKVERSION=4.3
export FW_DEVICE_IP=apple-tv.local

include theos/makefiles/common.mk

TWEAK_NAME = ScrollHack
ScrollHack_FILES = ScrollHack.xm
ScrollHack_LDFLAGS = -undefined dynamic_lookup
include $(FW_MAKEDIR)/tweak.mk

after-ScrollHack-stage:: 
	cp -r $(FW_STAGING_DIR)/Library ../layout/
	$(FAKEROOT) chown -R root:wheel ../layout/Library/
