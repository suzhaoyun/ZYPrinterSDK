//
//  ZYBlueToothTool.h
//  ZYBluetoothPrintDemo
//
//  Created by ZYSu on 2017/4/17.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYBlueToothDevice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;

@end

@class ZYBlueToothDevice;
@interface ZYBlueToothTool : NSObject

/**
 扫描周围设备

 @param callBack 回调
 */
- (void)scanBlueToothDeviceWithCallBack:(void (^)(NSMutableArray *deviceList))callBack;

// 选中该设备
- (void)selectDevice:(ZYBlueToothDevice *)device;

@end
