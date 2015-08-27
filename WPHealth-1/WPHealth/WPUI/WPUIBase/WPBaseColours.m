//
//  WPBaseColours.m
//  WPHealth
//
//  Created by justone on 15-5-25.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPBaseColours.h"

@implementation WPBaseColours

#pragma mark - UIColor from Hex

+(UIColor *)colorFromHex:(NSString *)hexString
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(UIColor *)colorFromHex:(NSString *)hexString andAlpa:(CGFloat)aAlpa
{
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:aAlpa];
}

#pragma mark - Hex from UIColor

+(NSString *)hexFromColor:(UIColor *)color
{
    NSArray *colorArray = [WPBaseColours rgbaArrayFromColor:color];
    int r = [colorArray[0] floatValue] * 255;
    int g = [colorArray[1] floatValue] * 255;
    int b = [colorArray[2] floatValue] * 255;
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];
    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}

#pragma mark - RGBA from UIColor

+(NSArray *)rgbaArrayFromColor:(UIColor *)color
{
    // Takes a UIColor and returns R,G,B,A values in NSNumber form
    CGFloat r=0,g=0,b=0,a=0;
    
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    return @[[NSNumber numberWithFloat:r],[NSNumber numberWithFloat:g],[NSNumber numberWithFloat:b],[NSNumber numberWithFloat:a]];
}

#pragma mark - HSBA from UIColor

+(NSArray *)hsbaArrayFromColor:(UIColor *)color
{
    // Takes a UIColor and returns Hue,Saturation,Brightness,Alpha values in NSNumber form
    CGFloat h=0,s=0,b=0,a=0;
    
    if ([color respondsToSelector:@selector(getHue:saturation:brightness:alpha:)]) {
        [color getHue:&h saturation:&s brightness:&b alpha:&a];
    }
    
    return @[[NSNumber numberWithFloat:h],[NSNumber numberWithFloat:s],[NSNumber numberWithFloat:b],[NSNumber numberWithFloat:a]];
}

#pragma mark - Generate Color Scheme

+(NSArray *)generateColorSchemeFromColor:(UIColor *)color ofType:(ColorScheme)type
{
    NSArray *hsbArray = [WPBaseColours hsbaArrayFromColor:color];
    float hue = [hsbArray[0] floatValue] * 360;
    float sat = [hsbArray[1] floatValue] * 100;
    float bright = [hsbArray[2] floatValue] * 100;
    float alpha = [hsbArray[3] floatValue];
    
    switch (type) {
        case ColorSchemeAnalagous:
            return [WPBaseColours analagousColorsFromHue:hue saturation:sat brightness:bright alpha:alpha];
            break;
        case ColorSchemeMonochromatic:
            return [WPBaseColours monochromaticColorsFromHue:hue saturation:sat brightness:bright alpha:alpha];
        case ColorSchemeTriad:
            return [WPBaseColours triadColorsFromHue:hue saturation:sat brightness:bright alpha:alpha];
        case ColorSchemeComplementary:
            return [WPBaseColours complementaryColorsFromHue:hue saturation:sat brightness:bright alpha:alpha];
        default:
            break;
    }
}

#pragma mark - Color Scheme Generation - Helper methods

+(NSArray *)analagousColorsFromHue:(float)h saturation:(float)s brightness:(float)b alpha:(float)a
{
    UIColor *colorAbove1 = [UIColor colorWithHue:[WPBaseColours addDegrees:15 toDegree:h]/360 saturation:(s-5)/100 brightness:(b-5)/100 alpha:a];
    UIColor *colorAbove2 = [UIColor colorWithHue:[WPBaseColours addDegrees:30 toDegree:h]/360 saturation:(s-5)/100 brightness:(b-10)/100 alpha:a];
    UIColor *colorBelow1 = [UIColor colorWithHue:[WPBaseColours addDegrees:-15 toDegree:h]/360 saturation:(s-5)/100 brightness:(b-5)/100 alpha:a];
    UIColor *colorBelow2 = [UIColor colorWithHue:[WPBaseColours addDegrees:-30 toDegree:h]/360 saturation:(s-5)/100 brightness:(b-10)/100 alpha:a];
    
    return @[colorAbove2,colorAbove1,colorBelow1,colorBelow2];
}

+(NSArray *)monochromaticColorsFromHue:(float)h saturation:(float)s brightness:(float)b alpha:(float)a
{
    UIColor *colorAbove1 = [UIColor colorWithHue:h/360 saturation:s/100 brightness:(b/2)/100 alpha:a];
    UIColor *colorAbove2 = [UIColor colorWithHue:h/360 saturation:(s/2)/100 brightness:(b/3)/100 alpha:a];
    UIColor *colorBelow1 = [UIColor colorWithHue:h/360 saturation:(s/3)/100 brightness:(2*b/3)/100 alpha:a];
    UIColor *colorBelow2 = [UIColor colorWithHue:h/360 saturation:s/100 brightness:(4*b/5)/100 alpha:a];
    
    return @[colorAbove2,colorAbove1,colorBelow1,colorBelow2];
}

+(NSArray *)triadColorsFromHue:(float)h saturation:(float)s brightness:(float)b alpha:(float)a
{
    UIColor *colorAbove1 = [UIColor colorWithHue:[WPBaseColours addDegrees:120 toDegree:h]/360 saturation:s/100 brightness:b/100 alpha:a];
    UIColor *colorAbove2 = [UIColor colorWithHue:[WPBaseColours addDegrees:120 toDegree:h]/360 saturation:(7*s/6)/100 brightness:(b-5)/100 alpha:a];
    UIColor *colorBelow1 = [UIColor colorWithHue:[WPBaseColours addDegrees:240 toDegree:h]/360 saturation:s/100 brightness:b/100 alpha:a];
    UIColor *colorBelow2 = [UIColor colorWithHue:[WPBaseColours addDegrees:240 toDegree:h]/360 saturation:(7*s/6)/100 brightness:(b-5)/100 alpha:a];
    
    return @[colorAbove2,colorAbove1,colorBelow1,colorBelow2];
}

+(NSArray *)complementaryColorsFromHue:(float)h saturation:(float)s brightness:(float)b alpha:(float)a
{
    UIColor *colorAbove1 = [UIColor colorWithHue:h/360 saturation:(5*s/7)/100 brightness:b/100 alpha:a];
    UIColor *colorAbove2 = [UIColor colorWithHue:h/360 saturation:s/100 brightness:(4*b/5)/100 alpha:a];
    UIColor *colorBelow1 = [UIColor colorWithHue:[WPBaseColours addDegrees:180 toDegree:h]/360 saturation:s/100 brightness:b/100 alpha:a];
    UIColor *colorBelow2 = [UIColor colorWithHue:[WPBaseColours addDegrees:180 toDegree:h]/360 saturation:(5*s/7)/100 brightness:b/100 alpha:a];
    
    return @[colorAbove2,colorAbove1,colorBelow1,colorBelow2];
}

+(float)addDegrees:(float)addDeg toDegree:(float)staticDeg
{
    staticDeg += addDeg;
    if (staticDeg > 360) {
        float offset = staticDeg - 360;
        return offset;
    } else if (staticDeg < 0) {
        return -1 * staticDeg;
    } else {
        return staticDeg;
    }
}

@end
