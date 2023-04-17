#import "Tweak.h"

UIView *emptyView;
ReachPlayerContainerView *containerView;

%group ReachPlayer

%hook _UIStatusBarForegroundView
// Double tap status bar to activate
- (id)initWithFrame:(CGRect)frame {
    self = %orig;
    if (activationStyle == 0) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleStatusReachability:)];
        self.userInteractionEnabled = YES;
        tapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

%new
- (void)toggleStatusReachability:(id)sender {
    [[%c(SBReachabilityManager) sharedInstance] toggleReachability];
}
%end

%hook UIWindow
// Shake device to activate
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    %orig;
    if (activationStyle == 1) {
        BOOL isScreenOn = MSHookIvar<BOOL>([%c(SBLockScreenManager) sharedInstance], "_isScreenOn");
        if (event.type == UIEventSubtypeMotionShake && self == [[UIApplication sharedApplication] keyWindow] && isScreenOn == YES) {
            [[%c(SBReachabilityManager) sharedInstance] toggleReachability];
        }
    }
}

%end

%hook SBSearchScrollView
// disable Spotlight when Reachability active
-(bool) gestureRecognizerShouldBegin:(id)arg1 {
    if ([[%c(SBReachabilityManager) sharedInstance] reachabilityModeActive] == YES) {
    return NO;
    }
    return %orig;
}

// disable Spotlight when Reachability active
-(BOOL)gestureRecognizer:(id)arg1 shouldRequireFailureOfGestureRecognizer:(id)arg2 {
    if ([[%c(SBReachabilityManager) sharedInstance] reachabilityModeActive] == YES) {
    return NO;
    }
    return %orig;
}
%end

%hook SBReachabilitySettings
-(double)yOffsetFactor {
    return reachOffset;
}

// Sets the vertical offset
- (void)setYOffsetFactor:(double)arg1 {
    %orig(reachOffset);
}

// Support for other devices
- (bool)allowOnAllDevices {
    return YES;
}

// Support for other devices
- (void)setAllowOnAllDevices:(bool)arg1 {
    %orig(YES);
}

%end

%hook SBReachabilityManager
//-(void)_setKeepAliveTimer {
    // remove orig timer
//}

-(void)_pingKeepAliveWithDuration:(double)arg1 interactedBeforePing:(BOOL)arg2 initialKeepAliveTime:(double)arg3 {
    %orig(keepAliveDuration,arg2,0.0);
}

// Support for other devices
+ (bool)reachabilitySupported {
    return YES;
}

// Support for other devices
- (bool)reachabilityEnabled {
    return YES;
}

// Support for other devices
- (void)setReachabilityEnabled:(bool)arg1 {
    %orig(YES);
}

- (void)_panToDeactivateReachability:(id)arg1 {
    if (![arg1 isKindOfClass:%c(SBScreenEdgePanGestureRecognizer)]) return;
    %orig;
}

- (_Bool)gestureRecognizerShouldBegin:(id)arg1 {
    if ((![arg1 isKindOfClass:%c(SBScreenEdgePanGestureRecognizer)] && ![arg1 isKindOfClass:%c(SBReachabilityGestureRecognizer)])) return false;
    return %orig;
}

- (void)_tapToDeactivateReachability:(id)arg1 {
    //remove tap gesture
}
%end

%hook SBSearchViewController
// Support for other devices
- (bool)reachabilitySupported {
    return YES;
}
%end


%hook SBAppSwitcherController
// Support for other devices
- (bool)_shouldRespondToReachability {
    return YES;
}
%end

%hook SBIconController
// Support for other devices
- (bool)_shouldRespondToReachability {
    return YES;
}
%end

%hook SBApplication
// Support for other devices
- (bool)isReachabilitySupported {
    return YES;
}

- (void)setReachabilitySupported:(bool)arg1 {
    %orig(YES);
}
%end

%hook SpringBoard
// Support for other devices
- (void)_setReachabilitySupported:(bool)arg1 {
    %orig(YES);
}
%end

%hook SBReachabilityWindow
// thanks NEPETA! put my own twist on it though (passes touches to our view)
- (id)hitTest:(CGPoint)arg1 withEvent:(id)arg2 {
    UIView *candidate = %orig;
    SBWallpaperEffectView *correctView = MSHookIvar<SBWallpaperEffectView *>(((SBReachabilityBackgroundView *)self.rootViewController.view), "_topWallpaperEffectView");
    if (arg1.y <= 0) {
        candidate = [correctView hitTest:[correctView convertPoint:arg1 fromView:self] withEvent:arg2];
        if (emptyView) {
            candidate = emptyView;
            emptyView = nil;
        } else {
            emptyView = candidate;
        }
    }
    return candidate;
}
%end

%hook SBReachabilityBackgroundView
- (void)setChevronAlpha:(double)arg1 {
    if (enable) {
    arg1 = chevronOpacity;
    %orig;
}
%orig;
}
%end

%hook SBReachabilityBackgroundViewController
%property (nonatomic, retain) NSTimer *updateTimer;
-(void)viewWillAppear:(BOOL)arg1 {
    %orig;
    [[%c(SBReachabilityManager) sharedInstance] _notifyObserversReachabilityYOffsetDidChange];
    [self addReachPlayerContainerView];
}

%new
- (void)addReachPlayerContainerView {
    SBWallpaperEffectView *topWallpaperEffectView = MSHookIvar<SBWallpaperEffectView *>(((SBReachabilityBackgroundView *)self.view), "_topWallpaperEffectView");
    
    if (topWallpaperEffectView != nil) {
        containerView = [ReachPlayerContainerView new];
        containerView.frame = topWallpaperEffectView.bounds;
        if (enableBlur) {
            containerView.backgroundImageView.hidden = NO;
            containerView.backgroundBlurView.hidden = NO;
        } else {
            containerView.backgroundImageView.hidden = YES;
            containerView.backgroundBlurView.hidden = YES;
        }
        [topWallpaperEffectView addSubview:containerView];
        
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        [containerView.bottomAnchor constraintEqualToAnchor:topWallpaperEffectView.bottomAnchor constant:0].active = YES;
        [containerView.leftAnchor constraintEqualToAnchor:topWallpaperEffectView.leftAnchor constant:0].active = YES;
        [containerView.rightAnchor constraintEqualToAnchor:topWallpaperEffectView.rightAnchor constant:0].active = YES;
        [containerView.topAnchor constraintEqualToAnchor:topWallpaperEffectView.topAnchor constant:0].active = YES;
    }
}
/*
%new
- (void)updateReachability {
    if ([[%c(SBReachabilityManager) sharedInstance] reachabilityModeActive] == YES) {
    [[%c(SBReachabilityManager) sharedInstance] toggleReachability];
    }
}
*/
%end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    loadPreferences();
}
%end
%end

%ctor {
    
    BOOL shouldLoad = NO;
    NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString *executablePath = args[0];
        if (executablePath) {
            NSString *processName = [executablePath lastPathComponent];
            BOOL isSpringBoard = [processName isEqualToString:@"SpringBoard"];
            BOOL isPreferences = [processName isEqualToString:@"Preferences"];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"]
            || [processName isEqualToString:@"CoreAuthUI"]
            || [processName isEqualToString:@"InCallService"]
            || [processName isEqualToString:@"MessagesNotificationViewService"]
            || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if (!isFileProvider && (isSpringBoard || isApplication || isPreferences) && !skip) {
                shouldLoad = YES;
            }
        }
    }
    if (shouldLoad) {

        loadPreferences(); // Load prefs
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPreferences, (CFStringRef)preferencesNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
    
    if (enable) {
    %init(ReachPlayer);
    return;
    }
    return;
}
}
