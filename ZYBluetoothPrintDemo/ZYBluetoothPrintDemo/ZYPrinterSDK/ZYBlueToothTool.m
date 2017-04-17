//
//  ZYBlueToothTool.m
//  ZYBluetoothPrintDemo
//
//  Created by ZYSu on 2017/4/17.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ZYBlueToothTool.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZYBTPrinterTool.h"
#import "ZYBlueToothTool.h"

@implementation ZYBlueToothDevice

- (BOOL)isEqual:(ZYBlueToothDevice *)object
{
    return [self.uuid isEqualToString:object.uuid];
}

@end


@interface ZYBlueToothTool ()<CBCentralManagerDelegate>

@property (nonatomic, copy) void (^callBack)(NSMutableArray *deviceList);

@property (nonatomic, strong) CBCentralManager *manager;

@property (nonatomic, strong) NSMutableArray *deviceList;


@end

@implementation ZYBlueToothTool

- (void)scanBlueToothDeviceWithCallBack:(void (^)(NSMutableArray *))callBack
{
    self.callBack = callBack;
    
    [[self manager] scanForPeripheralsWithServices:nil options:nil];
}

- (void)selectDevice:(ZYBlueToothDevice *)device
{
    if (device) {
        [[NSUserDefaults standardUserDefaults] setObject:device.name forKey:ZYPrinterNameKey];
        [[NSUserDefaults standardUserDefaults] setObject:device.uuid forKey:ZYPrinterUUIDKey];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBManagerStatePoweredOn) {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    ZYBlueToothDevice *device = [ZYBlueToothDevice new];
    device.name = peripheral.name.length?peripheral.name:@"未命名";
    device.uuid = peripheral.identifier.UUIDString;
    
    if (![self.deviceList containsObject:device]) {
        [self.deviceList addObject:device];
        !_callBack?:_callBack(_deviceList);
    }

}

- (CBCentralManager *)manager
{
    if (_manager == nil) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _manager;
}

- (NSMutableArray *)deviceList
{
    if (_deviceList == nil ){
        _deviceList = [NSMutableArray array];
    }
    return _deviceList;
}

@end
