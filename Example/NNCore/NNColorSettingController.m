//  NNColorSettingController.m
//  NNCore
//
//  Created by  XMFraker on 2017/12/14
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NNColorSettingController
//  @version    <#class version#>
//  @abstract   <#class description#>

#import "NNColorSettingController.h"
#import "NNViewController.h"

@interface NNColorSettingController ()

@end

@implementation NNColorSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - UITableViewDelegate & UITableViewSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return NNViewControllerColorModeMask;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NNViewControllerStyleModel colorTitleFormColorMode:indexPath.row];
    if (self.updatingBachgroundColor) {
        cell.accessoryType = indexPath.row == self.styleModel.barBackgroundColorMode ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = indexPath.row == self.styleModel.barTintColorMode ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.updatingBachgroundColor) {
        self.styleModel.barBackgroundColorMode = indexPath.row;
    } else {
        self.styleModel.barTintColorMode = indexPath.row;
    }
    [tableView reloadData];
}

@end
