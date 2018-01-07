//
//  NNViewController.m
//  NNCore
//
//  Created by ws00801526 on 11/14/2017.
//  Copyright (c) 2017 ws00801526. All rights reserved.
//

#import "NNViewController.h"
#import "NNColorSettingController.h"

#import <NNCore/NNCore.h>

@implementation NNViewControllerStyleModel

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(NNViewControllerStyle)style {
    
    if (self = [super init]) {
        switch (style) {
            case NNViewControllerStyleDisablePop:
            {
                _barHidden = NO;
                _popGestureDisabled = YES;
            }
                break;
            case NNViewControllerStyleBarHidden:
            {
                _barHidden = YES;
                _popGestureDisabled = NO;
            }
                break;
            case NNViewControllerStyleEnablePopOffset:
            {
                _barHidden = NO;
                _popGestureDisabled = NO;
                _popGestureOffset = SCREEN_WIDTH / 2.f;
            }
                break;
            case NNViewControllerStyleDefault:
            default:
            {
                _barHidden = NO;
                _popGestureDisabled = NO;
            }
                break;
        }
        _style = style;
    }
    return self;
}

#pragma mark - Getter

+ (UIColor *)colorFormColorMode:(NNViewControllerColorMode)mode {
    switch (mode) {
        case NNViewControllerColorModeRed:
            return [UIColor redColor];
        case NNViewControllerColorModeCyan:
            return [UIColor cyanColor];
        case NNViewControllerColorModeOrange:
            return [UIColor orangeColor];
        case NNViewControllerColorModeYellow:
            return [UIColor yellowColor];
        case NNViewControllerColorModeLightGray:
            return [UIColor lightGrayColor];
        case NNViewControllerColorModeDefault:
        default:
            return nil;
            break;
    }
}

+ (NSString *)colorTitleFormColorMode:(NNViewControllerColorMode)mode {
    switch (mode) {
        case NNViewControllerColorModeRed:
            return @"redColor";
        case NNViewControllerColorModeCyan:
            return @"cyanColor";
        case NNViewControllerColorModeOrange:
            return @"orangeColor";
        case NNViewControllerColorModeYellow:
            return @"yellowColor";
        case NNViewControllerColorModeLightGray:
            return @"lightGrayColor";
        case NNViewControllerColorModeDefault:
        default:
            return @"None Value";
    }
}

- (UIColor *)barTintColor {
    return [NNViewControllerStyleModel colorFormColorMode:self.barTintColorMode];
}

- (UIColor *)barBackgroundColor {
    return [NNViewControllerStyleModel colorFormColorMode:self.barBackgroundColorMode];
}

@end




@implementation UIImage (NNColorImage)

+ (instancetype)nn_imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.f, 1.f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@interface NNViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *barHiddenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *barShadowHiddenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *translucentSwitch;

@property (weak, nonatomic) IBOutlet UILabel *barTintColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *barBackgroundColorLabel;
@property (weak, nonatomic) IBOutlet UITextField *popGestureOffsetTextField;
@property (weak, nonatomic) IBOutlet UISwitch *popGestureDisabledSwitch;

@end

@implementation NNViewController

#pragma mark - Override

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!self.styleModel) {
        self.styleModel = [[NNViewControllerStyleModel alloc] initWithStyle:NNViewControllerStyleDefault];
    }
    
    [self setupViewControllerStyle];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40.f, 50.f);
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(handleNextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = nextButton;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.barTintColorLabel.text = [NNViewControllerStyleModel colorTitleFormColorMode:self.styleModel.barTintColorMode];
    self.barBackgroundColorLabel.text = [NNViewControllerStyleModel colorTitleFormColorMode:self.styleModel.barBackgroundColorMode];
}

#pragma mark - IBEvents

- (void)handleNextButtonAction:(UIButton *)button {
    
    NNViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NNViewController"];
    controller.styleModel = self.styleModel.yy_modelCopy;
    
    controller.styleModel.barHidden = self.barHiddenSwitch.isOn;
    controller.styleModel.barShadowHidden = self.barShadowHiddenSwitch.isOn;
    controller.styleModel.popGestureOffset = self.popGestureOffsetTextField.text.floatValue;
    controller.styleModel.popGestureDisabled = self.popGestureDisabledSwitch.isOn;
    
    controller.nn_perfersNavigationBarHidden = controller.styleModel.isBarHidden;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)handleTranslucentChanged:(UISwitch *)sender {
    self.navigationController.navigationBar.translucent = sender.isOn;
}

#pragma mark - Private

- (void)setupViewControllerStyle {
    
    self.navigationController.navigationBar.barTintColor = self.styleModel.barTintColor;
    if (self.styleModel.barBackgroundColor) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage nn_imageWithColor:self.styleModel.barBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationController.navigationBar.shadowImage = self.styleModel.isBarShadowHidden ? [UIImage new] : nil;
    
    self.title = [NSString stringWithFormat:@"Example :%d", (int)(self.navigationController.viewControllers.count)];

    self.nn_interactivePopOffset  = self.styleModel.popGestureOffset;
    self.popGestureOffsetTextField.text = [NSString stringWithFormat:@"%.2f", self.styleModel.popGestureOffset];
    
    self.nn_interactivePopDisabled = self.styleModel.popGestureDisabled;
    self.popGestureDisabledSwitch.on = self.styleModel.popGestureDisabled;
    
    self.barHiddenSwitch.on = self.styleModel.isBarHidden;
    self.barShadowHiddenSwitch.on = self.styleModel.isBarShadowHidden;
    
    if (self.styleModel.popGestureOffset > 0) {
        
        UILabel *disableLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - self.styleModel.popGestureOffset, 0, self.styleModel.popGestureOffset, SCREEN_HEIGHT)];
        disableLabel.text = @"不支持返回区域";
        disableLabel.backgroundColor = [UIColor redColor];
        disableLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:disableLabel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= 2) return;
    NNColorSettingController *settingController = [[NNColorSettingController alloc] init];
    settingController.styleModel = self.styleModel;
    settingController.updatingBachgroundColor = indexPath.row == 1;
    [self.navigationController pushViewController:settingController animated:YES];
}

@end
