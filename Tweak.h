#import <UIKit/UIKit.h>

#define plistPath ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.nahtedetihw.reachplayerprefs.plist"] ? @"/var/mobile/Library/Preferences/com.nahtedetihw.reachplayerprefs.plist" : @"/var/jb/var/mobile/Library/Preferences/com.nahtedetihw.reachplayerprefs.plist")

static NSString *preferencesNotification = @"com.nahtedetihw.reachplayerprefs/ReloadPrefs";

BOOL enable, enableBlur;
double chevronOpacity, keepAliveDuration, positionX, positionY, artworkSize, reachOffset;
NSInteger layoutStyle, blurStyle, activationStyle;

static void loadPreferences() {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    enable = dict[@"enable"] ? [dict[@"enable"] boolValue] : NO;
    enableBlur = dict[@"enableBlur"] ? [dict[@"enableBlur"] boolValue] : NO;
    
    chevronOpacity = dict[@"chevronOpacity"] ? [dict[@"chevronOpacity"] doubleValue] : 1.0;
    keepAliveDuration = dict[@"keepAliveDuration"] ? [dict[@"keepAliveDuration"] doubleValue] : 0.8;
    positionX = dict[@"positionX"] ? [dict[@"positionX"] doubleValue] : 0;
    positionY = dict[@"positionY"] ? [dict[@"positionY"] doubleValue] : 0;
    artworkSize = dict[@"artworkSize"] ? [dict[@"artworkSize"] doubleValue] : 160.0;
    reachOffset = dict[@"reachOffset"] ? [dict[@"reachOffset"] doubleValue] : 0.4;
    
    layoutStyle = dict[@"layoutStyle"] ? [dict[@"layoutStyle"] integerValue] : 0;
    blurStyle = dict[@"blurStyle"] ? [dict[@"blurStyle"] integerValue] : 0;
    activationStyle = dict[@"activationStyle"] ? [dict[@"activationStyle"] integerValue] : 0;
}

@interface SBLockScreenManager : NSObject
+(id)sharedInstance;
-(BOOL)isScreenOn;
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

@interface ReachPlayerArtworkContainerView : UIView
@property (nonatomic, strong) UIImageView *artworkView;
@end

@interface ReachPlayerContainerView : UIView
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) _UIBackdropView *backgroundBlurView;
@property (nonatomic, retain) ReachPlayerArtworkContainerView *artworkContainerView;
@property (nonatomic, retain) UILabel *nowPlayingInfoSong;
@property (nonatomic, retain) UILabel *nowPlayingInfoArtist;
@property (nonatomic, retain) UILabel *nowPlayingInfoAlbum;
@property (nonatomic, retain) UIButton *playPauseButton;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *previousButton;
@end

@interface SBWallpaperEffectView : UIVisualEffectView
@end

@interface SBReachabilityBackgroundView : UIView
@end

@interface SBReachabilityBackgroundViewController : UIViewController
@property (nonatomic, retain) NSTimer *updateTimer;
- (void)updateReachability;
- (void)addReachPlayerContainerView;
@end

@interface UIColor (Private)
-(BOOL)_isSimilarToColor:(id)arg1 withinPercentage:(double)arg2 ;
@end

@interface SBReachabilityManager : NSObject
-(void)_setKeepAliveTimer;
+(id)sharedInstance;
-(void)toggleReachability;
-(BOOL)reachabilityModeActive;
-(void)deactivateReachability;
-(void)_notifyObserversReachabilityYOffsetDidChange;
@end

@interface SBMediaController
+ (id)sharedInstance;
- (BOOL)isPlaying;
@end

@interface SBReachabilityWindow : UIWindow
- (id)view;
@end

@interface SBHomeScreenSpotlightViewController : UIViewController
@end

@interface _UIStatusBarForegroundView : UIView
- (void)toggleStatusReachability:(id)sender;
@end
