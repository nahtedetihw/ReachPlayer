#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <spawn.h>

@interface UIPopoverPresentationController (Private)
@property (assign,setter=_setPopoverBackgroundStyle:,nonatomic) long long _popoverBackgroundStyle;
@property (assign,setter=_setBackgroundBlurDisabled:,nonatomic) BOOL _backgroundBlurDisabled;
@end

@interface OBButtonTray : UIView
@property (nonatomic,retain) UIVisualEffectView * effectView;
- (void)addButton:(id)arg1;
- (void)addCaptionText:(id)arg1;;
@end

@interface OBBoldTrayButton : UIButton
- (void)setTitle:(id)arg1 forState:(unsigned long long)arg2;
+ (id)buttonWithType:(long long)arg1;
@end

@interface OBBulletedListItem : UIView
@property (nonatomic,retain) UIImageView * imageView;
@end

@interface OBBulletedList : UIView
@property (nonatomic,retain) NSMutableArray * items;
@end

@interface OBWelcomeController : UIViewController
@property (nonatomic,retain) OBBulletedList * bulletedList;
@property (nonatomic, retain) UIView *viewIfLoaded;
@property (nonatomic, strong) UIColor *backgroundColor;
- (OBButtonTray *)buttonTray;
- (id)initWithTitle:(id)arg1 detailText:(id)arg2 icon:(id)arg3;
- (void)addBulletedListItemWithTitle:(id)arg1 description:(id)arg2 image:(id)arg3;
@end

@interface REACHPLAYERPreferencesListController : PSListController<UIPopoverPresentationControllerDelegate> {

    UITableView * _table;

}
@property (nonatomic, retain) UIBarButtonItem *killButton;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) NSArray *versionArray;
@property (nonatomic, retain) OBWelcomeController *changelogController;
- (void)apply:(UIButton *)sender;
- (void)twitter:(UIButton *)sender;
- (void)paypal:(UIButton *)sender;
- (void)handleYesGesture;
- (void)handleNoGesture:(UIButton *)sender;
@end

@interface REACHPLAYERACTIVATIONPreferencesListController : PSListController
@end

@interface REACHPLAYERLAYOUTPreferencesListController : PSListController
@end

@interface REACHPLAYERBACKGROUNDPreferencesListController : PSListController
@end

@interface REACHPLAYERMISCPreferencesListController : PSListController
@end
