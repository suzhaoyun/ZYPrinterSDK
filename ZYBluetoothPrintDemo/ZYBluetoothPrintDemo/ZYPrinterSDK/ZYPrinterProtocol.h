//
//  ZYPrinterProtocol.h
//  ZYBluetoothPrintDemo
//
//  Created by ZYSu on 2017/4/17.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYPrinterDataProtocol.h"

@protocol ZYPrinterProtocol <NSObject>

/// 打印份数
@property (nonatomic, assign) NSInteger pageNum;

/// 数据生成类
@property (nonatomic, strong) id<ZYPrinterDataProtocol> dataTool;

/// 开始打印
- (void)startToPrint;

/// 打印完成的通知
#define ZYPrinterPrintDataFinishNotification @"ZYPrinterPrintDataFinishNotification"
#define ZYPrinterUUIDKey                     @"ZYPrinterUUIDKey"
#define ZYPrinterNameKey                     @"ZYPrinterNameKey"

@end
