#line 1 "Tweak.xm"
#import <AudioToolbox/AudioServices.h>
#import "MediaRemote.h"
#import "CBAutoScrollLabel.h"
#import <Cephei/HBPreferences.h>

HBPreferences *preferences;
BOOL enable;
BOOL enableBlur;
double chevronOpacity;
double keepAliveDuration;
double positionX;
double positionY;
double artworkSize;
double reachOffset;

@interface SBWallpaperEffectView : UIVisualEffectView
@end

@interface SBReachabilityBackgroundView : UIView
@end

@interface SBReachabilityBackgroundViewController : UIViewController
- (void)updateImage:(NSNotification *)notification;
- (void)updateReachability;
- (void)playPause;
- (void)next;
- (void)previous;
@end

@interface _UIBackdropView : UIView
@property (assign,nonatomic) BOOL blurRadiusSetOnce;
@property (nonatomic,copy) NSString * _blurQuality;
@property (assign,nonatomic) double _blurRadius;
-(id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3 ;
-(id)initWithSettings:(id)arg1 ;
@end

@interface _UIBackdropViewSettings : NSObject
+(id)settingsForStyle:(long long)arg1 ;
@end

@interface SBReachabilityManager : NSObject
-(void)_setKeepAliveTimer;
+(id)sharedInstance;
-(void)toggleReachability;
-(BOOL)reachabilityModeActive;
@end

@interface SBMediaController
+ (id)sharedInstance;
- (BOOL)isPlaying;
@end

@interface SBReachabilityWindow : UIWindow
- (id)view;
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBReachabilityManager; @class SBApplication; @class SBAppSwitcherController; @class SBSearchViewController; @class SBMediaController; @class SpringBoard; @class SBReachabilityBackgroundView; @class SBReachabilitySettings; @class SBReachabilityBackgroundViewController; @class SBIconController; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBMediaController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBMediaController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBReachabilityManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBReachabilityManager"); } return _klass; }
#line 58 "Tweak.xm"
BOOL isPlaying() {
    return [[_logos_static_class_lookup$SBMediaController() sharedInstance] isPlaying];
}
UIImageView *newImageView;
UIImageView *newBGImageView;
CBAutoScrollLabel *nowPlayingInfoSong;
CBAutoScrollLabel *nowPlayingInfoArtist;
CBAutoScrollLabel *nowPlayingInfoAlbum;

static void (*_logos_orig$ReachPlayer$SBReachabilitySettings$setYOffsetFactor$)(_LOGOS_SELF_TYPE_NORMAL SBReachabilitySettings* _LOGOS_SELF_CONST, SEL, double); static void _logos_method$ReachPlayer$SBReachabilitySettings$setYOffsetFactor$(_LOGOS_SELF_TYPE_NORMAL SBReachabilitySettings* _LOGOS_SELF_CONST, SEL, double); static bool (*_logos_orig$ReachPlayer$SBReachabilitySettings$allowOnAllDevices)(_LOGOS_SELF_TYPE_NORMAL SBReachabilitySettings* _LOGOS_SELF_CONST, SEL); static bool _logos_method$ReachPlayer$SBReachabilitySettings$allowOnAllDevices(_LOGOS_SELF_TYPE_NORMAL SBReachabilitySettings* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$ReachPlayer$SBReachabilitySettings$setAllowOnAllDevices$)(_LOGOS_SELF_TYPE_NORMAL SBReachabilitySettings* _LOGOS_SELF_CONST, SEL, bool); static void _logos_method$ReachPlayer$SBReachabilitySettings$setAllowOnAllDevices$(_LOGOS_SELF_TYPE_NORMAL SBReachabilitySettings* _LOGOS_SELF_CONST, SEL, bool); static void (*_logos_orig$ReachPlayer$SBReachabilityManager$_setKeepAliveTimer)(_LOGOS_SELF_TYPE_NORMAL SBReachabilityManager* _LOGOS_SELF_CONST, SEL); static void _logos_method$ReachPlayer$SBReachabilityManager$_setKeepAliveTimer(_LOGOS_SELF_TYPE_NORMAL SBReachabilityManager* _LOGOS_SELF_CONST, SEL); static bool (*_logos_meta_orig$ReachPlayer$SBReachabilityManager$reachabilitySupported)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static bool _logos_meta_method$ReachPlayer$SBReachabilityManager$reachabilitySupported(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static bool (*_logos_orig$ReachPlayer$SBReachabilityManager$reachabilityEnabled)(_LOGOS_SELF_TYPE_NORMAL SBReachabilityManager* _LOGOS_SELF_CONST, SEL); static bool _logos_method$ReachPlayer$SBReachabilityManager$reachabilityEnabled(_LOGOS_SELF_TYPE_NORMAL SBReachabilityManager* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$ReachPlayer$SBReachabilityManager$setReachabilityEnabled$)(_LOGOS_SELF_TYPE_NORMAL SBReachabilityManager* _LOGOS_SELF_CONST, SEL, bool); static void _logos_method$ReachPlayer$SBReachabilityManager$setReachabilityEnabled$(_LOGOS_SELF_TYPE_NORMAL SBReachabilityManager* _LOGOS_SELF_CONST, SEL, bool); static bool (*_logos_orig$ReachPlayer$SBSearchViewController$reachabilitySupported)(_LOGOS_SELF_TYPE_NORMAL SBSearchViewController* _LOGOS_SELF_CONST, SEL); static bool _logos_method$ReachPlayer$SBSearchViewController$reachabilitySupported(_LOGOS_SELF_TYPE_NORMAL SBSearchViewController* _LOGOS_SELF_CONST, SEL); static bool (*_logos_orig$ReachPlayer$SBAppSwitcherController$_shouldRespondToReachability)(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherController* _LOGOS_SELF_CONST, SEL); static bool _logos_method$ReachPlayer$SBAppSwitcherController$_shouldRespondToReachability(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherController* _LOGOS_SELF_CONST, SEL); static bool (*_logos_orig$ReachPlayer$SBIconController$_shouldRespondToReachability)(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST, SEL); static bool _logos_method$ReachPlayer$SBIconController$_shouldRespondToReachability(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST, SEL); static bool (*_logos_orig$ReachPlayer$SBApplication$isReachabilitySupported)(_LOGOS_SELF_TYPE_NORMAL SBApplication* _LOGOS_SELF_CONST, SEL); static bool _logos_method$ReachPlayer$SBApplication$isReachabilitySupported(_LOGOS_SELF_TYPE_NORMAL SBApplication* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$ReachPlayer$SBApplication$setReachabilitySupported$)(_LOGOS_SELF_TYPE_NORMAL SBApplication* _LOGOS_SELF_CONST, SEL, bool); static void _logos_method$ReachPlayer$SBApplication$setReachabilitySupported$(_LOGOS_SELF_TYPE_NORMAL SBApplication* _LOGOS_SELF_CONST, SEL, bool); static void (*_logos_orig$ReachPlayer$SpringBoard$_setReachabilitySupported$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, bool); static void _logos_method$ReachPlayer$SpringBoard$_setReachabilitySupported$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, bool); static void (*_logos_orig$ReachPlayer$SBReachabilityBackgroundView$setChevronAlpha$)(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundView* _LOGOS_SELF_CONST, SEL, double); static void _logos_method$ReachPlayer$SBReachabilityBackgroundView$setChevronAlpha$(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundView* _LOGOS_SELF_CONST, SEL, double); static void (*_logos_orig$ReachPlayer$SBReachabilityBackgroundViewController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$ReachPlayer$SBReachabilityBackgroundViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$ReachPlayer$SBReachabilityBackgroundViewController$viewDidLayoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$ReachPlayer$SBReachabilityBackgroundViewController$viewDidLayoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$ReachPlayer$SBReachabilityBackgroundViewController$updateReachability(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$ReachPlayer$SBReachabilityBackgroundViewController$updateImage$(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST, SEL, NSNotification *); 


static void _logos_method$ReachPlayer$SBReachabilitySettings$setYOffsetFactor$(_LOGOS_SELF_TYPE_NORMAL SBReachabilitySettings* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, double arg1) {
    arg1 = reachOffset;
    _logos_orig$ReachPlayer$SBReachabilitySettings$setYOffsetFactor$(self, _cmd, arg1);
}


static bool _logos_method$ReachPlayer$SBReachabilitySettings$allowOnAllDevices(_LOGOS_SELF_TYPE_NORMAL SBReachabilitySettings* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}


static void _logos_method$ReachPlayer$SBReachabilitySettings$setAllowOnAllDevices$(_LOGOS_SELF_TYPE_NORMAL SBReachabilitySettings* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, bool arg1) {
    _logos_orig$ReachPlayer$SBReachabilitySettings$setAllowOnAllDevices$(self, _cmd, YES);
}




static void _logos_method$ReachPlayer$SBReachabilityManager$_setKeepAliveTimer(_LOGOS_SELF_TYPE_NORMAL SBReachabilityManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    
}


static bool _logos_meta_method$ReachPlayer$SBReachabilityManager$reachabilitySupported(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}


static bool _logos_method$ReachPlayer$SBReachabilityManager$reachabilityEnabled(_LOGOS_SELF_TYPE_NORMAL SBReachabilityManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}


static void _logos_method$ReachPlayer$SBReachabilityManager$setReachabilityEnabled$(_LOGOS_SELF_TYPE_NORMAL SBReachabilityManager* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, bool arg1) {
    _logos_orig$ReachPlayer$SBReachabilityManager$setReachabilityEnabled$(self, _cmd, YES);
}




static bool _logos_method$ReachPlayer$SBSearchViewController$reachabilitySupported(_LOGOS_SELF_TYPE_NORMAL SBSearchViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}





static bool _logos_method$ReachPlayer$SBAppSwitcherController$_shouldRespondToReachability(_LOGOS_SELF_TYPE_NORMAL SBAppSwitcherController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}




static bool _logos_method$ReachPlayer$SBIconController$_shouldRespondToReachability(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}




static bool _logos_method$ReachPlayer$SBApplication$isReachabilitySupported(_LOGOS_SELF_TYPE_NORMAL SBApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}

static void _logos_method$ReachPlayer$SBApplication$setReachabilitySupported$(_LOGOS_SELF_TYPE_NORMAL SBApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, bool arg1) {
    _logos_orig$ReachPlayer$SBApplication$setReachabilitySupported$(self, _cmd, YES);
}




static void _logos_method$ReachPlayer$SpringBoard$_setReachabilitySupported$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, bool arg1) {
    _logos_orig$ReachPlayer$SpringBoard$_setReachabilitySupported$(self, _cmd, YES);
}



static void _logos_method$ReachPlayer$SBReachabilityBackgroundView$setChevronAlpha$(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, double arg1) {
    if (enable) {
    arg1 = chevronOpacity;
    _logos_orig$ReachPlayer$SBReachabilityBackgroundView$setChevronAlpha$(self, _cmd, arg1);
}
_logos_orig$ReachPlayer$SBReachabilityBackgroundView$setChevronAlpha$(self, _cmd, arg1);
}




static void _logos_method$ReachPlayer$SBReachabilityBackgroundViewController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated) {
    _logos_orig$ReachPlayer$SBReachabilityBackgroundViewController$viewWillAppear$(self, _cmd, animated);
    
    SBWallpaperEffectView *topWallpaperEffectView = MSHookIvar<SBWallpaperEffectView *>(((SBReachabilityBackgroundView *)self.view), "_topWallpaperEffectView");
    if (topWallpaperEffectView != nil) {
    newBGImageView = [[UIImageView alloc] initWithFrame:topWallpaperEffectView.bounds];
    newBGImageView.contentMode = UIViewContentModeScaleAspectFill;
    newBGImageView.hidden = YES;
    if (enableBlur) {
        newBGImageView.hidden = NO;
    }
    [topWallpaperEffectView addSubview:newBGImageView];
    
    newBGImageView.translatesAutoresizingMaskIntoConstraints = false;
    [newBGImageView.bottomAnchor constraintEqualToAnchor:topWallpaperEffectView.bottomAnchor constant:0].active = YES;
    [newBGImageView.leftAnchor constraintEqualToAnchor:topWallpaperEffectView.leftAnchor constant:0].active = YES;
    [newBGImageView.rightAnchor constraintEqualToAnchor:topWallpaperEffectView.rightAnchor constant:0].active = YES;
    [newBGImageView.topAnchor constraintEqualToAnchor:topWallpaperEffectView.topAnchor constant:0].active = YES;
    
    _UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

    _UIBackdropView *blurView = [[_UIBackdropView alloc] initWithSettings:settings];
    blurView.blurRadiusSetOnce = NO;
    blurView._blurRadius = 200.0;
    blurView._blurQuality = @"high";
    blurView.hidden = YES;
    if (enableBlur) {
        blurView.hidden = NO;
    }
    blurView.frame = newBGImageView.frame;
    [topWallpaperEffectView insertSubview:blurView aboveSubview:newBGImageView];
    
    blurView.translatesAutoresizingMaskIntoConstraints = false;
    [blurView.bottomAnchor constraintEqualToAnchor:topWallpaperEffectView.bottomAnchor constant:0].active = YES;
    [blurView.leftAnchor constraintEqualToAnchor:topWallpaperEffectView.leftAnchor constant:0].active = YES;
    [blurView.rightAnchor constraintEqualToAnchor:topWallpaperEffectView.rightAnchor constant:0].active = YES;
    [blurView.topAnchor constraintEqualToAnchor:topWallpaperEffectView.topAnchor constant:0].active = YES;
    
    newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,topWallpaperEffectView.center.y-positionY,artworkSize,artworkSize)];
    newImageView.contentMode = UIViewContentModeScaleAspectFill;
    newImageView.layer.masksToBounds = YES;
    newImageView.layer.cornerRadius = newImageView.frame.size.height/8;
    [topWallpaperEffectView addSubview:newImageView];
    
    newImageView.translatesAutoresizingMaskIntoConstraints = false;
    [newImageView.widthAnchor constraintEqualToConstant:artworkSize].active = true;
    [newImageView.heightAnchor constraintEqualToConstant:artworkSize].active = true;
    [newImageView.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX].active = true;
    [newImageView.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY].active = true;
    
    nowPlayingInfoSong = [[CBAutoScrollLabel alloc] init];
    nowPlayingInfoSong.textAlignment = NSTextAlignmentLeft;
    nowPlayingInfoSong.font = [UIFont boldSystemFontOfSize:20];
    nowPlayingInfoSong.frame = CGRectMake(topWallpaperEffectView.frame.size.width, topWallpaperEffectView.center.y-positionY-25, 150, 20);
    nowPlayingInfoSong.textColor = [UIColor labelColor];
    nowPlayingInfoSong.clipsToBounds = NO;
    [topWallpaperEffectView addSubview:nowPlayingInfoSong];
    
    nowPlayingInfoSong.translatesAutoresizingMaskIntoConstraints = false;
    [nowPlayingInfoSong.widthAnchor constraintEqualToConstant:150].active = true;
    [nowPlayingInfoSong.heightAnchor constraintEqualToConstant:20].active = true;
    [nowPlayingInfoSong.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX+170].active = true;
    [nowPlayingInfoSong.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY-25].active = true;
    
    
    nowPlayingInfoArtist = [[CBAutoScrollLabel alloc] init];
    nowPlayingInfoArtist.textAlignment = NSTextAlignmentLeft;
    nowPlayingInfoArtist.font = [UIFont boldSystemFontOfSize:14];
    nowPlayingInfoArtist.frame = CGRectMake(topWallpaperEffectView.frame.size.width, topWallpaperEffectView.center.y-positionY, 150, 20);
    nowPlayingInfoArtist.textColor = [[UIColor labelColor] colorWithAlphaComponent:0.6];
    nowPlayingInfoArtist.clipsToBounds = NO;
    [topWallpaperEffectView addSubview:nowPlayingInfoArtist];
    
    nowPlayingInfoArtist.translatesAutoresizingMaskIntoConstraints = false;
    [nowPlayingInfoArtist.widthAnchor constraintEqualToConstant:150].active = true;
    [nowPlayingInfoArtist.heightAnchor constraintEqualToConstant:20].active = true;
    [nowPlayingInfoArtist.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX+170].active = true;
    [nowPlayingInfoArtist.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY].active = true;
    
    
    nowPlayingInfoAlbum = [[CBAutoScrollLabel alloc] init];
    nowPlayingInfoAlbum.textAlignment = NSTextAlignmentLeft;
    nowPlayingInfoAlbum.font = [UIFont systemFontOfSize:14];
    nowPlayingInfoAlbum.frame = CGRectMake(topWallpaperEffectView.frame.size.width, topWallpaperEffectView.center.y-positionY+25, 150, 20);
    nowPlayingInfoAlbum.textColor = [[UIColor labelColor] colorWithAlphaComponent:0.2];
    nowPlayingInfoAlbum.clipsToBounds = NO;
    [topWallpaperEffectView addSubview:nowPlayingInfoAlbum];
    
    nowPlayingInfoAlbum.translatesAutoresizingMaskIntoConstraints = false;
    [nowPlayingInfoAlbum.widthAnchor constraintEqualToConstant:150].active = true;
    [nowPlayingInfoAlbum.heightAnchor constraintEqualToConstant:20].active = true;
    [nowPlayingInfoAlbum.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX+170].active = true;
    [nowPlayingInfoAlbum.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY+25].active = true;
    
    newImageView.hidden = YES;
    newBGImageView.hidden = YES;
    nowPlayingInfoSong.hidden = YES;
    nowPlayingInfoArtist.hidden = YES;
    nowPlayingInfoAlbum.hidden = YES;
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(updateImage:) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
        [notificationCenter postNotificationName:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
    }
}

static void _logos_method$ReachPlayer$SBReachabilityBackgroundViewController$viewDidLayoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$ReachPlayer$SBReachabilityBackgroundViewController$viewDidLayoutSubviews(self, _cmd);
    if ([[_logos_static_class_lookup$SBReachabilityManager() sharedInstance] reachabilityModeActive] == YES) {
    NSTimer *updateTimer = [NSTimer scheduledTimerWithTimeInterval:keepAliveDuration target:self selector:@selector(updateReachability) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];
    }
}


static void _logos_method$ReachPlayer$SBReachabilityBackgroundViewController$updateReachability(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if ([[_logos_static_class_lookup$SBReachabilityManager() sharedInstance] reachabilityModeActive] == YES) {
    [[_logos_static_class_lookup$SBReachabilityManager() sharedInstance] toggleReachability];
    }
}























static void _logos_method$ReachPlayer$SBReachabilityBackgroundViewController$updateImage$(_LOGOS_SELF_TYPE_NORMAL SBReachabilityBackgroundViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSNotification * notification) {
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
        
        if (result) {

        NSDictionary *dictionary = (__bridge NSDictionary *)result;
        
        NSString *songName = dictionary[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle];

        NSString *artistName = dictionary[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist];
          
        NSString *albumName = dictionary[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum];

        NSData *artworkData = [dictionary objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];

        if (artworkData != nil) {
            newImageView.image = [UIImage imageWithData:artworkData];
            newBGImageView.image = [UIImage imageWithData:artworkData];
        } else {
            newImageView.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/reachplayer/DefaultContainerArtwork.png"];
            newBGImageView.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/reachplayer/DefaultContainerArtwork.png"];
        }
            
            if (songName != nil) {
            nowPlayingInfoSong.text = [NSString stringWithFormat:@"%@", songName];
            } else {
            nowPlayingInfoSong.text = @" ";
            }
            
            if (artistName != nil) {
            nowPlayingInfoArtist.text = [NSString stringWithFormat:@"%@", artistName];
            } else {
            nowPlayingInfoArtist.text = @" ";
            }
              
            if (albumName != nil) {
            nowPlayingInfoAlbum.text = [NSString stringWithFormat:@"%@", albumName];
            } else {
            nowPlayingInfoAlbum.text = @" ";
            }
            
            if (enableBlur) {
                newBGImageView.hidden = NO;
            }
            newImageView.hidden = NO;
            nowPlayingInfoSong.hidden = NO;
            nowPlayingInfoArtist.hidden = NO;
            nowPlayingInfoAlbum.hidden = NO;

        } else {
            if (enableBlur) {
                newBGImageView.hidden = YES;
            }
            newImageView.hidden = YES;
            nowPlayingInfoSong.hidden = YES;
            nowPlayingInfoArtist.hidden = YES;
            nowPlayingInfoAlbum.hidden = YES;
        }
  });
}



static __attribute__((constructor)) void _logosLocalCtor_b44a9d58(int __unused argc, char __unused **argv, char __unused **envp) {
    
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

    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.nahtedetihw.reachplayerprefs"];
    [preferences registerBool:&enable default:NO forKey:@"enable"];
    [preferences registerBool:&enableBlur default:NO forKey:@"enableBlur"];
    [preferences registerDouble:&chevronOpacity default:1.0 forKey:@"chevronOpacity"];
    [preferences registerDouble:&keepAliveDuration default:8.0 forKey:@"keepAliveDuration"];
    [preferences registerDouble:&positionX default:90.0 forKey:@"positionX"];
    [preferences registerDouble:&positionY default:180.0 forKey:@"positionY"];
    [preferences registerDouble:&artworkSize default:160.0 forKey:@"artworkSize"];
    [preferences registerDouble:&reachOffset default:0.4 forKey:@"reachOffset"];
    
    if (enable) {
    {Class _logos_class$ReachPlayer$SBReachabilitySettings = objc_getClass("SBReachabilitySettings"); { MSHookMessageEx(_logos_class$ReachPlayer$SBReachabilitySettings, @selector(setYOffsetFactor:), (IMP)&_logos_method$ReachPlayer$SBReachabilitySettings$setYOffsetFactor$, (IMP*)&_logos_orig$ReachPlayer$SBReachabilitySettings$setYOffsetFactor$);}{ MSHookMessageEx(_logos_class$ReachPlayer$SBReachabilitySettings, @selector(allowOnAllDevices), (IMP)&_logos_method$ReachPlayer$SBReachabilitySettings$allowOnAllDevices, (IMP*)&_logos_orig$ReachPlayer$SBReachabilitySettings$allowOnAllDevices);}{ MSHookMessageEx(_logos_class$ReachPlayer$SBReachabilitySettings, @selector(setAllowOnAllDevices:), (IMP)&_logos_method$ReachPlayer$SBReachabilitySettings$setAllowOnAllDevices$, (IMP*)&_logos_orig$ReachPlayer$SBReachabilitySettings$setAllowOnAllDevices$);}Class _logos_class$ReachPlayer$SBReachabilityManager = objc_getClass("SBReachabilityManager"); Class _logos_metaclass$ReachPlayer$SBReachabilityManager = object_getClass(_logos_class$ReachPlayer$SBReachabilityManager); { MSHookMessageEx(_logos_class$ReachPlayer$SBReachabilityManager, @selector(_setKeepAliveTimer), (IMP)&_logos_method$ReachPlayer$SBReachabilityManager$_setKeepAliveTimer, (IMP*)&_logos_orig$ReachPlayer$SBReachabilityManager$_setKeepAliveTimer);}{ MSHookMessageEx(_logos_metaclass$ReachPlayer$SBReachabilityManager, @selector(reachabilitySupported), (IMP)&_logos_meta_method$ReachPlayer$SBReachabilityManager$reachabilitySupported, (IMP*)&_logos_meta_orig$ReachPlayer$SBReachabilityManager$reachabilitySupported);}{ MSHookMessageEx(_logos_class$ReachPlayer$SBReachabilityManager, @selector(reachabilityEnabled), (IMP)&_logos_method$ReachPlayer$SBReachabilityManager$reachabilityEnabled, (IMP*)&_logos_orig$ReachPlayer$SBReachabilityManager$reachabilityEnabled);}{ MSHookMessageEx(_logos_class$ReachPlayer$SBReachabilityManager, @selector(setReachabilityEnabled:), (IMP)&_logos_method$ReachPlayer$SBReachabilityManager$setReachabilityEnabled$, (IMP*)&_logos_orig$ReachPlayer$SBReachabilityManager$setReachabilityEnabled$);}Class _logos_class$ReachPlayer$SBSearchViewController = objc_getClass("SBSearchViewController"); { MSHookMessageEx(_logos_class$ReachPlayer$SBSearchViewController, @selector(reachabilitySupported), (IMP)&_logos_method$ReachPlayer$SBSearchViewController$reachabilitySupported, (IMP*)&_logos_orig$ReachPlayer$SBSearchViewController$reachabilitySupported);}Class _logos_class$ReachPlayer$SBAppSwitcherController = objc_getClass("SBAppSwitcherController"); { MSHookMessageEx(_logos_class$ReachPlayer$SBAppSwitcherController, @selector(_shouldRespondToReachability), (IMP)&_logos_method$ReachPlayer$SBAppSwitcherController$_shouldRespondToReachability, (IMP*)&_logos_orig$ReachPlayer$SBAppSwitcherController$_shouldRespondToReachability);}Class _logos_class$ReachPlayer$SBIconController = objc_getClass("SBIconController"); { MSHookMessageEx(_logos_class$ReachPlayer$SBIconController, @selector(_shouldRespondToReachability), (IMP)&_logos_method$ReachPlayer$SBIconController$_shouldRespondToReachability, (IMP*)&_logos_orig$ReachPlayer$SBIconController$_shouldRespondToReachability);}Class _logos_class$ReachPlayer$SBApplication = objc_getClass("SBApplication"); { MSHookMessageEx(_logos_class$ReachPlayer$SBApplication, @selector(isReachabilitySupported), (IMP)&_logos_method$ReachPlayer$SBApplication$isReachabilitySupported, (IMP*)&_logos_orig$ReachPlayer$SBApplication$isReachabilitySupported);}{ MSHookMessageEx(_logos_class$ReachPlayer$SBApplication, @selector(setReachabilitySupported:), (IMP)&_logos_method$ReachPlayer$SBApplication$setReachabilitySupported$, (IMP*)&_logos_orig$ReachPlayer$SBApplication$setReachabilitySupported$);}Class _logos_class$ReachPlayer$SpringBoard = objc_getClass("SpringBoard"); { MSHookMessageEx(_logos_class$ReachPlayer$SpringBoard, @selector(_setReachabilitySupported:), (IMP)&_logos_method$ReachPlayer$SpringBoard$_setReachabilitySupported$, (IMP*)&_logos_orig$ReachPlayer$SpringBoard$_setReachabilitySupported$);}Class _logos_class$ReachPlayer$SBReachabilityBackgroundView = objc_getClass("SBReachabilityBackgroundView"); { MSHookMessageEx(_logos_class$ReachPlayer$SBReachabilityBackgroundView, @selector(setChevronAlpha:), (IMP)&_logos_method$ReachPlayer$SBReachabilityBackgroundView$setChevronAlpha$, (IMP*)&_logos_orig$ReachPlayer$SBReachabilityBackgroundView$setChevronAlpha$);}Class _logos_class$ReachPlayer$SBReachabilityBackgroundViewController = objc_getClass("SBReachabilityBackgroundViewController"); { MSHookMessageEx(_logos_class$ReachPlayer$SBReachabilityBackgroundViewController, @selector(viewWillAppear:), (IMP)&_logos_method$ReachPlayer$SBReachabilityBackgroundViewController$viewWillAppear$, (IMP*)&_logos_orig$ReachPlayer$SBReachabilityBackgroundViewController$viewWillAppear$);}{ MSHookMessageEx(_logos_class$ReachPlayer$SBReachabilityBackgroundViewController, @selector(viewDidLayoutSubviews), (IMP)&_logos_method$ReachPlayer$SBReachabilityBackgroundViewController$viewDidLayoutSubviews, (IMP*)&_logos_orig$ReachPlayer$SBReachabilityBackgroundViewController$viewDidLayoutSubviews);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$ReachPlayer$SBReachabilityBackgroundViewController, @selector(updateReachability), (IMP)&_logos_method$ReachPlayer$SBReachabilityBackgroundViewController$updateReachability, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSNotification *), strlen(@encode(NSNotification *))); i += strlen(@encode(NSNotification *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$ReachPlayer$SBReachabilityBackgroundViewController, @selector(updateImage:), (IMP)&_logos_method$ReachPlayer$SBReachabilityBackgroundViewController$updateImage$, _typeEncoding); }}
    return;
    }
    return;
}
}
