#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import "MediaRemote.h"

static NSString *preferencesNotification = @"com.nahtedetihw.reachplayerprefs/ReloadPrefs";

#define bundlePath ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/PreferenceBundles/reachplayerprefs.bundle/"] ? @"/Library/PreferenceBundles/reachplayerprefs.bundle/" : @"/var/jb/Library/PreferenceBundles/reachplayerprefs.bundle/")

#define plistPath ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.nahtedetihw.reachplayerprefs.plist"] ? @"/var/mobile/Library/Preferences/com.nahtedetihw.reachplayerprefs.plist" : @"/var/jb/var/mobile/Library/Preferences/com.nahtedetihw.reachplayerprefs.plist")

double positionXRP, positionYRP, artworkSizeRP, reachOffsetRP;
NSInteger layoutStyleRP, blurStyleRP;

static void loadPreferences() {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    positionXRP = dict[@"positionX"] ? [dict[@"positionX"] doubleValue] : 0;
    positionYRP = dict[@"positionY"] ? [dict[@"positionY"] doubleValue] : 0;
    artworkSizeRP = dict[@"artworkSize"] ? [dict[@"artworkSize"] doubleValue] : 160.0;
    
    layoutStyleRP = dict[@"layoutStyle"] ? [dict[@"layoutStyle"] integerValue] : 0;
    blurStyleRP = dict[@"blurStyle"] ? [dict[@"blurStyle"] integerValue] : 0;
}

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

@interface UILabel (RP)
- (void)setMarqueeRunning:(BOOL)arg1;
- (void)setMarqueeEnabled:(BOOL)arg1;
- (BOOL)marqueeEnabled;
- (BOOL)marqueeRunning;
@end

@interface ReachPlayerArtworkContainerView : UIView
@property (nonatomic, strong) UIImageView *artworkView;
@end

@implementation ReachPlayerArtworkContainerView
@end

@interface ReachPlayerContainerView : UIView
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) _UIBackdropView *backgroundBlurView;
@property (nonatomic, retain) ReachPlayerArtworkContainerView *artworkContainerView;
@property (nonatomic, retain) UILabel *nowPlayingInfoSong;
@property (nonatomic, retain) UILabel *nowPlayingInfoArtist;
@property (nonatomic, retain) UILabel *nowPlayingInfoAlbum;
@property (nonatomic, retain) UIStackView *labelsStackView;
@property (nonatomic, retain) UIButton *playPauseButton;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *previousButton;
@property (nonatomic, retain) UIStackView *controlsStackView;
- (void)addBackgroundImage;
- (void)addBackgroundBlur;
- (void)addArtworkContainerView;
- (void)addNowPlayingInfoSong;
- (void)addNowPlayingInfoAlbum;
- (void)addPlayPauseButton;
- (void)addNextButton;
- (void)addPreviousButton;
- (void)playingDidChange:(NSNotification *)notification;
- (void)updateTransition;
- (void)playPause;
-(void)next;
-(void)previous;
- (void)updateImage;
- (void)addLabelsStackView;
- (void)addControlsStackView;
@end
