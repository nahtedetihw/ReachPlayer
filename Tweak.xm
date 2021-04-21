#import "Tweak.h"

HBPreferences *preferences;
BOOL enable;
BOOL enableBlur;
BOOL enableTapToToggle;
double chevronOpacity;
double keepAliveDuration;
double positionX;
double positionY;
double artworkSize;
double reachOffset;

BOOL isPlaying() {
    return [[%c(SBMediaController) sharedInstance] isPlaying];
}

UIView *emptyView;
UIImageView *newBGImageView;
UIImageView *newImageView;
CBAutoScrollLabel *nowPlayingInfoSong;
CBAutoScrollLabel *nowPlayingInfoArtist;
CBAutoScrollLabel *nowPlayingInfoAlbum;
NSTimer *updateTimer;
UIButton *playPauseButton;
UIButton *nextButton;
UIButton *previousButton;

%group ReachPlayer

// tap to toggle
%hook _UIStatusBarForegroundView
- (id)initWithFrame:(CGRect)frame {
    self = %orig;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleStatusReachability:)];
    self.userInteractionEnabled = YES;
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];
    
    return self;
}

%new
- (void)toggleStatusReachability:(id)sender {
    if (enableTapToToggle) {
    [[%c(SBReachabilityManager) sharedInstance] toggleReachability];
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
// Sets the vertical offset
- (void)setYOffsetFactor:(double)arg1 {
    arg1 = reachOffset;
    %orig;
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
-(void)_setKeepAliveTimer {
    // remove orig timer
}

-(void)_pingKeepAliveWithDuration:(double)arg1 interactedBeforePing:(BOOL)arg2 initialKeepAliveTime:(double)arg3 {
    // remove orig timer
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
- (void)viewWillAppear:(BOOL)animated {
    %orig;
    
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
    [newImageView.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY-10].active = true;
    
        nowPlayingInfoSong = [[CBAutoScrollLabel alloc] init];
        nowPlayingInfoSong.textAlignment = NSTextAlignmentLeft;
        nowPlayingInfoSong.font = [UIFont boldSystemFontOfSize:20];
        nowPlayingInfoSong.frame = CGRectMake(topWallpaperEffectView.frame.size.width, topWallpaperEffectView.center.y-positionY-25, 150, 20);
    if (newImageView.image != nil) {
        nowPlayingInfoSong.textColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
    } else {
        nowPlayingInfoSong.textColor = [UIColor labelColor];
    }
        nowPlayingInfoSong.clipsToBounds = NO;
        nowPlayingInfoSong.isAccessibilityElement = YES;
        nowPlayingInfoSong.accessibilityHint = @"Name of the currently playing song.";
    [topWallpaperEffectView addSubview:nowPlayingInfoSong];
    
        nowPlayingInfoSong.translatesAutoresizingMaskIntoConstraints = false;
    [nowPlayingInfoSong.widthAnchor constraintEqualToConstant:150].active = true;
    [nowPlayingInfoSong.heightAnchor constraintEqualToConstant:20].active = true;
    [nowPlayingInfoSong.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX+170].active = true;
    [nowPlayingInfoSong.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY-40].active = true;
    
    
        nowPlayingInfoArtist = [[CBAutoScrollLabel alloc] init];
        nowPlayingInfoArtist.textAlignment = NSTextAlignmentLeft;
        nowPlayingInfoArtist.font = [UIFont boldSystemFontOfSize:14];
        nowPlayingInfoArtist.frame = CGRectMake(topWallpaperEffectView.frame.size.width, topWallpaperEffectView.center.y-positionY, 150, 20);
        nowPlayingInfoArtist.alpha = 0.6;
    if (newImageView.image != nil) {
        nowPlayingInfoArtist.textColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
    } else {
        nowPlayingInfoArtist.textColor = [UIColor labelColor];
    }
        nowPlayingInfoArtist.clipsToBounds = NO;
        nowPlayingInfoArtist.isAccessibilityElement = YES;
        nowPlayingInfoArtist.accessibilityHint = @"Name of the currently playing artist.";
    [topWallpaperEffectView addSubview:nowPlayingInfoArtist];
    
        nowPlayingInfoArtist.translatesAutoresizingMaskIntoConstraints = false;
    [nowPlayingInfoArtist.widthAnchor constraintEqualToConstant:150].active = true;
    [nowPlayingInfoArtist.heightAnchor constraintEqualToConstant:20].active = true;
    [nowPlayingInfoArtist.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX+170].active = true;
    [nowPlayingInfoArtist.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY-20].active = true;
    
    
        nowPlayingInfoAlbum = [[CBAutoScrollLabel alloc] init];
        nowPlayingInfoAlbum.textAlignment = NSTextAlignmentLeft;
        nowPlayingInfoAlbum.font = [UIFont systemFontOfSize:14];
        nowPlayingInfoAlbum.frame = CGRectMake(topWallpaperEffectView.frame.size.width, topWallpaperEffectView.center.y-positionY+25, 150, 20);
        nowPlayingInfoAlbum.alpha = 0.2;
    if (newImageView.image != nil) {
        nowPlayingInfoAlbum.textColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
    } else {
        nowPlayingInfoAlbum.textColor = [UIColor labelColor];
    }
        nowPlayingInfoAlbum.clipsToBounds = NO;
        nowPlayingInfoAlbum.isAccessibilityElement = YES;
        nowPlayingInfoAlbum.accessibilityHint = @"Name of the currently playing album.";
    [topWallpaperEffectView addSubview:nowPlayingInfoAlbum];
    
        nowPlayingInfoAlbum.translatesAutoresizingMaskIntoConstraints = false;
    [nowPlayingInfoAlbum.widthAnchor constraintEqualToConstant:150].active = true;
    [nowPlayingInfoAlbum.heightAnchor constraintEqualToConstant:20].active = true;
    [nowPlayingInfoAlbum.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX+170].active = true;
    [nowPlayingInfoAlbum.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY].active = true;
        
        playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playPauseButton setTitle:@"" forState:UIControlStateNormal];
        playPauseButton.frame = CGRectMake(topWallpaperEffectView.frame.size.width, topWallpaperEffectView.center.y-positionY, 30, 30);
    if (isPlaying()) {
        [playPauseButton setImage:[[UIImage systemImageNamed:@"pause.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    } else {
        [playPauseButton setImage:[[UIImage systemImageNamed:@"play.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    if (newImageView.image != nil) {
        playPauseButton.tintColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
    } else {
        playPauseButton.tintColor = [UIColor labelColor];
    }
    [playPauseButton addTarget:self
                  action:@selector(playPause)
        forControlEvents:UIControlEventTouchUpInside];
        playPauseButton.isAccessibilityElement = YES;
        playPauseButton.accessibilityHint = @"Play Pause Song Button.";
    [topWallpaperEffectView addSubview:playPauseButton];
        
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false;
    [playPauseButton.widthAnchor constraintEqualToConstant:30].active = true;
    [playPauseButton.heightAnchor constraintEqualToConstant:30].active = true;
    [playPauseButton.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX+170].active = true;
    [playPauseButton.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY+30].active = true;
        
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(topWallpaperEffectView.frame.size.width, topWallpaperEffectView.center.y-positionY, 30, 30);
    [nextButton setTitle:@"" forState:UIControlStateNormal];
    [nextButton setImage:[[UIImage systemImageNamed:@"forward.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    if (newImageView.image != nil) {
        nextButton.tintColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
    } else {
        nextButton.tintColor = [UIColor labelColor];
    }
    [nextButton addTarget:self
                      action:@selector(next)
            forControlEvents:UIControlEventTouchUpInside];
        nextButton.isAccessibilityElement = YES;
        nextButton.accessibilityHint = @"Next Song Button.";
    [topWallpaperEffectView addSubview:nextButton];
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false;
    [nextButton.widthAnchor constraintEqualToConstant:30].active = true;
    [nextButton.heightAnchor constraintEqualToConstant:30].active = true;
    [nextButton.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX+170+50].active = true;
    [nextButton.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY+30].active = true;
        
        previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        previousButton.frame = CGRectMake(topWallpaperEffectView.frame.size.width, topWallpaperEffectView.center.y-positionY, 30, 30);
    [previousButton setTitle:@"" forState:UIControlStateNormal];
    [previousButton setImage:[[UIImage systemImageNamed:@"backward.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    if (newImageView.image != nil) {
        previousButton.tintColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
    } else {
        previousButton.tintColor = [UIColor labelColor];
    }
    [previousButton addTarget:self
                  action:@selector(previous)
        forControlEvents:UIControlEventTouchUpInside];
        previousButton.isAccessibilityElement = YES;
        previousButton.accessibilityHint = @"Next Song Button.";
    [topWallpaperEffectView addSubview:previousButton];
        
        previousButton.translatesAutoresizingMaskIntoConstraints = false;
    [previousButton.widthAnchor constraintEqualToConstant:30].active = true;
    [previousButton.heightAnchor constraintEqualToConstant:30].active = true;
    [previousButton.centerXAnchor constraintEqualToAnchor:topWallpaperEffectView.centerXAnchor constant:-positionX+170-50].active = true;
    [previousButton.centerYAnchor constraintEqualToAnchor:topWallpaperEffectView.centerYAnchor constant:positionY+30].active = true;
    
        newImageView.hidden = YES;
        newBGImageView.hidden = YES;
        nowPlayingInfoSong.hidden = YES;
        nowPlayingInfoArtist.hidden = YES;
        nowPlayingInfoAlbum.hidden = YES;
        playPauseButton.hidden = YES;
        nextButton.hidden = YES;
        previousButton.hidden = YES;
        
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(updateImage:) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
    [notificationCenter postNotificationName:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
        
    }
}

- (void)viewDidLoad {
    %orig;
    
    if ([[%c(SBReachabilityManager) sharedInstance] reachabilityModeActive] == YES) {
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:keepAliveDuration target:self selector:@selector(updateReachability) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];
        }
    if (isPlaying()) {
        [playPauseButton setImage:[[UIImage systemImageNamed:@"pause.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    } else {
        [playPauseButton setImage:[[UIImage systemImageNamed:@"play.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
}

%new
- (void)updateTransition {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;

    [newImageView.layer addAnimation:transition forKey:nil];
    
    CATransition *transitionBG = [CATransition animation];
    transitionBG.duration = 1.0f;
    transitionBG.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transitionBG.type = kCATransitionFade;

    [newBGImageView.layer addAnimation:transitionBG forKey:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    %orig;
    [updateTimer invalidate];
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
    if (isPlaying()) {
        [playPauseButton setImage:[[UIImage systemImageNamed:@"pause.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    } else {
        [playPauseButton setImage:[[UIImage systemImageNamed:@"play.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    AudioServicesPlaySystemSound(1519);
}

%new
-(void)next {
    MRMediaRemoteSendCommand(kMRNextTrack, nil);
    NSLog(@"ReachPlayer DEBUG: %@", @"Next");
    AudioServicesPlaySystemSound(1519);
    
    [self updateTransition];
}

%new
-(void)previous {
    MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
    NSLog(@"ReachPlayer DEBUG: %@", @"Previous");
    AudioServicesPlaySystemSound(1519);
    
    [self updateTransition];
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
            
            if (songName != nil) {
                nowPlayingInfoSong.text = [NSString stringWithFormat:@"%@", songName];
                nowPlayingInfoSong.accessibilityLabel = [NSString stringWithFormat:@"%@", songName];
            } else {
                nowPlayingInfoSong.text = @" ";
                nowPlayingInfoSong.accessibilityLabel = @" ";
            }
            
            if (artistName != nil) {
                nowPlayingInfoArtist.text = [NSString stringWithFormat:@"%@", artistName];
                nowPlayingInfoArtist.accessibilityLabel = [NSString stringWithFormat:@"%@", songName];
            } else {
                nowPlayingInfoArtist.text = @" ";
                nowPlayingInfoArtist.accessibilityLabel = @" ";
            }
              
            if (albumName != nil) {
                nowPlayingInfoAlbum.text = [NSString stringWithFormat:@"%@", albumName];
                nowPlayingInfoAlbum.accessibilityLabel = [NSString stringWithFormat:@"%@", songName];
            } else {
                nowPlayingInfoAlbum.text = @" ";
                nowPlayingInfoAlbum.accessibilityLabel = @" ";
            }
            
            if (enableBlur) {
                newBGImageView.hidden = NO;
            }
            if (isPlaying()) {
                [playPauseButton setImage:[[UIImage systemImageNamed:@"pause.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            } else {
                [playPauseButton setImage:[[UIImage systemImageNamed:@"play.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            }
            newImageView.hidden = NO;
            nowPlayingInfoSong.hidden = NO;
            nowPlayingInfoArtist.hidden = NO;
            nowPlayingInfoAlbum.hidden = NO;
            playPauseButton.hidden = NO;
            nextButton.hidden = NO;
            previousButton.hidden = NO;
            
            nowPlayingInfoSong.textColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
            nowPlayingInfoArtist.textColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
            nowPlayingInfoAlbum.textColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
            playPauseButton.tintColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
            nextButton.tintColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];
            previousButton.tintColor = [self lightDarkFromColor:[self getAverageColorFrom:newImageView.image withAlpha:1]];

        } else {
            if (enableBlur) {
                newBGImageView.hidden = YES;
            }
            newImageView.hidden = YES;
            nowPlayingInfoSong.hidden = YES;
            nowPlayingInfoArtist.hidden = YES;
            nowPlayingInfoAlbum.hidden = YES;
            playPauseButton.hidden = YES;
            nextButton.hidden = YES;
            previousButton.hidden = YES;
            
            nowPlayingInfoSong.textColor = [UIColor labelColor];
            nowPlayingInfoArtist.textColor = [UIColor labelColor];
            nowPlayingInfoAlbum.textColor = [UIColor labelColor];
            playPauseButton.tintColor = [UIColor labelColor];
            nextButton.tintColor = [UIColor labelColor];
            previousButton.tintColor = [UIColor labelColor];
        }
  });
}

%new
- (UIColor *)getAverageColorFrom:(UIImage *)image withAlpha:(double)alpha {
      
    CGSize size = {1, 1};
      UIGraphicsBeginImageContext(size);
      CGContextRef ctx = UIGraphicsGetCurrentContext();
      CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);

      [image drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];

      uint8_t *data = (uint8_t *)CGBitmapContextGetData(ctx);

      UIColor *color = [UIColor colorWithRed:data[2] / 255.0f
                                   green:data[1] / 255.0f
                                    blue:data[0] / 255.0f
                                   alpha:alpha];

      UIGraphicsEndImageContext();

      return color;

}

%new
- (UIColor *)lightDarkFromColor:(UIColor*)color {
    size_t count = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);

    CGFloat darknessScore = 0;
    if (count == 2) {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[0]*255) * 587) + ((componentColors[0]*255) * 114)) / 1000;
    } else if (count == 4) {
        darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
    }

    if (darknessScore >= 125) {
        return [UIColor blackColor];
    }

    return [UIColor whiteColor];
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
    [preferences registerBool:&enableTapToToggle default:NO forKey:@"enableTapToToggle"];
    [preferences registerDouble:&chevronOpacity default:1.0 forKey:@"chevronOpacity"];
    [preferences registerDouble:&keepAliveDuration default:8.0 forKey:@"keepAliveDuration"];
    [preferences registerDouble:&positionX default:90.0 forKey:@"positionX"];
    [preferences registerDouble:&positionY default:180.0 forKey:@"positionY"];
    [preferences registerDouble:&artworkSize default:160.0 forKey:@"artworkSize"];
    [preferences registerDouble:&reachOffset default:0.4 forKey:@"reachOffset"];
    
    if (enable) {
    %init(ReachPlayer);
    return;
    }
    return;
}
}
