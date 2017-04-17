//
//  ZYMFIPrinterTool.m
//  JuniuHD
//
//  Created by ZYSu on 2016/12/6.
//  Copyright © 2016年 ZYSu. All rights reserved.
//

#import "ZYMFIPrinterTool.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "UPOSPrinterController+ZY.h"
#import "ZYESCPOSDataTool.h"

@interface ZYMFIPrinterTool ()<UPOSDeviceControlDelegate>

@property (nonatomic, strong) UPOSPrinterController *bxlPrinter;
@property (nonatomic, assign) NSInteger finishCount;
@end


@implementation ZYMFIPrinterTool
@synthesize dataTool = _dataTool;
@synthesize pageNum = _pageNum;

- (instancetype)init
{
    if (self = [super init]) {
        self.pageNum = 1;
    }
    return self;
}

- (void)dealloc
{
    // weak 引用的属性 不会坏内存 assgin容易坏内存,所以代理使用weak
    self.bxlPrinter.delegate = nil;
    [self.bxlPrinter releaseDevice];
    [self.bxlPrinter close];
    NSLog(@"%@---dealloc", self);
}

- (void)startToPrint
{
    if ([EAAccessoryManager sharedAccessoryManager].connectedAccessories.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先去蓝牙设置中连接毕索龙打印机" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
        return;
    }
    NSLog(@"打印中");
    
    UPOSPrinters *printers = (UPOSPrinters *)self.bxlPrinter.getRegisteredDevice;
    NSArray *list = printers.getList;
    for (UPOSPrinter *temp in list) {
        [printers removeDevice:temp];
    }
    UPOSPrinter *newDevice = [[UPOSPrinter alloc] init];
    newDevice.modelName    = [[NSUserDefaults standardUserDefaults] stringForKey:ZYPrinterNameKey];
    newDevice.interfaceType= @(_INTERFACETYPE_BLUETOOTH);
    newDevice.address      = [[NSUserDefaults standardUserDefaults] stringForKey:ZYPrinterUUIDKey];
    [printers addDevice:newDevice];
    [printers save];
    [self beginFindPrinterWithModelName:newDevice.modelName];
}

- (void)beginFindPrinterWithModelName:(NSString *)modelName
{
    [self.bxlPrinter open:modelName];
    
    if (self.bxlPrinter.State == UPOS_S_CLOSED) {
        NSLog(@"打印失败");
        return;
    }
    
    if (self.bxlPrinter.Claimed == NO) {
        [self.bxlPrinter claim:5000];
    }
    
    if (self.bxlPrinter.Claimed == NO) {
        [self.bxlPrinter claim:5000];
    }
    if (self.bxlPrinter.Claimed == NO) {
        NSLog(@"打印失败");
        return;
    }
    
    if (self.bxlPrinter.DeviceEnabled == NO) {
        self.bxlPrinter.DeviceEnabled = YES;
    }
    
    if (self.bxlPrinter.AsyncMode == YES) {
        self.bxlPrinter.AsyncMode = NO;
    }
    
    [self printJuniu];
}

- (void)printJuniu
{
    self.finishCount = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSInteger i = 1; i <= self.pageNum; i++) {
            [self.dataTool printBusiness];
        }
       dispatch_sync(dispatch_get_main_queue(), ^{
           
           for (NSData *data in self.dataTool.datas) {
               [self.bxlPrinter printRawData:PTR_S_RECEIPT data:data];
           }
           double totalTime = 2.0 * (double)self.pageNum;
           [NSTimer scheduledTimerWithTimeInterval:totalTime target:self selector:@selector(printFinish) userInfo:nil repeats:NO];
       });
    });
    
}

// 打印完成
- (void)printFinish
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZYPrinterPrintDataFinishNotification object:nil];
}
- (void)StatusUpdateEvent:(NSNumber *)status
{
    NSInteger statusCode = [status integerValue];
    
    if (statusCode == PTR_SUE_COVER_OPEN) {
        NSLog(@"请关闭打印机纸盖");
    }
    else if (statusCode == PTR_SUE_REC_EMPTY){
        NSLog(@"打印机没纸了");
    }
}

- (void)DataEvent:(NSNumber *)status
{
    NSLog(@"--- dataEvent....");
    
}
#pragma mark - getter

- (UPOSPrinterController *)bxlPrinter {
    if(_bxlPrinter == nil) {
        _bxlPrinter = [UPOSPrinterController sharedInstance];
        _bxlPrinter.delegate = self;
    }
    return _bxlPrinter;
}

@end
