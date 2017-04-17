//
//  ViewController.m
//  ZYBluetoothPrintDemo
//
//  Created by ZYSu on 2017/4/17.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ViewController.h"
#import "ZYBTPrinterTool.h"
#import "BTListTableViewController.h"
#import "DemoTool.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (nonatomic, strong) ZYBTPrinterTool *tool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *text = [[NSUserDefaults standardUserDefaults] stringForKey:ZYPrinterNameKey];
    self.nameL.text = text.length?text:@"未选择打印机";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectClick:(id)sender {
    [self.navigationController pushViewController:[BTListTableViewController new] animated:YES];
}

- (IBAction)printClick:(id)sender {
    // 蓝牙打印
    self.tool = [ZYBTPrinterTool new];
    
    // 数据生成类
    DemoTool *dataTool = [DemoTool new];
    dataTool.model = @{@"content" : self.textV.text};
    
    // 赋值
    self.tool.dataTool = dataTool;
    
    // 开始打印
    [self.tool startToPrint];
}

@end
