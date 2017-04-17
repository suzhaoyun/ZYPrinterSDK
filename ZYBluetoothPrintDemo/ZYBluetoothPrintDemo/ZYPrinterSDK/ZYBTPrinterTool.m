//
//  ZYBTPrinterTool.m
//  JuniuHD
//
//  Created by ZYSu on 2016/12/6.
//  Copyright © 2016年 ZYSu. All rights reserved.
//

#import "ZYBTPrinterTool.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZYESCPOSDataTool.h"

@interface ZYBTPrinterTool ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, strong) CBCharacteristic *charactersticStr;//打印字符串的特征
@property (nonatomic, strong) CBPeripheral *seletedPeripheral;
@property (nonatomic, assign) NSInteger printCount;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) CGFloat timeSecond;

@end

@implementation ZYBTPrinterTool
@synthesize pageNum = _pageNum;
@synthesize dataTool = _dataTool;

- (instancetype)init
{
    if (self = [super init]) {
        // 默认打印页数
        self.pageNum = 1;
    }
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"%@工具类死了", self);
}

#pragma mark - 打印事件
- (BOOL)printerStatusError
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:ZYPrinterUUIDKey];
    if (!uuid.length) {
        return YES;
    }
    return NO;
}

- (void)startToPrint
{
    if ([self printerStatusError]) {
        NSLog(@"未选择打印机...");
        return;
    }
    
    if (self.manager.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"打印中...");
        self.timeSecond = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.manager scanForPeripheralsWithServices:nil options:nil];
    }
}
- (void)updateTime
{
    _timeSecond ++;
    if (_timeSecond >= 10) {
        // 任然没有找到特征
        if (self.charactersticStr == nil) {
            NSLog(@"打印失败...");
            _timeSecond = 0;
            [_timer invalidate];
            [_manager stopScan];
        }
    }
    
    if (_timeSecond > 30) {
        NSLog(@"打印失败...");
        [_timer invalidate];
        [_manager stopScan];
    }
}

- (void)printJuniu
{
    if (self.charactersticStr == nil){
        NSLog(@"没有特征");
        [self.seletedPeripheral discoverServices:nil];
        return;
    }
    
    self.printCount = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 初始化打印机
        for (NSInteger i = 1; i <= self.pageNum; i++) {
            // 存储要打印数据
            [self.dataTool printBusiness];
        }
        
        for (NSData *data in self.dataTool.datas) {
            [self.seletedPeripheral writeValue:data forCharacteristic:self.charactersticStr type:CBCharacteristicWriteWithResponse];
        }
    });
}

#pragma mark - CBCentramanagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startToPrint];
    }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"连接打印机失败");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (self.charactersticStr) {
        return;
    }
    for (CBCharacteristic *character in service.characteristics) {
        NSString *s = [self getPropertiesString:character.properties];
        NSLog(@"----%@", s);
        if ([self checkCharacter:character] > 0){
            self.charactersticStr = character;
            [self printJuniu];
            break;
        }
    }
}

/// 判断是否可以打印
- (int)checkCharacter:(CBCharacteristic *)character
{
    NSString *str = [self getPropertiesString:character.properties];
    
    /**
     * 这个特征是四个打印机共有的写特征
     * 只能使用对应的WriteWithOutResponse 不然会提示 (writing is not permited)
     */
    if ([str rangeOfString:@"Write"].length && [str rangeOfString:@"Read"].length && [str rangeOfString:@"Notify"].length && [str rangeOfString:@"Indicate"].length) {
        return 1;
    }
    return 0;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    // 自动连接设备
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:ZYPrinterUUIDKey] isEqualToString:peripheral.identifier.UUIDString]) {
        peripheral.delegate = self;
        self.seletedPeripheral = peripheral;
        [central connectPeripheral:peripheral options:nil];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    self.printCount ++;
    if (self.printCount == self.dataTool.datas.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self printFinish];
        });
    }
}


// 打印完成
- (void)printFinish
{
    [self.manager cancelPeripheralConnection:self.seletedPeripheral];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZYPrinterPrintDataFinishNotification object:nil];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

/**
 *  拼接特征值
 *
 *  @param properties 单个属性
 *
 *  @return 拼接后的属性
 */
- (NSString *)getPropertiesString:(CBCharacteristicProperties)properties{
    NSMutableString *s = [[NSMutableString alloc]init];
    [s appendString:@""];
    
    if ((properties & CBCharacteristicPropertyBroadcast) == CBCharacteristicPropertyBroadcast) {
        [s appendString:@" Broadcast"];
    }
    if ((properties & CBCharacteristicPropertyRead) == CBCharacteristicPropertyRead) {
        [s appendString:@" Read"];
    }
    if ((properties & CBCharacteristicPropertyWriteWithoutResponse) == CBCharacteristicPropertyWriteWithoutResponse) {
        [s appendString:@" WriteWithoutResponse"];
    }
    if ((properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite) {
        [s appendString:@" Write"];
    }
    if ((properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify) {
        [s appendString:@" Notify"];
    }
    if ((properties & CBCharacteristicPropertyIndicate) == CBCharacteristicPropertyIndicate) {
        [s appendString:@" Indicate"];
    }
    if ((properties & CBCharacteristicPropertyAuthenticatedSignedWrites) == CBCharacteristicPropertyAuthenticatedSignedWrites) {
        [s appendString:@" AuthenticatedSignedWrites"];
    }
    if ((properties & CBCharacteristicPropertyExtendedProperties) == CBCharacteristicPropertyExtendedProperties) {
        [s appendString:@" ExtendedProperties"];
    }
    if ((properties & CBCharacteristicPropertyNotifyEncryptionRequired) == CBCharacteristicPropertyNotifyEncryptionRequired) {
        [s appendString:@" NotifyEncryptionRequired"];
    }
    if ((properties & CBCharacteristicPropertyIndicateEncryptionRequired) == CBCharacteristicPropertyIndicateEncryptionRequired) {
        [s appendString:@" IndicateEncryptionRequired"];
    }
    
    if ([s length]<2) {
        [s appendString:@"unknow"];
    }
    return s;
}

- (CBCentralManager *)manager {
    if(_manager == nil) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _manager;
}

- (NSMutableArray *)peripherals{
    if (_peripherals == nil) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

@end
