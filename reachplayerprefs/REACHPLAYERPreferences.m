#include "REACHPLAYERPreferences.h"
#import <AudioToolbox/AudioServices.h>
#import <Cephei/HBPreferences.h>

UIBarButtonItem *respringButtonItem;
UIViewController *popController;

CAGradientLayer *gradient1;
UIView *gradientView1;

@implementation REACHPLAYERPreferencesListController
@synthesize killButton;
@synthesize versionArray;

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
    }

    return _specifiers;
}

- (instancetype)init {

    self = [super init];

    if (self) {
        
        REACHPLAYERAppearanceSettings *appearanceSettings = [[REACHPLAYERAppearanceSettings alloc] init];
        self.hb_appearanceSettings = appearanceSettings;
        
        UIButton *respringButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        respringButton.frame = CGRectMake(0,0,30,30);
        respringButton.layer.cornerRadius = respringButton.frame.size.height / 2;
        respringButton.layer.masksToBounds = YES;
        respringButton.backgroundColor = [UIColor colorWithRed:60/255.0f green:83/255.0f blue:103/255.0f alpha:1.0f];
        [respringButton setImage:[UIImage systemImageNamed:@"checkmark.circle"] forState:UIControlStateNormal];
        [respringButton addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
        respringButton.tintColor = [UIColor colorWithRed:109/255.0f green:133/255.0f blue:143/255.0f alpha:1.0f];
        
        respringButtonItem = [[UIBarButtonItem alloc] initWithCustomView:respringButton];
        
        self.navigationItem.rightBarButtonItem = respringButtonItem;
        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/reachplayerprefs.bundle/icon.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 0.0;
        [self.navigationItem.titleView addSubview:self.iconView];

        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];

    }

    return self;

}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {

    return UIModalPresentationNone;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:109/255.0f green:133/255.0f blue:143/255.0f alpha:1.0f];
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationController.navigationBar.translucent = NO;

    [self addAnimation];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    UIColor *topGradient = [UIColor colorWithRed:109/255.0f green:133/255.0f blue:143/255.0f alpha:1.0f];
    UIColor *bottomGradient = [UIColor colorWithRed:60/255.0f green:83/255.0f blue:103/255.0f alpha:1.0f];
    
    gradientView1 = [[UIView alloc] initWithFrame:self.headerView.bounds];
    gradientView1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gradientView1.contentMode = UIViewContentModeScaleAspectFill;
    gradientView1.clipsToBounds = NO;

    gradient1 = [CAGradientLayer layer];
    gradient1.frame = self.headerView.bounds;
    gradient1.masksToBounds = YES;
    gradient1.needsDisplayOnBoundsChange = YES;
    gradient1.colors = [NSArray arrayWithObjects:(id)topGradient.CGColor, (id)bottomGradient.CGColor, nil];
    gradient1.startPoint = CGPointMake(0.0,0.5);
    gradient1.endPoint = CGPointMake(1.0,0.5);
    gradient1.locations = @[@1, @0];
    gradient1.transform = CATransform3DMakeScale(4, 1, 1);
    
    UIImage *gradientMaskImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/reachplayerprefs.bundle/banner.png"];
    UIImageView *gradientMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(gradientView1.center.x,0,gradientView1.frame.size.width,gradientView1.frame.size.height)];
    gradientMaskView.image = gradientMaskImage;
    gradientMaskView.contentMode = UIViewContentModeScaleAspectFill;
    gradientView1.maskView = gradientMaskView;
    gradientView1.center = self.headerView.center;
    [gradientView1.layer insertSublayer:gradient1 atIndex:0];
    [self.headerView insertSubview:gradientView1 atIndex:0];

    //constraints boiiiis
    gradientView1.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [gradientView1.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [gradientView1.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [gradientView1.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [gradientView1.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    _table.tableHeaderView = self.headerView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addAnimation)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil];
    /*
    NSTimer *updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(addAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];
    */
    [self addAnimation];

}
- (void)addAnimation {
    UIColor *topGradient = [UIColor colorWithRed:109/255.0f green:133/255.0f blue:143/255.0f alpha:1.0f];
    UIColor *bottomGradient = [UIColor colorWithRed:60/255.0f green:83/255.0f blue:103/255.0f alpha:1.0f];
    
    const CFTimeInterval duration = 5;
    
    CABasicAnimation *gradientAnimation = [CABasicAnimation animation];
    gradientAnimation.keyPath = @"colors";
    gradientAnimation.fromValue = @[(id)topGradient.CGColor,(id)bottomGradient.CGColor];
    gradientAnimation.toValue = @[(id)bottomGradient.CGColor,(id)topGradient.CGColor];
    gradientAnimation.duration = duration;
    gradientAnimation.repeatCount = INFINITY;
    gradientAnimation.autoreverses = YES;

    [gradient1 addAnimation:gradientAnimation forKey:@"chatAnimation"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];
    }

    if (offsetY > 0) offsetY = 0;
    self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
}

- (void)apply:(UIButton *)sender {
    
    popController = [[UIViewController alloc] init];
    popController.modalPresentationStyle = UIModalPresentationPopover;
    popController.preferredContentSize = CGSizeMake(200,130);
    UILabel *respringLabel = [[UILabel alloc] init];
    respringLabel.frame = CGRectMake(20, 20, 160, 60);
    respringLabel.numberOfLines = 2;
    respringLabel.textAlignment = NSTextAlignmentCenter;
    respringLabel.adjustsFontSizeToFitWidth = YES;
    respringLabel.font = [UIFont boldSystemFontOfSize:20];
    respringLabel.textColor = [UIColor labelColor];
    respringLabel.text = @"Are you sure you want to respring?";
    [popController.view addSubview:respringLabel];
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesButton addTarget:self
                  action:@selector(handleYesGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    yesButton.frame = CGRectMake(100, 100, 100, 30);
    [popController.view addSubview:yesButton];
    
    UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noButton addTarget:self
                  action:@selector(handleNoGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    noButton.frame = CGRectMake(0, 100, 100, 30);
    [popController.view addSubview:noButton];
     
    UIPopoverPresentationController *popover = popController.popoverPresentationController;
    popover.delegate = self;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.barButtonItem = respringButtonItem;
    
    [self presentViewController:popController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);

}

- (void)handleYesGesture:(UIButton *)sender {
    AudioServicesPlaySystemSound(1521);

    pid_t pid;
    const char* args[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)handleNoGesture:(UIButton *)sender {
    [popController dismissViewControllerAnimated:YES completion:nil];
}

@end



@implementation REACHPLAYERAppearanceSettings: HBAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed:109/255.0f green:133/255.0f blue:143/255.0f alpha:1.0f];

}

- (UIColor *)tableViewCellSeparatorColor {

    return [UIColor clearColor];

}


@end
