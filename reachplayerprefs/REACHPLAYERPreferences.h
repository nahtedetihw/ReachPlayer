#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <spawn.h>
#import <SparkColourPickerUtils.h>
#import <SparkColourPickerView.h>

@interface REACHPLAYERPreferencesListController : HBRootListController<UIPopoverPresentationControllerDelegate> {

    UITableView * _table;

}
@property (nonatomic, retain) UIBarButtonItem *killButton;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) NSArray *versionArray;
- (void)handleYesGesture:(UIButton *)sender;
- (void)handleNoGesture:(UIButton *)sender;
- (void)addAnimation;
@end

@interface REACHPLAYERAppearanceSettings: HBAppearanceSettings

@end
