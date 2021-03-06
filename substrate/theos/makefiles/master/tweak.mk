TWEAK_NAME := $(strip $(TWEAK_NAME))

ifeq ($(FW_RULES_LOADED),)
include $(FW_MAKEDIR)/rules.mk
endif

before-all::
	@[ -f "$(FW_LIBDIR)/libsubstrate.dylib" ] || bootstrap.sh substrate

internal-all:: $(TWEAK_NAME:=.all.tweak.variables);

internal-stage:: $(TWEAK_NAME:=.stage.tweak.variables);

internal-after-install::
	install.exec "killall -9 Lowtide"

TWEAKS_WITH_SUBPROJECTS = $(strip $(foreach tweak,$(TWEAK_NAME),$(patsubst %,$(tweak),$($(tweak)_SUBPROJECTS))))
ifneq ($(TWEAKS_WITH_SUBPROJECTS),)
internal-clean:: $(TWEAKS_WITH_SUBPROJECTS:=.clean.tweak.subprojects)
endif

$(TWEAK_NAME):
	@$(MAKE) --no-print-directory --no-keep-going $@.all.tweak.variables
