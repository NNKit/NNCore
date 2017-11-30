//
//  UIColor+NNExtension.h
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 Create UIColor with a hex string.
 Example: NNColorHex(0xF0F), NNColorHex(66ccff), NNColorHex(#66CCFF88)
 
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 */
#ifndef NNColorHex
    #define NNColorHex(_hex_) [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
    #define NNColorString(_hex_) [UIColor colorWithHexString:_hex_]
    #define NNRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#endif

@interface UIColor (NNExtension)

@property (assign, nonatomic, readonly) CGFloat alpha; /**< 当前颜色的透明度 范围 0~1 */
@property (assign, nonatomic, readonly) uint32_t rgbValue; /**< 当前颜色的RGB数值 例: 0x66eecc */
@property (assign, nonatomic, readonly) uint32_t rgbaValue; /**< 当前颜色的RGBA数值 例: 0x66eeccff */
@property (copy, nonatomic, readonly, nullable)   NSString *hex; /**< 当前颜色的16进制字符串 例: @"0x66EECC" */
@property (copy, nonatomic, readonly, nullable)   NSString *hexWithAlpha; /**< 当前颜色的16进制字符串 例: @"0x66EECCFF" */


/**
 根据RGB数值生成对应UIColor

 @param rgbValue RGB数值 例: 0x66eecc
 @return UIColor or nil
 */
+ (nullable UIColor *)colorWithRGB:(uint32_t)rgbValue;


/**
 根据RGB数值生成对应UIColor
 
 @param rgbaValue RGB数值 例: 0x66eeccff
 @return UIColor or nil
 */
+ (nullable UIColor *)colorWithRGBA:(uint32_t)rgbaValue;


/**
 根据RGB数值生成对应UIColor
 
 @param rgbValue RGB数值 例: 0x66eecc
 @param alpha  颜色透明度
 @return UIColor or nil
 */
+ (nullable UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/**
 根据16进制字符串生成对应UIColor
 '#','0x'可以不添加
 
 例 : @"0xF1F",@"0x66eeff",@"0x66BBCCFF",@"66BBCC",@"#66BBFF"
 @param hex 颜色的16进制字符串
 @return UIColor or nil
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)hex;

@end

NS_ASSUME_NONNULL_END
