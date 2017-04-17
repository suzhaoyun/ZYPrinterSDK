//
//  ZYPrinterProtocol.h
//  ZYBluetoothPrintDemo
//
//  Created by ZYSu on 2017/4/17.
//  Copyright © 2017年 ZYSu. All rights reserved.
//  打印机的协议

#import <UIKit/UIKit.h>

@protocol ZYPrinterDataProtocol <NSObject>

/// 打印数据
@property (nonatomic, strong, readonly) NSMutableArray<NSMutableData *> *datas;

/// 模型
- (void)setModel:(id)model;
- (id)model;


/// 打印业务 <需要子类去实现>
- (void)printBusiness;

/**
 打印文本的对齐方式
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/**
 左边间距 cm
 */
@property (nonatomic, assign) float leftMargin;
/**
 字体的比例 1-7
 */
@property (nonatomic, assign) NSInteger fontScale;
/**
 设置粗的字体
 */
@property (nonatomic, assign) BOOL boldFont;
/**
 打印文字
 
 @param text NSString
 */
- (void)printText:(NSString *)text;
/**
 打印空行
 @param line 空行数
 */
- (void)printLineFeed:(NSInteger)line;
/**
 换行 \r\n
 */
- (void)printEnter;
/**
 打印线
 */
- (void)printLine;
/**
 打印实线线
 */
- (void)printRealLine;

/**
 打印粗体文字
 */
- (void)printBlodText:(NSString *)text;

/**
 打印距离左侧固定距离的文字
 */
- (void)printText:(NSString *)text leftMargin:(float)margin;

/**
 打印图片
 */
- (void)printImage:(UIImage *)image alignment:(NSTextAlignment)alignment maxHeight:(CGFloat)maxHeight;

/**
 打印二维码
 */
- (void)printQRCodeWithInfo:(NSString *)info size:(NSInteger)size alignment:(NSTextAlignment)alignment;


@end
