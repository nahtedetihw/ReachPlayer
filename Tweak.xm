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

@interface SBWallpaperEffectView : UIVisualEffectView
@end

@interface SBReachabilityBackgroundView : UIView
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

BOOL isPlaying() {
    return [[%c(SBMediaController) sharedInstance] isPlaying];
}
UIView *containerView;
UIImageView *newImageView;
UIImageView *newBGImageView;
CBAutoScrollLabel *nowPlayingInfoSong;
CBAutoScrollLabel *nowPlayingInfoArtist;
CBAutoScrollLabel *nowPlayingInfoAlbum;

%group ReachPlayer
%hook SBReachabilityManager
-(void)_setKeepAliveTimer {
    // remove orig timer
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

- (void)didMoveToSuperview {
    %orig;
    
    SBWallpaperEffectView *topWallpaperEffectView = MSHookIvar<SBWallpaperEffectView *>(self, "_topWallpaperEffectView");
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
    blurView.frame = containerView.frame;
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
    
    if ([[%c(SBReachabilityManager) sharedInstance] reachabilityModeActive] == YES) {
    NSTimer *updateTimer = [NSTimer scheduledTimerWithTimeInterval:keepAliveDuration target:self selector:@selector(updateReachability) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];
    }
    }
}

%new
- (void)updateReachability {
    if ([[%c(SBReachabilityManager) sharedInstance] reachabilityModeActive] == YES) {
    [[%c(SBReachabilityManager) sharedInstance] toggleReachability];
    }
}

%new
- (void)playPause {
    MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
    NSLog(@"ReachPlayer DEBUG: %@", @"PlayPause");
    AudioServicesPlaySystemSound(1519);
}

%new
-(void)next {
    MRMediaRemoteSendCommand(kMRNextTrack, nil);
    NSLog(@"ReachPlayer DEBUG: %@", @"Next");
    AudioServicesPlaySystemSound(1519);
}

%new
-(void)previous {
    MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
    NSLog(@"ReachPlayer DEBUG: %@", @"Previous");
    AudioServicesPlaySystemSound(1519);
}

%new
- (void)updateImage:(NSNotification *)notification {
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
            
            if (nowPlayingInfoSong != nil) {
            nowPlayingInfoSong.text = [NSString stringWithFormat:@"%@", songName];
            } else {
            nowPlayingInfoSong.text = @" ";
            }
            
            if (nowPlayingInfoArtist != nil) {
            nowPlayingInfoArtist.text = [NSString stringWithFormat:@"%@", artistName];
            } else {
            nowPlayingInfoArtist.text = @" ";
            }
              
            if (nowPlayingInfoAlbum != nil) {
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

    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.nahtedetihw.reachplayerprefs"];
    [preferences registerBool:&enable default:NO forKey:@"enable"];
    [preferences registerBool:&enableBlur default:NO forKey:@"enableBlur"];
    [preferences registerDouble:&chevronOpacity default:1.0 forKey:@"chevronOpacity"];
    [preferences registerDouble:&keepAliveDuration default:8.0 forKey:@"keepAliveDuration"];
    [preferences registerDouble:&positionX default:90.0 forKey:@"positionX"];
    [preferences registerDouble:&positionY default:180.0 forKey:@"positionY"];
    [preferences registerDouble:&artworkSize default:160.0 forKey:@"artworkSize"];
    
    if (enable) {
    %init(ReachPlayer);
    return;
    }
    return;
}
}
