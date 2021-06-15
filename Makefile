export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.4:13.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk/
export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

# TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard

# DEBUG=0
# FINALPACKAGE=1

# PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

# SYSROOT=$(THEOS)/sdks/iphoneos14.0.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ReachPlayer

ReachPlayer_FILES = Tweak.xm
ReachPlayer_CFLAGS = -fobjc-arc
ReachPlayer_FRAMEWORKS = UIKit
ReachPlayer_EXTRA_FRAMEWORKS += Cephei
ReachPlayer_PRIVATE_FRAMEWORKS = MediaRemote

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences && killall -9 SpringBoard"
SUBPROJECTS += reachplayerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk