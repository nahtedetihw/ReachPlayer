#import <AudioToolbox/AudioServices.h>
#import "MediaRemote.h"
#import "CBAutoScrollLabel.h"
#import <Cephei/HBPreferences.h>

@interface SBWallpaperEffectView : UIVisualEffectView
@end

@interface SBReachabilityBackgroundView : UIView
@end

@interface SBReachabilityBackgroundViewController : UIViewController
- (UIColor *)getAverageColorFrom:(UIImage *)image withAlpha:(double)alpha;
- (UIColor *)lightDarkFromColor:(UIColor*)color;
- (void)updateImage:(NSNotification *)notification;
- (void)updateReachability;
- (void)updateTransition;
- (void)playPause;
- (void)next;
- (void)previous;
- (void)playingDidChange:(NSNotification *)notification;
@end

@interface UIColor (Private)
-(BOOL)_isSimilarToColor:(id)arg1 withinPercentage:(double)arg2 ;
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

@interface SBHomeScreenSpotlightViewController : UIViewController
@end

@interface _UIStatusBarForegroundView : UIView
- (void)toggleStatusReachability:(id)sender;
@end
