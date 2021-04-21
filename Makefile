TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard

DEBUG=0
FINALPACKAGE=1

PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

SYSROOT=$(THEOS)/sdks/iphoneos14.0.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ReachPlayer

ReachPlayer_FILES = Tweak.xm CBAutoScrollLabel.m
ReachPlayer_CFLAGS = -fobjc-arc
ReachPlayer_EXTRA_FRAMEWORKS += Cephei
ReachPlayer_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences && killall -9 SpringBoard"
SUBPROJECTS += reachplayerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk