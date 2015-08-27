//
//  WPUtil.m
//  WPHealth
//
//  Created by justone on 15/4/1.
//  Copyright (c) 2015年 justone. All rights reserved.
//

#import "WPUtil.h"

double WPCurrentTime(void)
{
    return (double)[[NSDate date] timeIntervalSince1970];
}

NSString *WPCurrentTimeString(void)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"HH:mm"];
    
    NSDate *dateNow = [NSDate dateWithTimeIntervalSince1970:WPCurrentTime()];
    NSString *vTime = [formatter stringFromDate:dateNow];
    
    return vTime;
}

NSString *WPCurrentDateString(void)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateNow = [NSDate dateWithTimeIntervalSince1970:WPCurrentTime()];
    NSString *vTime = [formatter stringFromDate:dateNow];
    
    return vTime;
}

NSString *WPCurrentYearString(void)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy"];
    
    NSDate *dateNow = [NSDate dateWithTimeIntervalSince1970:WPCurrentTime()];
    NSString *vTime = [formatter stringFromDate:dateNow];
    
    return vTime;
}

NSInteger numberOfSecondsFromTodayByTime(NSString *aDate, NSString*aTimeStringFormat)
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitSecond;
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:aTimeStringFormat];
    
    NSDate *fromdate=[format dateFromString:aDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval:frominterval];
    //NSLog(@"fromdate=%@",fromDate);
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //NSLog(@"enddate=%@",localeDate);
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:localeDate options:0];
    NSInteger seconds = [components second];
    
    //NSLog(@"numberOfMinutesFromTodayByTime = %d",minutes);
    return seconds;
}

NSInteger numberOfMinutesFromTodayByTime(NSString *aDate, NSString*aTimeStringFormat)
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitMinute;
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:aTimeStringFormat];
    
    NSDate *fromdate=[format dateFromString:aDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval:frominterval];
    //NSLog(@"fromdate=%@",fromDate);
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //NSLog(@"enddate=%@",localeDate);
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:localeDate options:0];
    NSInteger minutes = [components minute];
    
    //NSLog(@"numberOfMinutesFromTodayByTime = %d",minutes);
    return minutes;
}

NSInteger numberOfDaysFromTodayByTime(NSString *aDate, NSString*aTimeStringFormat)
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay;
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:aTimeStringFormat];
    
    NSDate *fromdate=[format dateFromString:aDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval:frominterval];
    //NSLog(@"fromdate=%@",fromDate);
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //NSLog(@"enddate=%@",localeDate);
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:localeDate options:0];
    //NSInteger years = [components year]
    //NSInteger months = [components month];
    NSInteger days = [components day];
    
    //NSLog(@"numberOfDaysFromTodayByTime = %d",days);
    return days;
}

NSDictionary *WPJsonStringToDictionary(NSString *aJsonString)
{
    NSDictionary *retDict = nil;
    if (aJsonString) {
        NSData *jsonData = [aJsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData) {
            retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        }
    }
    return retDict;
}

NSString *WPDataToJsonString(id aObject)
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aObject
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

NSString *WPEncodeURL(NSString*aUnescapedString)
{
    NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)aUnescapedString, NULL,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", kCFStringEncodingUTF8));
    return escapedUrlString;
}

BOOL isValidateEmail(NSString *aEmail)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:aEmail];
}

BOOL isValidatePhoneNumber(NSString *aPhoneNumber)
{
    if ([aPhoneNumber length] < 11) {
        return NO;
    }
    
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:aPhoneNumber];
}

BOOL isValidatePassWord(NSString *aPassWord)
{
    if ([aPassWord length] < 4  || [aPassWord length] > 16) {
        return NO;
    }
    
    NSRange range = [aPassWord rangeOfString:@" "];
    if (range.location != NSNotFound) {
        //有空格
        return NO;
    }
    
    range = [aPassWord rangeOfString:@"'"];
    if (range.location != NSNotFound) {
        //有单引号
        return NO;
    }
    
    range = [aPassWord rangeOfString:@"\""];
    if (range.location != NSNotFound) {
        //英文键盘有双引号
        return NO;
    }
    
    range = [aPassWord rangeOfString:@"“"];
    if (range.location != NSNotFound) {
        //汉子键盘有双引号
        return NO;
    }
    range = [aPassWord rangeOfString:@"”"];
    if (range.location != NSNotFound) {
        //汉子键盘有双引号
        return NO;
    }
    
    return YES;
}

UIImage *createImageWithColor(UIColor *color, CGSize size)
{
    // Create a new size image context
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create a filled rect
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextAddRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    CGContextFillPath(context);
    
    // Recturn new image
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#define ORIGINAL_MAX_WIDTH 480.0f

UIImage *imageByScalingToMaxSize(UIImage *sourceImage)
{
    //  if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return imageByScalingAndCroppingForSourceImage(sourceImage, targetSize);
}

UIImage *imageByScalingAndCroppingForSourceImage(UIImage *sourceImage, CGSize targetSize)
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else {
            if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
        return newImage;
}
