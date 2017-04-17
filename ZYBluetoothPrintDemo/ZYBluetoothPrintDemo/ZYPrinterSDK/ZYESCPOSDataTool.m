//
//  ZYESCPOSDataTool.m
//  ZYBluetoothPrintDemo
//
//  Created by ZYSu on 2017/4/17.
//  Copyright © 2017年 ZYSu. All rights reserved.
//

#import "ZYESCPOSDataTool.h"
#import "UIImage+Bitmap.h"

@interface ZYESCPOSDataTool ()

@property (nonatomic, assign) NSInteger sigleDataMaxLength;

@end

@implementation ZYESCPOSDataTool

@synthesize datas = _datas;
@synthesize textAlignment = _textAlignment;
@synthesize leftMargin = _leftMargin;
@synthesize fontScale = _fontScale;
@synthesize boldFont = _boldFont;

- (instancetype)init
{
    if (self = [super init]) {
        // 控制每次发送数据包的大小 默认80
        _sigleDataMaxLength = 80;
        
        // 默认的对齐方式
        _textAlignment = NSTextAlignmentLeft;
        
        // 初始化打印机
        [self initializeDatas];
    }
    return self;
}

- (void)initializeDatas
{
    // 初始化打印机
    Byte bytes[] = {0x1B, 0x40};
    
    [self appendBytes:bytes];
    
    // 支持中文
    Byte chineseBytes[] = {0x1C, 0x26};
    
    [self appendBytes:chineseBytes];
}

- (void)appendBytes:(void *)bytes
{
    if (self.datas.count) {
        NSMutableData *lasData = self.datas.lastObject;
        [lasData appendBytes:bytes length:sizeof(bytes)/sizeof(bytes[0])];
        if (lasData.length > self.sigleDataMaxLength) {
            [self.datas addObject:[[NSMutableData alloc] init]];
        }
    }else{
        [self.datas addObject:[[NSMutableData alloc] initWithBytes:bytes length:sizeof(bytes)/sizeof(bytes[0])]];
    }
}

- (void)printText:(NSString *)text
{
    if (text.length) {
        
        // 字符串过长会导致文字丢失
        NSInteger maxLength = 30;
        NSInteger shang = text.length/30;
        NSInteger column = text.length%30?shang+1:shang;
        
        for (int i = 0; i < column; i++) {
            NSString *subStr = nil;
            // 如果是最后一段
            NSInteger index = i*maxLength;
            if (i == column-1) {
                subStr = [text substringFromIndex:index];
            }else{
                subStr = [text substringWithRange:NSMakeRange(index, maxLength)];
            }
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            [self appendBytes:(void *)[subStr dataUsingEncoding:encoding].bytes];
        }
    }
}

- (void)printLineFeed:(NSInteger)line
{
    for (int i = 0; i < line; i++) {
        Byte bytes[] = {0x0A};
        [self appendBytes:bytes];
    }
}

- (void)printEnter
{
    [self printLineFeed:1];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    switch (textAlignment) {
        case NSTextAlignmentRight:
        {
            Byte bytes[] = {0x1B, 0x61, 0x02};
            [self appendBytes:bytes];
            break;
        }
        case NSTextAlignmentCenter:
        {
            Byte bytes[] = {0x1B, 0x61, 0x01};
            [self appendBytes:bytes];
            break;
        }
        default:
        {
            Byte bytes[] = {0x1B, 0x61, 0x00};
            [self appendBytes:bytes];
            break;
        }
    }
}

- (void)setLeftMargin:(float)leftMargin
{
    _leftMargin = leftMargin;
    NSInteger number = leftMargin * 10 * 8;
    UInt8 a = number%256;
    UInt8 b = number/256;
    Byte bytes[] = {0x1B, 0x24,a,b};
    [self appendBytes:bytes];
}

- (void)setFontScale:(NSInteger)fontScale
{
    
    _fontScale = fontScale;
    switch (fontScale) {
        case 0:
        case 1:
        {
            Byte fontSize[] = {0x1D, 0x21, 0x00};
            [self appendBytes:fontSize];
            break;
        }
        default:
        {
            Byte fontSize[] = {0x1D, 0x21, 0x11};
            [self appendBytes:fontSize];
            break;
        }
    }
}

- (void)setBoldFont:(BOOL)boldFont
{
    _boldFont = boldFont;
    if (boldFont) {
        Byte bytes[] = {0x1B, 0x45, 0x01};
        [self appendBytes:bytes];
    }else{
        Byte bytes[] = {0x1B, 0x45, 0x00};
        [self appendBytes:bytes];
    }
}

- (void)printBusiness{}
- (void)setModel:(id)model{}
- (id)model{return nil;}

- (void)printBlodText:(NSString *)text
{
    self.boldFont = YES;
    [self printText:text];
}

- (void)printLine
{
    self.leftMargin = 0.0;
    [self printText:@"------------------------------------------------"];
    [self printEnter];
}

- (void)printRealLine
{
    self.leftMargin = 0.0;
    [self printText:@"━━━━━━━━━━━━━━━━━━━━━━━━"];
    [self printEnter];
}

- (void)printText:(NSString *)text leftMargin:(float)margin
{
    self.leftMargin = margin;
    [self printText:text];
}

- (void)printImage:(UIImage *)image alignment:(NSTextAlignment)alignment maxHeight:(CGFloat)maxHeight {
    if (!image) {
        return;
    }
    self.textAlignment = alignment;
    UIImage *newImage = [image imageWithscaleMaxWidth:maxHeight];
    NSData *imageData = [newImage bitmapData];
    [self.datas addObject:[NSMutableData dataWithData:imageData]];
}

- (void)printQRCodeWithInfo:(NSString *)info size:(NSInteger)size alignment:(NSTextAlignment)alignment;
{
    self.textAlignment = alignment;
    [self setQRCodeSize:size];
    [self setQRCodeErrorCorrection:48];
    [self setQRCodeInfo:info];
    [self printStoredQRData];
}

- (void)setQRCodeSize:(NSInteger)size
{
    Byte QRSize[] = {0x1D,0x28,0x6B,0x03,0x00,0x31,0x43,size};
    
    [self appendBytes:QRSize];
}

- (void)setQRCodeErrorCorrection:(NSInteger)level
{
    Byte levelBytes[] = {0x1D,0x28,0x6B,0x03,0x00,0x31,0x45,level};
    
    [self appendBytes:levelBytes];
}

- (void)setQRCodeInfo:(NSString *)info
{
    NSInteger kLength = info.length + 3;
    NSInteger pL = kLength % 256;
    NSInteger pH = kLength / 256;
    
    Byte dataBytes[] = {0x1D,0x28,0x6B,pL,pH,0x31,0x50,48};
    [self appendBytes:dataBytes];
    
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    [self appendBytes:(void *)infoData.bytes];
}

- (void)printStoredQRData
{
    Byte printBytes[] = {0x1D,0x28,0x6B,0x03,0x00,0x31,0x51,48};
    [self appendBytes:printBytes];
}

- (NSMutableArray<NSMutableData *> *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

@end
