#import "ReachPlayerContainerView.h"

@implementation ReachPlayerContainerView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addBackgroundImage];
        [self addBackgroundBlur];
        [self addArtworkContainerView];
        [self addLabelsStackView];
        [self addControlsStackView];
        [self updateImage];
        [self updateTransition];
        
        if (self.nowPlayingInfoSong.text == nil) {
            [self setHidden:YES];
        } else {
            [self setHidden:NO];
        }
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(updateImage) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
        [notificationCenter postNotificationName:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingDidChange:) name:(__bridge NSString *)kMRMediaRemoteNowPlayingApplicationPlaybackStateDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:(__bridge NSString *)kMRMediaRemoteNowPlayingApplicationPlaybackStateDidChangeNotification object:nil];
    }
    return self;
}

- (void)addBackgroundImage {
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.backgroundImageView];
    
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
    [self.backgroundImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0].active = YES;
    [self.backgroundImageView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0].active = YES;
    [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
}

- (void)addBackgroundBlur {
    _UIBackdropViewSettings *settings;
    if (blurStyleRP == 0) {
        settings = [_UIBackdropViewSettings settingsForStyle:4005];
    } else if (blurStyleRP == 1) {
        settings = [_UIBackdropViewSettings settingsForStyle:2];
    } else if (blurStyleRP == 2) {
        settings = [_UIBackdropViewSettings settingsForStyle:4000];
    }
    
    self.backgroundBlurView = [[_UIBackdropView alloc] initWithSettings:settings];
    self.backgroundBlurView.frame = self.backgroundImageView.frame;
    [self insertSubview:self.backgroundBlurView aboveSubview:self.backgroundImageView];
    
    self.backgroundBlurView.translatesAutoresizingMaskIntoConstraints = false;
    [self.backgroundBlurView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
    [self.backgroundBlurView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0].active = YES;
    [self.backgroundBlurView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0].active = YES;
    [self.backgroundBlurView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
}

- (void)addArtworkContainerView {
    self.artworkContainerView = [[ReachPlayerArtworkContainerView alloc] initWithFrame:CGRectMake(0,0,artworkSizeRP,artworkSizeRP)];
    self.artworkContainerView.contentMode = UIViewContentModeScaleAspectFill;
    self.artworkContainerView.layer.masksToBounds = YES;
    self.artworkContainerView.layer.cornerCurve = kCACornerCurveContinuous;
    self.artworkContainerView.layer.cornerRadius = self.artworkContainerView.frame.size.height/16;
    [self addSubview:self.artworkContainerView];
    
    self.artworkContainerView.translatesAutoresizingMaskIntoConstraints = false;
    [self.artworkContainerView.widthAnchor constraintEqualToConstant:artworkSizeRP].active = true;
    [self.artworkContainerView.heightAnchor constraintEqualToConstant:artworkSizeRP].active = true;
    if (layoutStyleRP == 0) {
        [self.artworkContainerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:positionXRP-(artworkSizeRP/2)-15].active = true;
        [self.artworkContainerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:positionYRP+(artworkSizeRP/2)].active = true;
    } else if (layoutStyleRP == 1) {
        [self.artworkContainerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:positionXRP].active = true;
        [self.artworkContainerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:positionYRP+(artworkSizeRP/2)].active = true;
    }
    
    self.artworkContainerView.artworkView = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.center.y-positionYRP,artworkSizeRP,artworkSizeRP)];
    self.artworkContainerView.artworkView.contentMode = UIViewContentModeScaleAspectFill;
    self.artworkContainerView.artworkView.layer.masksToBounds = YES;
    self.artworkContainerView.artworkView.layer.cornerCurve = kCACornerCurveContinuous;
    self.artworkContainerView.artworkView.layer.cornerRadius = self.artworkContainerView.frame.size.height/16;
    [self.artworkContainerView insertSubview:self.artworkContainerView.artworkView atIndex:1];
    
    self.artworkContainerView.artworkView.translatesAutoresizingMaskIntoConstraints = false;
    [self.artworkContainerView.artworkView.widthAnchor constraintEqualToConstant:artworkSizeRP].active = true;
    [self.artworkContainerView.artworkView.heightAnchor constraintEqualToConstant:artworkSizeRP].active = true;
    [self.artworkContainerView.artworkView.centerXAnchor constraintEqualToAnchor:self.artworkContainerView.centerXAnchor constant:0].active = true;
    [self.artworkContainerView.artworkView.centerYAnchor constraintEqualToAnchor:self.artworkContainerView.centerYAnchor constant:0].active = true;
}

- (void)addNowPlayingInfoSong {
    self.nowPlayingInfoSong = [[UILabel alloc] init];
    [self.nowPlayingInfoSong setMarqueeRunning:YES];
    [self.nowPlayingInfoSong setMarqueeEnabled:YES];
    if (layoutStyleRP == 0) {
        self.nowPlayingInfoSong.textAlignment = NSTextAlignmentLeft;
    } else if (layoutStyleRP == 1) {
        self.nowPlayingInfoSong.textAlignment = NSTextAlignmentCenter;
    }
    self.nowPlayingInfoSong.font = [UIFont boldSystemFontOfSize:20];
    self.nowPlayingInfoSong.frame = CGRectMake(0, 0, 150, 20);
    if (blurStyleRP == 2) {
        self.nowPlayingInfoSong.textColor = [UIColor blackColor];
    } else {
        self.nowPlayingInfoSong.textColor = [UIColor whiteColor];
    }
    self.nowPlayingInfoSong.clipsToBounds = NO;
    self.nowPlayingInfoSong.isAccessibilityElement = YES;
    self.nowPlayingInfoSong.accessibilityHint = @"Name of the currently playing song.";
    [self.labelsStackView addArrangedSubview:self.nowPlayingInfoSong];
    
    self.nowPlayingInfoSong.translatesAutoresizingMaskIntoConstraints = false;
    [self.nowPlayingInfoSong.widthAnchor constraintEqualToConstant:150].active = true;
    [self.nowPlayingInfoSong.heightAnchor constraintEqualToConstant:20].active = true;
}

- (void)addNowPlayingInfoArtist {
    self.nowPlayingInfoArtist = [[UILabel alloc] init];
    [self.nowPlayingInfoArtist setMarqueeRunning:YES];
    [self.nowPlayingInfoArtist setMarqueeEnabled:YES];
    if (layoutStyleRP == 0) {
        self.nowPlayingInfoArtist.textAlignment = NSTextAlignmentLeft;
    } else if (layoutStyleRP == 1) {
        self.nowPlayingInfoArtist.textAlignment = NSTextAlignmentCenter;
    }
    self.nowPlayingInfoArtist.font = [UIFont boldSystemFontOfSize:14];
    self.nowPlayingInfoArtist.frame = CGRectMake(0, 0, 150, 20);
    self.nowPlayingInfoArtist.alpha = 0.6;
    if (blurStyleRP == 2) {
        self.nowPlayingInfoArtist.textColor = [UIColor blackColor];
    } else {
        self.nowPlayingInfoArtist.textColor = [UIColor whiteColor];
    }
    self.nowPlayingInfoArtist.clipsToBounds = NO;
    self.nowPlayingInfoArtist.isAccessibilityElement = YES;
    self.nowPlayingInfoArtist.accessibilityHint = @"Name of the currently playing artist.";
    [self.labelsStackView addArrangedSubview:self.nowPlayingInfoArtist];
    
    self.nowPlayingInfoArtist.translatesAutoresizingMaskIntoConstraints = false;
    [self.nowPlayingInfoArtist.widthAnchor constraintEqualToConstant:150].active = true;
    [self.nowPlayingInfoArtist.heightAnchor constraintEqualToConstant:20].active = true;
}

- (void)addNowPlayingInfoAlbum {
    self.nowPlayingInfoAlbum = [[UILabel alloc] init];
    [self.nowPlayingInfoAlbum setMarqueeRunning:YES];
    [self.nowPlayingInfoAlbum setMarqueeEnabled:YES];
    if (layoutStyleRP == 0) {
        self.nowPlayingInfoAlbum.textAlignment = NSTextAlignmentLeft;
    } else if (layoutStyleRP == 1) {
        self.nowPlayingInfoAlbum.textAlignment = NSTextAlignmentCenter;
    }
    self.nowPlayingInfoAlbum.font = [UIFont systemFontOfSize:14];
    self.nowPlayingInfoAlbum.frame = CGRectMake(0, 0, 150, 20);
    self.nowPlayingInfoAlbum.alpha = 0.2;
    if (blurStyleRP == 2) {
        self.nowPlayingInfoAlbum.textColor = [UIColor blackColor];
    } else {
        self.nowPlayingInfoAlbum.textColor = [UIColor whiteColor];
    }
    self.nowPlayingInfoAlbum.clipsToBounds = NO;
    self.nowPlayingInfoAlbum.isAccessibilityElement = YES;
    self.nowPlayingInfoAlbum.accessibilityHint = @"Name of the currently playing album.";
    [self.labelsStackView addArrangedSubview:self.nowPlayingInfoAlbum];
    
    self.nowPlayingInfoAlbum.translatesAutoresizingMaskIntoConstraints = false;
    [self.nowPlayingInfoAlbum.widthAnchor constraintEqualToConstant:150].active = true;
    [self.nowPlayingInfoAlbum.heightAnchor constraintEqualToConstant:20].active = true;
}

- (void)addLabelsStackView {
    self.labelsStackView = [UIStackView new];
    self.labelsStackView.frame = CGRectMake(self.center.x+positionXRP+75, self.center.y+positionYRP+30, 150, 60);
    self.labelsStackView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.labelsStackView.axis = UILayoutConstraintAxisVertical;
    self.labelsStackView.alignment = UIStackViewAlignmentFill;
    self.labelsStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.labelsStackView.spacing = 5;
    self.labelsStackView.layoutMarginsRelativeArrangement = YES;
    [self addNowPlayingInfoSong];
    [self addNowPlayingInfoArtist];
    [self addNowPlayingInfoAlbum];
    self.labelsStackView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.labelsStackView];
    self.labelsStackView.translatesAutoresizingMaskIntoConstraints = false;
    [self.labelsStackView.heightAnchor constraintEqualToConstant:60].active = true;
    [self.labelsStackView.widthAnchor constraintEqualToConstant:150].active = true;
    if (layoutStyleRP == 0) {
        [self.labelsStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:positionXRP+75].active = true;
        [self.labelsStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:positionYRP+40].active = true;
    } else if (layoutStyleRP == 1) {
        [self.labelsStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:positionXRP].active = true;
        [self.labelsStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:positionYRP+artworkSizeRP+30+10].active = true;
    }
}

- (void)addPreviousButton {
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousButton.frame = CGRectMake(0, 0, 27, 12);
    [self.previousButton setTitle:@"" forState:UIControlStateNormal];
    [self.previousButton setImage:[[UIImage systemImageNamed:@"backward.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    if (blurStyleRP == 2) {
        self.previousButton.tintColor = [UIColor blackColor];
    } else {
        self.previousButton.tintColor = [UIColor whiteColor];
    }
    [self.previousButton addTarget:self
                            action:@selector(previous)
                  forControlEvents:UIControlEventTouchUpInside];
    self.previousButton.isAccessibilityElement = YES;
    self.previousButton.accessibilityHint = @"Next Song Button.";
    self.previousButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.previousButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.previousButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self.previousButton setContentMode:UIViewContentModeCenter];
    [self.controlsStackView addArrangedSubview:self.previousButton];
    
    self.previousButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.previousButton.widthAnchor constraintEqualToConstant:32].active = true;
    [self.previousButton.heightAnchor constraintEqualToConstant:12].active = true;
}

- (void)addPlayPauseButton {
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playPauseButton setTitle:@"" forState:UIControlStateNormal];
    self.playPauseButton.frame = CGRectMake(0, 0, 20, 23);
    if (blurStyleRP == 2) {
        self.playPauseButton.tintColor = [UIColor blackColor];
    } else {
        self.playPauseButton.tintColor = [UIColor whiteColor];
    }
    
    [self.playPauseButton addTarget:self
                             action:@selector(playPause)
                   forControlEvents:UIControlEventTouchUpInside];
    self.playPauseButton.isAccessibilityElement = YES;
    self.playPauseButton.accessibilityHint = @"Play Pause Song Button.";
    self.playPauseButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.playPauseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.playPauseButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self.playPauseButton setContentMode:UIViewContentModeCenter];
    [self.controlsStackView addArrangedSubview:self.playPauseButton];
    
    self.playPauseButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.playPauseButton.widthAnchor constraintEqualToConstant:25].active = true;
    [self.playPauseButton.heightAnchor constraintEqualToConstant:28].active = true;
}

- (void)addNextButton {
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(0, 0, 27, 12);
    [self.nextButton setTitle:@"" forState:UIControlStateNormal];
    [self.nextButton setImage:[[UIImage systemImageNamed:@"forward.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    if (blurStyleRP == 2) {
        self.nextButton.tintColor = [UIColor blackColor];
    } else {
        self.nextButton.tintColor = [UIColor whiteColor];
    }
    [self.nextButton addTarget:self
                        action:@selector(next)
              forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.isAccessibilityElement = YES;
    self.nextButton.accessibilityHint = @"Next Song Button.";
    self.nextButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.nextButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self.nextButton setContentMode:UIViewContentModeCenter];
    [self.controlsStackView addArrangedSubview:self.nextButton];
    
    self.nextButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.nextButton.widthAnchor constraintEqualToConstant:32].active = true;
    [self.nextButton.heightAnchor constraintEqualToConstant:12].active = true;
}

- (void)addControlsStackView {
    self.controlsStackView = [UIStackView new];
    self.controlsStackView.frame = CGRectMake(self.center.x+positionXRP+47,self.center.y+positionYRP+28.5,94,57);
    self.controlsStackView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.controlsStackView.axis = UILayoutConstraintAxisHorizontal;
    self.controlsStackView.alignment = UIStackViewAlignmentFill;
    self.controlsStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.controlsStackView.spacing = 25;
    self.controlsStackView.layoutMarginsRelativeArrangement = YES;
    self.controlsStackView.translatesAutoresizingMaskIntoConstraints = false;
    [self addPreviousButton];
    [self addPlayPauseButton];
    [self addNextButton];
    [self addSubview:self.controlsStackView];
    self.controlsStackView.translatesAutoresizingMaskIntoConstraints = false;
    [self.controlsStackView.heightAnchor constraintEqualToConstant:28].active = true;
    [self.controlsStackView.widthAnchor constraintEqualToConstant:144].active = true;
    if (layoutStyleRP == 0) {
        [self.controlsStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:positionXRP+72].active = true;
        [self.controlsStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:positionYRP+60+10+14].active = true;
    } else if (layoutStyleRP == 1) {
        [self.controlsStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:positionXRP].active = true;
        [self.controlsStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:positionYRP+artworkSizeRP+70+10+14].active = true;
    }
}

- (void)playingDidChange:(NSNotification *)notification {
    MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlayingNow){
            if (isPlayingNow == YES) {
                [self.playPauseButton setBackgroundImage:[[UIImage systemImageNamed:@"pause.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            } else {
                [self.playPauseButton setBackgroundImage:[[UIImage systemImageNamed:@"play.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            }
        });
}

- (void)updateTransition {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;

    [self.artworkContainerView.artworkView.layer addAnimation:transition forKey:nil];
    
    CATransition *transitionBG = [CATransition animation];
    transitionBG.duration = 1.0f;
    transitionBG.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transitionBG.type = kCATransitionFade;

    [self.backgroundImageView.layer addAnimation:transitionBG forKey:nil];
}

- (void)playPause {
    MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
    AudioServicesPlaySystemSound(1519);
}

-(void)next {
    MRMediaRemoteSendCommand(kMRNextTrack, nil);
    AudioServicesPlaySystemSound(1519);
}

-(void)previous {
    MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
    AudioServicesPlaySystemSound(1519);
}

- (void)updateImage {
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
        if (result) {
            NSDictionary *dictionary = (__bridge NSDictionary *)result;
            NSString *songName = dictionary[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle];
            NSString *artistName = dictionary[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist];
            NSString *albumName = dictionary[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum];
            NSData *artworkData = [dictionary objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
            
            if (artworkData != nil) {
                self.artworkContainerView.artworkView.image = [UIImage imageWithData:artworkData];
                self.backgroundImageView.image = [UIImage imageWithData:artworkData];
                [self updateTransition];
            }
            
            if (songName != nil) {
                self.nowPlayingInfoSong.text = [NSString stringWithFormat:@"%@", songName];
                self.nowPlayingInfoSong.accessibilityLabel = [NSString stringWithFormat:@"%@", songName];
                [self setHidden:NO];
            } else {
                self.nowPlayingInfoSong.text = @" ";
                self.nowPlayingInfoSong.accessibilityLabel = @" ";
                [self setHidden:YES];
            }
            
            if (artistName != nil) {
                self.nowPlayingInfoArtist.text = [NSString stringWithFormat:@"%@", artistName];
                self.nowPlayingInfoArtist.accessibilityLabel = [NSString stringWithFormat:@"%@", songName];
            } else {
                self.nowPlayingInfoArtist.text = @" ";
                self.nowPlayingInfoArtist.accessibilityLabel = @" ";
            }
            
            if (albumName != nil) {
                self.nowPlayingInfoAlbum.text = [NSString stringWithFormat:@"%@", albumName];
                self.nowPlayingInfoAlbum.accessibilityLabel = [NSString stringWithFormat:@"%@", songName];
            } else {
                self.nowPlayingInfoAlbum.text = @" ";
                self.nowPlayingInfoAlbum.accessibilityLabel = @" ";
            }
        } else {
            self.artworkContainerView.artworkView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@DefaultContainerArtwork.png", bundlePath]];
            self.backgroundImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@DefaultContainerArtwork.png", bundlePath]];
        }
    });
}
@end

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
    }
}
