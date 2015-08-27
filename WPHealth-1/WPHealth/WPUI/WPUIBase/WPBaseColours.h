//
//  WPBaseColours.h
//  WPHealth
//
//  Created by justone on 15-5-25.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import <Foundation/Foundation.h>

// Color Scheme Creation Enum
typedef enum {
    ColorSchemeAnalagous = 0,
    ColorSchemeMonochromatic,
    ColorSchemeTriad,
    ColorSchemeComplementary
}ColorScheme;

@interface WPBaseColours : NSObject

// Color Methods
+(UIColor *)colorFromHex:(NSString *)hexString;
+(UIColor *)colorFromHex:(NSString *)hexString andAlpa:(CGFloat)aAlpa;
+(NSString *)hexFromColor:(UIColor *)color;
+(NSArray *)rgbaArrayFromColor:(UIColor *)color;
+(NSArray *)hsbaArrayFromColor:(UIColor *)color;

// Generate Color Scheme
+(NSArray *)generateColorSchemeFromColor:(UIColor *)color ofType:(ColorScheme)type;

@end
