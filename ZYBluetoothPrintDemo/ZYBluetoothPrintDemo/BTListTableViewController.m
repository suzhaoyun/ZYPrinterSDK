//
//  BTListTableViewController.m
//  ZYBluetoothPrintDemo
//
//  Created by ZYSu on 2017/4/17.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "BTListTableViewController.h"
#import "ZYBlueToothTool.h"

@interface BTListTableViewController ()
@property (nonatomic, strong) ZYBlueToothTool *tool;
@property (nonatomic, strong) NSArray *deviceList;

@end

@implementation BTListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tool = [ZYBlueToothTool new];
    
    __weak typeof(self) this = self;
    [self.tool scanBlueToothDeviceWithCallBack:^(NSMutableArray *deviceList) {
        this.deviceList = deviceList;
        [this.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    ZYBlueToothDevice *device = self.deviceList[indexPath.row];
    cell.textLabel.text = device.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tool selectDevice:self.deviceList[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceList.count;
}

@end
