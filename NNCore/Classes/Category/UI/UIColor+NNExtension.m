//
//  UIColor+NNExtension.m
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#import "UIColor+NNExtension.h"

static inline NSUInteger hexStrToInt(NSString *str) {
    
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL hexStrToRGBA(NSString *str, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    
    str = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f * 17.f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f * 17.f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f * 17.f;
        if (length == 4)  *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f * 17.f;
        else *a = 1;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

@implementation UIColor (NNExtension)

#pragma mark - Private Methods

- (NSString *)hexStringWithAlpha:(BOOL)withAlpha {
    
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)MIN((components[0] * 255.0f), 255);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)MIN((components[0] * 255.0f), 255),
               (NSUInteger)MIN((components[1] * 255.0f), 255),
               (NSUInteger)MIN((components[2] * 255.0f), 255)];
    }
    
    
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    
    if (hex && withAlpha) { hex = [hex stringByAppendingFormat:@"%02lx", (unsigned long)(self.alpha * 255.0 + 0.5)]; }
    return [hex lowercaseString];
}

#pragma mark - Getter

- (CGFloat)alpha {
    return [[NSString stringWithFormat:@"%.2f", CGColorGetAlpha(self.CGColor)] floatValue];
}

- (uint32_t)rgbValue {
    
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)rgbaValue {
    
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}

- (NSString *)hex {
    return [self hexStringWithAlpha:NO];
}

- (NSString *)hexWithAlpha {
    return [self hexStringWithAlpha:YES];
}


#pragma mark - Class Methods

+ (nullable UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return [self colorWithRGB:rgbValue alpha:1.f];
}

+ (nullable UIColor *)colorWithRGBA:(uint32_t)rgbaValue {
    
    return [UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24) / 255.0f
                           green:((rgbaValue & 0xFF0000) >> 16) / 255.0f
                            blue:((rgbaValue & 0xFF00) >> 8) / 255.0f
                           alpha:(rgbaValue & 0xFF) / 255.0f];
}

+ (nullable UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:alpha];
}

+ (nullable UIColor *)colorWithHexString:(NSString *)hex {
    
    CGFloat r, g, b, a;
    if (hexStrToRGBA(hex, &r, &g, &b, &a)) { return [UIColor colorWithRed:r green:g blue:b alpha:a]; }
    return nil;
}

@end
