export SDKVERSION=4.2
TOOL_NAME := setuid
setuid_C_FILES = setuid.c
setuid_PACKAGE_TARGET_DIR = /usr/libexec/nitotv

include ../theos/makefiles/common.mk
include ../theos/makefiles/tool.mk

after-setuid-stage::
	$(FAKEROOT) chmod 6755 $(FW_STAGING_DIR)/usr/libexec/nitotv/setuid
	$(FAKEROOT) cp $(FW_STAGING_DIR)/usr/libexec/nitotv/setuid ../layout/usr/libexec/nitotv/
	$(FAKEROOT) chmod 6755 ../layout/usr/libexec/nitotv/setuid