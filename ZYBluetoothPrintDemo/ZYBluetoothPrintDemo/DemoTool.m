//
//  DemoTool.m
//  ZYBluetoothPrintDemo
//
//  Created by ZYSu on 2017/4/17.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "DemoTool.h"

@implementation DemoTool

- (void)printBusiness
{
    [self printText:self.model[@"content"]];
    [self printLineFeed:10];
}

@end
