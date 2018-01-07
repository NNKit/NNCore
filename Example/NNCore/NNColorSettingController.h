//  NNColorSettingController.h
//  NNCore
//
//  Created by  XMFraker on 2017/12/14
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NNColorSettingController
//  @version    <#class version#>
//  @abstract   <#class description#>

#import <UIKit/UIKit.h>
#import "NNViewController.h"

@interface NNColorSettingController : UITableViewController

@property (assign, nonatomic) BOOL updatingBachgroundColor;
@property (strong, nonatomic) NNViewControllerStyleModel *styleModel;

@end
