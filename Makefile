TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard

DEBUG=0
FINALPACKAGE=1
## THEOS_PACKAGE_SCHEME=rootless

SYSROOT=$(THEOS)/sdks/iphoneos14.2.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ReachPlayer

ReachPlayer_FILES = Tweak.xm ReachPlayerContainerView.xm
ReachPlayer_CFLAGS = -fobjc-arc -Wdeprecated-declarations -Wno-deprecated-declarations
ReachPlayer_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences && killall -9 SpringBoard"
SUBPROJECTS += reachplayerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
