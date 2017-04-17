//
//  UPOSPrinterController+zy.m
//  Juniu
//
//  Created by ZYSu on 2016/10/13.
//  Copyright © 2016年 com.juniu. All rights reserved.
//

#import "UPOSPrinterController+ZY.h"

@implementation UPOSPrinterController (ZY)

+ (instancetype)sharedInstance
{
    static UPOSPrinterController *_sigleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sigleton = [[self alloc] init];
    });
    return _sigleton;
}
@end
